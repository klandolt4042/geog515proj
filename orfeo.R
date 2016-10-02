#make


NDVI <- function(input, out){
  if(missing(input)){
    stop("Please provide input")}
  if(missing(out)){
    stop("Please provide output")}
  o_dir <- "/Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_RadiometricIndices"
  system(paste(o_dir, "-in", input, "-out", out, "-channels.red", 1, "-channels.nir", 4, 
               "-list Vegetation:NDVI", sep=" "))
}


meanShiftSmoothing <- function(input, fout, foutpos, ranger, spatialr, maxiter, modesearch){
  if(missing(input)){
    stop("Please provide input")}
  if(missing(fout)){
    stop("Please provide output")}
  if(missing(foutpos)){
    stop("Please provide output")} 
   if(missing(ranger)){
    ranger <- 30}
  if(missing(spatialr)){
    spatialr <- 5}
  if(missing(maxiter)){
    maxiter <- 10}
  if(missing(modesearch)){
    modesearch <- 0}
  o_dir <- "/Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_MeanShiftSmoothing"
  system(paste(o_dir, "-in", input, "-fout", fout, "-foutpos", foutpos, "-ranger", ranger, 
                     "-spatialr", spatialr, "-maxiter", maxiter, "-modesearch", modesearch, sep=" "))
}


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
  o_dir <- "/Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_LSMSSegmentation"
  system(paste(o_dir, "-in", input, "-inpos", inpos, "-out", out, "uint32", "-ranger", ranger, 
               "-spatialr", spatialr, "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}

# LSMSSegmentation(input = "/Volumes/geo_mac/fout.tif", inpos = "/Volumes/geo_mac/foutpos.tif", out = "/Volumes/geo_mac/seg.tif")

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
  o_dir <- "/Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_LSMSSmallRegionsMerging"
  system(paste(o_dir, "-in", input, "-inseg", inseg, "-out", out, "unint32", "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}

LSMSSmallRegionsMerging(input = "/Volumes/geo_mac/fout.tif", inseg = "/Volumes/geo_mac/seg.tif", out = "/Volumes/geo_mac/seg_merg.tif", tilesizex = 256, tilesizey = 256)

LSMSVectorization <- function(inseg, outshp, tilesizex, tilesizey){
  if(missing(inseg)){
    stop("Please provide input")}
  if(missing(outshp)){
    stop("Please provide output")}
  if(missing(minsize)){
    maxiter <- 0}
  if(missing(tilesizex)){
    modesearch <- 256}
  if(missing(tilesizey)){
    modesearch <- 256}
  o_dir <- "/Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_LSMSVectorization"
  system(paste(o_dir, "-inseg", inseg, "-out", outshp, "unint32", "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}





