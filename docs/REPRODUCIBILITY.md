# Reproducibility and Software Dependencies

## Project

**Organism:** *Salmonella enterica*
**SRA accession:** SRR8508672
**Analysis type:** Bacterial whole-genome sequencing

## Software Versions

| Tool | Version |
|---|---|
| fastp | 1.3.6 |
| SPAdes | 4.3.0 |
| SeqKit | 2.13.0 |
| Bakta | 1.12.1 |
| AMRFinderPlus | 4.2.7 |
| StarAMR | 0.12.3 |
| MOB-recon (MOB-suite) | 3.1.9 |

## Reference Databases

### Bakta

- Database version: 6.0
- Database type: Light
- Release date: 2025-02-24
- DOI: 10.5281/zenodo.14916843

### AMRFinderPlus

- Standalone database version: 2026-08-07.1
- Bakta-bundled AMRFinderPlus reference release: 2024-12-18.1

### StarAMR

- ResFinder database commit: `65c9ba3b680d13fe5eb13ec78bf1a4160ef4c6d7`
- PointFinder database commit: `694919f59a38980204009e7ade76bf319cb7df0b`
- PlasmidFinder database commit: `49c24c1c9401fa175fbcfdbd4b37227a160baca4`
- MLST software version: 2.33.1
- ResFinder gene-drug mapping version: 032525.1
- PointFinder gene-drug mapping version: 032525
- PointFinder organism: salmonella

## Conda Environments

Environment specifications are provided in:

- `environments/annotation.yml`
- `environments/starmr.yml`
- `environments/plasmid.yml`

These specifications were exported from the analysis environment. Clean-environment recreation and full pipeline execution have not yet been independently validated.

## Analysis Scripts

The pipeline is documented in the following order:

1. `scripts/01_quality_control.sh`
2. `scripts/02_genome_assembly.sh`
3. `scripts/03_genome_annotation.sh`
4. `scripts/04_amr_analysis.sh`
5. `scripts/05_plasmid_analysis.sh`

## Interpretation Note

Antimicrobial resistance determinants and predicted phenotypes are computational results. They should not be interpreted as laboratory-confirmed antimicrobial susceptibility.

Plasmid reconstruction results are computational predictions and do not independently establish that complete plasmids were recovered.

## Environment Setup

This workflow was developed on an Apple Silicon Mac
using Miniforge and Conda

### Recreate the Conda environments

From the repository root, run:

```bash
conda env create -f environments/annotation.yml
conda env create -f environments/starmr.yml
conda env create -f environments/plasmid.yml
```

These commands recreate the three Conda environments used for genome annotation, antimicrobial resistance analysis, and plasmid reconstruction.

The exported specifications may contain platform-specific dependencies. Successful recreation on other operating systems has not yet been validated.

### Additional software requirements

The following tools were installed separately from the three exported Conda environments:

- fastp 1.3.6
- SPAdes 4.3.0
- SeqKit 2.13.0

These tools must be installed and available on `PATH` before running the quality-control and genome-assembly scripts.

### Reference database requirements

Bakta requires a reference database to be downloaded separately. The original analysis used Bakta database version 6.0 (light).

The annotation script expects this database at:

`~/bioinformatics_databases/bakta/db-light`

AMRFinderPlus and StarAMR also require their respective reference databases. See the Reference Databases section for the versions used in the original analysis.

Database installation and version verification instructions will be documented separately.

## Sequencing Data Retrieval

### Dataset

The analysis uses publicly available paired-end Illumina sequencing data from the NCBI Sequence Read Archive (SRA).

- **SRA accession:** SRR8508672
- **Organism:** *Salmonella enterica*
- **Sequencing platform:** Illumina HiSeq 2500
- **Read layout:** Paired-end

### Required software

NCBI SRA Toolkit, including `fasterq-dump`.

Version used for the documented retrieval procedure: 3.4.1.

### Download raw sequencing reads

From the repository root, create the data directory:

```bash
mkdir -p data
```

Download and split the paired-end reads:

```bash
fasterq-dump SRR8508672 --split-files --outdir data
```

The expected output files are:

```text
data/
├── SRR8508672_1.fastq
└── SRR8508672_2.fastq
```

Verify that both files exist:

```bash
ls -lh data/SRR8508672_*.fastq
```

The raw FASTQ files are excluded from version control because of their size. They must be downloaded separately before running the analysis pipeline.

**Note:** Sufficient disk space is required for the downloaded reads and temporary files created by `fasterq-dump`.

## Pipeline Execution

Run all scripts from the root directory of the `Salmonella_WGS` repository.

The workflow must be executed in the following order.

### 1. Quality control

Ensure that fastp is installed and available on `PATH`.

```bash
bash scripts/01_quality_control.sh
```

This processes the paired-end FASTQ files and generates trimmed reads and quality-control reports.

### 2. Genome assembly

Ensure that SPAdes and SeqKit are available on `PATH`.

```bash
bash scripts/02_genome_assembly.sh
```

This assembles the trimmed reads and filters the resulting contigs to a minimum length of 500 bp.

### 3. Genome annotation

Activate the annotation environment:

```bash
conda activate annotation
```

Run Bakta:

```bash
bash scripts/03_genome_annotation.sh
```

The script uses the Bakta database at `~/bioinformatics_databases/bakta/db-light` by default. A different database location can be supplied through the `BAKTA_DB` environment variable.

### 4. Antimicrobial resistance analysis

The AMR script invokes the `annotation` and `starmr` Conda environments using `conda run`.

```bash
bash scripts/04_amr_analysis.sh
```

This runs AMRFinderPlus and StarAMR on their respective input sequences.

### 5. Plasmid reconstruction

Activate the plasmid environment:

```bash
conda activate plasmid
```

Run MOB-recon:

```bash
bash scripts/05_plasmid_analysis.sh
```

This performs computational plasmid reconstruction using the filtered genome assembly.

## Important Execution Notes

- Run the workflow on a fresh set of output paths. The scripts include safeguards against overwriting existing results.
- Do not delete the original analysis results merely to rerun the scripts.
- Raw sequencing reads must be downloaded before starting quality control.
- Reference databases must be installed and accessible before running the database-dependent analyses.
- The Conda environment specifications have not yet been tested through clean-environment recreation.
- Full end-to-end reproduction of the workflow has not yet been independently validated.
