process happy {
    input:
        tuple val(sampleId), val(vcfTruth), val(bedFile), val(chr), val(stratFile), val(ref), val(SDF), val(vcfTest), val(tag)
        val outDir

    output:
        tuple path("${sampleId}-${tag}-${chr}*"),  val("${outDir}/${sampleId}-${tag}/${chr}/"), emit: publishFiles

    container "${ workflow.containerEngine == 'singularity' ? 'docker://quay.io/biocontainers/hap.py:0.3.14--py27h5c5a3ab_0' : 'quay.io/biocontainers/hap.py:0.3.14--py27h5c5a3ab_0'}"
    cpus 2

    tag "${sampleId}-${tag}-${chr}"
    memory { 50.GB * 2 * task.attempt }
    errorStrategy { sleep(Math.pow(2, task.attempt) * 600 as long); return 'retry' }
    maxRetries 10

    time '23h'
    clusterOptions '-A tgen-371000'

    script:

        """
            hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} -l ${chr} --stratification ${stratFile} -r ${ref} -o ${sampleId}-${tag}-${chr} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${sampleId}-${tag}-${chr}.log --threads ${task.cpus}
        """
}

