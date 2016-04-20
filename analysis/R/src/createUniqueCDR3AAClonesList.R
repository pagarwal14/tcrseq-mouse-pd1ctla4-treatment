#04-20-16 (Wed)
#
#3.30 pm
#
#Code for reading in all the sample level TSV files with AA seq, count, and frequency, and creating a master list of unique AA seq, and write out as TSV with row.name=T.
#- or could create a df with col with number and second col with AA seq - do that - so can modify the col with number (index) later with something else if needed.
#
sampleTSV_dir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/data/samples/"
#
listuniqueAA_dir = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/data/uniqueCDR3List/"
#
#files <- dir(sampleTSV_dir, pattern = ".tsv")
files <- dir(sampleTSV_dir, pattern = "^AA")
numfiles = length(files)
numfiles
#
samplesCDR3AAList = list()
#
for(i in 1:numfiles) {
	input.file = paste(sampleTSV_dir,files[i],sep="");
	print(input.file);
	df = read.table(input.file, header=T, row.names=NULL, sep="\t", stringsAsFactors=FALSE);
	samplesCDR3AAList[[substring(files[i], 4, nchar(files[i])-10)]] = df$CDR3.UniqueAA.Seq;
	rm(df);
}
commonUniqueCDR3AAClones = Reduce(union, samplesCDR3AAList)
#
numUniqueCDR3AAClones = length(commonUniqueCDR3AAClones)
#
numUniqueCDR3AAClones
#
dfUniqueCDR3AAClones = data.frame( "CDR3.UniqueAA.Seq"=character(numUniqueCDR3AAClones), "CDR3.UniqueAA.Seq.ID"=numeric(numUniqueCDR3AAClones), stringsAsFactors=F) 
#
j=1
#
for(j in 1:numUniqueCDR3AAClones){
#for(j in 1:2){
	#print(j);
	dfUniqueCDR3AAClones[j,1] = commonUniqueCDR3AAClones[j];
	dfUniqueCDR3AAClones[j,2] = j;
	j = j+1;
}
str(dfUniqueCDR3AAClones)
#
write.table(dfUniqueCDR3AAClones, paste(listuniqueAA_dir, "AA_UniqueCDR3List.tsv", sep=""), sep="\t", quote=F, col.names=T, row.names=F);

