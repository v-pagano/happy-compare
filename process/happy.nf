process happy {
    input:
        tuple val(sampleId), val(vcfTruth), val(bedFile), val(chr), val(stratFile), val(ref), val(SDF), val(vcfTest), val(tag)

    output:
        path "${sampleId}-${tag}*", emit: publishFiles

    container params.happyContainer
    cpus params.happyCpus
    queue 'defq,cpu-scavenge'
    clusterOptions '--time=12:00:00'

    script:
    if (chr != '') {
        chromosome = '-l ' + chr
        chromosomeTag = '-' + chr
    } else {
        chromosome = ''
        chromosomeTag = ''
    }
    """
        hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} ${chromosome} --stratification ${stratFile} -r ${ref} -o ${sampleId}-${tag}-${chromosomeTag} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${sampleId}-${tag}${chromosomeTag}.log --threads ${task.cpus}
    """
}

