args <- commandArgs(trailingOnly=TRUE) # required command line arguments order: {cleaned data csv} {k}
data <- as.matrix(read.csv(file=args[1])) # load cleaned data into matrix
clusters <- FastPG::fastCluster(data=data, k=args[2]) # compute clusters

# TO DO: make csv with cluster identifications

cat(clusters$modularity)