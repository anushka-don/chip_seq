#!/usr/bin/env nextflow

process TRIMMOMATIC {
    container 'ghcr.io/bf528/trimmomatic:latest'
    label 'process_low'
    publishDir params.outdir

    input:
    tuple val(name), path(fq)

    output:
    tuple val(name) , path("${name}_trimmed.fq"), emit: trimmed
    path ("${name}_log.txt"), emit: trim_log

    shell:
    """
    trimmomatic SE -phred33 $fq ${name}_trimmed.fq SLIDINGWINDOW:4:20 MINLEN:36 -trimlog "${name}_log.txt"
    """
}