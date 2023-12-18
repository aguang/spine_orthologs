#!/bin/bash

#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 24:00:00

module load transdecoder
module load blast/2.6.0+ hmmer/3.1b2
REPO=/gpfs/data/datasci/aguang/spine_orthologs
DATA=$REPO/data
TRANSCRIPTOMES=$DATA/transcriptomes

#TransDecoder.LongOrfs -t $TRANSCRIPTOMES/ET-transcripts.fa
hmmsearch --cpu 8 -E 1e-10 --domtblout $TRANSCRIPTOMES/ET.pfam.domtblout $DATA/Pfam-A.hmm ET-transcripts.fa.transdecoder_dir/longest_orfs.pep
TransDecoder.Predict -t $TRANSCRIPTOMES/ET-transcripts.fa --retain_pfam_hits $TRANSCRIPTOMES/ET.pfam.domtblout
