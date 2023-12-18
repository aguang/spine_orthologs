#!/bin/bash
#SBATCH -c 20
#SBATCH --mem 160G
#SBATCH -t 4-00:00:00
#SBATCH -C intel
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/04_agalma_transcriptome-Hp-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/04_agalma_transcriptome-Hp-%J.out

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/agalma

export BIOLITE_RESOURCES="database=$DATA/agalma.sqlite"
export AGALMA_DB=$DATA/agalma.sqlite
export SINGULARITY_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/agalma.simg

IDS=(
#Pencil_combined
Hp_combined
#LvGrn_combined
#LvOv_combined
#LvRed_combined
#Sp_combined
)

#ID=${IDS[$SLURM_ARRAY_TASK_ID]}

for ID in "${IDS[@]}"
do
    echo $ID

    cd $DATA/scratch
    singularity exec ${SINGULARITY_IMG} agalma transcriptome --id $ID

    cd $DATA/reports
    singularity exec ${SINGULARITY_IMG} agalma report --id $ID
done
