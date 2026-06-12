# Ebola
## Ebola virus genome

NCBI link: [https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000848505.1/](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000848505.1/)

ACCESSION: GCA_000848505.1

Genome: [https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/)
GCF_000848505.1_ViralProj14703_rna_from_genomic.fna.gz
(itt FTP -re kell kattintani fent és beugranak a letölthető fájlok)

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

#### másik módszerrel

```
URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

GENOME=ebola.genome.fna.gz

download:
curl -o $(GENOME) $(URL)
```

Nem működött nekem a .fa kiterjesztésű refgenom megnyitással az igv, ezért letöltöttük az .fna fájl és így már működött! igazából ez az a fájl csak nem fastának neveztem át

```
curl https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz > ebola.fna.gz

gunzip ebola.fna.gz
```

## IGV

Ahhoz hogy IGV-ben csak mRNS-t mutassa, a .gff fájlt át kell írni úgy hogy csak az mRNS legyen benne
szűrés, mRNA tartsuk meg

```
    awk -F'\t' '$0 ~ /^#/ || ($3 == "mRNA")' ebola-mayinga-annotation.gff > ebola-mayinga-mrna-only.gff
```

Szűrés, CDS tartsuk meg

```
    awk -F'\t' '$0 ~ /^#/ || ($3 == "CDS")' ebola-mayinga-annotation.gff > ebola-mayinga-CDS-only.gff
```

#### Generate statistics on the genome.
```
    seqkit stats ebola-mayinga-genome.fasta
```

#### FASTQ
A FASTQ egy kimenet (FASTA és GFF azok a bemeneti fájlok, amit tudunk, ez maga a mérés).

# 2. nap - mérések

#### Link - https://www.ncbi.nlm.nih.gov/sra/SRX994253[accn]
#### SRA number - SRR1972976
#### Link number - PRJNA257197
#### SRA Experiments - 891-re katitntani

#### Get the metadata for a run

    bio search SRR1972976

#### Get all runs for a project

    bio search PRJNA257197

#### Metadata for bioproject - header is legyen!

     bio search PRJNA257197 --csv -H > samples.csv

#### Watch samples.csv directly in the terminal 

    pixi add xan
    xan view samples.csv
    
#### Csak a head első 10 sor és 2 oszlopot mutat    
    xan view -s run_accession,info samples.csv | head

#### Make the directory for the FASTQ files
    mkdir -p fastq

#### Obtain the first 100,000 reads
    fastq-dump -X 100000 --outdir fastq --split-files SRR1972976


##########################################

## HA TÖBB MAKEFILE VAN
    make -f Makefile2.mk hello

    #The URL to the genome
    FASTA_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

    #The URL to the annotation.
    GFF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.gff.gz

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

 ## Ha szeretnéd hogy csak megnézni működik e a cucc és listázza ki a parancsokat
    make -f Makefile2.mk download -n

 # Elromlott az AI, nem segít de kifizettem a pro-t.

    .PHONY download fastq (tudja hogy ez egy álcél és nem akad fenn a problémát)

 ### Ha gyorsan mintát akarsz keresni csak a meglévő makefile-t használhatod másik mintára

    make -f Makefile2.mk fastq align sort SRR=SRR1972957
    cat SRR1972957.sorted.flagstat
        
# Nem tudom mi az az egy adatom, ezt minden genomhoz hozzá akarom mérni? BLAST!

## Install seqtk
    pixi add seqtk

# 3.nap

# mit jelent mindez? gondold végig otthon hogyan lehetne ezt gyorsabbá tenni

## Extract the first 20 FASTQ records and convert to FASTA for BLAST seqrch on NCBI to find out which sequence are in the fastq file
    cat fastq/SRR1972976_1.fastq | \
        head -80 | \
        seqtk seq -A > mystery.fa

## megnézem egy genomot (Genbank ID - CP025298.1)???
    bio fetch -format fasta CP025298.1 > refs/scarybug.fa

## hogyan csinálom meg gyorsan a makefile alapján a dolgokat
    make -f FASTA_URL= GENOME=baci1 Makefile2.mk download fastq align sort

## IGV - colored by reads!!!

## The Genetic Codes
https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi

## The HGV Nomenclature
https://hgvs-nomenclature.org/stable/

# ő kódja VCF-hez
Csinál egy src mappát, bele run mappa, abban van egy bcftools.mk
Ezután benne van  avariant callinghoz minden parancs, 

    bio code
    make -f src/run/bcftools.mk
    make run -f src/run/bcftools.mk REF=refs/ebola-mayinga.fasta BAM=bam/SRR1972957.sorted.bam

# Nem tudom mi az az egy adatom, ezt minden genomhoz hozzá akarom mérni? BLAST!

    #Install seqtk
    pixi add seqtk

    #Extract the first 20 FASTQ records and convert to FASTA
    cat fastq/SRR1972976_1.fastq | \
    head -80 | \
    seqtk seq -A > mystery.fa

