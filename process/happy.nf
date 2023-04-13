process happy {
    input:
        tuple val(sampleId), val(vcfTruth), val(bedFile), val(chr), val(stratFile), val(ref), val(SDF), val(vcfTest), val(tag)
        val outDir

    output:
        tuple path("${sampleId}-${tag}-${chr}*"),  val("${outDir}/${sampleId}-${tag}/${chr}/"), emit: publishFiles

    container '/scratch/vpagano/singularity/hap.py-0.3.15.sif'
    cpus params.happyCpus

    tag "${sampleId}-${tag}-${chr}"
    // errorStrategy { sleep(Math.pow(2, task.attempt) * 600 as long); return 'retry' }
    // maxRetries 10
    memory params.happyMem
    queue 'defq'

    time '23h'
    clusterOptions '-A tgen-371000'

    script:
        if (chr == 'all') {
            """
                hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} -l chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22 --stratification ${stratFile} -r ${ref} -o ${sampleId}-${tag}-${chr} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${sampleId}-${tag}-${chr}.log --threads ${task.cpus}
            """
        } else {
            """
                hap.py ${vcfTruth} ${vcfTest} -f ${bedFile} -l ${chr} --stratification ${stratFile} -r ${ref} -o ${sampleId}-${tag}-${chr} --engine=vcfeval --engine-vcfeval-template ${SDF} ${params.happyOptions} --verbose --logfile ${sampleId}-${tag}-${chr}.log --threads ${task.cpus}
            """
        }
}

