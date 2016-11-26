library(dplyr)
library(stringr)
library(tidyr)
library("ggplot2")
rm(list = ls())
setwd("~/Desktop/2016FALL/554/project/project-g2-master/R")

ReadIntakefilename="../data/Austin_Animal_Center_Intakes.csv"
dfIntake=read.csv(ReadIntakefilename,stringsAsFactors = FALSE)
dfLocation=read.csv("../data/mapLatLng.intake.csv",stringsAsFactors = FALSE)
colnames(dfLocation) <- c("Lat","Lng","Found.Location")
df = dfIntake %>% inner_join(dfLocation,by=c("Found.Location"))
df$DateTime = as.POSIXct(strptime(df$DateTime,format="%m/%d/%y %H:%M"))
df$MonthYear=NULL
df$Intake.Type=NULL
df$Intake.Condition=NULL
df$Sex.upon.Intake=NULL
df$Age.upon.Intake=NULL
df$Breed=NULL
df$Color=NULL
rm(dfIntake,dfLocation)

lngmax=-97.62
lngmin=-98.01
latmax=30.53
latmin=30.08

df <- df[df$Lat >= latmin,]
df <- df[df$Lat <= latmax,]
df <- df[df$Lng >= lngmin,]
df <- df[df$Lng <= lngmax,]

latsecN=20
lngsecN=25
width=(latmax-latmin)/latsecN
height=(lngmax-lngmin)/lngsecN

df$section=0
for (i in 1:length(df$Animal.ID))
{
  indexlat <- ceiling((df$Lat[i]-latmin)/width)
  indexlng <-ceiling((df$Lng[i]-lngmin)/height)
  df$section[i]=(indexlng-1)*latsecN+indexlat
}
  
# ggplot(df, aes(section)) + geom_histogram()
df$Found.Location=NULL
df$Name=NULL
factor(df$Animal.Type)
df$Year <- as.POSIXlt(df$DateTime)$year+1900
df$Month <- as.POSIXlt(df$DateTime)$mon
df$Hour <- as.POSIXlt(df$DateTime)$hour
df$DateTime=NULL


x=1:(latsecN*lngsecN)
xlng=(ceiling(x/latsecN)-0.5)*height+lngmin
xlat=((x-1)%%latsecN+0.5)*width+latmin
long_mytable <- data.frame(lat=xlat, lng=xlng)

df$section=factor(df$section,levels = 1:(latsecN*lngsecN))
mytable <- data.frame(total=table(df$section))
long_mytable <- cbind(long_mytable, mytable)
long_mytable$total.Var1=NULL
#colnames(long_mytable) <- c("lat","lng","total")

mytable <- table(df$section,df$Animal.Type)
mytable <- as.data.frame.matrix(mytable)
long_mytable <- cbind(long_mytable,mytable)

mytable <- table(df$section,df$Year)
mytable <- as.data.frame.matrix(mytable)
long_mytable <- cbind(long_mytable,mytable)

mytable <- table(df$section,df$Month)
mytable <- as.data.frame.matrix(mytable)
long_mytable <- cbind(long_mytable,mytable)

mytable <- table(df$section,df$Hour)
mytable <- as.data.frame.matrix(mytable)
long_mytable <- cbind(long_mytable,mytable)
colnames(long_mytable) <- c("lat","lng","total","bird","cat","dog","livestock","other","year2013","year2014","year2015","year2016","Jan","Feb","Mar","Apr","May","June","July","Aug","Sep","Oct","Nov","Dec","hour0","hour1","hour2","hour3","hour4","hour5","hour6","hour7","hour8","hour9","hour10","hour11","hour12","hour13","hour14","hour15","hour16","hour17","hour18","hour19","hour20","hour21","hour22","hour23")

long_mytable <- long_mytable[long_mytable$lat <= 30.41197,]
long_mytable <- long_mytable[long_mytable$lat >= 30.17897,]
long_mytable <- long_mytable[long_mytable$lng >= -97.93007,]
long_mytable <- long_mytable[long_mytable$lng <= -97.64854,]

result=data.frame()
for (i in 1:length(long_mytable$lat)){
  if (!(long_mytable$lng[i] >= -97.78587) & (long_mytable$lat[i] >= 30.27745)){}
  else
  {
    result <- rbind(result,long_mytable[i,])
  }
}

write.csv(result,"../data/foundlocation.csv",row.names = FALSE)



