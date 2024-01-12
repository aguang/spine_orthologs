#!/bin/bash
#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 24:00:00
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/07_orthofinder-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/07_orthofinder-%J.out

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
AGALMA=$WORKDIR/data/agalma/scratch
METADATA=${WORKDIR}/metadata
TRANSCRIPTOMES=$WORKDIR/data/transcriptomes
PROTEOMES=$WORKDIR/data/proteomes/spine

export SINGULARITY_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/orthofinder_latest.sif

IDS=(
Pencil
Hp
LvGrn
LvOv
LvRed
Sp
)

for ID in "${IDS[@]}"
do
    echo $ID
    cp -r ${AGALMA}/transcriptome-${ID}/${ID}_combined.fa.transdecoder.* $PROTEOMES
done

singularity exec ${SINGULARITY_IMG} orthofinder -f $PROTEOMES
