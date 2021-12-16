#!/usr/bin/env nextflow
if(nextflow.version.matches(">=20.07.1")){
    nextflow.enable.dsl=2
}else{
    nextflow.preview.dsl=2
}
process GuppyBasecaller {
    input:
    path fast5sdir
    
    output:
    path "${params.fast5sdir_guppy}.fastq", emit: basecall
    path "${params.fast5sdir_guppy}", emit: basecall_dir
    path "${params.fast5sdir_guppy}/sequencing_summary.txt", emit: basecall_seq_summary
    """
    date; hostname; pwd

    mkdir -p ${params.fast5sdir_guppy}

    ${guppy_install_dir}/guppy_basecaller -i ${fast5sdir} -r \
        -s ${params.fast5sdir_guppy} \
        --config ${params.GUPPY_BASECALL_MODEL} \
        --num_callers ${params.process_num} \
        --verbose_logs  &>> Basecall.run.log
    
    cat ${params.fast5sdir_guppy}/*.fastq > ${params.fast5sdir_guppy}.fastq
    """
}

process TomboResquiggle{
    input:
    path basecall
    path basecall_dir 
    path seq_summary_file
    
    output:
    path 'resquiggle.txt', emit: resquiggle 
    
    """
    tombo preprocess annotate_raw_with_fastqs \
        --fast5-basedir ${params.fast5sdir} \
        --fastq-filenames ${basecall} \
        --sequencing-summary-filenames ${seq_summary_file} \
        --basecall-group Basecall_1D_000 \
        --basecall-subgroup BaseCalled_template \
        --overwrite \
        --processes ${params.process_num} 

    tombo resquiggle ${params.fast5sdir} \
        ${params.tombo_resquiggle_genomic} \
        --processes ${params.process_num} \
        --corrected-group RawGenomeCorrected_001 \
        --basecall-group Basecall_1D_000 \
        --overwrite
    
    echo "TomboResquiggle Done" > resquiggle.txt
    """
}

process DeepsignalCall{
    input:
    path resquiggle
    
    """
    deepsignal call_mods --input_path ${params.fast5sdir} \
        --model_path ${params.deepsignal_model_path} \
        --result_file ${params.deepsignal_res_file} \
        --reference_path ${params.tombo_resquiggle_genomic} \
        --corrected_group RawGenomeCorrected_001 \
        --nproc ${params.process_num} \
        --is_gpu ${params.deepsignal_use_gpu} 
        
    python '${params.python_modifi_py_path}' \
        --input_path ${params.deepsignal_res_file} \
        --result_file ${params.python_modifi_frequency_res} 
    """
}
workflow{
    fast5sdir_path = Channel.fromPath(params.fast5sdir)
    GuppyBasecaller(fast5sdir_path)
    TomboResquiggle(GuppyBasecaller.out.basecall, GuppyBasecaller.out.basecall_dir, GuppyBasecaller.out.basecall_seq_summary)
    DeepsignalCall(TomboResquiggle.out.resquiggle)
}
