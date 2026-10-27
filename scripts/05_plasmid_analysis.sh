#!/usr/bin/env bash
set -euo pipefail

# Project: Salmonella enterica WGS
# Dataset: SRR8508672
# Tool: MOB-suite v3.1.9
# Purpose: Plasmid reconstruction and characterization
# Conda environment: plasmid
# Run from the repository root.

INPUT="results/assembly/contigs_min500.fasta"
OUTDIR="results/plasmid/mob_recon_SRR8508672"

# Check that the input assembly exists.
if [[ ! -f "$INPUT" ]]; then
    echo "ERROR: Input assembly not found: $INPUT" >&2
    exit 1
fi

# Prevent overwriting existing results.
if [[ -e "$OUTDIR" ]]; then
    echo "ERROR: Plasmid analysis output already exists." >&2
    echo "Existing results will not be overwritten." >&2
    exit 1
fi

# Check that MOB-recon is available.
if ! command -v mob_recon >/dev/null 2>&1; then
    echo "ERROR: MOB-recon is not installed in the active environment." >&2
    exit 1
fi

# Run plasmid reconstruction.
mob_recon \
    -i "$INPUT" \
    -o "$OUTDIR"

echo "MOB-recon plasmid analysis completed successfully."
