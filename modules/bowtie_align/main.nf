#!/usr/bin/env nextflow

process BOWTIE_ALIGN {
    container 'ghcr.io/bf528/bowtie2:latest'
    label 'process_medium'
    publishDir params.outdir

    input:
    tuple val(name),path(read_fq)
    path bt2_idx

    output:
    tuple val("${name}"), path ("${name}.sam"), emit: sam_files
    
    shell:
    """
    bowtie2 -x genome_index -U $read_fq -S ${name}.sam
    """
}
