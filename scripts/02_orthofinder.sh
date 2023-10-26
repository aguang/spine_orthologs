#!/bin/bash

#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 24:00:00

export SINGULARITY_BINDPATH="/gpfs/data/datasci/aguang/spine_orthologs"
REPO=/gpfs/data/datasci/aguang/spine_orthologs

cp ET-transcripts.fa.transdecoder.pep $REPO/data/proteomes/ET-transcripts.fa.transdecoder.pep
singularity exec $REPO/metadata/orthofinder_latest.sif orthofinder -f $REPO/data/proteomes
