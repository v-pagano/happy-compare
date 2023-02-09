nextflow.enable.dsl=2

include { happy } from './process/happy'
include { publishResults } from './process/helpers'

workflow {

    publishFiles = Channel.empty()

    v = [ 
            vcfTruth: '/scratch/vpagano/happy-test/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz',
            bedFile: '/scratch/vpagano/happy-test/HG002_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.bed',
            chr: '',
            stratFile: params.stratifications,
            ref: params.reference,
            SDF: params.sdf 
        ]

    x = [
            [ vcfTest: '/scratch/vpagano/happy-test/HG002_HiSeq30x_subsampled_R_pb_haplotypecaller.vcf.gz', tag: 'GATK' ],
            [ vcfTest: '/scratch/vpagano/happy-test/HG002_HiSeq30x_subsampled_R_pb_pb_deepvariant.vcf.gz', tag: 'DV' ],
            [ vcfTest: '/scratch/vpagano/happy-test/HG002_HiSeq30x_subsampled_R_PG.filtered.vcf.gz', tag: 'SBPAN' ],
            [ vcfTest: '/scratch/vpagano/happy-test/HG002_HiSeq30x_subsampled_R_AMR.filtered.vcf.gz', tag: 'SBAI' ],
            [ vcfTest: '/scratch/vpagano/happy-test/HG002.30x_novaseq_pcrfree.giraffedv.vcf.gz', tag: 'HPRCDV' ],
            [ vcfTest: '/scratch/vpagano/happy-test/HG002_cohort.joint_called.trained_model.deeptrio.indel_realigned.unfiltered-renamed.HG002.vcf.gz', tag: 'HPRCDTrio' ]
        ]

    xx = Channel.from(v).combine(Channel.from(x)).view()
    cc = xx.map { 
        [ 
            vcfTruth: it[0].vcfTruth, 
            bedFile: it[0].bedFile,
            chr: it[0].chr,
            stratFile: it[0].stratFile,
            ref: it[0].ref,
            SDF: it[0].SDF,
            vcfTest: it[1].vcfTest,
            tag: it[1].tag 
        ]
    }.view()
    happy(cc)

    publishResults(happy.out.publishFiles)


}