#!/bin/bash
#SBATCH -n 1
#SBATCH --mem 4g
#SBATCH -t 00:10:00
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/03_agalma_catalog-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/03_agalma_catalog-%J.out

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
DATA=$WORKDIR/data/agalma

export BIOLITE_RESOURCES="database=$DATA/agalma.sqlite"
export AGALMA_DB=$DATA/agalma.sqlite
export SINGULARITY_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/agalma.simg
FASTQS=$WORKDIR/data/fastqs

mkdir -p $DATA/data
mkdir -p $DATA/scratch
mkdir -p $DATA/reports

singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Hp1 -p ${FASTQS}/Hp1_R1_001.fastq.gz ${FASTQS}/Hp1_R2_001.fastq.gz -s "Hemicentrotus pulcherrimus" -n 7650 --individual Hp1
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Hp2 -p ${FASTQS}/Hp2_R1_001.fastq.gz ${FASTQS}/Hp2_R2_001.fastq.gz -s "Hemicentrotus pulcherrimus" -n 7650 --individual Hp2
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Hp3 -p ${FASTQS}/Hp3_R1_001.fastq.gz ${FASTQS}/Hp3_R2_001.fastq.gz -s "Hemicentrotus pulcherrimus" -n 7650 --individual Hp3
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvGr145 -p ${FASTQS}/LvGrn145_R1_001.fastq.gz ${FASTQS}/LvGrn145_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvGr145
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvGr146 -p ${FASTQS}/LvGrn149_R1_001.fastq.gz ${FASTQS}/LvGrn149_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvGr149
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvOv1 -p ${FASTQS}/LvOv1_R1_001.fastq.gz ${FASTQS}/LvOv1_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvOv1
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvOv2 -p ${FASTQS}/LvOv2_R1_001.fastq.gz ${FASTQS}/LvOv2_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvOv2
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvOv3 -p ${FASTQS}/LvOv3_R1_001.fastq.gz ${FASTQS}/LvOv3_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvOv3
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvRed136 -p ${FASTQS}/LvRed136_R1_001.fastq.gz ${FASTQS}/LvRed136_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvRed136
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvRed144 -p ${FASTQS}/LvRed144_R1_001.fastq.gz ${FASTQS}/LvRed144_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvOv1
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Pencil1 -p ${FASTQS}/Pencil1_R1_001.fastq.gz ${FASTQS}/Pencil1_R2_001.fastq.gz -s "Eucidaris tribuloides" -n 7632 --individual Pencil1
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Pencil1 -p ${FASTQS}/Pencil2_R1_001.fastq.gz ${FASTQS}/Pencil2_R2_001.fastq.gz -s "Eucidaris tribuloides" -n 7632 --individual Pencil2
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Pencil1 -p ${FASTQS}/Pencil3_R1_001.fastq.gz ${FASTQS}/Pencil3_R2_001.fastq.gz -s "Eucidaris tribuloides" -n 7632 --individual Pencil3
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Sp1 -p ${FASTQS}/Sp1_R1_001.fastq.gz ${FASTQS}/Sp1_R2_001.fastq.gz -s "Strongylocentrotus purpuratus" -n 7668 --individual Sp1
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Sp2 -p ${FASTQS}/Sp2_R1_001.fastq.gz ${FASTQS}/Sp2_R2_001.fastq.gz -s "Strongylocentrotus purpuratus" -n 7668 --individual Sp2
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Sp3 -p ${FASTQS}/Sp3_R1_001.fastq.gz ${FASTQS}/Sp3_R2_001.fastq.gz -s "Strongylocentrotus purpuratus" -n 7668 --individual Sp3

# Concatenating sequences for assembly

cat ${FASTQS}/Hp*_R1_001.fastq.gz > ${FASTQS}/combined/Hp_combined_R1_001.fastq.gz
cat ${FASTQS}/Hp*_R2_001.fastq.gz > ${FASTQS}/combined/Hp_combined_R2_001.fastq.gz
cat ${FASTQS}/LvGrn*_R1_001.fastq.gz > ${FASTQS}/combined/LvGrn_combined_R1_001.fastq.gz
cat ${FASTQS}/LvGrn*_R2_001.fastq.gz > ${FASTQS}/combined/LvGrn_combined_R2_001.fastq.gz
cat ${FASTQS}/LvOv*_R1_001.fastq.gz > ${FASTQS}/combined/LvOv_combined_R1_001.fastq.gz
cat ${FASTQS}/LvOv*_R2_001.fastq.gz > ${FASTQS}/combined/LvOv_combined_R2_001.fastq.gz
cat ${FASTQS}/LvRed*_R1_001.fastq.gz > ${FASTQS}/combined/LvRed_combined_R1_001.fastq.gz
cat ${FASTQS}/LvRed*_R2_001.fastq.gz > ${FASTQS}/combined/LvRed_combined_R2_001.fastq.gz
cat ${FASTQS}/Pencil*_R1_001.fastq.gz > ${FASTQS}/combined/Pencil_combined_R1_001.fastq.gz
cat ${FASTQS}/Pencil*_R2_001.fastq.gz > ${FASTQS}/combined/Pencil_combined_R2_001.fastq.gz
cat ${FASTQS}/Sp*_R1_001.fastq.gz > ${FASTQS}/combined/Sp_combined_R1_001.fastq.gz
cat ${FASTQS}/Sp*_R2_001.fastq.gz > ${FASTQS}/combined/Sp_combined_R2_001.fastq.gz

singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Pencil_combined -p ${FASTQS}/combined/Pencil_combined_R1_001.fastq.gz ${FASTQS}/combined/Pencil_combined_R2_001.fastq.gz -s "Eucidaris tribuloides" -n 7632 --individual Pencil_combined
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Hp_combined -p ${FASTQS}/combined/Hp_combined_R1_001.fastq.gz ${FASTQS}/combined/Hp_combined_R2_001.fastq.gz -s "Hemicentrotus pulcherrimus" -n 7650 --individual Hp_combined
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvGrn_combined -p ${FASTQS}/combined/LvGrn_combined_R1_001.fastq.gz ${FASTQS}/combined/LvGrn_combined_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvGrn_combined
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvOv_combined -p ${FASTQS}/combined/LvOv_combined_R1_001.fastq.gz ${FASTQS}/combined/LvOv_combined_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvOv_combined
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i LvRed_combined -p ${FASTQS}/combined/LvRed_combined_R1_001.fastq.gz ${FASTQS}/combined/LvRed_combined_R2_001.fastq.gz -s "Lytechinus variegatus" -n 7654 --individual LvRed_combined
singularity exec ${SINGULARITY_IMG} agalma catalog insert -i Sp_combined -p ${FASTQS}/combined/Sp_combined_R1_001.fastq.gz ${FASTQS}/combined/Sp_combined_R2_001.fastq.gz -s "Strongylocentrotus purpuratus" -n 7668 --individual Sp_combined
