process happy {
    input:
        tuple val(sampleId), val(vcfTruth), val(bedFile), val(chr), val(stratFile), val(ref), val(SDF), val(vcfTest), val(tag)

    output:
        path "${sampleId}-${tag}*", emit: publishFiles

    container params.happyContainer
    cpus params.happyCpus
    queue params.happyQueue
    clusterOptions '--time=12:00:00'

    script:
        chromosome = ''
        chromosomeTag = ''
        if (chr != '') {
            chromosome = '-l ' + chr
            chromosomeTag = '-' + chr
        }
        if (chr == 'all') {
            chromosome = '-l chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22'
            chromosomeTag = '-all'
        }
        """
            hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} ${chromosome} --stratification ${stratFile} -r ${ref} -o ${sampleId}-${tag}${chromosomeTag} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${sampleId}-${tag}${chromosomeTag}.log --threads ${task.cpus}
        """
}

