#!/bin/bash
#SBATCH -A cbc-condo
#SBATCH -c 8
#SBATCH --mem 8G
#SBATCH -t 3-00:00:00
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/11_GSE136352-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/11_GSE136352-%J.out

module load hpcx-mpi/4.1.5rc2s-yflad4v
module load blast-plus/2.2.30-cyxldrt hmmer-mpi/3.3.2-wyoo2te

# Exit on error
set -e

# 0. Setup
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/tissue_assemblies
export APPTAINER_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/trinityrnaseq.v2.15.1.simg
TRINITY_HOME=/usr/local/bin

# 1. Download the FASTA/FASTQ data from ENA
PROJECT_ID="GSE136352"

# all files come from trinity assembly and counts scripts already

echo "Starting transdecoder & trinotate portion..."

export TRINOTATE_HOME="/usr/local/src/Trinotate"
TRINOTATE_IMG=${WORKDIR}/metadata/trinotate.v4.0.2.simg
ANNOTATIONS=$WORKDIR/data/annotations
TRANSDECODER=$ANNOTATIONS/${PROJECT_ID}_annotation/${PROJECT_ID}.fasta.transdecoder.pep
METADATA=${WORKDIR}/metadata
TRANSCRIPT_FASTA=$DATA/${PROJECT_ID}/${PROJECT_ID}_Mfranciscanus_transcripts.fasta

cd $ANNOTATIONS
mkdir -p ${PROJECT_ID}_annotation
cd ${PROJECT_ID}_annotation

TRANSDECODER_IMG=${WORKDIR}/metadata/transdecoder.v5.7.1.simg

echo "Transdecoder longORfs"
#cp ${TRANSCRIPT_FASTA} ${PROJECT_ID}.fasta
#singularity exec ${TRANSDECODER_IMG} TransDecoder.LongOrfs -t ${PROJECT_ID}.fasta

echo "Hmmsearch"
#hmmsearch --cpu 8 -E 1e-10 --domtblout ${PROJECT_ID}.pfam.domtblout $METADATA/Pfam-A.hmm ${PROJECT_ID}.fasta.transdecoder_dir/longest_orfs.pep

echo "blastp"
#blastp -query ${PROJECT_ID}.fasta.transdecoder_dir/longest_orfs.pep  \
#    -db ${METADATA}/uniprot_sprot.fasta  -max_target_seqs 1 \
#    -outfmt 6 -evalue 1e-5 -num_threads ${SLURM_CPUS_PER_TASK} > blastp.outfmt6

echo "Running transdecoder predict"
singularity exec ${TRANSDECODER_IMG} TransDecoder.Predict -t ${PROJECT_ID}.fasta \
	    --retain_pfam_hits ${PROJECT_ID}.pfam.domtblout \
	    --retain_blastp_hits blastp.outfmt6

echo "Running trinotate..."
cp $METADATA/TrinotateBoilerplate.sqlite ./${PROJECT_ID}_Trinotate.sqlite

# https://groups.google.com/g/trinityrnaseq-users/c/7rq3C0hn5p0?pli=1
# create gene_trans_map script
# trinityrnaseq/util//support_scripts/get_Trinity_gene_to_trans_map.pl
# usage: https://github.com/Trinotate/Trinotate/issues/22
#singularity exec ${SINGULARITY_IMG} ${TRINITY_HOME}/util/support_scripts/get_Trinity_gene_to_trans_map.pl \
#	    ${PROJECT_ID}.fasta > ${PROJECT_ID}.fasta.gene_trans_map

#singularity exec ${TRINOTATE_IMG} ${TRINOTATE_HOME}/Trinotate --db ${PROJECT_ID}_Trinotate.sqlite --init \
#	    --gene_trans_map ${PROJECT_ID}.fasta.gene_trans_map \
#	    --transcript_fasta ${PROJECT_ID}.fasta \
#	    --transdecoder_pep $TRANSDECODER

echo "trinotate: blastp blastx pfam"
singularity exec ${TRINOTATE_IMG} ${TRINOTATE_HOME}/Trinotate --db ${PROJECT_ID}_Trinotate.sqlite --CPU 8 \
	    --transcript_fasta ${PROJECT_ID}.fasta \
	    --transdecoder_pep $TRANSDECODER \
	    --trinotate_data_dir $METADATA \
	    --run "swissprot_blastp swissprot_blastx pfam"

singularity exec ${TRINOTATE_IMG} ${TRINOTATE_HOME}/Trinotate --db ${PROJECT_ID}_Trinotate.sqlite --report > ${PROJECT_ID}_Trinotate.tsv

echo "Adding annotations to expression matrices"
singularity exec ${TRINOTATE_IMG} ${TRINOTATE_HOME}/util/Trinotate_get_feature_name_encoding_attributes.pl \
	    $WORKDIR/data/annotations/${PROJECT_ID}/${PROJECT_ID}_Trinotate.tsv > $WORKDIR/data/annotations/${PROJECT_ID}/${PROJECT_ID}_annot_feature_map.txt

# needs to be from trinity - https://github.com/trinityrnaseq/trinityrnaseq/issues/1250
# ${TRINITY_HOME} - https://github.com/trinityrnaseq/trinityrnaseq/wiki/Functional-Annotation-of-Transcripts
#echo ${COUNTS_DIR}/${ID}/${ID}.gene_counts_matrix
singularity exec ${SINGULARITY_IMG} ${TRINITY_HOME}/Analysis/DifferentialExpression/rename_matrix_feature_identifiers.pl \
	    ${COUNTS_DIR}/${PROJECT_ID}/${PROJECT_ID}.gene.counts.matrix $WORKDIR/data/annotations/${PROJECT_ID}/${PROJECT_ID}_annot_feature_map.txt > ${COUNTS_DIR}/${PROJECT_ID}/${PROJECT_ID}_gene_counts_matrix_annot
