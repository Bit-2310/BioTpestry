#!/bin/bash

# ==============================================================================
# BIO-TAPESTRY: MASTER CONFIGURATION FILE
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. DIRECTORY & FILE PATHS
# ------------------------------------------------------------------------------
# It's best practice to define paths relative to the project's root directory.
export PROJECT_ROOT=$(pwd)
export SCRIPT_DIR="${PROJECT_ROOT}/scripts"
export DATA_MIRROR_DIR="${PROJECT_ROOT}/data_mirror"
export DATA_DIR="${PROJECT_ROOT}/data"
export RESULTS_DIR="${PROJECT_ROOT}/results"
export H5AD_DIR="${RESULTS_DIR}/h5ad"
export TABLES_DIR="${RESULTS_DIR}/tables"
export FIGURES_DIR="${PROJECT_ROOT}/figures"
export LOG_DIR="${PROJECT_ROOT}/logs"

# ------------------------------------------------------------------------------
# 2. DATA SOURCES
# ------------------------------------------------------------------------------
# URLs for fetching the raw data.
export PBMC3K_URL="https://cf.10xgenomics.com/samples/cell-exp/1.1.0/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz"
export MOUSE_BRAIN_SPATIAL_URL="https://cf.10xgenomics.com/samples/spatial-exp/1.2.0/V1_Mouse_Brain_Sagittal_Anterior/V1_Mouse_Brain_Sagittal_Anterior_filtered_feature_bc_matrix.tar.gz"

# ------------------------------------------------------------------------------
# 3. ANALYSIS PARAMETERS
# ------------------------------------------------------------------------------
# -- QC Parameters --
export MITO_PERCENT_CUTOFF=5      # Max mitochondrial gene percentage
export MIN_GENES_PER_CELL=200     # Min number of genes expressed in a cell
export MIN_CELLS_PER_GENE=3       # Min number of cells expressing a gene

# -- Clustering Parameters --
export N_TOP_GENES=2000           # Number of highly variable genes to use
export N_PCS=30                   # Number of principal components for dimensionality reduction
export CLUSTER_RESOLUTION=0.5     # Leiden clustering resolution (higher = more clusters)

# -- DEG Parameters --
export DEG_LOG_FC_CUTOFF=0.25     # Log2 fold-change threshold for DEGs
export DEG_MIN_PCT=0.1            # Min percentage of cells expressing a gene in a cluster