#!/usr/bin/env nextflow

process BOWTIE_INDEX {
    container 'ghcr.io/bf528/bowtie2:latest'
    label 'process_high'
    publishDir params.outdir

    input:
    path genome_fasta

    output:
    path("*.bt2*"), emit: index_files

    script:
    """
    bowtie2-build $genome_fasta genome_index
    """
}
