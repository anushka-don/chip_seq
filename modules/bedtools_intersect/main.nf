#!/usr/bin/env nextflow

process INTERSECT_PEAKS {
    container 'ghcr.io/bf528/bedtools:latest'
    label 'process_medium'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple path(peak1), path(peak2)

    output:
    path "consensus_peaks.bed", emit: consensus

    script:
    """
    bedtools intersect -a $peak1 -b $peak2 > consensus_peaks.bed
    """
}
