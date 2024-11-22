# Echinoderma spine orthologs

This repository contains code used to generate orthologs and tissue specificty scores for a spine ortholog project with Cosmo Pieplow and Gary Wessel in the Ecology and Evolutionary Biology department at Brown University.

There are a few sections to the analysis:
 * A summary of orthologs in reference transcriptomes
 * Transcriptome assembly and identification of orthologs in spine-specific transcriptomes
 * Estimation of tissue specificty to orthologs relative to other transcriptomes such as gonads and embryo.

## To reproduce

 * To reproduce starting from intermediate results (i.e. after assembly, ortholog identification, annotation) run associated notebooks in the **notebooks** directory
 * To reproduce starting from raw reads, run scripts in order in **scripts** directory

## References

 * *H.pulcherrimus:* https://cell-innovation.nig.ac.jp/cgi-bin/Hpul_public/Hpul_annot_download.cgi
 * *S.purpuratus:* https://download.xenbase.org/echinobase/Genomics/Spur5.0/
 * *Lvar:* https://www.echinobase.org/echinobase/static-echinobase/ftpDatafiles.jsp
 * *ET:* https://download.xenbase.org/echinobase/Legacy/

## Directory organization

 * **data:** All relevant data for this project. Scripts to run use paths based off of this directory, but you can view the data on Google Drive as well.
 * **metadata:** Contains Dockerfiles. On Oscar also contains Singularity images.
 * **scripts:** Contains scripts for transcriptome assembly (agalma), translation (TransDecoder), OrthoFinder (ortholog identification), annotation (Trinotate). To reproduce the analyses, follow the steps in this directory.
 * **notebooks:** Contains notebooks for some summary statistics on all steps in scripts.
 * **results:** any files that will be provided to the collaborator
