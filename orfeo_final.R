myfiles <- list.files("D:/final_scratch/raw/", pattern=".tif$", full.names = TRUE)
tmpdir <- "D:/final_scratch/tmp/"
vectdir <- "D:/final_scratch/vect/"

if (length("D:/final_scratch/vect/")==0){
for (i in 1:length(myfiles)){
  NDVI(input = myfiles[[i]], out = paste0(tmpdir, "ndvi", i, ".tif"))
  Scale255(input = paste0(tmpdir, "ndvi", i, ".tif"), output = paste0(tmpdir, "ndviscale", i, ".tif"))
  
  
  HaralickTextureExtration(input = paste0(tmpdir, "ndviscale", i, ".tif"), output = paste0(tmpdir, "text", i, ".tif"))
  Scale255(input = paste0(tmpdir, "text", i, ".tif"), output = paste0(tmpdir, "textscale", i, ".tif"))
  
  BandSplit(input = paste0(tmpdir, "textscale", i, ".tif"), output = paste0(tmpdir, "textscale", i, "band", ".tif"))
  
  
  mergeBands(layer.1 = paste0(tmpdir, "ndviscale", i, ".tif"), layer.2 = paste0(tmpdir, "textscale", i, "band_7.tif"), out = paste0(tmpdir, "merge", i, ".tif"))
  meanShiftSmoothing(input = paste0(tmpdir, "merge", i, ".tif"), fout = paste0(tmpdir, "range", i, ".tif"), foutpos = paste0(tmpdir, "spatial", i, ".tif"), ranger = 30, spatialr = 5)
  LSMSSegmentation(input = paste0(tmpdir, "range", i, ".tif"), inpos = paste0(tmpdir, "spatial", i, ".tif"), out = paste0(tmpdir, "seg", i, ".tif"), ranger = 30, spatialr = 5)
  LSMSVectorization(input = myfiles[[i]], inseg = paste0(tmpdir, "seg", i, ".tif"), outshp = paste0(vectdir, "segfinal", i, ".shp"))
}}

for (i in 1:length(myfiles)){

  mergeBands(layer.1 = paste0(tmpdir, "ndviscale", i, ".tif"), layer.2 = paste0(tmpdir, "textscale", i, "band_7.tif"), out = paste0(tmpdir, "merge", i, ".tif"))
  meanShiftSmoothing(input = paste0(tmpdir, "merge", i, ".tif"), fout = paste0(tmpdir, "range", i, ".tif"), foutpos = paste0(tmpdir, "spatial", i, ".tif"), ranger = 30, spatialr = 5)
  LSMSSegmentation(input = paste0(tmpdir, "range", i, ".tif"), inpos = paste0(tmpdir, "spatial", i, ".tif"), out = paste0(tmpdir, "seg", i, ".tif"), ranger = 30, spatialr = 5)
  LSMSVectorization(input = myfiles[[i]], inseg = paste0(tmpdir, "seg", i, ".tif"), outshp = paste0(vectdir, "segfinal", i, ".shp"))
}
