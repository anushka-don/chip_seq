#!usr/bin/env nextflow

include { FASTQC as RAW_FASTQC } from './modules/fastqc'
include { FASTQC as TRIMMED_FASTQC } from './modules/fastqc'
include { TRIMMOMATIC } from './modules/trimmomatic'
include { BOWTIE_INDEX } from './modules/bowtie_index'
include { BOWTIE_ALIGN } from './modules/bowtie_align'
include { SAMTOOLS_SORT_IDX } from './modules/samtools_sort'
include { SAMTOOLS_FLAGSTAT } from './modules/samtools_flagstat'
include { MULTI_QC } from './modules/multiqc'
include { BAM_COVERAGE } from './modules/bam_coverage'
include { MULTIBIGWIGSUMMARY } from './modules/bigwigsum'
include { PLOT_CORRELATION } from './modules/plot_corr'
include { MACS3_CALLPEAK } from './modules/call_peak'
include { INTERSECT_PEAKS } from './modules/bedtools_intersect'
include { FILTER_BLACKLIST } from './modules/filter_blacklist'
include { HOMER_ANNOTATE } from './modules/annotate'
include { COMPUTEMATRIX } from './modules/compute_matrix'
include { PLOTPROFILE } from './modules/plot_profile'
include { FIND_MOTIFS_GENOME } from './modules/motif_find'

workflow {
    // Reading the data
    reads = file(params.samplesheet)

    Channel.from(reads.text) |
    splitCsv(header: true) |
    set { reads_ch }

    // QC on raw reads
    raw_qc_ch = RAW_FASTQC( reads_ch )

    // Trimming off adapter seq using trimmomatic
    trim_ch = TRIMMOMATIC( reads_ch )

    // QC on trimmed reads
    trimmed_qc_ch = TRIMMED_FASTQC( trim_ch.trimmed )

    // Creating Bowtie Index
    index_ch = BOWTIE_INDEX( params.genome )

    // Align with Bowtie Align
    align_ch = BOWTIE_ALIGN ( trim_ch.trimmed, index_ch )

    // Samtoools for sorting and indexing
    srt_idx_ch = SAMTOOLS_SORT_IDX ( align_ch )

    // flagstat
    flagstat_ch = SAMTOOLS_FLAGSTAT ( srt_idx_ch )

    // Pass only the trimmed FastQC results to multiqc
    // multiqc_ch = MULTI_QC(file(params.outdir))

    // bam_coverage
    bam_cov_ch = BAM_COVERAGE ( srt_idx_ch )

    // Create a matrix containing the information from the bigWig files of all of your samples
    bigwigs_ch = bam_cov_ch.map { name, bw -> bw }
    summary_ch = MULTIBIGWIGSUMMARY(bigwigs_ch.collect())

    corr_ch = PLOT_CORRELATION(summary_ch)

    // Pair up IP and control BAMs
    srt_idx_ch
    .map { name, bam, bai -> tuple(name.split('_')[1], [(name.startsWith('IP') ? 'IP' : 'INPUT'): bam]) }
    .groupTuple(by: 0)
    .map { rep, maps -> tuple(rep, maps[0] + maps[1]) }
    .map { rep, samples -> tuple(rep, samples.IP, samples.INPUT, params.macs3_genome) }
    .set { peakcalling_ch }

    macs_peaks_ch = MACS3_CALLPEAK( peakcalling_ch )
    macs_peaks_ch | view()

    // Collect replicate peak files
    peaks_list_ch = macs_peaks_ch.map { name, peak_file -> peak_file }.collect()

    // Use map to extract first two peaks and feed to INTERSECT
    consensus_ch = peaks_list_ch.map { peaks_list -> 
        def p1 = peaks_list.find { it.name.contains('rep1') }
        def p2 = peaks_list.find { it.name.contains('rep2') }
        tuple(p1, p2)
    } | INTERSECT_PEAKS


    // Filter the files
    blacklist_ch = Channel.of(file(params.blacklist))
    filtered_ch = FILTER_BLACKLIST(consensus_ch, blacklist_ch)

    filtered_ch | view ()

    // Annotate the filtered stuff
    annotated_ch = HOMER_ANNOTATE(filtered_ch)

    // prepare channel for computing matrix
    bam_cov_ch
    .filter { meta, bw -> meta.startsWith('IP') }
    .map { meta, bw -> tuple(meta, bw) }
    .set { ip_bw_ch }

    matrix_ch = ip_bw_ch
    .map { meta, bw -> tuple(meta, bw, file('refs/hg38_genes.bed'), 2000) }
    | COMPUTEMATRIX 

    matrix_ch
    | PLOTPROFILE

    motif_ch = FIND_MOTIFS_GENOME(filtered_ch, file(params.genome))

}
