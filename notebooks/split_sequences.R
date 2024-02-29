# utility function to split sequences by folder
# writes list of orthogroups for each combo

library(tidyverse)
PATH <- "/Users/aguang/CORE/spine_orthologs"
DATA <- "/Users/aguang/Google Drive/Shared drives/CBC-HPC/Data/Spine_orthologs"
orthogroups <- read_tsv(file.path(DATA,"OrthoFinder/Results_Jan08/Orthogroups/Orthogroups.tsv"))
colnames(orthogroups) <- c("Orthogroup", "Hp", "LvGrn", "LvRed", "Pencil", "Sp")
orthogroup_seqs <- file.path(DATA,"OrthoFinder/Results_Jan08/Orthogroup_Sequences")
folders <- file.path(DATA,"OrthoFinder/overlaps")
#tmp <- lapply(list.files(folders,full.names=TRUE), function(x) dir.create(file.path(x,"sequences"),showWarnings=FALSE))

split_orthogroups <- mutate(orthogroups,Pencilt=!is.na(Pencil),Hpt=!is.na(Hp),Spt=!is.na(Sp),LvGrnt=!is.na(LvGrn)) %>%
    nest(data=c(Orthogroup,Hp,LvGrn,LvRed,Sp,Pencil)) %>%
    filter(Pencilt | Hpt | Spt | LvGrnt) %>%
    arrange(desc(Pencilt),desc(Hpt),desc(Spt),desc(LvGrnt))

names(split_orthogroups$data) <- c("all","ET_Hp_Sp","ET_Hp_LvGrn","ET_Hp","ET_Sp_LvGrn",
                                   "ET_Sp","ET_LvGrn","ET","Hp_Sp_LvGrn","Hp_Sp",
                                   "Hp_LvGrn","Hp","Sp_Lvgrn","Sp","LvGrn")
split_ids <- lapply(split_orthogroups$data, function(x) x$Orthogroup)
lapply(names(split_ids), function(x) {
    ogs <- split_ids[[x]]
    path <- file.path(folders, x)
    con <- file(file.path(path,"ogs.txt"))
    writeLines(ogs, con)
})

