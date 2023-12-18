# sets up environment and singularity images
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs

# all singularity images should be in the metadata folder
cd $WORKDIR/metadata
singularity build agalma.simg docker://dunnlab/agalma
singularity build bowtie2.simg docker://staphb/bowtie2:2.5.1
