library(dplyr)
library(ggplot2)
library(stringr)

incomingDf = read.csv('../data/Austin_Animal_Center_Intakes.csv',stringsAsFactors = FALSE)
outgoingDf = read.csv('../data/Austin_Animal_Center_Outcomes.csv',stringsAsFactors = FALSE)

outgoingDf = outgoingDf %>% filter(Outcome.Type == "Adoption" | Outcome.Type == "Return to Owner")

incomingDf$DateTime = as.POSIXct(strptime(incomingDf$DateTime,format="%m/%d/%Y %H:%M:%S %p"))
outgoingDf$DateTime = as.POSIXct(strptime(outgoingDf$DateTime,format="%m/%d/%Y %H:%M:%S %p"))

joinDf = incomingDf %>% inner_join(outgoingDf,by=c("Animal.ID"))
joinDf = joinDf %>% filter(DateTime.x < DateTime.y)
joinDf$diffTime = joinDf$DateTime.y - joinDf$DateTime.x
joinDf = joinDf %>% group_by(Animal.ID,DateTime.x) %>% slice(which.min(diffTime))

#show data
head(joinDf[c("Animal.ID","Animal.Type.x","diffTime","Intake.Type","Outcome.Type","Outcome.Subtype")])
head(joinDf[c("Animal.ID","DateTime.x","DateTime.y","Found.Location")])

joinDf = joinDf %>% filter(Animal.Type.x == "Dog" | Animal.Type.x == "Cat")

joinDf$diffTime = as.numeric(joinDf$diffTime,units="days")

ggplot(joinDf[which(joinDf$diffTime <= 23),],aes(x=diffTime)) + 
    geom_histogram(aes(y=..ncount..,fill=Animal.Type.x),alpha=0.9) +
    scale_y_continuous(labels = scales::percent) +
    facet_grid(Animal.Type.x ~ Outcome.Type)

#transform age to numeric(#years)
transformToYears <- function(x){
    strTemp = strsplit(x,"\\s+")[[1]]
    numValue = as.numeric(strTemp[1])
    if(numValue == 0){
        numValue = 1
    }
    unitValue = strTemp[2]
    if(str_detect(unitValue,"year") ){
        return(numValue)
    }else if(str_detect(unitValue,"month")){
        return(1)
    }
    return(1)
}

joinDf$age = as.numeric(sapply(joinDf$Age.upon.Intake,transformToYears))

#=====

# The time it takes(days) for dog/cat until their owners took them back VS. animalAge(years) upon intake

showDf = joinDf %>% filter(Outcome.Type == "Return to Owner")

ggplot(showDf,aes(age,diffTime)) + 
    geom_point() + 
    facet_grid(Animal.Type.x ~ .)

intakeAgeDiffDf = showDf %>% group_by(age,Animal.Type.x) %>% 
    summarise(medianDiffTime = median(diffTime),count=n())

ggplot(intakeAgeDiffDf,aes(age,medianDiffTime)) + 
    geom_line() + 
    facet_grid(Animal.Type.x ~ .)

colnames(intakeAgeDiffDf) = c("age","animalType","stayDuration","count")
write.csv(intakeAgeDiffDf,"../web/data/dog_cat_stay_vs_age_return_to_owner.csv",row.names = FALSE)

#=====

# The time it takes(days) for dog/cat until they got adopted VS. animalAge(years) upon intake

showDf = joinDf %>% filter(Outcome.Type == "Adoption")

ggplot(showDf,aes(age,diffTime)) + 
    geom_point() + 
    facet_grid(Animal.Type.x ~ .)

intakeAgeDiffDf = showDf %>% group_by(age,Animal.Type.x) %>% 
    summarise(medianDiffTime = median(diffTime),count=n())

ggplot(intakeAgeDiffDf,aes(age,medianDiffTime)) + 
    geom_line() + 
    facet_grid(Animal.Type.x ~ .)

colnames(intakeAgeDiffDf) = c("age","animalType","stayDuration","count")
write.csv(intakeAgeDiffDf,"../web/data/dog_cat_stay_vs_age_adoption.csv",row.names = FALSE)

#=====

#mapping Intake.Type to Outcome.Type

joinDf = incomingDf %>% left_join(outgoingDf,by=c("Animal.ID"))
joinDf = joinDf %>% filter(DateTime.x < DateTime.y | is.na(DateTime.y))
joinDf[which(is.na(joinDf$DateTime.y)),"Outcome.Type"] = "Staying"
ratioData = joinDf %>% group_by(Intake.Type,Outcome.Type) %>% summarise(count = n())
ratioGroupByIntake = ratioData %>% group_by(Intake.Type) %>% summarise(total = sum(count))
ratioData = ratioData %>% inner_join(ratioGroupByIntake,by = c("Intake.Type"))
ratioData$PercentInGroup = ratioData$count * 100 / ratioData$total


