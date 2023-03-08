process happy {
    input:
        tuple val(sampleId), val(vcfTruth), val(bedFile), val(chr), val(stratFile), val(ref), val(SDF), val(vcfTest), val(tag)
        val outDir

    output:
        tuple path("${sampleId}-${tag}-${chr}*"),  val("${outDir}/${sampleId}-${tag}/${chr}/"), emit: publishFiles

    container params.happyContainer
    cpus params.happyCpus
    queue params.happyQueue
    time '23h'
    clusterOptions '-A tgen-371000'

    script:

        """
            hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} -l ${chr} --stratification ${stratFile} -r ${ref} -o ${sampleId}-${tag}-${chr} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${sampleId}-${tag}-${chr}.log --threads ${task.cpus}
        """
}

