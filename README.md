# Echinoderma spine orthologs

## References

 * *H.pulcherrimus:* https://cell-innovation.nig.ac.jp/cgi-bin/Hpul_public/Hpul_annot_download.cgi
 * *S.purpuratus:* https://download.xenbase.org/echinobase/Genomics/Spur5.0/
 * *Lvar:* https://www.echinobase.org/echinobase/static-echinobase/ftpDatafiles.jsp
 * *ET:* https://download.xenbase.org/echinobase/Legacy/

## Directory organization

 * **metadata:** Contains Dockerfiles
 * **scripts:** Contains scripts for running Orthofinder, TransDecoder, etc etc
 * **results:** any files that will be provided to the collaborator

This template also comes with a pre-written github action workflow that will work out-of-the-box as is and automates the process of updating docker images for your analysis project, publishing these updates, and image versioning. To ensure this workflow works for your new repo, you will need to create **two github secrets** for your repo as follows:

# CBC Project Information

```
title:
tags:
analysts:
git_repo_url:
resources_used:
summary:
project_id:
```
