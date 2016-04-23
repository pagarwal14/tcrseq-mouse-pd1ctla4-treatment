library(ggplot2)
library(reshape2)
library(scales)
library(stringr)
library(ggrepel)
#can use the following file for testing
#filePairwise = "AA_Treg_depleted_ExpU_E_214_tumor_AA_Treg_depleted_ExpU_E_224_tumor.tsv"
#
print("Begin...")
inputdir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/clone_overlap/data/input/combinedgroups/"
outputdir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/clone_overlap/data/results/combinedgroups_top2Per/"
cmdFlag = T # change to T if taking the name of the pairwise TSV file from command line
#
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
# 04-21-16
# read in the file with the list of unique AA clones across all samples which have a unique numerical identifier - use that for the label in the plot instead of the AA sequence
# read in as factors - so can make sure number of levels same as number of row for uniqueness
#
dfUniqAALab = read.table("/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/data/uniqueCDR3List/AA_UniqueCDR3ListTop2Per.tsv", sep="\t", header=T)
str(dfUniqAALab)
#
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
#create a data frame for putting text label in overlap plot - just a subset of the overlap pairwise data frame with the top 2% clones since only they will get the AA seq (or numerical identifier) label - 2% can be changed (parameterized?)
dftext = subset(df, df[,3] > 0.02 | df[,5] > 0.02)
#insert column with unique numerical identifer
dftext$CDR3.UniqueAA.Seq.ID = subset(dfUniqAALab, dfUniqAALab$CDR3.UniqueAA.Seq %in% dftext$CDR3.UniqueAA.Seq,c("CDR3.UniqueAA.Seq.ID"))
dftext
#layer_text = geom_text(data = dftext, aes(x = dftext[,2], y = dftext[,4], label = dftext[,1]))
# with repel
#layer_text = geom_text_repel(data = dftext, aes(x = dftext[,2], y = dftext[,4], label = dftext[,1]))
# with unique numerical label
layer_text = geom_text_repel(data = dftext, aes(x = dftext[,2], y = dftext[,4], label = dftext[,"CDR3.UniqueAA.Seq.ID"]))
#
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


