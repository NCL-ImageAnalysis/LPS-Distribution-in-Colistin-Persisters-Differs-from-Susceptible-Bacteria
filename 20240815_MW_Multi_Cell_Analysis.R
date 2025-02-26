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


#calculation of number of nearest neighbours

data1<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/Single_Datapoint_Files/RBPB_no colistin_whole image.csv",header = TRUE)


##This portion splits the data into individual cells based on their XY coordinate information
##Imaging a box around each cell, the xStart represents the smallest X coordinate of that box, while the xEnd represents the highest X coordinate of that box
##It's then the same process for the Y axis (yStart and yEnd)
##THIS DATA FOR FILE FM464_no colistin_whole image
xStart = c(14.06,19.58,1.58,3.62,9.26,14.58,19.14,18.34,10.72) ##9 cells
yStart = c(0.54,5.28,6.8,9.76,8.72,8.4,12.9,15.82,20.16) 
xEnd = c(15.74,20.98,3.36,5.78,10.78,16.72,20.74,20.06,12.24) 
yEnd = c(1.76,6.66,7.82,10.88,9.86,10.08,14.7,17.38,21.54)

##For FM464_with colistin_whole image
xStart = c(0.88,6.5,11.5,19.52) ##4 cells
yStart = c(2.08,4.86,6.56,10.96)
xEnd = c(2.32,7.84,13.14,21.12)
yEnd = c(3.18,5.94,7.84,12.34)

##For RBPB_no colistin_whole image
xStart = c(14.3,13.74,18.48,2.42,5.78,4) ## 6 cells
yStart = c(1.04,2.98,11.14,12.02,15.94,19.92)
xEnd = c(16.08,15.3,20.16,4.16,8,5.76)
yEnd = c(2.22,4.26,12.86,13.5,17.28,21.14)

##For RBPB_with colistin_whole image
xStart = c(2.32,2.82,9.04,14.14,19.04,20,17.68,14.9,11.62,7.34,15.22) ##11 cells
yStart = c(19.14,14,9.56,8.3,5.62,6.46,12.22,13.04,12.24,18.42,16.82)
xEnd = c(3.58,4.16,10.96,16,20.46,21.92,19.14,16.32,13,8.58,17.16)
yEnd = c(20.62,15.42,10.94,9.82,6.72,8.1,13.62,14.7,13.7,19.98,18.66)


##NEW IMAGE
xStart = c(13.72,19.2,14.12,8.28,1.68,3.44,19.08,18.04,10.32)
yStart = c(0.32,4.8,8.4,8.16,6.52,9.24,12.76,15.44,19.52)
xEnd = c(16.08,21.04,17.08,10.88,3.68,6.4,21.4,20.08,12.44)
yEnd = c(2,6.8,10.24,9.92,7.88,11.44,14.76,17.76,21.8)





##This part converts the data into a readable format for doing nearest neighbour number calculations
df_sfPre <- st_as_sf(data1, coords = c("X", "Y"), remove = FALSE)


data1%>%
  ggplot(aes(x=X,y=Y,colour=as.numeric(X)))+xlab("X Coordinate")+ylab("Y Coordinate")+
  theme_classic()+
  theme(text=element_text(size=20),axis.text.x=element_text(angle=90,vjust =0.5,hjust=1))+
  scale_color_gradient(low = "#00FF00",high = "#FF0000")+
  geom_point(alpha=0.5,size=0.3)



