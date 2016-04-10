# 02-26-16 (Fri)
# 1.45 am (night)
# Update the coe from 02-24-16
# Code for all clones, not just top 10.
#
# 02-28-16 (Sun)
# 10 am
# Added code to write out the combined df to the results dir which can then be used by more than one plotting program (base, ggplot, lattice) to generate the plots.
# Made the file name (input and output) standardized - so can quickly generate the file with Union (overlapping) set of clones which can be used for plotting.
#
# 03-12-16 (Sat)
# Clean up code and make it more logical - today wrote code to generate all NT and AA unique clones TSV file from BGI XL (much better than before)
#
#03-20-16 (Sun)
# Editing for Erika's Mice project
#
# dir for input files - individual sample TSV 
#
#datadir = "D:\\PROJECTS\\DUKE\\LyerlyLab\\HKL-Immuno_Sequencing\\Erika_MiceTreatmentEffects\\analysis\\R\\overlap_analysis\\data\\input\\"
datadir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/data/samples/"
#
# write out the combined TSV to this dir.
#
#resultsdir = "D:\\PROJECTS\\DUKE\\LyerlyLab\\HKL-Immuno_Sequencing\\Erika_MiceTreatmentEffects\\analysis\\R\\overlap_analysis\\results\\pairwiseinput\\"
resultsdir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/clone_overlap/data/input/"
#
# First and second sample in the pairwise TSV generation
#
sample1 = "ExpU_C_215_tumor" #
sample2 = "ExpU_C_231_tumor" #"Untreated_Controls" #"ExpU_B_217_tumor" #401, 402, 403, 501, 504, 506, 602, 603, 604
#
# extend by parameterizing baseline/post, treamtment (orienx010, dc-cik), AA/NT, unique/frequency.....
#
treatment1 = "aCTLA4_Rx" #"Untreated_Controls" #"aPD1_Rx" #"aCTLA4_Rx" #"aPD1_aCTLA4" #"Treg_depleted" 
treatment2 = "aCTLA4_Rx" #"Untreated_Controls" #"aPD1_Rx" #"aCTLA4_Rx" #"aPD1_aCTLA4" #"Treg_depleted"
#
# Molecule
#
mol1 = "AA"
mol2 = "AA"
#
# first mouse and second mouse
#file1prefix = paste(treatment1, "_", sample1,  "_", mol1, sep="")
file1prefix = paste(mol1, "_", treatment1, "_", sample1, sep="")
#file1 = paste(file1prefix, ".TRB.CDR3.unique.frequency.tsv", sep="")# can't have the other extension since did not put it when created the file.
file1 = paste(file1prefix, ".tsv", sep="")
file1
file2prefix = paste(mol2, "_", treatment2, "_", sample2, sep="")
file2 = paste(file2prefix, ".tsv", sep="")
file2
#
df1 = read.table(paste(datadir, file1, sep=""), header=T, sep="\t", stringsAsFactors=F)
str(df1)
# Verify all are unique.
sum(df1$Frequency) 
# Verify all are unique in another way.
if(mol1 == "AA"){
	duplicatesdf1 = df1$CDR3.UniqueAA.Seq[duplicated(df1$CDR3.UniqueAA.Seq)] 
	length(duplicatesdf1) 
}
#
df2 = read.table(paste(datadir, file2, sep=""), header=T, sep="\t", stringsAsFactors=F)
str(df2)
# Verify all are unique.
sum(df2$Frequency) 
# Verify all are unique in another way. 
if(mol2 == "AA"){
	duplicatesdf2 = df2$CDR3.UniqueAA.Seq[duplicated(df2$CDR3.UniqueAA.Seq)] 
	length(duplicatesdf2) 
}
#
if(mol1 == "AA" & mol2 == "AA"){
	combinedclones = union(df1$CDR3.UniqueAA.Seq, df2$CDR3.UniqueAA.Seq)
}else{
	combinedclones = union(df1$CDR3.UniqueNT.Seq, df2$CDR3.UniqueNT.Seq)
}
head(combinedclones)
numCombClones = length(combinedclones)
numCombClones
#Check how many are common and how many unique - rough estimate
nrow(df1)
nrow(df2)
nrow(df1)+nrow(df2) # sum of all clones in df1 and df2 - if many are common then this number will be much larger than numCombClones
# 
# First make a dataframe for the result - each AA in the union, cols for sample1 clone count, clone freq, cols for sample2 clone count, clone freq. 
# Go through each AA clones and get the clone count and freq for each of the sample and bind to the empty df. 
# 
dfcombined = data.frame( col1=character(numCombClones), col2=numeric(numCombClones), col3=numeric(numCombClones), col4=numeric(numCombClones), col5=numeric(numCombClones), stringsAsFactors=F) 
colnames = c(paste("CDR3.Unique",mol1,".Seq",sep=""), paste("S",file1prefix,"CloneCount",sep="_"), paste("S",file1prefix,"Frequency",sep="_"), paste("S",file2prefix,"CloneCount",sep="_"), paste("S",file2prefix,"Frequency",sep="_") )
names(dfcombined) = colnames
str(dfcombined)
#
i=0 
for(clone in combinedclones){ 
 i=i+1; 
 #print(i);
 #print(paste("clone", clone)); 	
 dfcombined[i,1] = clone;
 dftemp1 = subset(df1, df1[,4] == clone)
 #print(dftemp1) 
 if(nrow(dftemp1) > 0){ 
 	#dfcombined$CloneCountSample1[i] = dftemp1[,"CloneCount"]; 
	dfcombined[i,2] = sum(dftemp1[,2]);# sum because the clones are not unique (some case of more than one row) in the original data
	#print(dfcombined$CloneCountSample1[i])
 	#dfcombined$FrequencySample1[i] = dftemp1[,"Frequency"]; 
	dfcombined[i,3] = sum(dftemp1[,3]); 
	#print(dfcombined$FrequencySample1[i])
 }else{ 
 	dfcombined[i,2] = 1; 
 	dfcombined[i,3] = 0; 
 }
 dftemp2 = subset(df2, df2[,4] == clone) 
 if(nrow(dftemp2) > 0){ 
 	dfcombined[i,4] = sum(dftemp2[,2]);
	dfcombined[i,5] = sum(dftemp2[,3]);
 }else{ 
 	dfcombined[i,4] = 1; 
 	dfcombined[i,5] = 0; 
 } 
} 
str(dfcombined) 
#
# write output TSV file
#
write.table(dfcombined, paste(resultsdir, paste(file1prefix, "_",file2prefix, ".tsv", sep=""), sep=""), row.names=F, col.names=T, quote=F,sep="\t")



