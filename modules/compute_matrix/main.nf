#!usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(meta), path(bigwig), path(genes_bed), val(window_size)

    output:
    tuple val(meta), path("${meta}_matrix.gz"), emit: matrix

    shell:
    """
    computeMatrix scale-regions \
        -S $bigwig \
        -R $genes_bed \
        -a $window_size \
        -b $window_size \
        -p $task.cpus \
        -o ${meta}_matrix.gz
    """
}
