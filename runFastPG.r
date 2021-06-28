# get data and cluster it
args <- commandArgs(trailingOnly=TRUE) # required command line arguments order: {cleaned data csv} {k}
data <- as.matrix(read.csv(file=args[1])) # load cleaned data into matrix
clusters <- FastPG::fastCluster(data=data, k=args[2]) # compute clusters
community <- clusters$communities # get all cell community assignations (these are in the same order as cells in data)
data <- cbind(community, data) # add community assignation to data

# make cells.csv
cells <- (data[,c('CellID','community')]) # get just cell IDs and community assignations for export
write.table(cells,file="cells.csv",row.names=FALSE,quote=FALSE,sep=',') # write data to csv

# make clusters.csv
clusterData <- aggregate(data[,-1], list(data[,'community']), mean) # group feature/expression data by cluster and find mean expression for each cluster
cols <- cols[cols != 'Group.1'] # remove group number because is identical to community assignation number
write.table(clusterData[,cols],file="clusters.csv",row.names=FALSE,quote=FALSE,sep=',') # write data to csv

cat(clusters$modularity) # output modularity