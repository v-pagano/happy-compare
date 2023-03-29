nextflow.enable.dsl=2

include { happy } from './process/happy'
include { CSV_PARSE } from './workflows/happy'
include { publishResults } from './process/helpers'

workflow {

    // allChromosomes = [ 
    //     'chr1', 
    //     'chr2', 
    //     'chr3', 
    //     'chr4', 
    //     'chr5', 
    //     'chr6', 
    //     'chr7', 
    //     'chr8', 
    //     'chr9', 
    //     'chr10', 
    //     'chr11', 
    //     'chr12', 
    //     'chr13', 
    //     'chr14', 
    //     'chr15', 
    //     'chr16', 
    //     'chr17', 
    //     'chr18', 
    //     'chr19', 
    //     'chr20', 
    //     'chr21', 
    //     'chr22'
    // ]

    allChromosomes = [ 

        'chr9',  
        'chr19' 

    ]

    xx = CSV_PARSE(params.input)

    xx = xx.combine(allChromosomes).map { it[0] + [ chr: it[1] ] + [ vcfTruth: it[0].vcfTruth.replace('chr*', it[1]) ] }
    xx = xx.filter{ it.vcfTest != null }
    happy(xx, params.outputFolder)

    publishResults(happy.out.publishFiles)


}