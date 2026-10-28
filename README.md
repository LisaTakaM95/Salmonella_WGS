# Salmonella Whole-Genome Sequencing Analysis

## Project overview

This project demonstrates a bioinformatics workflow for processing and characterizing paired-end bacterial whole-genome sequencing data. The analysis focuses on draft genome assembly, genome annotation, multilocus sequence typing (MLST), antimicrobial-resistance (AMR) screening, and plasmid characterization.

The project is part of a computational genomics portfolio focused on infectious disease and genomic surveillance.

## Dataset

| Field | Details |
|---|---|
| Organism | *Salmonella enterica* |
| SRA accession | `SRR8508672` |
| Study description | Public Health England – Salmonella, as recorded in project notes |
| Sequencing platform | Illumina HiSeq 2500 |
| Sequencing layout | Paired-end whole-genome sequencing |

Raw sequencing data are not included in this repository. The accession can be used to locate the source data through the NCBI Sequence Read Archive.

## Workflow

1. **Read quality control and preprocessing** — FastQC and fastp were used during the analysis.
2. **Genome assembly** — SPAdes v4.3.0 was used to assemble the sequencing reads.
3. **Assembly filtering** — a contig set with a minimum length of 500 bp was used for downstream analyses.
4. **Genome annotation** — Bakta v1.12.1 was used to annotate the filtered assembly.
5. **AMR screening and sequence typing** — StarAMR v0.12.3 was used to screen for resistance determinants, resistance-associated variants, plasmid replicons, and MLST.
6. **Additional AMR screening** — AMRFinderPlus was used to identify antimicrobial-resistance determinants.
7. **Plasmid characterization** — MOB-recon outputs were generated to investigate candidate plasmid-associated sequences.

Five executable workflow scripts, Conda environment specifications, and detailed reproducibility documentation are available in this repository.

## Results

### Draft genome assembly

| Metric | Result |
|---|---:|
| Total assembly length | 4,899,544 bp |
| Contigs of at least 500 bp | 48 |
| N50 | 348,292 bp |
| N90 | 73,697 bp |
| GC content | 51.9% |
| Ambiguous-base ratio | 0.0 |
| Coding density | 88.0% |

The original assembly contained 140 contigs, with a total length of 4,913,507 bp. After filtering out contigs shorter than 500 bp, 48 contigs remained.

### Genome annotation

Bakta reported the following features:

| Feature | Count |
|---|---:|
| Coding sequences (CDSs) | 4,605 |
| Hypothetical proteins | 281 |
| tRNAs | 54 |
| tmRNAs | 1 |
| rRNAs | 3 |
| ncRNAs | 126 |
| CRISPR arrays | 2 |

Software: Bakta v1.12.1; database v6.0 (light).

### Multilocus sequence typing

StarAMR reported the following MLST result:

- Scheme: `salmonella`
- Sequence type: `1541`
- Status: `PERFECT`
- Score: `100`

The reported allele profile is available in `results/staramr/SRR8508672/mlst.tsv`.

### Antimicrobial-resistance screening

The AMRFinderPlus output reported four resistance-associated genes:

| Gene | Reported resistance category |
|---|---|
| `tet(A)` | Tetracycline |
| `aph(6)-Id` | Streptomycin |
| `aph(3'')-Ib` | Streptomycin |
| `sul2` | Sulfonamide |

StarAMR additionally reported the `parC (T57S)` variant. This result is recorded separately because outputs from different screening tools may differ in scope and interpretation.

These are computational predictions from genomic data. They are not substitutes for laboratory antimicrobial-susceptibility testing.

### Plasmid characterization

MOB-recon reported four candidate plasmid-associated sequences, ranging from 3,428 bp to 8,623 bp. The outputs include predicted mobility and sequence-similarity information.

These predictions require appropriate interpretation and do not, by themselves, establish the presence of complete, independently confirmed plasmids.

## Repository contents

- `data/` — local input data; excluded from version control.
- `results/assembly/` — selected genome assembly output.
- `results/annotation/` — selected Bakta annotation output.
- `results/amr/` — AMRFinderPlus output.
- `results/staramr/` — StarAMR results.
- `results/plasmid/` — MOB-recon outputs.
- `results/trimmed/` — selected read-preprocessing reports.
- `notes/` — project notes and analysis records.
- `scripts/` — five Bash scripts covering quality control, assembly, annotation, AMR analysis, and plasmid reconstruction.
- `environments/` — Conda environment specifications for annotation, StarAMR, and plasmid analysis.
- `docs/` — reproducibility documentation, including software versions, reference databases, and pipeline execution instructions.

Only selected outputs should be committed. Large raw reads, temporary files, and redundant intermediate files are excluded.

## Limitations

- The assembly statistics alone do not establish genome completeness, contamination status, or overall assembly accuracy.
- Genomic resistance predictions do not establish phenotypic susceptibility or clinical treatment outcomes.
- Plasmid reconstruction and mobility classifications are computational predictions.
- Software versions, reference database releases, and workflow commands are documented; clean-environment recreation and independent end-to-end reproduction have not yet been validated.

## Reproducibility
The repository includes five Bash scripts documenting the analytical workflow, three exported Conda environment specifications, and a dedicated reproducibility guide.

The reproducibility guide documents:

- Software versions, database releases, and execution commands are documented; independent end-to-end reproduction has not yet been validated.
- Reference database releases and revision identifiers.
- Retrieval of the public sequencing dataset `SRR8508672`.
- Pipeline execution order and input requirements.
- Scientific interpretation limitations.

See [Reproducibility and Software Dependencies](docs/REPRODUCIBILITY.md) for detailed instructions.

The workflow has been documented, but clean-environment recreation and independent end-to-end reproduction have not yet been validated.

## Scope

This is a bioinformatics portfolio project using public sequencing data. Findings should be interpreted in the context of the dataset, analysis methods, and limitations described above.
