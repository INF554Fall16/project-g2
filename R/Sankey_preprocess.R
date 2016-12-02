library(dplyr)
library(stringr)
library(tidyr)
rm(list = ls())
setwd("~/Desktop/2016FALL/554/project/project-g2-master/R")

ReadIntakefilename="../data/Austin_Animal_Center_Intakes.csv"
ReadOutcomefilename="../data/Austin_Animal_Center_Outcomes.csv"

dfIntake0=read.csv(ReadIntakefilename,stringsAsFactors = FALSE)
dfOutcome0=read.csv(ReadOutcomefilename,stringsAsFactors = FALSE)

dfIntake0$Name=NULL
dfIntake0$DateTime=NULL
dfIntake0$MonthYear=NULL
dfIntake0$Found.Location=NULL
dfIntake0$Intake.Type=NULL
dfIntake0$Intake.Condition=NULL
dfIntake0$Breed=NULL

dfOutcome0$Name=NULL
dfOutcome0$DateTime=NULL
dfOutcome0$MonthYear=NULL
dfOutcome0$Date.of.Birth=NULL
dfOutcome0$Outcome.Subtype=NULL
dfOutcome0$Breed=NULL

tmp <- dfIntake0$Animal.ID
for (i in 1:length(tmp)) { 
  dfIntake0$I[i]=1}

tmp <- dfIntake0$Animal.ID
for (i in 1:length(tmp)) { 
  dfIntake0$O[i]=1}

joinDf = dfIntake0 %>% full_join(dfOutcome0,by=c("Animal.ID"))


names(joinDf) <- c("ID", "Type.Intake", "Sex.Intake", "Age.Intake", "Color.Intake", "I","O","Outcome","Type.Outcome","Sex.Outcome","Age.Outcome","Color.Outcome")
joinDf$Type.Intake <- factor(joinDf$Type.Intake)
rm(tmp)
rm(tmp2)
tmp <- joinDf$Age.Intake
tmp2 <- joinDf$Age.Intake
for (i in 1:length(tmp)) { 
  if (is.na(tmp[i]) || is.null(tmp[i])) tmp2[i] = NA
  else
    if (tmp[i]=="NULL") tmp2[i] = NA
    else {
      tmp[i] <- strsplit(tmp[[i]]," ")
      if(tmp[[i]][2] != "years")  tmp2[i] <- "< 1 year"
      else 
        if (strtoi(tmp[[i]][1]) <= 3) tmp2[i] <-"1~3 years"
        else
          if ((strtoi(tmp[[i]][1]) > 3) && (strtoi(tmp[[i]][1]) <= 6)) tmp2[i] <-"3~6 years"
          else 
            if (strtoi(tmp[[i]][1]) >6) tmp2[i] <-"> 6 years"
    }
}
joinDf$Age.Intake <- tmp2
joinDf <- joinDf[!(is.na(joinDf$Age.Intake)),]
joinDf$Age.Intake <- factor(joinDf$Age.Intake)

joinDf$Outcome <- factor(joinDf$Outcome)
joinDf$Type.Outcome <- factor(joinDf$Type.Outcome)

tmp <- joinDf$Age.Outcome
tmp2 <- joinDf$Age.Outcome
i=0
for (i in 1:length(tmp)) { 
  if (is.na(tmp[i]) || is.null(tmp[i])) tmp2[i] = NA
  else
    if (tmp[i]=="NULL") tmp2[i] = NA
    else {
    tmp[i] <- strsplit(tmp[[i]]," ")
    if(tmp[[i]][2] != "years")  tmp2[i] <- "< 1 year"
    else 
      if (strtoi(tmp[[i]][1]) <=3) tmp2[i] <-"1~3 years"
      else
        if ((strtoi(tmp[[i]][1]) >3) && (strtoi(tmp[[i]][1]) <= 6)) tmp2[i] <-"3~6 years"
        else 
          if (strtoi(tmp[[i]][1]) >6) tmp2[i] <-"> 6 years"
  }
}
joinDf$Age.Outcome <- tmp2
joinDf <- joinDf[!(is.na(joinDf$Age.Outcome)),]
joinDf$Age.Outcome <- factor(joinDf$Age.Outcome)


