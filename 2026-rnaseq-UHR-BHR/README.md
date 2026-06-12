

## Install additional software
pixi add hisat2 subread

## Get the bioinformatics toolbox
bio code

## Download the Makefile
curl https://data.biostarhandbook.com/make/rnaseq.hisat.2026.mk > Makefile

## show statistics
seqkit stats reads/*.fq

## make index and align
make index
make align SAMPLE=HBR_1

## count featureCounts
    make count

##
Switch environment before to_csv command

## differential expression

make design file
    make design

# make plots

## PCA plot
    make pca

## heatmap
heatmap - R script written by Fable 5.0 AI in console (name: csv/heatmap-chatgpt.r)
     Rscript csv/heatmap-chatgpt.r

## collect the functions for each gene
    bio gprofiler -c edger.csv -d hsapiens

## other suggestions!
    xan view



