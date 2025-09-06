#!/bin/bash

# ==============================================================================
# BIO-TAPESTRY: MASTER PIPELINE SCRIPT
# ==============================================================================
# This script runs the entire single-cell analysis workflow from start to finish.
# ==============================================================================

# --- Script Setup ---
# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error.
set -u
# Ensures that the exit status of a pipeline is the rightmost command to exit with a non-zero status.
set -o pipefail

# --- Load Configuration ---
echo "INFO: Loading configuration from config.sh..."
source config.sh
echo "INFO: Project Root is set to: ${PROJECT_ROOT}"

# --- Create Directories ---
echo "INFO: Creating output directories..."
mkdir -p "${DATA_MIRROR_DIR}" "${DATA_DIR}" "${H5AD_DIR}" "${TABLES_DIR}" "${FIGURES_DIR}" "${LOG_DIR}"

# --- Execute Pipeline Stages ---
echo "=========================================================="
echo "          STARTING BIO-TAPESTRY PIPELINE                  "
echo "=========================================================="

# STAGE 1: Data Fetch & QC
echo "--> STAGE 1: Data Fetching and Quality Control..."
python "${SCRIPT_DIR}/01_fetch_and_qc.py" \
    --pbmc_url "${PBMC3K_URL}" \
    --output_dir "${DATA_MIRROR_DIR}" \
    --min_genes "${MIN_GENES_PER_CELL}" \
    --min_cells "${MIN_CELLS_PER_GENE}" \
    --mito_cutoff "${MITO_PERCENT_CUTOFF}" \
    --output_h5ad "${H5AD_DIR}/pbmc3k_filtered.h5ad" \
    > "${LOG_DIR}/01_fetch_and_qc.log" 2>&1
echo "--> STAGE 1: Complete. Log saved to ${LOG_DIR}/01_fetch_and_qc.log"

# STAGE 2: Normalization & Clustering
echo "--> STAGE 2: Normalization, HVG selection, and Clustering..."
python "${SCRIPT_DIR}/02_cluster.py" \
    --input_h5ad "${H5AD_DIR}/pbmc3k_filtered.h5ad" \
    --n_top_genes "${N_TOP_GENES}" \
    --n_pcs "${N_PCS}" \
    --resolution "${CLUSTER_RESOLUTION}" \
    --output_h5ad "${H5AD_DIR}/pbmc3k_clustered.h5ad" \
    --output_figure "${FIGURES_DIR}/pbmc3k_umap.png" \
    > "${LOG_DIR}/02_cluster.log" 2>&1
echo "--> STAGE 2: Complete. Log saved to ${LOG_DIR}/02_cluster.log"

# STAGE 3: Differential Expression
echo "--> STAGE 3: Running Differential Expression Analysis..."
# (Add command for 03_run_degs.py here)
echo "--> STAGE 3: Complete."

# STAGE 4: Pathway Enrichment
echo "--> STAGE 4: Running Pathway Enrichment..."
# (Add command for 04_enrichment.R here)
echo "--> STAGE 4: Complete."

# ... Add other stages as you build them ...

echo "=========================================================="
echo "          BIO-TAPESTRY PIPELINE FINISHED SUCCESSFULLY     "
echo "=========================================================="
