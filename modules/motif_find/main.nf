#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_low'
    container 'ghcr.io/bf528/homer:latest'
    publishDir params.outdir, mode: 'copy'

    input:
    path(repr_filtered_peaks)
    path(genome_fasta)

    output:
    path('motifs/')

    shell:
    """
    findMotifsGenome.pl $repr_filtered_peaks $genome_fasta motifs/ -size 200 -mask
    """
}
