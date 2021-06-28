args <- commandArgs(trailingOnly=TRUE) # required command line arguments order: {cleaned data csv} {k}
data <- as.matrix(read.csv(file=args[1])) # load cleaned data into matrix
clusters <- FastPG::fastCluster(data=data, k=args[2]) # compute clusters
cellID <- data[,1] # get all cell IDs
community <- clusters$communities # get all cell community assignations (these are in the same order as cells in data)
cells <- cbind(cellID, community) # combine cell IDs and community assignations for export
write.table(cells,file="cells.csv",row.names=FALSE,quote=FALSE) # write data to csv

# TO DO: make csv with cluster identifications

cat(clusters$modularity)