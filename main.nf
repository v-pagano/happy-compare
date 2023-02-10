nextflow.enable.dsl=2

include { happy } from './process/happy'
include { CSV_PARSE } from './workflows/happy'
include { publishResults } from './process/helpers'

workflow {

    publishFiles = Channel.empty()

    xx = CSV_PARSE(params.input)

    happy(xx)

    publishResults(happy.out.publishFiles)


}