#!/usr/bin/env nextflow

process FASTQC {
  container 'ghcr.io/bf528/fastqc:latest'
  label 'process_single'
  publishDir params.outdir, mode: 'copy'

  input:
  tuple val(name), path(reads)

  output:
  path("*_fastqc.zip"), emit: fastqc_zip
  path("*_fastqc.html"), emit: fastqc_html

  script:
  """
  fastqc $reads
  """
}
