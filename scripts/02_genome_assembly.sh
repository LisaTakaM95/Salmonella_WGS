#!/usr/bin/env bash
set -euo pipefail

# Project: Salmonella enterica WGS
# Dataset: SRR8508672
# Tool: SPAdes v4.3.0
# Purpose: De novo genome assembly
# Run from the repository root.

READ1="results/trimmed/SRR8508672_1.trimmed.fastq"
READ2="results/trimmed/SRR8508672_2.trimmed.fastq"

OUTDIR="results/assembly/spades_output"

# Check that input reads exist.
for file in "$READ1" "$READ2"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Missing input file: $file" >&2
        exit 1
    fi
done

# Prevent accidental overwriting of an existing assembly.
if [[ -e "$OUTDIR" ]]; then
    echo "ERROR: Assembly output directory already exists." >&2
    echo "Existing results will not be overwritten." >&2
    exit 1
fi

spades.py \
    -1 "$READ1" \
    -2 "$READ2" \
    -o "$OUTDIR" \
    --threads 4
# Filter assembled contigs to retain sequences >=500 bp.
FILTERED="results/assembly/contigs_min500.fasta"

if [[ -e "$FILTERED" ]]; then
    echo "ERROR: Filtered assembly already exists." >&2
    exit 1
fi

seqkit seq -m 500 \
    "$OUTDIR/contigs.fasta" \
    -o "$FILTERED"

echo "Genome assembly and contig filtering completed successfully."
