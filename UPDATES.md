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
