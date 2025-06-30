# ChIP-seq Analysis Pipeline
This repository contains a Nextflow pipeline for analyzing ChIP-seq data, including quality control, trimming, alignment, peak calling, and downstream analysis.

## Pipeline Overview
The pipeline performs the following steps:

FASTQC – Quality control on raw and trimmed reads.

Trimmomatic – Adapter trimming of sequencing reads.

Bowtie Index – Builds Bowtie genome index.

Bowtie Align – Aligns reads to the reference genome.

Samtools – Sorts, indexes BAM files, and generates alignment statistics.

BAM Coverage – Generates bigWig coverage files.

MultiBigwigSummary – Summarizes bigWig signals across the genome.

PlotCorrelation – Produces correlation plots for QC.

MACS3 – Calls peaks for IP vs. INPUT samples.

Bedtools Intersect – Generates consensus peaks between replicates.

Blacklist Filtering – Filters peaks against known blacklist regions.

HOMER Annotate – Annotates filtered peak regions.

ComputeMatrix + PlotProfile – Visualizes ChIP signal over features.

HOMER FindMotifsGenome – Identifies enriched motifs.

## Input
Sample sheet: A CSV/TSV file listing your sample metadata and file paths (specified with --samplesheet).

Genome FASTA: Reference genome file (specified with --genome).

Blacklist BED: Regions to exclude during peak filtering (specified with --blacklist).

## Tools and modules:

FASTQC

Trimmomatic

Bowtie2

Samtools

MACS3

Bedtools

MultiQC

deepTools (bamCoverage, computeMatrix, plotProfile, multiBigwigSummary, plotCorrelation)

HOMER

## Output
FASTQC reports (raw and trimmed reads)

Trimmed FASTQ files

BAM files (sorted, indexed)

Alignment stats (flagstat)

bigWig coverage files

Correlation plots

Peak files (MACS3, consensus peaks)

Filtered/blacklist-removed peaks

Peak annotations

Motif enrichment results

ChIP signal heatmaps and profiles

## Notes
The pipeline expects standard ChIP-seq sample naming conventions (e.g., IP_rep1, INPUT_rep1).

Ensure all modules are available in ./modules/.

Results will be written to the directory specified by --outdir.