tmp <- joinDf$Color.Intake
t<-table(tmp)
which(t>2000)
for (i in 1:length(tmp)) {
  tmp[i]=trimws(tmp[i])
  flag = 0
  if (tmp[i]=="Black") {tmp[i]="Black"; flag=1; }
  if (tmp[i]=="Black/White") {tmp[i]="Black/White"; flag=1; }
  if (tmp[i]=="Brown") {tmp[i]="Brown"; flag=1; }
  if (tmp[i]=="Brown Tabby") {tmp[i]="Brown"; flag=1; }
  if (tmp[i]=="Brown/White") {tmp[i]="Brown/White"; flag=1; }
  if (tmp[i]=="Tan/White") {tmp[i]="Tan/White"; flag=1; }
  if (tmp[i]=="White") {tmp[i]="White"; flag=1; }
  if (flag ==0) {tmp[i] = "Other"}}
tmp <- factor(tmp)
joinDf$Color.Intake <- tmp

joinDf$Color.Outcome <- NULL

joinDf <- joinDf[joinDf$Sex.Intake!="NULL",]
joinDf <- joinDf[joinDf$Sex.Outcome!="NULL",]

tmp <- joinDf$Sex.Intake
for (i in 1:length(tmp)) {
  tmp[i]=trimws(tmp[i])
  if (tmp[i]=="Intact Female") tmp[i] <- "Intact";
  if (tmp[i]=="Intact Male") tmp[i] <- "Intact";
  if (tmp[i]=="Spayed Female") tmp[i] <- "BirthControlled";
  if (tmp[i]=="Neutered Male") tmp[i] <- "BirthControlled";
  if (tmp[i]=="Unknown") tmp[i] <- "Unknown";
}
tmp <- factor(tmp)
joinDf$Surgeried.Intake <- tmp

tmp <- joinDf$Sex.Outcome
for (i in 1:length(tmp)) {
  tmp[i]=trimws(tmp[i])
  if (tmp[i]=="Intact Female") tmp[i] <- "Intact";
  if (tmp[i]=="Intact Male") tmp[i] <- "Intact";
  if (tmp[i]=="Spayed Female") tmp[i] <- "BirthControlled";
  if (tmp[i]=="Neutered Male") tmp[i] <- "BirthControlled";
  if (tmp[i]=="Unknown") tmp[i] <- "Unknown";
}
tmp <- factor(tmp)
joinDf$Surgeried.Outcome <- tmp


joinDf$Sex.Intake <- factor(joinDf$Sex.Intake)
joinDf$Sex.Outcome <- factor(joinDf$Sex.Outcome)

# type->sex(intake)
#rm(i,t,tmp,tmp2)
mytable <- table(joinDf$Type.Intake,joinDf$Surgeried.Intake)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c("Bird","Cat","Dog","Livestock","OtherType")
colnames(mytable) <- c("BirthControlled","Intact","Unknown.")
mytable$x=c("Bird","Cat","Dog","Livestock","OtherType")
mytable <- mytable[c("x","BirthControlled","Intact","Unknown.")]
long_mytable <- mytable %>% gather(y, Count, BirthControlled :Unknown.)
rm(mytable)

#rm(i,t,tmp,tmp2)
#mytable <- table(joinDf$Type.Intake,joinDf$Sex.Intake)
#mytable <- as.data.frame.matrix(mytable)
#rownames(mytable) <- c("I.Bird","I.Cat","I.Dog","I.Livestock","I.OtherType")
#colnames(mytable) <- c("I.IntactFemale","I.IntactMale","I.NeuteredMale","I.SpayedFemale","I.Unknown")
#mytable$x=c("I.Bird","I.Cat","I.Dog","I.Livestock","I.OtherType")
#mytable <- mytable[c("x","I.IntactFemale","I.IntactMale","I.NeuteredMale","I.SpayedFemale","I.Unknown")]
#new_mytable <- mytable %>% gather(y, Count, I.IntactFemale : I.Unknown)
#long_mytable <- rbind(long_mytable,new_mytable)
#rm(mytable)

