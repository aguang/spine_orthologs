#!/bin/bash
#SBATCH -c 8
#SBATCH -A cbc-condo
#SBATCH --mem 32G
#SBATCH -t 4-00:00:00
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/09_other_tissues-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/09_other_tissues-%J.out

module load hpcx-mpi/4.1.5rc2s-yflad4v
module load blast-plus/2.2.30-cyxldrt hmmer-mpi/3.3.2-wyoo2te

# Exit on error
set -e

# 0. Setup
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/tissue_assemblies
mkdir -p ${DATA}
export APPTAINER_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/trinityrnaseq.v2.15.1.simg

# 1. Download the FASTA/FASTQ data from ENA
PROJECT_ID="PRJNA554218"
ENA_URL="https://www.ebi.ac.uk/ena/browser/api/fasta/${PROJECT_ID}?download=true"
OUTPUT_DIR=${DATA}/${PROJECT_ID}/"fastqs"
ASSEMBLY_DIR=${DATA}/${PROJECT_ID}/"trinity_out_dir"
MAPPING_DIR=${DATA}/${PROJECT_ID}/"rsem_output"

# Create output directories
mkdir -p ${OUTPUT_DIR} ${ASSEMBLY_DIR} ${MAPPING_DIR}

echo "Downloading raw FASTA/FASTQ files from ENA..."
echo "slurm_cpus_per_task"
echo ${SLURM_CPUS_PER_TASK}
#cd ${OUTPUT_DIR}
#bash ${WORKDIR}/scripts/utility/download_PRJNA554218.sh
#bash ${WORKDIR}/scripts/utility/count_and_write_samples.sh ${OUTPUT_DIR} ${PROJECT_ID}

# 2. Run Trinity for transcriptome assembly
#cd ${ASSEMBLY_DIR}
#echo "Running Trinity assembly..."
	     #--max_memory ${SLURM_MEM_PER_NODE} \ # can't parse because needs to be xG value
#singularity exec ${SINGULARITY_IMG} Trinity --seqType fq \
#	    --max_memory 240G \
#        --CPU ${SLURM_CPUS_PER_TASK} \
#        --samples_file ${OUTPUT_DIR}/${PROJECT_ID}_samples_file.tsv \
#        --output ${ASSEMBLY_DIR}

# 3. Map reads back to the reference with Trinity's script (align_and_estimate_abundance.pl)
TRANSCRIPT_FASTA="${ASSEMBLY_DIR}.Trinity.fasta"
echo "Mapping reads back to reference using RSEM..."
cd ${MAPPING_DIR} # I guess this script doesn't actually output them to --output_dir
#singularity exec ${SINGULARITY_IMG} /usr/local/bin/util/align_and_estimate_abundance.pl --transcripts ${TRANSCRIPT_FASTA} \
#                                --seqType fq \
#				--samples_file ${OUTPUT_DIR}/${PROJECT_ID}_samples_file.tsv \
#                                --est_method RSEM \
#                                --aln_method bowtie2 \
#                                --gene_trans_map ${ASSEMBLY_DIR}.Trinity.fasta.gene_trans_map \
#                                --output_dir ${MAPPING_DIR} \
#                                --prep_reference \
#                                --thread_count ${SLURM_CPUS_PER_TASK}

# 4. Generate counts matrices
echo "Generating counts matrices for genes and transcripts..."

# Collect all RSEM output files (*.genes.results and *.isoforms.results)
TRANSCRIPT_RESULT_FILES=$(find ${MAPPING_DIR} -name "*.isoforms.results")

# Generate transcript-level counts matrix
mkdir -p ${COUNTS_DIR}/${ID}
singularity exec ${SINGULARITY_IMG} /usr/local/bin/util/abundance_estimates_to_matrix.pl --est_method RSEM \
    --gene_trans_map ${ASSEMBLY_DIR}.Trinity.fasta.gene_trans_map \
    --out_prefix ${COUNTS_DIR}/${ID}/${ID} \
    --name_sample_by_basedir \
    ${TRANSCRIPT_RESULT_FILES}

echo "All steps completed successfully!"
echo "Counts matrices are located in ${COUNTS_DIR}."

echo "Starting transdecoder & trinotate portion..."

export TRINOTATE_HOME="/usr/local/src/Trinotate"
TRINOTATE_IMG=${WORKDIR}/metadata/trinotate.v4.0.2.simg
ANNOTATIONS=$WORKDIR/data/annotations
TRANSDECODER=$ANNOTATIONS/${PROJECT_ID}.fasta.transdecoder.pep
METADATA=${WORKDIR}/metadata

cd $ANNOTATIONS
mkdir -p ${PROJECT_ID}_annotation
cd ${PROJECT_ID}_annotation

TRANSDECODER_IMG=${WORKDIR}/metadata/transdecoder.v5.7.1.simg

echo "Transdecoder longORfs"
cp ${TRANSCRIPT_FASTA} ${PROJECT_ID}.fasta
singularity exec ${TRANSDECODER_IMG} TransDecoder.LongOrfs -t ${PROJECT_ID}.fasta

echo "Hmmsearch"
hmmsearch --cpu 8 -E 1e-10 --domtblout ${PROJECT_ID}.pfam.domtblout $METADATA/Pfam-A.hmm ${PROJECT_ID}.fasta.transdecoder_dir/longest_orfs.pep

echo "blastp"
blastp -query ${PROJECT_ID}.fasta.transdecoder_dir/longest_orfs.pep  \
    -db ${METADATA}/uniprot_sprot.fasta  -max_target_seqs 1 \
    -outfmt 6 -evalue 1e-5 -num_threads ${SLURM_CPUS_PER_TASK} > blastp.outfmt6

echo "Running transdecoder predict"
singularity exec ${TRANSDECODER_IMG} TransDecoder.Predict -t ${PROJECT_ID}.fasta \
	    --retain_pfam_hits $WORKDIR/data/transcriptomes/${PROJECT_ID}.pfam.domtblout \
	    --retain_blastp_hits $ASSEMBLY_DIR/blastp.outfmt6

echo "Running trinotate..."
cp $METADATA/TrinotateBoilerplate.sqlite ./${PROJECT_ID}_Trinotate.sqlite

singularity exec ${TRINOTATE_IMG} ${TRINOTATE_HOME}/Trinotate --db ${PROJECT_ID}_Trinotate.sqlite --init \
	    --gene_trans_map $ASSEMBLY_DIR/Trinity.fasta.gene_trans_map \
	    --transcript_fasta ${PROJECT_ID}.fasta \
	    --transdecoder_pep $TRANSDECODER

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
