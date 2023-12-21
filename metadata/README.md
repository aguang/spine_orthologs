# File descriptions

Here we have all of our singularity images (for downloading, see `scripts/00_env.sh`) as well as different databases we map against. The files will be described under the appropriate heading. Most of these files are not in the Github repository due to their size, but they are in the directory on Oscar, so they'll be described anyway until replaced by instructions on creating them.

## Singularity images

 * `agalma.simg`: [agalma](https://bitbucket.org/caseywdunn/agalma/src/master/) v2.0.0 singularity image
 * `bowtie2.simg`: bowtie2 image from staphb. This does **not** include samtools
 * `Dockerfile`: A Dockerfile that contains OrthoFinder2. Needs to be updated with other binaries.
 * `trinotate.v4.0.2.simg`: Trinotate v4.0.2.

## Databases

 * `Pfam-A.hmm`: Pfam database, used for TransDecoder