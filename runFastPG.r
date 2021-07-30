# runFastPG.r runs the FastPG program (https://github.com/sararselitsky/FastPG), an R implementation of the Phenograph method, to cluster cells by the markers
# included in the input csv.
#
# Arguments:
#     1. the cleaned data input csv
#     2. the local neighborhood size (k)
#     3. the number of cpus to use in the k nearest neighbors part of clustering
#     4. output directory
#     5. output file name for cell/cluster assignment
#     6. output file name for cluster mean feature values
#     7. flag to include method name as a column
#     8. log transform flag
#
# Output: 
#     cells.csv - which contains the cell ID and cluster ID
#     clusters.csv - which contains the mean expression values for each marker, for each cluster


# get data
args <- commandArgs(trailingOnly=TRUE) # required command line arguments order: {cleaned data csv} {k} {num_threads} {output dir}
data <- read.csv(file=args[1]) # read data
CellID <- data$CellID # save cell ID's
data <- subset(data, select = -c(CellID)) # remove Cell ID's from data so they aren't used for clustering
data <- as.matrix(data) # write data to matrix so it can be processed by FastPG
rownames(data) <- CellID # save rownames of data matrix as cell ID's

# log transform data according to flag, if auto, transform if the max value >1000. write state to yaml file
if (args[8] == 'true') {
    data <- log10(data)
    f <- file('config.yaml')
    writeLines(c('---','transform: true'), f)
    close(f)
} else if (args[8] == 'auto' && max(apply(data,2,max)) > 1000) {
    data <- log10(data)
    f <- file('config.yaml')
    writeLines(c('---','transform: true'), f)
    close(f)
} else {
    f <- file('config.yaml')
    writeLines(c('---','transform: false'), f)
    close(f)
}

# cluster data
clusters <- FastPG::fastCluster(data=data, k=as.integer(args[2]), num_threads=as.integer(args[3])) # compute clusters
Cluster <- clusters$communities # get all cell community assignations (these are in the same order as cells in data)
data <- cbind(Cluster, CellID, data) # add community assignation to data

# make cells.csv
cells <- (data[,c('CellID','Cluster')]) # get just cell IDs and community assignations for export
if (as.logical(args[7])) { # inlcude method column
    Method <- rep(c('FastPG'),nrow(cells))
    cells <- cbind(cells, Method)
}
write.table(cells,file=paste(args[4], args[5], sep='/'),row.names=FALSE,quote=FALSE,sep=',') # write data to csv

# make clusters.csv
clusterData <- aggregate(subset(data, select=-c(CellID)), list(data[,'Cluster']), mean) # group feature/expression data by cluster and find mean expression for each cluster, remove CellID column
clusterData <- subset(clusterData, select=-c(Group.1)) # remove group number column because is identical to community assignation number
if (as.logical(args[7])) { # inlcude method column
    Method <- rep(c('FastPG'),nrow(clusterData))
    clusterData <- cbind(clusterData, Method)
}
write.table(clusterData,file=paste(args[4], args[6], sep='/'),row.names=FALSE,quote=FALSE,sep=',') # write data to csv

cat(clusters$modularity) # output modularity