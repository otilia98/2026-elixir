# Ebola
## Ebola virus genome

NCBI link: [https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000848505.1/](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000848505.1/)

ACCESSION: GCA_000848505.1

Genome: [https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/)

#### The URL to the genome.

```
FASTA_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz
```

#### The URL to the annotation.

```
GFF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.gff.gz
```

#### Download the genome

```
curl $FASTA_URL > ebola-mayinga-genome.fasta
```

#### Download the annotation.

```
curl $GFF_URL > ebola-mayinga-annotation.gff.gz
```

#### Unzip the annotation.

```
gunzip ebola-mayinga-annotation.gff.gz
```

#### Other way

URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

GENOME=ebola.genome.fna.gz

```
curl https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz > ebola.fna.gz
download:
curl -o $(GENOME) $(URL)
gunzip ebola.fna.gz
```

## IGV

TO display only mRNA or CDS by IGV, the .gff file needs to be modified

```
	#to display only mRNA
    awk -F'\t' '$0 ~ /^#/ || ($3 == "mRNA")' ebola-mayinga-annotation.gff > ebola-mayinga-mrna-only.gff
	#to display only CDS
    awk -F'\t' '$0 ~ /^#/ || ($3 == "CDS")' ebola-mayinga-annotation.gff > ebola-mayinga-CDS-only.gff
```

#### Generate statistics on the genome.
```
    seqkit stats ebola-mayinga-genome.fasta
```

# Day2

#### Link - https://www.ncbi.nlm.nih.gov/sra/SRX994253[accn]
#### SRA number - SRR1972976
#### Link number - PRJNA257197
#### SRA Experiments - 891-re katitntani

#### Get the metadata for a run
```
    bio search SRR1972976
```
#### Get all runs for a project
```
    bio search PRJNA257197
```
#### Metadata for bioproject - header is legyen!
```
     bio search PRJNA257197 --csv -H > samples.csv
```
#### Watch samples.csv directly in the terminal 
```
    pixi add xan
    xan view samples.csv
 ```   
#### Show first 10 row and 2 column in terminal  
```
	xan view -s run_accession,info samples.csv | head
```
#### Make the directory for the FASTQ files
```
    mkdir -p fastq
```
#### Obtain the first 100,000 reads
```
    fastq-dump -X 100000 --outdir fastq --split-files SRR1972976
```

### The URL to the genome
    FASTA_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

### The URL to the annotation.

GFF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.gff.gz
```
    #The simpler name for the genome.
    GENOME_NAME=ebola-mayinga

    #The name of the genome file.
    GENOME_FASTA=refs/${GENOME_NAME}.fna

    #The name of the annotation file.
    GENOME_GFF=refs/${GENOME_NAME}.gff

    #---- no changes below this line

    # The help target.
    usage:
	    @echo "# Read the Makefile for more details."

    # Make the directory for the references.
    # Then download and unzip the genome and annotation.
    download:
        mkdir -p refs
        curl -o $(GENOME_FASTA).gz $(FASTA_URL)
        curl -o $(GENOME_GFF).gz $(GFF_URL)
        gunzip $(GENOME_FASTA).gz
        gunzip $(GENOME_GFF).gz

    clean:
        rm -f $(GENOME_FASTA) $(GENOME_GFF)
```

## Don't forget
``` 
	make -f Makefile2.mk download -n
```
```
    .PHONY download fastq (tudja hogy ez egy álcél és nem akad fenn a problémát)
```
```
    make -f Makefile2.mk fastq align sort SRR=SRR1972957
    cat SRR1972957.sorted.flagstat
```

# Day3
## Don't forget
Extract the first 20 FASTQ records and convert to FASTA for BLAST search on NCBI to find out which sequences are in the FASTQ file
```
    cat fastq/SRR1972976_1.fastq | \
        head -80 | \
        seqtk seq -A > mystery.fa
```

Show a genome (Genbank ID - CP025298.1)
```
    bio fetch -format fasta CP025298.1 > refs/scarybug.fa
```

Do all commands from makefile
```
    make -f FASTA_URL= GENOME=baci1 Makefile2.mk download fastq align sort
```

VCF - make src/rub folder with a bcftools.mk file in it
```
    bio code
    make -f src/run/bcftools.mk
    make run -f src/run/bcftools.mk REF=refs/ebola-mayinga.fasta BAM=bam/SRR1972957.sorted.bam
```

BLAST
```
	#Install seqtk
    pixi add seqtk
	#Extract the first 20 FASTQ records and convert to FASTA
    cat fastq/SRR1972976_1.fastq | \
    head -80 | \
    seqtk seq -A > mystery.fa
```

# Useful links
### The Genetic Codes: https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi
### The HGV Nomenclature: https://hgvs-nomenclature.org/stable/

