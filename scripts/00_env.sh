#!/bin/bash
#SBATCH -t 12:00:00

# sets up environment and singularity images
WORKDIR=/oscar/data/datasci/aguang/spine_orthologs
METADATA=$WORKDIR/metadata

mkdir -p $WORKDIR/data/annotations

# all singularity images should be in the metadata folder
# commands to pull singularity images
cd $METADATA

"""
#wget https://data.broadinstitute.org/Trinity/TRINOTATE_SINGULARITY/trinotate.v4.0.2.simg
#singularity build agalma.simg docker://dunnlab/agalma
#singularity build bowtie2.simg docker://staphb/bowtie2:2.5.1
"""

# pulling databases
export SINGULARITY_BINDPATH=$WORKDIR
export TRINOTATE_HOME="/usr/local/src/Trinotate"
cd $WORKDIR/data/annotations/Pencil # hack for issue
singularity exec $METADATA/trinotate.v4.0.2.simg ${TRINOTATE_HOME}/Trinotate --create \
	    --db Trinotate.sqlite --trinotate_data_dir $METADATA

# signalp
# need to do academic download yourself
#tar -zxf signalp-6.0h.fast.tar.gz
pip install --user signalp6_fast/signalp-6-package/
SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )
cp -r signalp-6-package/models/* $SIGNALP_DIR/model_weights/
