##Essential Packages
install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")
install.packages("sf")
install.packages("spdep")
install.packages("RANN")

library(ggplot2)
library(dplyr)
library(readr)
library(RANN)
library(spdep)
library(sf)
library(FSA)
library(tidyr)

##Gets all the files from a folder, saves as a collated file. Manually check and adapt as needed before continuing with statistical analysis
file_names <- dir("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/1655/CSV_Files/",full.names = TRUE) 
spots <- do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x), name=strsplit(x,'\\.')[[1]][1])))

##spots<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/1655/1655_collated_Dataset.csv",header = TRUE)


membranePoints<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/1655/Mandy_Wang_Membrane_Coordinates.csv",header = TRUE)


##MAKE SO MATCHING BASED ON IMAGE IS POSSIBLE
membranePoints$membraneImg = sapply(strsplit(as.character(membranePoints$Image_Name), split = ".zip"), `[`, 1)


##CONVERT MEMBRANE POINTS TO MICRONS
membranePoints$xCoordMicron <- membranePoints$XCoord*0.02
membranePoints$yCoordMicron <- membranePoints$YCoord*0.02

xList <- membranePoints$xCoordMicron
xList <- membranePoints$xCoordMicron


##MAKE SO MATCHING BASED ON IMAGE IS POSSIBLE
spots$fileName = sapply(strsplit(as.character(spots$name), split = "/"), `[`, 8)




##Finds the number of spots along the membrane within certain threshold boxes

membranePoints$spotCount10 <- paste(0)
for(i in 1:nrow(membranePoints)){
  imgName = membranePoints[i, 7]
  xCoord = membranePoints[i, 8]
  yCoord = membranePoints[i, 9]
  colDataMod <- subset(spots, fileName == imgName)
  colDataMod <- subset(colDataMod, X>xCoord-0.01)
  colDataMod <- subset(colDataMod, X<xCoord+0.01)
  colDataMod <- subset(colDataMod, Y>yCoord-0.01)
  colDataMod <- subset(colDataMod, Y<yCoord+0.01)
  membranePoints[i, 10] <- nrow(colDataMod)
}

membranePoints$spotCount20 <- paste(0)
for(i in 1:nrow(membranePoints)){
  imgName = membranePoints[i, 7]
  xCoord = membranePoints[i, 8]
  yCoord = membranePoints[i, 9]
  colDataMod <- subset(spots, fileName == imgName)
  colDataMod <- subset(colDataMod, X>xCoord-0.02)
  colDataMod <- subset(colDataMod, X<xCoord+0.02)
  colDataMod <- subset(colDataMod, Y>yCoord-0.02)
  colDataMod <- subset(colDataMod, Y<yCoord+0.02)
  membranePoints[i, 11] <- nrow(colDataMod)
}

membranePoints$spotCount50 <- paste(0)
for(i in 1:nrow(membranePoints)){
  imgName = membranePoints[i, 7]
  xCoord = membranePoints[i, 8]
  yCoord = membranePoints[i, 9]
  colDataMod <- subset(spots, fileName == imgName)
  colDataMod <- subset(colDataMod, X>xCoord-0.05)
  colDataMod <- subset(colDataMod, X<xCoord+0.05)
  colDataMod <- subset(colDataMod, Y>yCoord-0.05)
  colDataMod <- subset(colDataMod, Y<yCoord+0.05)
  membranePoints[i, 12] <- nrow(colDataMod)
}

membranePoints$spotCount100 <- paste(0)
for(i in 1:nrow(membranePoints)){
  imgName = membranePoints[i, 7]
  xCoord = membranePoints[i, 8]
  yCoord = membranePoints[i, 9]
  colDataMod <- subset(spots, fileName == imgName)
  colDataMod <- subset(colDataMod, X>xCoord-0.1)
  colDataMod <- subset(colDataMod, X<xCoord+0.1)
  colDataMod <- subset(colDataMod, Y>yCoord-0.1)
  colDataMod <- subset(colDataMod, Y<yCoord+0.1)
  membranePoints[i, 13] <- nrow(colDataMod)
}




##SAVE THE DATA 
image_Name = "Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/1655/Membrane_Analysis_Spot_Count.csv";
write.csv(membranePoints, image_Name, row.names=FALSE)

##Reads the data if it's already been saved
membranePoints<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/PA14/Membrane_Analysis_Spot_Count_PA14.csv",header = TRUE)

pairwise.wilcox.test(membranePoints$spotCount10, membranePoints$Condition,
                     p.adjust.method = "BH")


