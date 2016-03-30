setwd("../raw")
dfUntreated_Controls = read.table("Untreated_Controls.tsv", header=T, stringsAsFactors=F, sep="\t")
str(dfUntreated_Controls)
unique(dfUntreated_Controls$sample_name)
length(unique(dfUntreated_Controls$sample_name))
sum(dfUntreated_Controls$productive.frequency)
sum(dfUntreated_Controls[dfUntreated_Controls$sample_name=="ExpU_A_213_tumor",]$productive.frequency)
sum(dfUntreated_Controls[dfUntreated_Controls$sample_name=="ExpU_A_219_tumor",]$productive.frequency)
sum(dfUntreated_Controls[dfUntreated_Controls$sample_name=="ExpU_A_222_tumor",]$productive.frequency)
sum(dfUntreated_Controls[dfUntreated_Controls$sample_name=="ExpU_A_229_tumor",]$productive.frequency)
sum(dfUntreated_Controls[dfUntreated_Controls$sample_name=="ExpU_A_233_tumor",]$productive.frequency)
#
dfaCTLA4_Rx = read.table("aCTLA4_Rx.tsv",  header=T, stringsAsFactors=F, sep="\t")
str(dfaCTLA4_Rx)
unique(dfaCTLA4_Rx$sample_name)
sum(dfaCTLA4_Rx$productive_frequency)
#
dfaPD1_aCTLA4 = read.table("aPD1_aCTLA4.tsv",  header=T, stringsAsFactors=F, sep="\t")
str(dfaPD1_aCTLA4)
unique(dfaPD1_aCTLA4$sample_name)
sum(dfaPD1_aCTLA4$productive_frequency)
#
dfaPD1_Rx = read.table("aPD1_Rx.tsv", header=T, stringsAsFactors=F, sep="\t")
str(dfaPD1_Rx)
unique(dfaPD1_Rx$sample_name)
sum(dfaPD1_Rx$productive_frequency)
#
dfTreg_depleted = read.table("Treg_depleted.tsv", header=T, stringsAsFactors=F, sep="\t")
str(dfTreg_depleted)
unique(dfTreg_depleted$sample_name)
sum(dfTreg_depleted$productive_frequency)
#
allSampleIDs = vector()
allSampleIDs = c(allSampleIDs, unique(dfUntreated_Controls$sample_name), unique(dfaCTLA4_Rx$sample_name), unique(dfaPD1_aCTLA4$sample_name), unique(dfaPD1_Rx$sample_name), unique(dfTreg_depleted$sample_name))
length(allSampleIDs)
length(unique(allSampleIDs))
allSampleIDs
#
#
#Generate TSV with renamed col headers and select only relevant columns for further analysis.
#
#
#NOTE:
#In the original "raw" exported TSV, Untreated_Controls col name is "productive.frequency" (actualy "productive frequency" but when R import as table puts a "." between the two words),
#others are "productive_frequency"
#renamed col in Untreated_Controls as "productive_frequency" just for writing out the TSV.
#setwd("../samples")
#dirInputTSV = "D:\\PROJECTS\\DUKE\\LyerlyLab\\HKL-Immuno_Sequencing\\Erika_MiceTreatmentEffects\\data\\preprocessing\\input\\"
dirInputTSV = "../samples/"
#colselect = c("sample_name", "templates", "productive_frequency", "v_resolved", "d_resolved", "j_resolved", "amino_acid", "rearrangement")
colselect = c("sample_name", "productive_frequency", "templates", "v_resolved", "d_resolved", "j_resolved", "amino_acid", "rearrangement")
#write.table(dfUntreated_Controls[dfUntreated_Controls$sample_name=="ExpU_A_213_tumor", colselect], paste(dirInputTSV, "Untreated_Controls", "_", "ExpU_A_213_tumor", ".tsv", sep=""), col.names=T, row.names=F, sep="\t", quote=F)
#dfUntreated_Controls
#Note: only renaming the col names for Untreated Controls because the frequency col had a different col name from all other treated samples (had ""productive frequency" instead of "productive_frequency")
names(dfUntreated_Controls) = colselect
#
for(sample in unique(dfUntreated_Controls$sample_name)){
	write.table(dfUntreated_Controls[dfUntreated_Controls$sample_name==sample, colselect], paste(dirInputTSV, "Untreated_Controls", "_", sample, ".tsv", sep=""), col.names=T, row.names=F, sep="\t", quote=F)
}
#dfaCTLA4_Rx
for(sample in unique(dfaCTLA4_Rx$sample_name)){
	write.table(dfaCTLA4_Rx[dfaCTLA4_Rx$sample_name==sample, colselect], paste(dirInputTSV, "aCTLA4_Rx", "_", sample, ".tsv", sep=""), col.names=T, row.names=F, sep="\t", quote=F)
}
#dfaPD1_aCTLA4
for(sample in unique(dfaPD1_aCTLA4$sample_name)){
	write.table(dfaPD1_aCTLA4[dfaPD1_aCTLA4$sample_name==sample, colselect], paste(dirInputTSV, "aPD1_aCTLA4", "_", sample, ".tsv", sep=""), col.names=T, row.names=F, sep="\t", quote=F)
}
#dfaPD1_Rx
for(sample in unique(dfaPD1_Rx$sample_name)){
	write.table(dfaPD1_Rx[dfaPD1_Rx$sample_name==sample, colselect], paste(dirInputTSV, "aPD1_Rx", "_", sample, ".tsv", sep=""), col.names=T, row.names=F, sep="\t", quote=F)
}
#dfTreg_depleted
for(sample in unique(dfTreg_depleted$sample_name)){
	write.table(dfTreg_depleted[dfTreg_depleted$sample_name==sample, colselect], paste(dirInputTSV, "Treg_depleted", "_", sample, ".tsv", sep=""), col.names=T, row.names=F, sep="\t", quote=F)
}
