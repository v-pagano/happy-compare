process truvariBench {
    input:
        tuple val(sampleId), val(vcfTruth), val(bedFile), val(ref), val(vcfTest), val(tag)
        val outDir

    output:
        tuple path("${sampleId}-${tag}/*"),  val("${outDir}/${sampleId}/${tag}"), emit: publishFiles
        tuple val(sampleId), path("${sampleId}-${tag}/${sampleId}-${tag}-tp-base.vcf"), emit: baseVcf
        tuple val(sampleId), path("${sampleId}-${tag}/${sampleId}-${tag}-fn.vcf"), emit: fnVcf

    container 'docker://quay.io/biocontainers/truvari:3.5.0--pyhdfd78af_0'
    cpus 2
    memory '1GB'

    tag "${sampleId}-${tag}"

    queue 'cpu-scavenge'

    time '23h'
    clusterOptions '-A tgen-371000'

    script:
    """
    	truvari bench --base ${vcfTruth} --comp ${vcfTest} --reference ${ref} --output  ${sampleId}-${tag} --includebed ${bedFile} ${params.truvariOptions}
        mv ${sampleId}-${tag}/tp-base.vcf ${sampleId}-${tag}/${sampleId}-${tag}-tp-base.vcf
        mv ${sampleId}-${tag}/fn.vcf ${sampleId}-${tag}/${sampleId}-${tag}-fn.vcf
    """
}

process truvariConsistency {
    input:
        tuple val(sampleId), path(inputVcf)
        val inputTag
        val outDir

    output:
        tuple path("${inputTag}-consistency.report"),  val("${outDir}/${sampleId}"), emit: publishFiles

    container 'docker://quay.io/biocontainers/truvari:3.5.0--pyhdfd78af_0'
    cpus 2
    memory '1GB'

    tag "${sampleId}-${inputTag}"
    errorStrategy 'retry'
    maxRetries 5
    queue 'cpu-scavenge'

    time '23h'
    clusterOptions '-A tgen-371000'

    script:
    """
    	truvari consistency ${inputVcf} > ${inputTag}-consistency.report
    """
}