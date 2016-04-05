dirInputTSV = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/data/preprocessing/samples/"
dirOverlapIntputTSV = "/srv/agarw005/projects/tcr-seq/Erika_MouseCTLA_PD1/tcrseq-mouse-pd1ctla4-treatment/analysis/R/data/samples/"
files <- dir(dirInputTSV, pattern = ".tsv") 
numfiles = length(files)
numfiles
colsOverlapAA=c("sample_name", "templates", "productive_frequency", "amino_acid")
colsOverlapNT=c("sample_name", "templates", "productive_frequency", "rearrangement")
colNamesOverlapAA=c("sample_name", "CloneCount", "Frequency", "CDR3.UniqueAA.Seq")
colNamesOverlapNT=c("sample_name", "CloneCount", "Frequency", "CDR3.UniqueNT.Seq")
#AA
for(i in 1:numfiles) { 
	input.file = paste(dirInputTSV,files[i],sep="");
	print(input.file);
	df = read.table(input.file, header=T, row.names=NULL, sep="\t", stringsAsFactors=FALSE);
	dftmp = df[colsOverlapAA];
	names(dftmp) = colNamesOverlapAA;
	write.table(dftmp, paste(dirOverlapIntputTSV, "AA_", files[i], sep=""), sep="\t", quote=F, col.names=T, row.names=F);
}
#NT
for(i in 1:numfiles) { 
	input.file = paste(dirInputTSV,files[i],sep="");
	print(input.file);
	df = read.table(input.file, header=T, row.names=NULL, sep="\t", stringsAsFactors=FALSE);
	dftmp = df[colsOverlapNT];
	names(dftmp) = colNamesOverlapNT;
	write.table(dftmp, paste(dirOverlapIntputTSV, "NT_", files[i], sep=""), sep="\t", quote=F, col.names=T, row.names=F);
}

