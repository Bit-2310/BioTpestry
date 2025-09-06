import scanpy as sc
import argparse
import os
import tarfile
import urllib.request
from pathlib import Path

def download_and_extract_data(url, output_dir):
    """Downloads and extracts the 10x Genomics dataset."""
    output_path = Path(output_dir)
    # The file is a tarball, e.g., pbmc3k_filtered_gene_bc_matrices.tar.gz
    tarball_name = Path(url).name
    extracted_folder_name = tarball_name.replace(".tar.gz", "")
    final_data_path = output_path / extracted_folder_name

    # Check if data is already extracted
    if final_data_path.exists():
        print(f"INFO: Data already found at {final_data_path}. Skipping download.")
        return final_data_path

    print(f"INFO: Downloading data from {url}...")
    output_path.mkdir(parents=True, exist_ok=True)
    tarball_path = output_path / tarball_name
    urllib.request.urlretrieve(url, tarball_path)

    print(f"INFO: Extracting data to {output_path}...")
    with tarfile.open(tarball_path, "r:gz") as tar:
        tar.extractall(path=output_path)
    
    # Clean up the downloaded tarball
    os.remove(tarball_path)
    print("INFO: Extraction complete.")
    
    return final_data_path

def main(args):
    """Main function to run the QC pipeline."""
    
    # 1. Download and extract the data
    raw_data_path = download_and_extract_data(args.pbmc_url, args.output_dir)
    
    # The actual count matrix is in a subfolder, typically 'filtered_gene_bc_matrices/hg19' for human data
    matrix_path = raw_data_path / 'filtered_gene_bc_matrices' / 'hg19'
    
    print(f"INFO: Loading data from {matrix_path}...")
    adata = sc.read_10x_mtx(
        matrix_path,
        var_names='gene_symbols',
        cache=True
    )
    adata.var_names_make_unique()

    print("INFO: Starting QC process...")
    # 2. Calculate mitochondrial gene percentage
    adata.var['mt'] = adata.var_names.str.startswith('MT-')
    sc.pp.calculate_qc_metrics(adata, qc_vars=['mt'], percent_top=None, log1p=False, inplace=True)

    # 3. Apply filters
    print(f"INFO: Initial cell count: {adata.n_obs}")
    print(f"INFO: Filtering cells with < {args.min_genes} genes...")
    sc.pp.filter_cells(adata, min_genes=args.min_genes)
    
    print(f"INFO: Filtering genes present in < {args.min_cells} cells...")
    sc.pp.filter_genes(adata, min_cells=args.min_cells)
    
    print(f"INFO: Filtering cells with > {args.mito_cutoff}% mitochondrial reads...")
    adata = adata[adata.obs.pct_counts_mt < args.mito_cutoff, :]
    print(f"INFO: Final cell count after QC: {adata.n_obs}")

    # 4. Save the filtered AnnData object
    output_h5ad_path = Path(args.output_h5ad)
    output_h5ad_path.parent.mkdir(parents=True, exist_ok=True)
    print(f"INFO: Saving filtered data to {output_h5ad_path}...")
    adata.write(output_h5ad_path)
    print("INFO: QC script finished successfully.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Fetch PBMC3k data and perform QC.")
    
    # Arguments from config.sh
    parser.add_argument('--pbmc_url', type=str, required=True, help='URL for PBMC3k dataset')
    parser.add_argument('--output_dir', type=str, required=True, help='Directory to save raw data')
    parser.add_argument('--min_genes', type=int, required=True, help='Min genes per cell')
    parser.add_argument('--min_cells', type=int, required=True, help='Min cells per gene')
    parser.add_argument('--mito_cutoff', type=float, required=True, help='Mitochondrial percentage cutoff')
    parser.add_argument('--output_h5ad', type=str, required=True, help='Path to save the output h5ad file')

    args = parser.parse_args()
    main(args)