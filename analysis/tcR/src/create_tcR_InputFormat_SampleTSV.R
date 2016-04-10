#
# 04-10-16 (Sun)
# Read in per sample TSV file (Adaptive format) and create tcR format sample TSV format
#
dir.input = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/data/preprocessing/samples/"
dir.input
dir.out = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/tcR/data/input/"
dir.out
filesSampleTSV = dir(dir.input, pattern = ".tsv")
filesSampleTSV
numfiles = length(filesSampleTSV)
#
# define col names for various files
# Adaptive col names
sourcecols = c("productive_frequency", "templates", "v_resolved", "d_resolved", "j_resolved", "amino_acid", "rearrangement")
print(sourcecols)
# Just reorder the Adaptive col names in the order needed for tcR
sourcecolsreoder = c("templates", "productive_frequency", "rearrangement", "amino_acid", "v_resolved", "d_resolved", "j_resolved")
# Rename col names to that needed by tcR
tcRcols=c("Read.count", "Read.proportion", "CDR3.nucleotide.sequence", "CDR3.amino.acid.sequence", "V.gene", "D.gene", "J.gene")
#
#
for(i in 1:numfiles){
#for(i in 1:3){
 filename =  filesSampleTSV[i];
 sourceSampleFile = paste(dir.input, filesSampleTSV[i],sep="");
 print(filename);
 dftemp = read.table(sourceSampleFile, header=T, stringsAsFactors=F, sep="\t");
 # remove the first col
 print(names(dftemp));
 dftemp = dftemp[, sourcecols];
 print(str(dftemp));
 #rearrange order of cols;
 dftemp = dftemp[sourcecolsreoder];
 print(str(dftemp));
 #rename col names;
 names(dftemp) = tcRcols;
 print(str(dftemp));
 #add UMI cols
 dftemp = cbind(Umi.count = NA, Umi.proportion = NA, dftemp);
 print("PRINTING FILE DF");
 print(str(dftemp));
 #write out tsv file
 write.table(dftemp, paste(dir.out,filename,sep=""), col.names=T, row.names=F, sep="\t", quote=F);
 rm(dftemp);
}
