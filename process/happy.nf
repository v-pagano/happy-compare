process happy {
    input:
        tuple val(vcfTruth), val(bedFile), val(chr), val(stratFile), val(ref), val(SDF), val(vcfTest), val(tag)

    output:
        path "${tag}*", emit: publishFiles

    container params.happyContainer
    cpus params.happyCpus

    script:
    if (chr != '') {
        chromosome = '-l ' + chr
        chromosomeTag = '-' + chr
    } else {
        chromosomeTag = ''
    }
    """
        hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} ${chromosome} --stratification ${stratFile} -r ${ref} -o ${tag}-ve${chromosomeTag} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${tag}-ve${chromosomeTag}.log --threads ${task.cpus}
    """
}

