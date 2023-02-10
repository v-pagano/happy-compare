workflow CSV_PARSE {

    take:
        csvFile

    main:
        runs = Channel.fromPath(csvFile).splitCsv(header: true)

        runs = runs.map { 
            x = new ArrayList();
            for (i = 7; i < it.size(); i++) {
                l = [ 
                    sampleId: it.sampleId,
                    vcfTruth: it.truthVcf,
                    bedFile: it.bedFile == '' ? params.bedFile : it.bedFile,
                    chr: it.chromosome,
                    stratFile: it.stratifications == '' ? params.stratifications : it.stratifications,
                    ref: it.reference == '' ? params.reference : it.reference,
                    SDF: it.SDF == '' ? params.sdf : it.SDF
                ]
                l.put('vcfTest',it[it.keySet()[i]]);
                l.put('tag',it.keySet()[i])
                x.add(l);
            }
            return x;
        }.flatten()

    emit:
        runs
}