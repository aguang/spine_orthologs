#!/bin/bash
#SBATCH -t 96:00:00
#SBATCH --mem 256G
#SBATCH --cpus-per-task=8
#SBATCH --array=0-5
#SBATCH -e /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/08_trinotate/08_trinotate-%J.err
#SBATCH -o /oscar/data/datasci/aguang/spine_orthologs/scripts/logs/08_trinotate/08_trinotate-%J.out

WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
AGALMA=$WORKDIR/data/agalma/scratch
METADATA=$WORKDIR/metadata
TRANSCRIPTOMES=$WORKDIR/data/transcriptomes
PROTEOMES=$WORKDIR/data/proteomes
ANNOTATIONS=$WORKDIR/data/annotations

export SINGULARITY_BINDPATH="/oscar/data/datasci/aguang/spine_orthologs,/users/aguang/.local"
export TRINOTATE_HOME="/usr/local/src/Trinotate"
SINGULARITY_IMG=${WORKDIR}/metadata/trinotate.v4.0.2.simg

IDS=(
Pencil
Hp
LvGrn
LvRed
LvOv
Sp
)

ID=${IDS[$SLURM_ARRAY_TASK_ID]}
echo $ID

cd $ANNOTATIONS
mkdir -p ${ID}_run2
cd ${ID}_run2

TRANSDECODER=$PROTEOMES/spine/${ID}.fasta.transdecoder.pep
FASTA=$AGALMA/transcriptome-${ID}/trinity_out_dir/Trinity.fasta

# should go into 00_env.sh cuz you only run once
#singularity exec ${SINGULARITY_IMG} ${TRINOTATE_HOME}/Trinotate --create \
    #	    --db ${ID}_Trinotate.sqlite --trinotate_data_dir $METADATA

cp $METADATA/TrinotateBoilerplate.sqlite ./${ID}_Trinotate.sqlite

singularity exec ${SINGULARITY_IMG} ${TRINOTATE_HOME}/Trinotate --db ${ID}_Trinotate.sqlite --init \
	    --gene_trans_map $AGALMA/transcriptome-${ID}/trinity_out_dir/Trinity.fasta.gene_trans_map \
	    --transcript_fasta $FASTA \
	    --transdecoder_pep $TRANSDECODER

singularity exec ${SINGULARITY_IMG} ${TRINOTATE_HOME}/Trinotate --db ${ID}_Trinotate.sqlite --CPU 8 \
	    --transcript_fasta $FASTA \
	    --transdecoder_pep $TRANSDECODER \
	    --trinotate_data_dir $METADATA \
	    --run "swissprot_blastp swissprot_blastx pfam signalp6"
#	    --run "signalp6"

singularity exec ${SINGULARITY_IMG} ${TRINOTATE_HOME}/Trinotate --db ${ID}_Trinotate.sqlite --report > ${ID}_Trinotate_v2.tsv
