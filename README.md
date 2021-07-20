# mcmicro-fastPG

An mcmicro module that provides a command-line interface for [FastPG](https://github.com/sararselitsky/FastPG), a C++ implementation of the popular Phenograph method.

Example usage:
```
docker run --rm -v "$PWD":/data labsyspharm/mc-fastpg:1.0.4 python3 /app/cluster.py \
  -i /data/unmicst-exemplar-001.csv -o /data/
```
where `unmicst-exemplar-001.csv` is a [spatial feature table](https://mcmicro.org/step-quant.html) produced by MCMICRO. Note that the above command must be executed from the directory containing `uncmist-exemplar-001.csv`. Alternatively, replace `"$PWD"` with a full path to the data. If the largest value in the input dataset is >1000, the data will be log10 transformed. This will be reflected in the means of the output `clusters` file.

## Parameter Reference

```
usage: cluster.py [-h] -i INPUT [-o OUTPUT] [-m MARKERS] [-v] [-k NEIGHBORS] [-n NUM_THREADS] [-c]

Cluster cell types using mcmicro marker expression data.

optional arguments:
  -h, --help            show this help message and exit
  -i INPUT, --input INPUT
                        Input CSV of mcmicro marker expression data for cells
  -o OUTPUT, --output OUTPUT
                        The directory to which output files will be saved
  -m MARKERS, --markers MARKERS
                        A text file with a marker on each line to specify which markers to use for clustering
  -v, --verbose         Flag to print out progress of script
  -k NEIGHBORS, --neighbors NEIGHBORS
                        the number of nearest neighbors to use when clustering. The default is 30.
  -n NUM_THREADS, --num-threads NUM_THREADS
                        the number of cpus to use during the k nearest neighbors part of clustering. The default is 1.
  -c, --method          Include a column with the method name in the output files.
```