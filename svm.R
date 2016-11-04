#load libraries
library(raster)


source("/Users/lando/Dropbox/Fall2016/GEOG515/project/orfeo.R")

my.files <- list.files("/Volumes/geo_mac/naip_tiffs/", pattern=".tif$", full.names = TRUE)
my.rasts <- lapply(my.files,stack)

#naip <- raster("/Users/lando/Dropbox/Fall2016/GEOG515/data/mos_class_fin.tif")
#writeRaster(naip, filename = "/Users/lando/Dropbox/Fall2016/GEOG515/data/mos_class1.tif", datatype="INT1U", format="GTiff")

naip <- raster("/Users/lando/Dropbox/Fall2016/GEOG515/data/mos_class1.tif")

#0 is Canopy
#1 is Urban
#2 is Water
#3 is Grass
#4 is Shadow




#focal(naip, w=matrix(1,3,3), fun=modal, filename="/Volumes/geo_mac/svm/smooth.tif")
#writeRaster(my.smooth, filename = "/Volumes/geo_mac/svm/smooth.tif", format="GTiff", overwrite=TRUE)

#SDMtools
rm(my.smooth)

