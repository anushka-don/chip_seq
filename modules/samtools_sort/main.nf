#!/usr/bin/env nextflow

process SAMTOOLS_SORT_IDX {
    container 'ghcr.io/bf528/samtools:latest'
    label 'process_low'
    publishDir params.outdir

    input:
    tuple val (name), path(sam_file)

    output:
    tuple val(name), path("srtd_${name}.bam"), path("srtd_${name}.bam.bai"), emit:bam_files

    shell:
    """
    samtools view -Sb -o "${name}.bam" "${name}.sam"

    samtools sort -O bam -o "srtd_${name}.bam" "${name}.bam"

    samtools index "srtd_${name}.bam"
    """
}