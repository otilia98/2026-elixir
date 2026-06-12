

# Install additional software
pixi add hisat2 subread

# Get the bioinformatics toolbox
bio code

# Download the Makefile
curl https://data.biostarhandbook.com/make/rnaseq.hisat.2026.mk > Makefile

# show statistics
seqkit stats reads/*.fq

# make index and align
make index
make align SAMPLE=HBR_1

# count featureCounts
    make count

a to_csv előtt kell a stats környezetet váltani!!!

# differential expression

make design file
    make design

# plotokat csinálni!!

## PCA plot
    make pca

## heatmap
heatmap - R script written by Fable 5.0 AI in console (name: csv/heatmap-chatgpt.r)
     Rscript csv/heatmap-chatgpt.r

# gyűjtsd ki a génekhez az adott funkciókat
    bio gprofiler -c edger.csv -d hsapiens

# xan view - nagyon jó!!




