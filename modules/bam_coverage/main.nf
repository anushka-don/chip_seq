#!/usr/bin/env nextflow

process BAM_COVERAGE {
    container 'ghcr.io/bf528/deeptools:latest'
    label 'process_medium'
    publishDir params.outdir

    input:
    tuple val(name), path(bam), path(bai)


    output:
    tuple val(name), path ("${name}.SeqDepthNorm.bw")

    shell:
    """
    bamCoverage --bam "${bam}" -o "${name}.SeqDepthNorm.bw"
    """
}