for(v in 1:1) {
  
  ##This part subsets the data to only look at the specified cell
  df_sf <- subset(df_sfPre, X>xStart[v])
  df_sf <- subset(df_sf, X<xEnd[v])
  df_sf <- subset(df_sf, Y>yStart[v])
  df_sf <- subset(df_sf, Y<yEnd[v])
  
  
  data_neighbours<-st_join(df_sf,
                           df_sf%>%select(geometry),
                           join = st_is_within_distance,dist=0.1) %>%
    st_drop_geometry()%>%
    group_by(ID)%>% 
    summarise(no_neighbours=sum(n()))
    df_sf$num_Neighbours_0.1=paste(as.numeric(data_neighbours$no_neighbours))
  data_neighbours<-st_join(df_sf,
                             df_sf%>%select(geometry),
                             join = st_is_within_distance,dist=0.2) %>%
      st_drop_geometry()%>%
      group_by(ID)%>% 
      summarise(no_neighbours=sum(n()))
    df_sf$num_Neighbours_0.2=paste(as.numeric(data_neighbours$no_neighbours))
  data_neighbours<-st_join(df_sf,
                             df_sf%>%select(geometry),
                             join = st_is_within_distance,dist=0.3) %>%
      st_drop_geometry()%>%
      group_by(ID)%>% 
      summarise(no_neighbours=sum(n()))
    df_sf$num_Neighbours_0.3=paste(as.numeric(data_neighbours$no_neighbours))
  data_neighbours<-st_join(df_sf,
                             df_sf%>%select(geometry),
                             join = st_is_within_distance,dist=0.4) %>%
      st_drop_geometry()%>%
      group_by(ID)%>% 
      summarise(no_neighbours=sum(n()))
    df_sf$num_Neighbours_0.4=paste(as.numeric(data_neighbours$no_neighbours))
  data_neighbours<-st_join(df_sf,
                             df_sf%>%select(geometry),
                             join = st_is_within_distance,dist=0.5) %>%
      st_drop_geometry()%>%
      group_by(ID)%>% 
      summarise(no_neighbours=sum(n()))
    df_sf$num_Neighbours_0.5=paste(as.numeric(data_neighbours$no_neighbours))
    
   
    
    
     
  
  df_sf%>%
    ggplot(aes(x=X,y=Y,colour=as.numeric(num_Neighbours_0.1)))+xlab("X Coordinate")+ylab("Y Coordinate")+
    theme_classic()+
    theme(text=element_text(size=20),axis.text.x=element_text(angle=90,vjust =0.5,hjust=1))+
    scale_color_gradient(low = "#00FF00",high = "#FF0000")+
    geom_point(alpha=0.5,size=0.3)
  
  # think about what further analysis required 
  
  
  
  ##Finds the 5 closest neighbours for each spot and records the distances measured
  distancesPre <- df_sf%>%
      st_distance(
        df_sf$geometry,
        by_element = FALSE,
        which = "Euclidean",
        par = 0,
        tolerance = 0)
  
  distances <- as.data.frame(distancesPre)
  distances[distances == 0] <- 100000
  distancesMin <- distances
  distancesMin$MinimumValue1 = ""
  distancesMin$MinimumValue2 = ""
  distancesMin$MinimumValue3 = ""
  distancesMin$MinimumValue4 = ""
  distancesMin$MinimumValue5 = ""
  distancesMin$MeanDistance = ""
  for(i in 1:ncol(distances)) {
    distTemp = as.data.frame(distancesMin[, i])
    mindist1 = as.numeric(min(distTemp));
    distTemp[distTemp == mindist1] <- 10000
    mindist2 = as.numeric(min(distTemp));
    distTemp[distTemp == mindist2] <- 10000
    mindist3 = as.numeric(min(distTemp));
    distTemp[distTemp == mindist3] <- 10000
    mindist4 = as.numeric(min(distTemp));
    distTemp[distTemp == mindist4] <- 10000
    mindist5 = as.numeric(min(distTemp));
    distTemp[distTemp == mindist5] <- 10000
    distancesMin[i,ncol(distances)+1] = mindist1;
    distancesMin[i,ncol(distances)+2] = mindist2;
    distancesMin[i,ncol(distances)+3] = mindist3;
    distancesMin[i,ncol(distances)+4] = mindist4;
    distancesMin[i,ncol(distances)+5] = mindist5;
    distancesMin[i,ncol(distances)+6] = (mindist1+mindist2+mindist3+mindist4+mindist5)/5;
    print(i);
  }

  
  
  
  
  dg <- data.frame(distancesMin$MinimumValue1)
  
  dg$X=paste(as.numeric(df_sf$X))
  dg$Y=paste(as.numeric(df_sf$Y))
  dg$Num_Neighbours_0.1=paste(as.numeric(df_sf$num_Neighbours_0.1))
  dg$Num_Neighbours_0.1=paste(as.numeric(df_sf$num_Neighbours_0.1))
  dg$Num_Neighbours_0.2=paste(as.numeric(df_sf$num_Neighbours_0.2))
  dg$Num_Neighbours_0.3=paste(as.numeric(df_sf$num_Neighbours_0.3))
  dg$Num_Neighbours_0.4=paste(as.numeric(df_sf$num_Neighbours_0.4))
  dg$Num_Neighbours_0.5=paste(as.numeric(df_sf$num_Neighbours_0.5))
  dg$MinimumDistance1=as.numeric(distancesMin$MinimumValue1)
  dg$MinimumDistance2=as.numeric(distancesMin$MinimumValue2)
  dg$MinimumDistance3=as.numeric(distancesMin$MinimumValue3)
  dg$MinimumDistance4=as.numeric(distancesMin$MinimumValue4)
  dg$MinimumDistance5=as.numeric(distancesMin$MinimumValue5)
  dg$MeanDistance=(dg$MinimumDistance1 + dg$MinimumDistance2 + dg$MinimumDistance3 + dg$MinimumDistance4 + dg$MinimumDistance5)/5
  
  image_Name = paste("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/Output_Analysis_Folder/RBPB_no colistin_whole image Cell_", v, ".csv");
  
  write.csv(dg, image_Name, row.names=FALSE)
  gc()
}




