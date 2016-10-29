library(dplyr)
library(ggplot2)
library(stringr)

incomingDf = read.csv('../data/Austin_Animal_Center_Intakes.csv',stringsAsFactors = FALSE)
outgoingDf = read.csv('../data/Austin_Animal_Center_Outcomes.csv',stringsAsFactors = FALSE)

incomingDf$dmy = str_c("01/",substr(incomingDf$DateTime,1,2),"/",substr(incomingDf$DateTime,7,10))
outgoingDf$dmy = str_c("01/",substr(outgoingDf$DateTime,1,2),"/",substr(outgoingDf$DateTime,7,10))

incomingOverview = incomingDf %>% group_by(dmy,Animal.Type) %>%
    summarise(count=n())
incomingOverview = as.data.frame(incomingOverview)
colnames(incomingOverview) = c("dmy","animalType","count")

outgoingOverview = outgoingDf %>% group_by(dmy,Animal.Type) %>%
    summarise(count=n())
outgoingOverview = as.data.frame(outgoingOverview)
colnames(outgoingOverview) = c("dmy","animalType","count")

dates = strptime(incomingOverview$dmy,"%d/%m/%Y")
all_data = expand.grid(dmy=unique(incomingOverview$dmy),animalType=unique(incomingOverview$animalType),stringsAsFactors = FALSE)

#fill in missing dates with 0
incomingOverview = all_data %>% left_join(incomingOverview,by=c("dmy","animalType"))
incomingOverview$count[is.na(incomingOverview$count)] = 0

outgoingOverview = all_data %>% left_join(outgoingOverview,by=c("dmy","animalType"))
outgoingOverview$count[is.na(outgoingOverview$count)] = 0

write.csv(incomingOverview,"../web/data/incomingOverview.csv",row.names = FALSE)
write.csv(outgoingOverview,"../web/data/outgoingOverview.csv",row.names = FALSE)
