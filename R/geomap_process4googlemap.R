#this script join incoming and outgoin data to look for animals that were adopted multiple times
rm(list = ls())
Index=5
cutRow=15056#cutoff value

filename="../data/Austin_Animal_Center_Intakes"
pfix=".csv"

rfilename=paste(filename,toString(Index-1),pfix,sep = "")
wfilename=paste(filename,toString(Index),pfix,sep = "")

#--------------------------------------------read-------------------------------------
Df = read.csv(rfilename,stringsAsFactors = FALSE)

df2 = Df[cutRow:nrow(Df),]

write.csv(df2,wfilename,row.names = FALSE)

