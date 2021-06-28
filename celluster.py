import argparse
import pandas as pd

'''
Parse arguments.
Input file is required.
'''
def parseArgs():
    parser = argparse.ArgumentParser(description='Cluster cell types using mcmicro marker expression data.')
    parser.add_argument('-i', '--input', help="Input CSV of mcmicro marker expression data for cells", type=str, required=True)
    parser.add_argument('-o', '--output', help='The directory to which output files will be saved', type=str, required=False)
    parser.add_argument('-m', '--markers', help='A text file with a marker on each line to specify which markers to use for clustering', type=str, required=False)
    args = parser.parse_args()
    return args


'''
Clean data in input file.
NOTE: Currently we are doing this with pandas however, using csv might be faster.

Exclude the following data from clustering:
    - X_centroid, …, Extent, Orientation - morphological features
    - Any of the following DNA stains
        - DNA0, DNA1, DNA2, …
        - Hoechst0, Hoechst1, ....
        - DAPI0, DAPI1, …
    - AF* (e.g., AF488, AF555, etc.) - autofluorescence
    - A* (e.g., A488, A555, etc.) - secondary antibody staining only

To include any of these markers in the clustering, provide their exact names in a file passed in with the '-m' flag
'''
def clean(input_file):
    print('Cleaning dataset...')

    # load csv
    data = pd.read_csv(input_file)

    # a default list of features to exclude from clustering
    FEATURES_TO_REMOVE = ['X_centroid', 'Y_centroid', # morphological features
                        'column_centroid', 'row_centroid', 
                        'Area', 'MajorAxisLength', 
                        'MinorAxisLength', 'Eccentricity', 
                        'Solidity', 'Extent', 'Orientation', 
                        'DNA', 'Hoechst', 'DAP', # DNA stain
                        'AF', # autofluorescence
                        'A'] # secondary antibody staining only

    # find any columns in the input csv that should be excluded from clustering be default
    # NOTE: may want to replace this with regex, it might be faster.
    col_to_remove = []
    for col in data.columns:
        for feature in FEATURES_TO_REMOVE:
            if col.startswith(feature):
                col_to_remove.append(col)
    
    # drop all columns that should be excluded
    data = data.drop(columns=col_to_remove, axis=1)

    # save cleaned data to csv
    data.to_csv(f'{output}/clean_data.csv', index=False)

    print('Done.')


'''
Run an R script that runs FastPG. Scriptception.
'''
def runFastPG():
    print('Running R script...')
    import subprocess

    r_script = ['Rscript', 'celluster/runFastPG.r'] # use FastPG.r script
    r_args = [f'{output}/clean_data.csv', '30'] # current hardcoded arguments will be provided by user in future version

    # Build subprocess command
    command = r_script + r_args

    # run R script and get modularity from stdout 
    modularity = subprocess.check_output(command, universal_newlines=True)

    print(f'Modularity: {modularity}')
    print('Done.')


'''
Main.
'''
if __name__ == '__main__':
    args = parseArgs() # parse arguments
    if args.output is None:
        output = '.'
    clean(args.input)
    runFastPG()
