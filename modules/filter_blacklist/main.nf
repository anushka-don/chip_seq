#!/usr/bin/env nextflow

process FILTER_BLACKLIST {
    container 'ghcr.io/bf528/bedtools:latest'
    label 'process_medium'
    publishDir params.outdir, mode: 'copy'

    input:
    path peaks
    path blacklist

    output:
    path "filtered_peaks.bed", emit: filtered

    script:
    """
    bedtools intersect -v -a $peaks -b $blacklist > filtered_peaks.bed
    """
}
