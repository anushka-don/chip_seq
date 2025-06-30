#!/usr/bin/env nextflow

process MULTI_QC {
    container 'ghcr.io/bf528/multiqc:latest'
    label 'process_low'
    publishDir params.outdir, mode: 'copy'

    input:
    path input_dir

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc $input_dir
    """
}
