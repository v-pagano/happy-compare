process publishResults {
    input:
        tuple path(f), val(outDir)

    output:
        path f

    cpus 1
    publishDir path: "${outDir}", mode: 'copy', overwrite: 'true'

    script:
    """
        echo '${f}'
    """
}

process gzip {

    input:
        tuple val(meta), path(f)

    output:
        path "*.gz"

    container 'docker://ghcr.io/v-pagano/pigz'
    clusterOptions '-A tgen-371000'


    cpus 24

    script:
    """
        pigz -f -p 24 ${f} 
    """

}

process tabix {
    input:
        tuple val(meta), path(vcf)

    output:
        tuple val(meta), path("*vcf.gz"), emit: vcf
        path "*vcf.gz*", emit: publishFiles

    container 'docker://quay.io/biocontainers/tabix:1.11--hdfd78af_0'
    cpus 2

    script:
    """
        ${params.petagene ? params.petagenePreload : ''} bgzip ${vcf}
        tabix ${vcf}.gz
    """
}

process dback2Gemini {

    input:
        val dbackFile

    output:
        path "*"


    script:
        dbackFile = dbackFile.replace("labs", "tgen_labs")
        dbackFile = dbackFile.replace("scratch", "dback_scratch")
        dbackFile = dbackFile.replace("home", "tgen_home")
        """
            scp gemini-data1.rc.tgen.org:${dbackFile} .
        """
}