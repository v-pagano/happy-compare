process publishResults {
    input:
        path f

    output:
        path f

    cpus 1
    publishDir path: params.outputFolder, mode: 'copy', overwrite: 'true'

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