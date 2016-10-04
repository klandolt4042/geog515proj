#make

#make NDVI function for NAIP imagery
NDVI <- function(input, out){
  if(missing(input)){
    stop("Please provide input")}
  if(missing(out)){
    stop("Please provide output")}
  o_dir <- "E:\\OTB-5.6.1-win64\\OTB-5.6.1-win64\\bin\\otbcli_RadiometricIndices"
  system(paste(o_dir, "-in", input, "-out", out, "-channels.red", 1, "-channels.nir", 4, "-list Vegetation:NDVI", "-ram 3000",sep=" "))
}
# NDVI(input = "E://geog515//naip_tiffs//m_2909401_ne_15_1_20141015_20141201.tif", out = "E://geog515//processed//testndvi.tif")

#make merge bands function to merge R,G,B,NIR, and NDVI
mergeBands <- function(tif, ndvi, out){
  if(missing(tif)){
    stop("")}
  if(missing(ndvi)){
    stop("")}
  if(missing(out)){
    stop("")}
  o_dir <- "E:\\OTB-5.6.1-win64\\OTB-5.6.1-win64\\bin\\otbcli_ConcatenateImages"
  system(paste(o_dir, "-il", tif, ndvi, "-out", out,"-ram 3000", sep = " "))
}

#Large-Scale Mean Shift (LSMS) segmentation
#Step 1: mean shift smoothing 
meanShiftSmoothing <- function(input, fout, foutpos, ranger, spatialr, maxiter, modesearch){
  if(missing(input)){
    stop("Please provide input")}
  if(missing(foutpos)){
    stop("Please provide output")}
  if(missing(fout)){
    stop("Please provide output")}
  if(missing(ranger)){
    ranger <- 30}
  if(missing(spatialr)){
    spatialr <- 5}
  if(missing(maxiter)){
    maxiter <- 10}
  if(missing(modesearch)){
    modesearch <- 0}
  o_dir <- "E:\\OTB-5.6.1-win64\\OTB-5.6.1-win64\\bin\\otbcli_MeanShiftSmoothing"
  system(paste(o_dir, "-in", input, "-fout", fout, "-foutpos", foutpos, "-ranger", ranger, "-spatialr", spatialr, "-maxiter", maxiter, "-modesearch", modesearch, "-ram 3000", sep=" "))
}

#example
# meanShiftSmoothing(input = "E://geog515//naip_tiffs//m_2909401_ne_15_1_20141015_20141201.tif", fout = "E://geog515//processed//filtered_range.tif")

#step two: segmentation
LSMSSegmentation <- function(input, inpos, out, ranger, spatialr, minsize, tilesizex, tilesizey){
  if(missing(input)){
    stop("Please provide input")}
  if(missing(inpos)){
    stop("Please provide input")}
  if(missing(out)){
    stop("Please provide output")} 
  if(missing(ranger)){
    ranger <- 30}
  if(missing(spatialr)){
    spatialr <- 5}
  if(missing(minsize)){
    minsize <- 0}
  if(missing(tilesizex)){
    tilesizex <- 256}
  if(missing(tilesizey)){
    tilesizey <- 256}
  o_dir <- "E:\\OTB-5.6.1-win64\\OTB-5.6.1-win64\\bin\\otbcli_LSMSSegmentation"
  system(paste(o_dir, "-in", input, "-inpos", inpos, "-out", out, "uint32", "-ranger", ranger, 
               "-spatialr", spatialr, "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}

#example
# LSMSSegmentation(input = "/Volumes/geo_mac/fout.tif", inpos = "/Volumes/geo_mac/foutpos.tif", out = "/Volumes/geo_mac/seg.tif")

#step three: small regions merging
#NOTE: not used because I want to delineate indivial trees if possible
LSMSSmallRegionsMerging <- function(input, inseg, out, minsize, tilesizex, tilesizey){
  if(missing(input)){
    stop("Please provide input")}
  if(missing(inseg)){
    stop("Please provide input")}
  if(missing(out)){
    stop("Please provide output")}
  if(missing(minsize)){
    minsize <- 10}
  if(missing(tilesizex)){
    tilesizex <- 256}
  if(missing(tilesizey)){
    tilesizey <- 256}
  o_dir <- "E:\\OTB-5.6.1-win64\\OTB-5.6.1-win64\\bin\\otbcli_LSMSSmallRegionsMerging"
  system(paste(o_dir, "-in", input, "-inseg", inseg, "-out", out, "unint32", "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, "-ram 1536", sep=" "))
}

#example
# LSMSSmallRegionsMerging(input = "/Volumes/geo_mac/fout.tif", inseg = "/Volumes/geo_mac/seg.tif", out = "/Volumes/geo_mac/seg_merg.tif", tilesizex = 256, tilesizey = 256)

#step four: Vectorization
LSMSVectorization <- function(input, inseg, outshp, tilesizex, tilesizey){
  if(missing(input)){
    stop("Pleaes provide input image")}
  if(missing(inseg)){
    stop("Please provide input segment")}
  if(missing(outshp)){
    stop("Please provide output")}
  if(missing(tilesizex)){
    tilesizex <- 256}
  if(missing(tilesizey)){
    tilesizey <- 256}
  o_dir <- "E:\\OTB-5.6.1-win64\\OTB-5.6.1-win64\\bin\\otbcli_LSMSVectorization"
  system(paste(o_dir, "-in", input, "-inseg", inseg, "-out", outshp, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}

#list of geotifs
myfilenames <- list.files("E:\\geog515\\naip_tiffs\\", pattern=".tif$")
myfiles <- list.files("E:\\geog515\\naip_tiffs\\", pattern=".tif$", full.names=TRUE)

#list of directories
tmpdir <- "E:\\geog515\\processed\\"
vectdir <- "D:\\processed\\vectors\\"

#loop through functions, make vector output, delete temporary files
#approximately 90 hours of run time
#total temporary files take approximately 543 gb
for (i in 1:length(myfiles)){
  NDVI(input = myfiles[[i]], out = paste0(tmpdir, "ndvi", i, ".tif"))
  mergeBands(tif = myfiles[[i]], ndvi = paste0(tmpdir, "ndvi", i, ".tif"), out = paste0(tmpdir, "merge", i, ".tif"))
  meanShiftSmoothing(input = paste0(tmpdir, "merge", i, ".tif"), fout = paste0(tmpdir, "range", i, ".tif"), foutpos = paste0(tmpdir, "spatial", i, ".tif"))
  LSMSSegmentation(input = paste0(tmpdir, "range", i, ".tif"), inpos = paste0(tmpdir, "spatial", i, ".tif"), out = paste0(tmpdir, "seg", i, ".tif"))
  LSMSVectorization(input = myfiles[[i]], inseg = paste0(tmpdir, "seg", i, ".tif"), outshp = paste0(vectdir, "segfinal", i, ".shp"))
  file.remove(paste0(tmpdir, "ndvi", i, ".tif"))
  file.remove(paste0(tmpdir, "range", i, ".tif"))
  file.remove(paste0(tmpdir, "spatial", i, ".tif"))
  file.remove(paste0(tmpdir, "seg", i, ".tif"))
  file.remove(paste0(tmpdir, "merge", i, ".tif"))
}



