#!/bin/bash
#SBATCH -n 4
#SBATCH --mem=16G
#SBATCH -t 24:00:00
#SBATCH --array=0-5
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/06_transdecoder-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/06_transdecoder-%J.out

module load transdecoder
module load blast/2.6.0+ hmmer/3.1b2
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
AGALMA=$WORKDIR/data/agalma/scratch
METADATA=${WORKDIR}/metadata
TRANSCRIPTOMES=$WORKDIR/data/transcriptomes
PROTEOMES=$WORKDIR/data/proteomes

# if everything runs perfectly the transcriptome-n files will be in order, otherwise you'll have to rearrange yourself
"""
cd $AGALMA
mv transcriptome-3 transcriptome-Pencil
mv transcriptome-4 transcriptome-LvGrn
mv transcriptome-6 transcriptome-LvRed
mv transcriptome-7 transcriptome-Sp
mv transcriptome-8 transcriptome-Hp
"""

IDS=(
Pencil
Hp
LvGrn
#LvOv
LvRed
Sp
)

ID=${IDS[$SLURM_ARRAY_TASK_ID]}
echo $ID

cd $TRANSCRIPTOMES
hmmsearch --cpu 8 -E 1e-10 --domtblout $TRANSCRIPTOMES/${ID}.pfam.domtblout $METADATA/Pfam-A.hmm ${AGALMA}/transcriptome-${ID}/${ID}_combined.fa.transdecoder_dir/longest_orfs.pep
# use blastp hits from agalma
cd $PROTEOMES
TransDecoder.Predict -t $AGALMA/transcriptome-${ID}/trinity_out_dir/Trinity.fasta --retain_pfam_hits $TRANSCRIPTOMES/${ID}.pfam.domtblout --retain_blastp_hits ${AGALMA}/transcriptome-${ID}/blastp.tsv
