#!/usr/bin/env nextflow

process HOMER_ANNOTATE {
    container 'ghcr.io/bf528/homer:latest'
    label 'process_medium'
    publishDir params.outdir, mode: 'copy'

    input:
    path bed_file

    output:
    path "annotated_peaks.txt", emit: annotated

    script:
    """
    annotatePeaks.pl $bed_file  hg38 > annotated_peaks.txt
    """
}
