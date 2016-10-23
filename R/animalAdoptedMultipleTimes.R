#this script join incoming and outgoin data to look for animals that were adopted multiple times

library(dplyr)
library(ggplot2)
library(stringr)

#cutoff value
numIntake = 5
incomingDf = read.csv('../data/Austin_Animal_Center_Intakes.csv',stringsAsFactors = FALSE)
outgoingDf = read.csv('../data/Austin_Animal_Center_Outcomes.csv',stringsAsFactors = FALSE)

#outgoingDf = outgoingDf %>% filter(Outcome.Type == "Adoption" | Outcome.Type == "Return to Owner")

includeId = incomingDf %>% group_by(Animal.ID) %>% summarise(count=n()) %>% filter(count >= numIntake) %>% select(Animal.ID)
includeId = as.data.frame(includeId)

incomingDf = incomingDf %>% inner_join(includeId,by="Animal.ID")

incomingDf$DateTime = as.POSIXct(strptime(incomingDf$DateTime,format="%m/%d/%Y %H:%M:%S %p"))
outgoingDf$DateTime = as.POSIXct(strptime(outgoingDf$DateTime,format="%m/%d/%Y %H:%M:%S %p"))

joinDf = incomingDf %>% left_join(outgoingDf,by=c("Animal.ID"))
joinDf = joinDf %>% filter(DateTime.x < DateTime.y| is.na(DateTime.y))
joinDf$diffTime = joinDf$DateTime.y - joinDf$DateTime.x
joinDf = joinDf %>% group_by(Animal.ID,DateTime.x) %>% slice(which.min(diffTime))

#use Python script to resolve lat/long geocoding
write.csv(joinDf,"../data/animalAdoptedMultipleTimes.csv",row.names = FALSE)

#read lat/long result and join back to joinDf
latLongDf = incomingDf = read.csv('../python/mapLatLng.csv',stringsAsFactors = FALSE)
joinDf = joinDf %>% left_join(latLongDf,by=c("Found.Location"="location"))
write.csv(joinDf,"../data/animalAdoptedMultipleTimes.csv",row.names = FALSE)
