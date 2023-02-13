# Happy-Compare Documentation

## Initial setup

The repository is on github. Simply clone that repo and you can run the pipeline.

    git clone git@github.com:v-pagano/happy-compare.git

## Running a simple pipeline

Everything is setup in the input csv file, with that running the pipeline is simple. Just identify the input file and where you would like the output files to be written

    nextflow run main.nf --input samples.csv --outputFolder /scratch/myFolder/output

### CSV Format

The input csv file is setup with one row per sample. Many columns have a default if the field is left blank
sampleId,truthVcf,bedFile,chromosome,stratifications,reference,SDF,GATK,DV,SBPAN,SBAI,HPRCDV,HPRCDTrio

| Column          | Description                         |  Default                                                                   |
|-----------------|-------------------------------------|----------------------------------------------------------------------------|
| sampleId        | Sample identifier                   |                                                                            |
| truthVcf        | True variants for comparison        |                                                                            |
| bedFile         | .bed file for comparison locations  | HG002_GRCh38_1_22_v4.2.1_benchmark_noinconsistent.bed                      |
| chromosome      | chromosomes to compare              | All chromosomes                                                            |
| stratifications | tsv of bed files for stratification | v3.1-GRCh38-stratifications-all-except-genome-specific-stratifications.tsv |
| reference       | genome reference .fa file           | GRCh38tgen_decoy_alts_hla.fa                                               |
| SDF             | SDF folder for comparison           | GRCh38tgen_decoy_alts_hla.sdf                                              |

The rest of the columns are the comparisons that you want to do with the column name as the tag for that sample and the field with the vcf file to test. Take a look at HG002-happy.csv for an example.

## Output files

The output files will all end up in the outputFolder that you specified. They will be named sampleId-comparisonTag-chromosome.*

## Profiles

Profiles allow you to tailor how to run the pipeline. Simply add -profile profileName to your command line to use them, for example:

    nextflow run main.nf --input samples.csv --outputFolder /scratch/myFolder/output -profile gemini 

Here are the current profiles you can use:

| Profile | Modifications                                 |
|---------|-----------------------------------------------|
| dback   | Configured for the dback cluster              |
| gemini  | Configured for the gemini cluster             |
| reports | Outputs reports on CPU usage and elapsed time |
