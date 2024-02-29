#!/bin/bash
#SBATCH -n 1
#SBATCH --mem=4G
#SBATCH -t 24:00:00

# This is a utility script to copy orthogroup sequences into their own folders by species overlap from the OrthoFinder results
# based on ogs.txt lists in each of the folders
# the ogs.txt list was generated with split_sequences.R from the orthogroups.tsv data table

ORTHO=/gpfs/data/datasci/aguang/spine_orthologs/data/proteomes/spine/OrthoFinder
for i in "$ORTHO"/overlaps/*
do
    echo $i
    while read -r line
    do
#	echo $line
	cp $ORTHO/Results_Jan08/Orthogroup_Sequences/$line.fa $i/sequences/$line.fa
    done < $i/ogs.txt
done