mytable <- table(joinDf$Surgeried.Intake,joinDf$Sex.Intake)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c("BirthControlled","Intact","Unknown.")
colnames(mytable) <- c("IntactFemale","IntactMale","NeuteredMale","SpayedFemale","Unknown")
mytable$x=c("BirthControlled","Intact","Unknown.")
mytable <- mytable[c("x","IntactFemale","IntactMale","NeuteredMale","SpayedFemale","Unknown")]
new_mytable <- mytable %>% gather(y, Count, IntactFemale : Unknown)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)


mytable <- table(joinDf$Sex.Intake,joinDf$Age.Intake)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c("IntactFemale","IntactMale","NeuteredMale","SpayedFemale","Unknown")
colnames(mytable) <- c("YoungerThan1YearOld","OlderThan6YearsOld","Age_From_1-3_YearsOld","Age_From_3_6_YearsOld")
mytable$x=c("IntactFemale","IntactMale","NeuteredMale","SpayedFemale","Unknown")
mytable <- mytable[c("x","YoungerThan1YearOld","OlderThan6YearsOld","Age_From_1-3_YearsOld","Age_From_3_6_YearsOld")]
new_mytable <- mytable %>% gather(y, Count, YoungerThan1YearOld : Age_From_3_6_YearsOld)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)

mytable <- table(joinDf$Age.Intake,joinDf$Color.Intake)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c("YoungerThan1YearOld","OlderThan6YearsOld","Age_From_1-3_YearsOld","Age_From_3_6_YearsOld")
colnames(mytable) <- c("Black","BlacknWhite","Brown","BrownnWhite","OtherColor","TannWhite","White")
mytable$x=c("YoungerThan1YearOld","OlderThan6YearsOld","Age_From_1-3_YearsOld","Age_From_3_6_YearsOld")
mytable <- mytable[c("x","Black","BlacknWhite","Brown","BrownnWhite","OtherColor","TannWhite","White")]
new_mytable <- mytable %>% gather(y, Count, Black : White)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)

mytable <- table(joinDf$Color.Intake,joinDf$I)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c("Black","BlacknWhite","Brown","BrownnWhite","OtherColor","TannWhite","White")
colnames(mytable) <- c("Incoming")
mytable$x=c("Black","BlacknWhite","Brown","BrownnWhite","OtherColor","TannWhite","White")
mytable <- mytable[c("x","Incoming")]
new_mytable <- mytable %>% gather(y, Count, Incoming)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)

mytable <- table(joinDf$I,joinDf$Outcome)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c("Incoming")
colnames(mytable) <- c("Other","Adoption","Died","Disposal","Euthanasia","Missing","Relocate","ReturnToOwner","Transfer")
mytable$x=c("Incoming")
mytable <- mytable[c("x","Other","Adoption","Died","Disposal","Euthanasia","Missing","Relocate","ReturnToOwner","Transfer")]
new_mytable <- mytable %>% gather(y, Count, Other : Transfer)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)

mytable <- table(joinDf$Outcome, joinDf$O)
mytable <- as.data.frame.matrix(mytable)
colnames(mytable) <- c("Outgoing")
rownames(mytable) <- c("Other","Adoption","Died","Disposal","Euthanasia","Missing","Relocate","ReturnToOwner","Transfer")
mytable$x=c("Other","Adoption","Died","Disposal","Euthanasia","Missing","Relocate","ReturnToOwner","Transfer")
mytable <- mytable[c("x","Outgoing")]
new_mytable <- mytable %>% gather(y, Count, Outgoing)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)

