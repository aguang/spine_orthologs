#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH --mem 64G
#SBATCH --array=0-4
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/05_assembly_qc-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/05_assembly_qc-%J.out

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/agalma
module load samtools

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

cd $DATA/reports/$ID
singularity exec ${SINGULARITY_IMG} bowtie2-build *.assembly.fa ${ID}.fa
singularity exec ${SINGULARITY_IMG} bowtie2 -p 10 -q --no-unal -k 20 -x ${ID}.fa -1 ${READ1} -2 ${READ2} 2>align_stats.txt| samtools view -@10 -Sb -o bowtie2.bam
