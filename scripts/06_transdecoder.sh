#!/bin/bash
#SBATCH -n 4
#SBATCH --mem=32G
#SBATCH -t 48:00:00
#SBATCH --array=0
# later do 0-5
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/06_transdecoder-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/06_transdecoder-%J.out

module load hpcx-mpi/4.1.5rc2s-yflad4v
module load blast-plus/2.2.30-cyxldrt hmmer-mpi/3.3.2-wyoo2te

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
AGALMA=$WORKDIR/data/agalma/scratch
METADATA=${WORKDIR}/metadata
TRANSCRIPTOMES=$WORKDIR/data/transcriptomes
PROTEOMES=$WORKDIR/data/proteomes


export SINGULARITY_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs"
SINGULARITY_IMG=${WORKDIR}/metadata/transdecoder.v5.7.1.simg

# if everything runs perfectly the transcriptome-n files will be in order, otherwise you'll have to rearrange yourself
"""
cd $AGALMA
mv transcriptome-3 transcriptome-Pencil
mv transcriptome-4 transcriptome-LvGrn
mv transcriptome-6 transcriptome-LvRed
mv transcriptome-7 transcriptome-Sp
mv transcriptome-8 transcriptome-Hp
mv transcriptome-11 transcriptome-LvOv
"""

#IDS=(
#Pencil
#Hp
#LvGrn
#LvOv
#LvRed
#Sp
#)

#ID=${IDS[$SLURM_ARRAY_TASK_ID]}
ID=LvOv
echo $ID

#cd $TRANSCRIPTOMES
hmmsearch --cpu 8 -E 1e-10 --domtblout $TRANSCRIPTOMES/${ID}.pfam.domtblout $METADATA/Pfam-A.hmm ${AGALMA}/transcriptome-${ID}/${ID}_combined.fa.transdecoder_dir/longest_orfs.pep
# use blastp hits from agalma

# transdecoder only recognizes directory you are in
cd $AGALMA/transcriptome-${ID}
singularity exec ${SINGULARITY_IMG} TransDecoder.Predict -t $AGALMA/transcriptome-${ID}/${ID}_combined.fa --retain_pfam_hits $TRANSCRIPTOMES/${ID}.pfam.domtblout --retain_blastp_hits ${AGALMA}/transcriptome-${ID}/blastp.tsv
cp -r ${ID}_combined.fa.transdecoder* $PROTEOMES
