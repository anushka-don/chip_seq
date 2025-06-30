#!/usr/bin/env nextflow

process MACS3_CALLPEAK {
    label 'process_high'
    container 'ghcr.io/bf528/macs3:latest'
    publishDir params.outdir

    input:
    tuple val(rep), path(IP), path(CONTROL), val(macs3_genome)

    output:
    tuple val(rep), path("${rep}_peaks.narrowPeak"), emit: peaks

    shell:
    """
    macs3 callpeak -t $IP -c $CONTROL -f BAM -g $macs3_genome -n $rep --outdir . --keep-dup all --nomodel --extsize 171
    """
}
