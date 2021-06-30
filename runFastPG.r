# runFastPG.r runs the FastPG program (https://github.com/sararselitsky/FastPG) to cluster cells by the markers
# included in the input csv.
#
# Arguments:
#     1. the cleaned data input csv
#     2. the local neighborhood size (k)
#     3. the number of cpus to use in the k nearest neighbors part of clustering
#     4. output directory
#
# Output: 
#     cells.csv - which contains the cell ID and cluster ID
#     clusters.csv - which contains the mean expression values for each marker, for each cluster


# get data and cluster it
args <- commandArgs(trailingOnly=TRUE) # required command line arguments order: {cleaned data csv} {k}
data <- as.matrix(read.csv(file=args[1])) # load cleaned data into matrix TIME: 273.236s
clusters <- FastPG::fastCluster(data=data, k=as.integer(args[2]), num_threads=as.integer(args[3])) # compute clusters TIME: 144.232s
community <- clusters$communities # get all cell community assignations (these are in the same order as cells in data) TIME: 0s
data <- cbind(community, data) # add community assignation to data TIME: 0.504s

# make cells.csv
cells <- (data[,c('CellID','community')]) # get just cell IDs and community assignations for export TIME: 0.005s
write.table(cells,file=paste(args[4],'cells.csv', sep='/'),row.names=FALSE,quote=FALSE,sep=',') # write data to csv TIME: 3.478s

# make clusters.csv
clusterData <- aggregate(subset(data, select=-c(CellID)), list(data[,'community']), mean) # group feature/expression data by cluster and find mean expression for each cluster, remove CellID column TIME: 6.780s
write.table(subset(clusterData, select=-c(Group.1)),file=paste(args[4],'clusters.csv', sep='/'),row.names=FALSE,quote=FALSE,sep=',') # remove group number column because is identical to community assignation number and write data to csv TIME: 0.037s

cat(clusters$modularity) # output modularity