##Calculates average values for important outputs measurements
##membranePointsModCol <- membranePoints %>%
##  group_by(membraneImg, Cell) %>%
##  summarise(Mean_spotCount10 = mean(as.numeric(spotCount10)), Mean_spotCount10STD = sd(as.numeric(spotCount10), na.rm=TRUE) Mean_spotCount20 = mean(as.numeric(spotCount20)), Mean_spotCount50 = mean(as.numeric(spotCount50)), Mean_spotCount100 = mean(as.numeric(spotCount100)), Variance_spotCount10 = var(spotCount10), Variance_spotCount20 = var(spotCount20), Variance_spotCount50 = var(spotCount50), Variance_spotCount100 = var(spotCount100))


##Calculates average values for important outputs measurements
membranePointsModCol <- membranePoints %>%
  group_by(membraneImg, Cell) %>%
  summarise(Mean_spotCount10 = mean(as.numeric(spotCount10)), Mean_spotCount10STD = sd(as.numeric(spotCount10), na.rm=TRUE), Mean_spotCount20 = mean(as.numeric(spotCount20)), Mean_spotCount20STD = sd(as.numeric(spotCount20), na.rm=TRUE), Mean_spotCount50 = mean(as.numeric(spotCount50)), Mean_spotCount50STD = sd(as.numeric(spotCount50), na.rm=TRUE), Mean_spotCount100 = mean(as.numeric(spotCount100)), Mean_spotCount100STD = sd(as.numeric(spotCount100), na.rm=TRUE), Variance_spotCount10 = var(spotCount10), Variance_spotCount20 = var(spotCount20), Variance_spotCount50 = var(spotCount50), Variance_spotCount100 = var(spotCount100))

##SAVE THE DATA 
image_Name = "Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/PA14/Membrane_Analysis_Spot_Count_PA14_STD.csv";
write.csv(membranePointsModCol, image_Name, row.names=FALSE)

##Sets the save folder for all outputs
saveFolder = "Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/1655/Output_Graphs/"


##Reads the data if it's already been saved
membranePointsModCol<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/20240930_Mandy_Wang_Membrane_Analysis/1655/Membrane_Analysis_Spot_Count_1655.csv",header = TRUE)

##Groups into categories based on the image/csv names
membranePointsModCol$Condition <- ""
membranePointsModCol$Condition <- ifelse(grepl("FM464_No", membranePointsModCol$membraneImg), "FM464 No Colistin", membranePointsModCol$Condition)
membranePointsModCol$Condition <- ifelse(grepl("FM464_With", membranePointsModCol$membraneImg), "FM464 With Colistin", membranePointsModCol$Condition)
membranePointsModCol$Condition <- ifelse(grepl("RBPB_No", membranePointsModCol$membraneImg), "RBPB No Colistin", membranePointsModCol$Condition)
membranePointsModCol$Condition <- ifelse(grepl("RBPB_With", membranePointsModCol$membraneImg), "RBPB With Colistin", membranePointsModCol$Condition)

##Statisticall assesses the conditions
pairwise.wilcox.test(membranePointsModCol$spotCount10, membranePointsModCol$Condition,
                     p.adjust.method = "BH")




##Does the graphing
membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Mean_spotCount10, color = Condition)) +
  xlab("Condition") + ylab("Mean_spotCount10") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Mean_spotCount10.png")
ggsave(width = 10, height = 10, saveName)
  
membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Mean_spotCount20, color = Condition)) +
  xlab("Condition") + ylab("Mean_spotCount20") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Mean_spotCount20.png")
ggsave(width = 10, height = 10, saveName)

membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Mean_spotCount50, color = Condition)) +
  xlab("Condition") + ylab("Mean_spotCount50") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Mean_spotCount50.png")
ggsave(width = 10, height = 10, saveName)
  
membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Mean_spotCount100, color = Condition)) +
  xlab("Condition") + ylab("Mean_spotCount100") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Mean_spotCount100.png")
ggsave(width = 10, height = 10, saveName)


membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Variance_spotCount10, color = Condition)) +
  xlab("Condition") + ylab("Variance_spotCount10") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Variance_spotCount10.png")
ggsave(width = 10, height = 10, saveName)

membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Variance_spotCount20, color = Condition)) +
  xlab("Condition") + ylab("Variance_spotCount20") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Variance_spotCount20.png")
ggsave(width = 10, height = 10, saveName)

membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Variance_spotCount50, color = Condition)) +
  xlab("Condition") + ylab("Variance_spotCount10") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Variance_spotCount50.png")
ggsave(width = 10, height = 10, saveName)

membranePointsModCol %>%
  group_by(Condition) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = Condition, y = Variance_spotCount100, color = Condition)) +
  xlab("Condition") + ylab("Variance_spotCount100") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.75, size = 1)
saveName = paste(saveFolder, "_Variance_spotCount100.png")
ggsave(width = 10, height = 10, saveName)


