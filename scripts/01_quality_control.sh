#!/usr/bin/env bash
set -euo pipefail

# Project: Salmonella enterica WGS
# Dataset: SRR8508672
# Tool: fastp v1.3.6
# Purpose: Paired-end read quality control and adapter trimming
# Run from the repository root.

READ1="data/SRR8508672_1.fastq"
READ2="data/SRR8508672_2.fastq"

OUTDIR="results/trimmed"

mkdir -p "$OUTDIR"

fastp \
    --in1 "$READ1" \
    --in2 "$READ2" \
    --out1 "$OUTDIR/SRR8508672_1.trimmed.fastq" \
    --out2 "$OUTDIR/SRR8508672_2.trimmed.fastq" \
    --html "$OUTDIR/fastp.html" \
    --json "$OUTDIR/fastp.json" \
    --detect_adapter_for_pe \
    --thread 4

echo "Quality control completed successfully."
