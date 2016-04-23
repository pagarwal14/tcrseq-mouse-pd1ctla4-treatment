#04-23-16 (Sat)
#
#11.45 am
#
#Code for reading in all the pairwise combined (treatment group) samples TSV files with AA seq, count, and frequency greater than 2%, and creating a master list of unique AA seq, and write out as TSV with row.name=F.
#a df with col with number and second col with AA seq - can modify the col with number (index) later with something else if needed.
#
combinedSamplesPairwiseTSV_dir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/clone_overlap/data/input/combinedgroups/"
#
listuniqueAA_dir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/data/uniqueCDR3List/"
#
#files <- dir(combinedSamplesPairwiseTSV_dir, pattern = ".tsv")
files <- dir(combinedSamplesPairwiseTSV_dir, pattern = "^AA")
numfiles = length(files)
numfiles
#
combinedSamplesPairwiseCDR3AAList = list()
#
for(i in 1:numfiles) {
	input.file = paste(combinedSamplesPairwiseTSV_dir,files[i],sep="");
	print(input.file);
	df = read.table(input.file, header=T, row.names=NULL, sep="\t", stringsAsFactors=FALSE);
	combinedSamplesPairwiseCDR3AAList[[substring(files[i], 4, nchar(files[i])-10)]] = (subset(df, df[,3] > 0.02 | df[,5] > 0.02))$CDR3.UniqueAA.Seq;
	rm(df);
}
commonUniqueCDR3AAClones = Reduce(union, combinedSamplesPairwiseCDR3AAList)
#
numUniqueCDR3AAClones = length(commonUniqueCDR3AAClones)
#
numUniqueCDR3AAClones
#
dfUniqueCDR3AAClonesTop2Per = data.frame( "CDR3.UniqueAA.Seq"=character(numUniqueCDR3AAClones), "CDR3.UniqueAA.Seq.ID"=numeric(numUniqueCDR3AAClones), stringsAsFactors=F) 
#
j=1
#
for(j in 1:numUniqueCDR3AAClones){
#for(j in 1:2){
	#print(j);
	dfUniqueCDR3AAClonesTop2Per[j,1] = commonUniqueCDR3AAClones[j];
	dfUniqueCDR3AAClonesTop2Per[j,2] = j;
	j = j+1;
}
str(dfUniqueCDR3AAClonesTop2Per)
#
write.table(dfUniqueCDR3AAClonesTop2Per, paste(listuniqueAA_dir, "AA_UniqueCDR3ListTop2Per.tsv", sep=""), sep="\t", quote=F, col.names=T, row.names=F);

