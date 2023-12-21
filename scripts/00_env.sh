# sets up environment and singularity images
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs

# all singularity images should be in the metadata folder
# commands to pull singularity images
cd $WORKDIR/metadata
wget https://data.broadinstitute.org/Trinity/TRINOTATE_SINGULARITY/trinotate.v4.0.2.simg
singularity build agalma.simg docker://dunnlab/agalma
singularity build bowtie2.simg docker://staphb/bowtie2:2.5.1

# pulling databases
#wget https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
