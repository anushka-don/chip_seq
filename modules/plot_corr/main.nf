#!/usr/bin/env nextflow

process PLOT_CORRELATION {
    container 'ghcr.io/bf528/deeptools:latest'
    label 'process_medium'
    publishDir params.outdir, mode: 'copy'

    input:
    path "summary.npz"

    output:
    path "correlation_matrix.png", emit: corr_plot
    path "correlation_matrix.tab", emit: corr_matrix

    script:
    """
    plotCorrelation -in summary.npz --corMethod spearman --whatToPlot heatmap --plotNumbers -o correlation_matrix.png --outFileCorMatrix correlation_matrix.tab
    """
}