##Gets all the files from a folder, saves as a collated file. Manually check and adapt as needed before continuing with statistical analysis
file_names <- dir("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/Output_Analysis_Folder/",full.names = TRUE) 
dData <- do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x), name=strsplit(x,'\\.')[[1]][1])))

image_Name = "Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/Output_Analysis_Folder/Collated_Dataset.csv";
write.csv(dData, image_Name, row.names=FALSE)



##Reads the collated adapted dataset for graphing and statistics
colData<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/Output_Analysis_Folder/Collated_Dataset.csv",header = TRUE)

colData$nameMod <- sapply(strsplit(as.character(colData$name), split = "/"), `[`, 7)
colData$imgName <- sapply(strsplit(as.character(colData$nameMod), split = "Cell_ "), `[`, 1)

df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_Neighbours = median(MinimumDistance1))


colData %>%
  group_by(imgName) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = imgName, y = MinimumDistance1, color = imgName)) +
  xlab("imgName") + ylab("Distance to Closest Neighbour") +
  theme_classic() +
  ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.1, size = 0.5)

df %>%
  group_by(imgName) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = imgName, y = mean_Neighbours, color = imgName)) +
  xlab("imgName") + ylab("Median Distance to Nearest Neighbour") +
  theme_classic() +
  ylim(0, 0.01) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 1, size = 5)


##Performs the Statistical Testing on the Neighbour Analysis
pairwise.wilcox.test(colData$Num_Neighbours_0.1, colData$imgName,
                     p.adjust.method = "bonferroni")
pairwise.wilcox.test(colData$Num_Neighbours_0.2, colData$imgName,
                     p.adjust.method = "bonferroni")
pairwise.wilcox.test(colData$Num_Neighbours_0.3, colData$imgName,
                     p.adjust.method = "bonferroni")
pairwise.wilcox.test(colData$Num_Neighbours_0.4, colData$imgName,
                     p.adjust.method = "bonferroni")
pairwise.wilcox.test(colData$Num_Neighbours_0.5, colData$imgName,
                     p.adjust.method = "bonferroni")

pairwise.wilcox.test(colData$MeanDistance, colData$imgName,
                     p.adjust.method = "bonferroni")
pairwise.wilcox.test(colData$MinimumDistance1, colData$imgName,
                     p.adjust.method = "bonferroni")


df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_Neighbours_0.1 = median(Num_Neighbours_0.1))
pairwise.wilcox.test(df$mean_Neighbours_0.1, df$imgName,
                     p.adjust.method = "bonferroni")
df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_Neighbours_0.2 = median(Num_Neighbours_0.2))
pairwise.wilcox.test(df$mean_Neighbours_0.2, df$imgName,
                     p.adjust.method = "bonferroni")
df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_Neighbours_0.3 = median(Num_Neighbours_0.3))
pairwise.wilcox.test(df$mean_Neighbours_0.3, df$imgName,
                     p.adjust.method = "bonferroni")
df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_Neighbours_0.4 = median(Num_Neighbours_0.4))
pairwise.wilcox.test(df$mean_Neighbours_0.4, df$imgName,
                     p.adjust.method = "bonferroni")
df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_Neighbours_0.5 = median(Num_Neighbours_0.5))
pairwise.wilcox.test(df$mean_Neighbours_0.5, df$imgName,
                     p.adjust.method = "bonferroni")

