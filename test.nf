// Trimming off adapter seq using trimmomatic
    trim_ch = TRIMMOMATIC( reads_ch )

    // QC on trimmed reads
    trimmed_qc_ch = TRIMMED_FASTQC( trim_ch.trimmed )

    // Creating Bowtie Index
    index_ch = BOWTIE_INDEX( params.genome )

    // Align with Bowtie Align
    align_ch = BOWTIE_ALIGN( trim_ch.trimmed, index_ch )

    // Samtoools for sorting and indexing
    srt_idx_ch = SAMTOOLS_SORT_IDX ( align_ch )

    // flagstat
    flagstat_ch = SAMTOOLS_FLAGSTAT ( srt_idx_ch )

    // Combinnig all essential files and Generating multiqc report
    qc_files = Channel.mix(
        raw_qc_ch.fastqc_zip,
        trimmed_qc_ch.fastqc_zip,
        trim_ch.trim_log,
        flagstat_ch.flagstat_out)   
    qc_files |
    view()

    // multiqc_ch = MULTI_QC (qc_files)