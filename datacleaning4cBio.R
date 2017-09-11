rm(list=ls())
library(readxl)
df<- read_excel("D:/bioinformatics/emory/cmp26_synoptic_dump.20170726.xlsx",sheet = 1)
df1<- read_excel("D:/bioinformatics/emory/cmp26_synoptic_dump.20170726.xlsx",sheet = 2)
data<- merge(df,df1,by="SYN_CASE_SAID")
data<-as.data.frame(data)
data1<-data[data[,11]%in%c("TP53"),]
library(data.table)
data2<-data1[data1$PRIMARY_TUMOR_TYPE%like% c("Lung"),]
str(data)
data2<-data2[c(2,4,8,9,11,12)]
write.csv(data2, "D:/bioinformatics/emory/emoryp53.csv", row.names = F)
set.seed(20)
p53emory<- read.csv("D:/bioinformatics/emory/p53lung.csv",header = T)
#p53oemory<- p53emory[order(p53emory[,6]),]
library(ggplot2)
require(scales)
ggplot(data=p53emory)+geom_bar(mapping=aes(x=Domain,color=Domain))
ggplot(data=p53emory)+geom_bar(mapping=aes(x=Domain,fill=Domain))
ggplot(data=p53emory, aes(x = Domain,color=Domain,fill=Domain) )+  
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent)


library(cgdsr)
mycgds <- CGDS("http://www.cbioportal.org/public-portal/")
mycancerstudy <- getCancerStudies(mycgds)[80,1]
mycaselist<- getCaseLists(mycgds,mycancerstudy)[1,1]
mygeneticprofile <-getGeneticProfiles(mycgds,mycancerstudy)[2,1]
getProfileData(mycgds,c('TP53'), mygeneticprofile, mycaselist)
myclinicaldata = getClinicalData(mycgds,mycaselist)
library(dplyr)
p53cbio<-read.table("D:/bioinformatics/emory/T53cbio.csv", sep=',',header= T)
P53cbiom<-mutate(p53cbio,aminochange=sub('.', '',p53cbio$AA.change))
p53cbiosorted<-P53cbiom[order(P53cbiom$aminochange),]
write.csv(p53cbiosorted, "D:/bioinformatics/emory/p53cbio.csv", row.names = F)

p53cBio<- read.csv("D:/bioinformatics/emory/p53cbio.csv",header = T)
library(ggplot2)
require(scales)
ggplot(data=p53cBio)+geom_bar(mapping=aes(x=Domain,color=Domain))
ggplot(data=p53cBio)+geom_bar(mapping=aes(x=Domain,fill=Domain))
ggplot(data=p53cBio, aes(x = Domain,color=Domain,fill=Domain) )+  
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels = percent)