df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_MeanDistance = median(MeanDistance))
pairwise.wilcox.test(df$mean_MeanDistance, df$imgName,
                     p.adjust.method = "bonferroni")
df <- colData %>%
  group_by(nameMod, imgName) %>%
  summarise(mean_MinimumDistance1 = median(MinimumDistance1))
pairwise.wilcox.test(df$mean_MinimumDistance1, df$imgName,
                     p.adjust.method = "bonferroni")






##Parametric Alternatives, not recommended due to nature of data
pairwise.t.test(colData$Num_Neighbours_0.1, colData$imgName, p.adjust.method = "bonferroni")
pairwise.t.test(colData$Num_Neighbours_0.2, colData$imgName, p.adjust.method = "bonferroni")
pairwise.t.test(colData$Num_Neighbours_0.3, colData$imgName, p.adjust.method = "bonferroni")
pairwise.t.test(colData$Num_Neighbours_0.4, colData$imgName, p.adjust.method = "bonferroni")
pairwise.t.test(colData$Num_Neighbours_0.5, colData$imgName, p.adjust.method = "bonferroni")

pairwise.t.test(colData$MeanDistance, colData$imgName, p.adjust.method = "bonferroni")
pairwise.t.test(colData$MinimumDistance1, colData$imgName, p.adjust.method = "bonferroni")



##Reads the collated adapted dataset for graphing and statistics
colData<-read.csv("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/Output_Analysis_Folder/Collated_Dataset.csv",header = TRUE)

colData$nameMod <- sapply(strsplit(as.character(colData$name), split = "/"), `[`, 7)
colData$imgName <- sapply(strsplit(as.character(colData$nameMod), split = "Cell_ "), `[`, 1)
colData$cellNum <- sapply(strsplit(as.character(colData$nameMod), split = "Cell_ "), `[`, 2)

colDataMod <- subset(colData, imgName == "RBPB_no colistin_whole image ")

colDataMod %>%
  group_by(imgName) %>%
  ##summarise(mean_score = mean(PerArea)) %>%
  ggplot(aes(x = X, y = Y, color = Num_Neighbours_0.1)) +
  xlab("X") + ylab("Y") +
  theme_classic() +
  ##ylim(0, 0.02) +
  theme(text = element_text(size=10), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##scale_color_gradient(low="#648FFF", high="#FFB000") +
  ##theme(legend.position = "none") +
  geom_jitter(alpha = 0.1, size = 0.5)


##Put the image name exactly how it appears in the title
imageNameArray = c("FM464_no colistin_whole image ", "FM464_with colistin_whole image ", "RBPB_no colistin_whole image ", "RBPB_with colistin_whole image ")

##Put the number of cells in each image here, in the same order as the images are listed above
cellNumber = c(9, 4, 6, 11)

for(v in 1:4) {
  
  imageName = imageNameArray[v]
  colDataMod <- subset(colData, imgName == imageName)
  cellNumberMax = cellNumber[v]
  
  for(x in 1:cellNumberMax) {
    cellString = paste(x, "")
    colDataCell <- subset(colDataMod, cellNum == cellString)
    
    minimumX = min(colDataCell$X)
    maximumX = max(colDataCell$X)
    minimumY = min(colDataCell$Y)
    maximumY = max(colDataCell$Y)

    Sizex = maximumX - minimumX;
    Sizey = maximumY - minimumY;


    colDataCell %>%
      group_by(imgName) %>%
      ##summarise(mean_score = mean(PerArea)) %>%
      ggplot(aes(x = X, y = Y, color = Num_Neighbours_0.1, fill = Num_Neighbours_0.1)) +
      ##xlab("X") + ylab("Y") +
      theme_classic() +
      ##ylim(0, 0.02) +
      theme(text = element_text(size=-1), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      scale_color_gradient(low="white", high="black") +
      scale_fill_gradient(low="white", high="black") +
      ##scale_color_gradient(low="#648FFF", high="#FFB000") +
      theme(legend.position = "none") +
      geom_point(alpha = 0.3, size = 5)
    saveName = paste("Y:/Bioimaging_Staff/George/20240814_Mandy_Wang_STORM/Full_Image_Trialling/RStudio_Cluster_Image_Outputs/", imageName, "Cell_", x, ".png")
    ggsave(width = Sizex*10, height = Sizey*10, saveName)
  }
}

