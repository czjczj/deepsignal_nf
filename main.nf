#!/usr/bin/env nextflow
/*
=========================================================================================
  		NANOME(Nanopore methylation) pipeline for Oxford Nanopore sequencing
=========================================================================================
 NANOME Analysis Pipeline.
 #### Homepage / Documentation
 https://github.com/TheJacksonLaboratory/nanome
 @Author   : Yang Liu
 @FileName : main.nf
 @Software : NANOME project
 @Organization : JAX Li Lab
----------------------------------------------------------------------------------------
*/
// We now support both latest and lower versions, due to Lifebit CloudOS is only support 21.04
// Note: NXF_VER=20.04.1 nextflow run main.nf -profile test,singularity
if( nextflow.version.matches(">= 20.07.1") ){
	nextflow.enable.dsl=2
} else {
	// Support lower version of nextflow
	nextflow.preview.dsl=2
}

process sayHello {
    echo true

    """
    echo 'Hello World!' > file
    """
}
