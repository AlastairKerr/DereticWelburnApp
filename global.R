mito <- read.table('mitosis.tsv', header=TRUE, sep="\t")
tab <-read.table('region-table.tsv', sep="\t", fill=T, header=T)
tab$Cluster = as.factor(tab$Cluster)

ch <-read.table('hs.count')
cg <-read.table('gg.count')
cd <-read.table('dr.count')

ch$V2 <- as.factor(ch$V2)
cg$V2 <- as.factor(cg$V2)
cd$V2 <- as.factor(cd$V2)
