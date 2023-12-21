#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --mem 128G
#SBATCH --cpus-per-task=8
#SBATCH --array=0-4
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/05_assembly_qc-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/05_assembly_qc-%J.out

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/agalma
module load samtools
module load blast

export SINGULARITY_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/bowtie2.simg

IDS=(
Pencil
Hp
LvGrn
LvRed
Sp
)

ID=${IDS[$SLURM_ARRAY_TASK_ID]}
echo $ID

READ1=${WORKDIR}/data/fastqs/combined/${ID}_combined_R1_001.fastq.gz
READ2=${WORKDIR}/data/fastqs/combined/${ID}_combined_R2_001.fastq.gz

# bowtie2 mapping rates

cd $DATA/reports/$ID
# don't need to build index rn, just rerun
#singularity exec ${SINGULARITY_IMG} bowtie2-build *.assembly.fa ${ID}.fa
#singularity exec ${SINGULARITY_IMG} bowtie2 -p $SLURM_CPUS_PER_TASK -q --no-unal -k 20 -x ${ID}.fa -1 ${READ1} -2 ${READ2} 2>align_stats.txt| samtools view -@10 -Sb -o bowtie2.bam

# full length transcript analysis
makeblastdb -in uniprot_sprot.fasta -dbtype prot
