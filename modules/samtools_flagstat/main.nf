#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    container 'ghcr.io/bf528/samtools:latest'
    label 'process_medium'
    publishDir params.outdir

    input:
    tuple val (name), path(bam_file), path (bam_index)

    output:
    path ("flagstat_${name}.tsv"), emit: flagstat_out

    shell:
    """
    samtools flagstat "${bam_file}" -O tsv >"flagstat_${name}.tsv"
    """
}