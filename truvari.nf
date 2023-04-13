nextflow.enable.dsl=2

include { truvariBench; truvariConsistency as truvariConsistencyFn; truvariConsistency } from './process/truvari'
include { CSV_PARSE } from './workflows/happy'
include { publishResults } from './process/helpers'

workflow {
    xx = CSV_PARSE(params.input)
    xx = xx.map { [ sampleId: it.sampleId, vcfTruth: it.vcfTruth, bedFile: it.bedFile, ref: it.ref, vcfTest: it.vcfTest, tag: it.tag ] }
    xx = xx.filter{ it.vcfTest != '' }

    publishFiles = Channel.empty()

    truvariBench(xx, params.outputFolder)
    publishFiles = publishFiles.mix(truvariBench.out.publishFiles)

    baseVcf = truvariBench.out.baseVcf.groupTuple()
    //baseVcf = baseVcf.map { [sampleId: it[0], files: it[1].join(' ') ]}.view()
    truvariConsistency(baseVcf, 'tp-base', params.outputFolder)
    publishFiles = publishFiles.mix(truvariConsistency.out.publishFiles)

    fnVcf = truvariBench.out.fnVcf.groupTuple()
    //fnVcf = fnVcf.map { [sampleId: it[0], files: it[1].join(' ') ]}.view()
    truvariConsistencyFn(fnVcf, 'fn', params.outputFolder)
    publishFiles = publishFiles.mix(truvariConsistencyFn.out.publishFiles)

    publishResults(publishFiles)
}
