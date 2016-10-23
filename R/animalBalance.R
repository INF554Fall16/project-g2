library(dplyr)
library(ggplot2)
library(stringr)

incomingDf = read.csv('../data/Austin_Animal_Center_Intakes.csv',stringsAsFactors = FALSE)
outgoingDf = read.csv('../data/Austin_Animal_Center_Outcomes.csv',stringsAsFactors = FALSE)

incomingDf$DateTime = as.POSIXct(strptime(incomingDf$DateTime,format="%m/%d/%Y %H:%M:%S %p"))
outgoingDf$DateTime = as.POSIXct(strptime(outgoingDf$DateTime,format="%m/%d/%Y %H:%M:%S %p"))

joinDf = incomingDf %>% left_join(outgoingDf,by=c("Animal.ID"))
joinDf = joinDf %>% filter(DateTime.x < DateTime.y | is.na(DateTime.y))
joinDf[which(is.na(joinDf$DateTime.y)),"Outcome.Type"] = "Staying"

beginQuarters = c("2014-01-01 00:00:00","2014-04-01 00:00:00","2014-07-01 00:00:00","2014-10-01 00:00:00",
                 "2015-01-01 00:00:00","2015-04-01 00:00:00","2015-07-01 00:00:00","2015-10-01 00:00:00",
                 "2016-01-01 00:00:00","2016-04-01 00:00:00","2016-07-01 00:00:00","2016-10-01 00:00:00"
                 )

collectData = data.frame(beginQuarter=character(),animalType=character(),count=numeric())

for(beginQuarter in beginQuarters){
    balanceData = joinDf %>% filter(DateTime.x <= beginQuarter & ( Outcome.Type == "Staying" | DateTime.y >= beginQuarter ))
    balanceData = balanceData %>% group_by(Animal.Type.x) %>% summarise(count=n())
    balanceData$beginQuarter = beginQuarter
    balanceData = balanceData[c("beginQuarter","Animal.Type.x","count")]
    colnames(balanceData) = c("beginQuarter","animalType","count")
    collectData = rbind(collectData,balanceData)
}

groupByQuarter = collectData %>% group_by(beginQuarter) %>% summarise(total=sum(count))
collectData = collectData %>% left_join(groupByQuarter,by=c("beginQuarter")) %>% mutate(count_percent = count * 100 / total)
ggplot(collectData,aes(x=factor(beginQuarter),y=count)) +
    geom_bar(stat="identity",aes(fill=animalType))
ggplot(collectData,aes(x=factor(beginQuarter),y=count_percent)) +
    geom_bar(stat="identity",aes(fill=animalType))
