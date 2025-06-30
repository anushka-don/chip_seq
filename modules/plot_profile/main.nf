#!usr/bin/env nextflow

process PLOTPROFILE {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(meta), path(matrix)

    output:
    path("${meta}_profile.png")

    shell:
    """
    plotProfile -m $matrix -out ${meta}_profile.png
    """
}
