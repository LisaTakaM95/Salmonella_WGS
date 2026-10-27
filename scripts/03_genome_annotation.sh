#!/usr/bin/env bash
set -euo pipefail

# Project: Salmonella enterica WGS
# Dataset: SRR8508672
# Tool: Bakta v1.12.1
# Database: Bakta DB v6.0 light
# Purpose: Functional annotation of the filtered assembly
# Run from the repository root.
# Conda environment: annotation

INPUT="results/assembly/contigs_min500.fasta"
DB="${BAKTA_DB:-$HOME/bioinformatics_databases/bakta/db-light}"
OUTDIR="results/annotation/bakta_SRR8508672"

# Check input assembly.
if [[ ! -f "$INPUT" ]]; then
    echo "ERROR: Input assembly not found: $INPUT" >&2
    exit 1
fi

# Check Bakta database.
if [[ ! -d "$DB" ]]; then
    echo "ERROR: Bakta database not found: $DB" >&2
    exit 1
fi

# Prevent overwriting existing annotation results.
if [[ -e "$OUTDIR" ]]; then
    echo "ERROR: Annotation output directory already exists." >&2
    echo "Existing results will not be overwritten." >&2
    exit 1
fi

bakta \
    --db "$DB" \
    --output "$OUTDIR" \
    --prefix SRR8508672 \
    --genus Salmonella \
    --species enterica \
    --strain SRR8508672 \
    --threads 4 \
    "$INPUT"

echo "Bakta genome annotation completed successfully."
