# Overview

This folder contains all scripts used in the bioinformatics processing of the spine transcriptome data. They are meant to be run in order, with results from each script feeding directly into the next unless otherwise stated.

All scripts were run on the HPC system at Brown, aka OSCAR, which uses SLURM. Steps to reproduce have been detailed as much as possible, but we cannot guarantee that these scripts will work for you. Associated singularity images are in `00_env.sh`, and more details on each script are below.

# Requirements

To run, you will need at least 160GB of memory, primarily for the transcriptome assembly step. The way the scripts are written assumes you have access to this repository, and that directory structure within the repository will remain the same, i.e. singularity images will be in the `metadata` folder, scripts will be in the `scripts` folder, logs for scripts will be in `scripts/logs`, etc. All of that is already set up if you clone the repository, however if you move files around or pipe output to a diffrent directory there will likely be issues.

You must also have access to the raw data, which is assumed to be in the `data/fastqs` folder. Change the path in `03_agalma_catalog.sh` if the raw data is in a different folder.

# Files

 * `00_env.sh` sets up the environment by downloading tagged versions of the singularity images used in the analysis to the `metadata` folder.

## Reference transcriptome

 The next two scripts are standalone for a reference transcriptome analysis of orthogroups. They do not have to be run for the rest of the analysis to function.
   * `01_transdecoder_ET.sh` runs transdecoder on the ET reference to get a reference proteome. Transdecoder is pulled from the Oscar modules rather than a singularity image.
   * `02_orthofinder.sh` runs OrthoFinder2 on the reference transcriptomes to get a general overview of orthogroups between the species.

## Transcriptome assembly and orthologous gene identification
 * `03_agalma_catalog.sh` catalogs the spine tissue data in a BioLite database and concatenates the raw reads into a combined fastq file for each species for input into agalma/Trinity.
 * `04_agalma_assemble.sh` runs the agalma transcriptome assembly pipeline
 * `05_assemble_qc.sh` runs bowtie2 on the assemblies to [assess assembly quality](https://github.com/trinityrnaseq/trinityrnaseq/wiki/RNA-Seq-Read-Representation-by-Trinity-Assembly).
 * `06_transdecoder.sh` runs transdecoder including `TransDecoder.LongOrfs`, `hmmsearch`, and `TransDecoder.predict`
 * `07_orthofinder.sh` runs OrthoFinder on all sequences `data/proteomes/spine`
 * `08_trinotate.sh` runs Trinotate including `blastp` and `blastx` against swissport, `pfam`, and attempts `signalp6` (currently doesn't work) as well as outputs a tsv sheet report. NOTE: if you have to rerun for any reason make sure to delete certain checkpoints like `__init` and `loading` as you will not have any of the mappings or old loadings in your sqlite db if you don't do so. For some reason it writes a new db but skips over those commands so you end up losing what you had before. See https://github.com/Trinotate/Trinotate.github.io/issues/70.
