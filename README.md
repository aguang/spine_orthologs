# CBC analysis template

Template for analyses repositories. For more information see https://compbiocore-brown.slab.com/posts/data-organisation-for-analysis-repos-fdi2cddd. Folders that should be present in all such repositories are:

 * **metadata:** files such as sample manifests, YAML control files, and Dockerfiles 
 * **scripts:** additional scripts created for analysis of data

**Note:** If you are including a Dockerfile, make sure it starts with the FROM statement; do not use any commenting or labeling before that statement. 

Optional directories are:

 * **notebooks:** notebooks for processed data
 * **results:** any files that will be provided to the collaborator

This template also comes with a pre-written github action workflow that will work out-of-the-box as is and automates the process of updating docker images for your analysis project, publishing these updates, and image versioning. To ensure this workflow works for your new repo, you will need to create **two github secrets** for your repo as follows:

* **GH_USERNAME -** this is your guthub username
* **GH_TOKEN -** this is a personal access token (PAT); make sure it has read, write, and delete permissions (if you need to make one and are unsure how, please see:  https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) 

**IMPORTANT:** Before making edits to your repo, please make sure you have visited and read: https://app.gitbook.com/o/-LLCCXzgv2-pRyGi-QB2/s/-LpZv9ZetU-XF7BJyICY/container-automation-pipeline

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
