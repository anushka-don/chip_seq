#!/usr/bin/env nextflow

process MULTIBIGWIGSUMMARY {
    container 'ghcr.io/bf528/deeptools:latest'
    label 'process_medium'
    publishDir params.outdir, mode: 'copy'

    input:
    path bigwigs

    output:
    path "summary.npz", emit: summary

    script:
    """
    multiBigwigSummary bins -b ${bigwigs.join(' ')} -o summary.npz
    """
}
