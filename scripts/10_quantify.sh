#!/bin/bash
#SBATCH -c 8
#SBATCH --mem 64G
#SBATCH -t 4-00:00:00
#SBATCH -C intel
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/10_quantify-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/10_quantify-%J.out
#SBATCH --array=1-5

# Exit on error
set -e

# setup
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/agalma
IDS=(
    Pencil
    Hp
    LvGrn
    LvOv
    LvRed
    Sp
)
ID=${IDS[$SLURM_ARRAY_TASK_ID]}
echo $ID
MAPPING_DIR=${DATA}/scratch/transcriptome-${ID}/rsem_output
mkdir -p ${MAPPING_DIR}
ASSEMBLY_DIR=${DATA}/scratch/transcriptome-${ID}/trinity_out_dir
RAW_DIR=${WORKDIR}/data/fastqs
COUNTS_DIR=${WORKDIR}/data/counts
export APPTAINER_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/trinityrnaseq.v2.15.1.simg
TRINITY_HOME=/usr/local/bin

# home path: https://github.com/trinityrnaseq/trinityrnaseq/wiki/Trinity-in-Docker#running-trinity-using-singularity
# Prepare reference from Trinity output for mapping
TRANSCRIPT_FASTA="${ASSEMBLY_DIR}/Trinity.fasta"

echo "Mapping reads back to reference using RSEM..."

SAMPLES_FILE=$(find ${RAW_DIR} -name "${ID}_samples_file")

cd ${MAPPING_DIR}
singularity exec ${SINGULARITY_IMG} /usr/local/bin/util/align_and_estimate_abundance.pl --transcripts ${TRANSCRIPT_FASTA} \
            --seqType fq \
	    --samples_file ${SAMPLES_FILE} \
                                --est_method RSEM \
                                --aln_method bowtie2 \
				--gene_trans_map ${ASSEMBLY_DIR}/Trinity.fasta.gene_trans_map \
                                --output_dir ${MAPPING_DIR} \
                                --prep_reference \
				--thread_count ${SLURM_CPUS_PER_TASK}

# Generate counts matrices
echo "Generating counts matrices for genes and transcripts..."

# Collect all RSEM output files (*.genes.results and *.isoforms.results)
GENE_RESULT_FILES=$(find ${MAPPING_DIR} -name "*.genes.results")
TRANSCRIPT_RESULT_FILES=$(find ${MAPPING_DIR} -name "*.isoforms.results")

# Generate counts matrix
# use isoform files only: https://github.com/trinityrnaseq/trinityrnaseq/issues/1382
mkdir -p ${COUNTS_DIR}/${ID}
singularity exec ${SINGULARITY_IMG} /usr/local/bin/util/abundance_estimates_to_matrix.pl --est_method RSEM \
    --gene_trans_map ${ASSEMBLY_DIR}/Trinity.fasta.gene_trans_map \
    --out_prefix ${COUNTS_DIR}/${ID}/${ID} \
        --name_sample_by_basedir \
    ${TRANSCRIPT_RESULT_FILES}


echo "All steps completed successfully!"
echo "Counts matrices are located in ${COUNTS_DIR}."

# Add annotations to expression matrices
echo "Adding annotations to expression matrices"
export TRINOTATE_HOME="/usr/local/src/Trinotate"
TRINOTATE_IMG=${WORKDIR}/metadata/trinotate.v4.0.2.simg
singularity exec ${TRINOTATE_IMG} ${TRINOTATE_HOME}/util/Trinotate_get_feature_name_encoding_attributes.pl \
	    $WORKDIR/data/annotations/${ID}_run2/${ID}_Trinotate_v2.tsv > $WORKDIR/data/annotations/${ID}_run2/${ID}_annot_feature_map.txt

# needs to be from trinity - https://github.com/trinityrnaseq/trinityrnaseq/issues/1250
# ${TRINITY_HOME} - https://github.com/trinityrnaseq/trinityrnaseq/wiki/Functional-Annotation-of-Transcripts
#echo ${COUNTS_DIR}/${ID}/${ID}.gene_counts_matrix
#echo ${COUNTS_DIR}/${ID}/${ID}_gene_counts_matrix_annot.tsv
#echo $WORKDIR/data/annotations/${ID}_run2/${ID}_annot_feature_map.txt
singularity exec ${SINGULARITY_IMG} ${TRINITY_HOME}/Analysis/DifferentialExpression/rename_matrix_feature_identifiers.pl \
	    ${COUNTS_DIR}/${ID}/${ID}.gene.counts.matrix $WORKDIR/data/annotations/${ID}_run2/${ID}_annot_feature_map.txt > ${COUNTS_DIR}/${ID}/${ID}_gene_counts_matrix_annot
