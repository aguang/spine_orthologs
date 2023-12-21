# 12/20/23 - transdecoder, LvOv assembly run

## LvOv assembly

 * LvOv assembly issue was that the LvOv files are titled differently (no R001_1 or anything) so the command to cat all replicates into one file produced nothing. Did the correct `cat` command and started running, folder is `transcriptome-10`
 * Ended in an error however
 * `Error, cmd: /opt/agalma/opt/trinity-2.5.1/util/..//trinity-plugins/jellyfish/bin/jellyfish count -t 32 -m 25 -s 38372075584  --canonical  both.fa died with ret 9 at /opt/agalma/opt/trinity-2.5.1/util/insilico_read_normalization.pl line 758.` 
 * Indicates out of memory, so need to increase

## Transdecoder

 * Set up script in 06_transdecoder.sh, running for all organisms except LvOv right now
 * For some reason LvGrn Trinity.fasta is not concordant with the one from the agalma report, but the rest of them are. But we use the Trinity.fasta rather than the ones from the reports anyway.

# 12/18/23 - trinotate, [issue #14](https://github.com/aguang/spine_orthologs/issues/14)

 * need to do transdecoder before doing trinotate
 * annotation is also separate from orthology inference, so going to do OrthoFinder2 and OrthoSNAP after transdecoder instead

# 12/15/23 - transcriptome assembly QC, [issue #13](https://github.com/aguang/spine_orthologs/issues/13)

 * QC for transcriptome assembly is done
 * Summary: Since the spine analysis depends on the quality of the transcriptome, I assessed the transcriptome quality by mapping the RNAseq reads back to the assembled transcriptome. In a perfect scenario, almost all the reads map back to the assembly and around 70-80% of them will map back as paired reads. For these species, around 75% map back, with ET/Pencil being lower at around 65%. Around 55% map as pairs and the rest of the 65-80% map when they are unpaired. I attached two, LvGrn and Pencil alignment stats to show as examples.
 * This is not ideal, but also not indicative of anything being terribly wrong like contamination. Usually this means that many of the assembled transcripts are fragmented due to low coverage, so fewer properly paired reads will align to the individual contigs and some will not align at all. The main two ways to improve that would be to do more sequencing, or to see if incorporating a reference improves the assembly by providing scaffolding at certain points. Regardless, I can proceed with the next steps and if we want to improve the assembly it can be parallel work or we can return to it.

# 12/11/23

 * Downloaded singularity image of staphb/bowtie2 to `metadata` folder.
 * Assembly with agalma was finished last week, however LvOv was not run. All others were, so we will make a note of this as an issue to revisit later.
 * Ran [assembly QC with bowtie2](https://github.com/trinityrnaseq/trinityrnaseq/wiki/RNA-Seq-Read-Representation-by-Trinity-Assembly) on all successfully assembled transcriptomes. To pass QC, the majority of all reads should map back to the assembly, and ~70-80% of mapped fragments should be mapped as proper pairs, i.e. aligning concordantly to alignment 1 or more times.

# 11/30/23

 * Downloaded agalma Docker image to `metadata` folder
 * Catalogued all FASTQ files into agalma db

# 10/26/23

 * OrthoFinder and transdecoder finished running, analyzing on R now.

# 10/16/23

 * Script for transdecoder for ET transcriptome to convert to proteome. We only do the pfam search for now but can add in blastp later.
 * Initial docker image but it's running into some issues with builds, maybe it's internet connectivity though

# 9/25/23

 * Initial docker image by pulling from [daviedmms/orthofinder](https://hub.docker.com/r/davidemms/orthofinder)
    * Started to add in transdecoder but haven't built image with it yet
 * To run example analysis:
 ```
 docker run -v /Users/aguang/CORE/spine_orthologs/data/OrthoFinder/ExampleData/:/root/ExampleData --rm spine_orthologs:20230925 orthofinder -f ExampleData/
 ```
 * OrthoFinder best practices: https://davidemms.github.io/orthofinder_tutorials/orthofinder-best-practices.html
 * Reference proteomes are pulled from:
    * H.pul: https://cell-innovation.nig.ac.jp/cgi-bin/Hpul_public/Hpul_annot_download.cgi
    * Spur: https://download.xenbase.org/echinobase/Genomics/Spur5.0/
    * ET: https://download.xenbase.org/echinobase/Legacy/ (needs to be converted to protein translation with transdecoder)
    * Lvar: https://www.echinobase.org/echinobase/static-echinobase/ftpDatafiles.jsp
 * To run analysis on downloaded proteomes (minus ET):
 ```
 docker run -v /Users/aguang/CORE/spine_orthologs/data/proteomes/:/root/proteomes --rm spine_orthologs:20230925 orthofinder -f proteomes/
 ```
 * Set up batch script on Oscar and ran Orthofinder on data thru singularity