mytable <- table(joinDf$O, joinDf$Age.Outcome)
mytable <- as.data.frame.matrix(mytable)
colnames(mytable) <- c(c)
rownames(mytable) <- c("Outgoing")
mytable$x=c("Outgoing")
mytable <- mytable[c("x",".YoungerThan1YearOld",".OlderThan6YearsOld",".Age_From_1-3_YearsOld",".Age_From_3_6_YearsOld")]
new_mytable <- mytable %>% gather(y, Count, .YoungerThan1YearOld : .Age_From_3_6_YearsOld)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)


#mytable <- table(joinDf$Color.Outcome,joinDf$Age.Outcome)
#mytable <- as.data.frame.matrix(mytable)
#rownames(mytable) <- c("O.Black","O.BlacknWhite","O.Brown","O.BrownnTabby","O.BrownnWhite","O.OtherColor","O.TannWhite","O.White")
#colnames(mytable) <- c("O.YoungerThan1YearOld","O.OlderThan6YearsOld","O.1to3YearsOld","O.3to6YearsOld")
#mytable$x=c("O.Black","O.BlacknWhite","O.Brown","O.BrownnTabby","O.BrownnWhite","O.OtherColor","O.TannWhite","O.White")
#mytable <- mytable[c("x","O.YoungerThan1YearOld","O.OlderThan6YearsOld","O.1to3YearsOld","O.3to6YearsOld")]
#new_mytable <- mytable %>% gather(y, Count, O.YoungerThan1YearOld : O.3to6YearsOld)
#long_mytable <- rbind(long_mytable,new_mytable)
#rm(mytable, new_mytable)

mytable <- table(joinDf$Age.Outcome,joinDf$Surgeried.Outcome)
mytable <- as.data.frame.matrix(mytable)
rownames(mytable) <- c(".YoungerThan1YearOld",".OlderThan6YearsOld",".Age_From_1-3_YearsOld",".Age_From_3_6_YearsOld")
colnames(mytable) <- c(".BirthControlled",".Intact",".Unknown.")
mytable$x=c(".YoungerThan1YearOld",".OlderThan6YearsOld",".Age_From_1-3_YearsOld",".Age_From_3_6_YearsOld")
mytable <- mytable[c("x",".BirthControlled",".Intact",".Unknown.")]
new_mytable <- mytable %>% gather(y, Count,  .BirthControlled : .Unknown.)
long_mytable <- rbind(long_mytable,new_mytable)
rm(mytable, new_mytable)

#mytable <- table(joinDf$Sex.Outcome, joinDf$Surgeried.Outcome)
#mytable <- as.data.frame.matrix(mytable)
#rownames(mytable) <- c("O.IntactFemale","O.IntactMale","O.NeuteredMale","O.SpayedFemale","O.Unknown")
#colnames(mytable) <- c("O.BirthControlled","O.Intact","O.Unknown.")
#mytable$x=c("O.IntactFemale","O.IntactMale","O.NeuteredMale","O.SpayedFemale","O.Unknown")
#mytable <- mytable[c("x","O.BirthControlled","O.Intact","O.Unknown.")]
#new_mytable <- mytable %>% gather(y, Count, O.BirthControlled : O.Unknown.)
#long_mytable <- rbind(long_mytable,new_mytable)
#rm(mytable, new_mytable)

#mytable <- table(joinDf$Surgeried.Outcome, joinDf$Type.Outcome)
#mytable <- as.data.frame.matrix(mytable)
#rownames(mytable) <- c("O.BirthControlled","O.Intact","O.Unknown.")
#colnames(mytable) <- c("O.Bird","O.Cat","O.Dog","O.Livestock","O.OtherType")
#mytable$x=c("O.BirthControlled","O.Intact","O.Unknown.")
#mytable <- mytable[c("x","O.Bird","O.Cat","O.Dog","O.Livestock","O.OtherType")]
#new_mytable <- mytable %>% gather(y, Count, O.Bird : O.OtherType)
#long_mytable <- rbind(long_mytable,new_mytable)
#rm(mytable, new_mytable)
colnames(long_mytable) <- c("source","target","value")
write.csv(long_mytable,"../data/sankeyFlow.csv",row.names = FALSE)



