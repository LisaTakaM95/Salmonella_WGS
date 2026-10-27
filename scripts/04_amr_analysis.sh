#!/usr/bin/env bash
set -euo pipefail

# Project: Salmonella enterica WGS
# Dataset: SRR8508672
# Purpose: Antimicrobial resistance analysis
#
# Tools:
# AMRFinderPlus v4.2.7 (annotation environment)
# StarAMR v0.12.3 (starmr environment)
#
# Run from the repository root.

AMR_INPUT="results/annotation/bakta_SRR8508672/SRR8508672.fna"
STARAMR_INPUT="results/assembly/contigs_min500.fasta"

AMR_OUT="results/amr/SRR8508672_amr.tsv"
STARAMR_OUT="results/staramr/SRR8508672"

# Check required input files.
for file in "$AMR_INPUT" "$STARAMR_INPUT"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Missing input: $file" >&2
        exit 1
    fi
done

# Protect existing results.
if [[ -e "$AMR_OUT" || -e "$STARAMR_OUT" ]]; then
    echo "ERROR: Existing AMR results detected." >&2
    echo "No analysis will be performed." >&2
    exit 1
fi

# Check that Conda is available.
if ! command -v conda >/dev/null 2>&1; then
    echo "ERROR: Conda is not available." >&2
    exit 1
fi

mkdir -p results/amr results/staramr

# AMRFinderPlus
conda run -n annotation amrfinder \
    -n "$AMR_INPUT" \
    -o "$AMR_OUT"

# StarAMR
conda run -n starmr staramr search \
    --pointfinder-organism salmonella \
    --output-dir "$STARAMR_OUT" \
    "$STARAMR_INPUT"

echo "AMR analysis completed successfully."
