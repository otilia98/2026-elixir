# The URL to the genome
FASTA_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

# The URL to the annotation.
GFF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.gff.gz

# The simpler name for the genome.
GENOME_NAME=ebola-mayinga

# The name of the genome file.
GENOME_FASTA=refs/${GENOME_NAME}.fasta

# The name of the annotation file.
GENOME_GFF=refs/${GENOME_NAME}.gff

# The SRR ID of the sample
SRR=SRR1553425

#The number of reads to download
LIMIT=100000

# BAM output path - ide kéne a .bam kiterjesztés, de ha nem írom be, akkor nem működik a vcf kód.
BAM=bam/$(SRR)

#The path to the read files
R1_READS=reads/${SRR}_1.fastq
R2_READS=reads/${SRR}_2.fastq

# ---- no changes below this line

# The help target.
usage:
	@echo "# Read the Makefile for more details."

# Make the directory for the references, then download and unzip the genome and annotation and index the genome
download:
	mkdir -p refs
	curl -o ${GENOME_FASTA}.gz ${FASTA_URL}
	curl -o ${GENOME_GFF}.gz ${GFF_URL}
	gunzip ${GENOME_FASTA}.gz
	gunzip ${GENOME_GFF}.gz
	bwa index ${GENOME_FASTA}
# Download the reads from SRA, limit the reads to LIMIT and use the fastq-dump command

fastq:
	mkdir -p reads
	fastq-dump -X 100000 --outdir reads --split-files ${SRR}

# align and index and sortthe reads to the genome
align:
	mkdir -p bam
	bwa mem -t 4 ${GENOME_FASTA} ${R1_READS} ${R2_READS} | samtools view -bS - > ${BAM}.bam
	samtools sort -o ${BAM}.sorted.bam ${BAM}.bam
	samtools index ${BAM}.sorted.bam
	samtools flagstat ${BAM}.sorted.bam > ${BAM}.sorted.flagstat

#remove all the derived files
clean:
	rm -rf reads bam refs

.PHONY: download fastq samtools 

#variant calling bfctools

#VCF file name
VCF=vcf/variants_${SRR}.vcf.gz

# Flags to customize mpileup command
PILEUP_FLAGS=-d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Flags for the call command
CALL_FLAGS=--ploidy 2 --annotate 'FORMAT/GQ' 

vcf:
	mkdir -p vcf
	bcftools mpileup ${PILEUP_FLAGS} -O u -f ${GENOME_FASTA} ${BAM}.sorted.bam | \
	bcftools call ${CALL_FLAGS} -mv -O u | \
	bcftools norm -f ${GENOME_FASTA} -d all -O u | \
	bcftools sort -O z > ${VCF}

.PHONY: vcf

