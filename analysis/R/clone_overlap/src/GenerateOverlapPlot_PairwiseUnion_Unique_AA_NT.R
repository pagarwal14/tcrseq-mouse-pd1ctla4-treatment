library(ggplot2)
library(reshape2)
library(scales)
library(stringr)
library(ggrepel)
#filePairwise = "402_orienx010_baseline_AA_402_orienx010_post_AA.tsv"
#filePairwise = "501_orienx010_baseline_AA_501_orienx010_post_AA.tsv"
#filePairwise = "504_orienx010_baseline_AA_504_orienx010_post_AA.tsv"
#filePairwise = "604_orienx010_baseline_AA_604_orienx010_post_AA.tsv"
print("Begin...")
inputdir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/clone_overlap/data/input/"
outputdir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/clone_overlap/data/results/"
cmdFlag = T # change to T if taking the name of the pairwise TSV file from command line

if(cmdFlag==T){
args = commandArgs(trailingOnly=TRUE)
numargs = length(args)
print(paste("Number of cmd line args",numargs))
if(length(args)==0) {
	stop("At least one argument must be supplied (input file).tsv", call.=FALSE)
}else if (length(args)==1) {
	filePairwise = args[1]
}else{
	stop("Only one argument must be supplied (input file).tsv", call.=FALSE)
}
#
}else{
filePairwise = "604_orienx010_baseline_AA_604_orienx010_post_AA.tsv"
}
print(paste("filePairwise", filePairwise))
#
pos = unlist(str_locate_all(pattern =".tsv", filePairwise))[1]
print(paste("pos=",pos))
pairwiseSample = substr(filePairwise, 0, pos-1)
print(paste("pairwiseSample = ", pairwiseSample))
#
###stop("test stop")### For testing
#
df = read.table(paste(inputdir,filePairwise,sep=""),  sep="\t", header=T,  stringsAsFactors=F)
#
str(df)
head(df)
max1 = max(df[,2])
max1
max2 = max(df[,4])
max2
max=max(c(max1, max2))
max
max = max + 0.05*max
max
#
#options(bitmapType='cairo')
#png(paste(pairwiseSample,".png",sep=""))
overlapPlot = ggplot()
#layer_point = geom_point(mapping = aes(x = df[,2], y = df[,4]), data=df,  size=2)
# break up the data into low frequency clones and high frequency clones and display AA only for high frequency clones.
dflowfreq=subset(df, df[,3] < 0.01 & df[,5] < 0.01)
dfhighreq=df[ !(df[,1] %in% dflowfreq[,1]), ]
layer_point1 = geom_point(mapping = aes(x = dfhighreq[,2], y = dfhighreq[,4]), data=dfhighreq,  size=2)
layer_point2 = geom_point(mapping = aes(x = dflowfreq[,2], y = dflowfreq[,4]), data=dflowfreq,  size=0.5)
#
overlapPlot = overlapPlot + layer_point1 + layer_point2
#overlapPlot
overlapPlot = overlapPlot + expand_limits(x = c(0, max)) + expand_limits(y = c(0, max))
#change the breaks from 50000 to 500
overlapPlot = overlapPlot + scale_x_continuous(labels = comma, breaks=seq(0,max,500)) + scale_y_continuous(labels = comma, breaks=seq(0,max,500))
#overlapPlot
layer_abline = geom_abline(intercept=0, slope=1, color="blue", linetype="dashed", size=0.05)
overlapPlot = overlapPlot + layer_abline
#overlapPlot
dftext = subset(df, df[,3] > 0.02 | df[,5] > 0.02)
dftext
layer_text = geom_text_repel(data = dftext, aes(x = dftext[,2], y = dftext[,4], label = dftext[,1]))
#layer_text = geom_text(data = dftext, aes(x = dftext[,2], y = dftext[,4], label = dftext[,1]))
overlapPlot = overlapPlot + layer_text
#overlapPlot
overlapPlot = overlapPlot + ggtitle(pairwiseSample)
overlapPlot = overlapPlot + xlab(names(df)[2])
overlapPlot = overlapPlot + ylab(names(df)[4])
####overlapPlot
#ggsave(paste(pairwiseSample,".png",sep=""))
ggsave(paste(outputdir, pairwiseSample,".pdf",sep=""))
#dev.off()
rm(layer_point)
rm(layer_abline)
rm(dftext)
rm(layer_text)
rm(overlapPlot)


