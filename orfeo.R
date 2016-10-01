#make

o_dir <- "/Users/lando/OTB/OTB-5.6.1-Darwin64/bin/"

NDVI <- function(input, out){
  if(!is.null(input)){
    stop("Please provide input")}
  if(!is.null(out)){
    stop("Please provide output")}
  # if(!is.null(ranger)){
  #   ranger <- 30}
  # if(!is.null(spatialr)){
  #   spatialr <- 5}
  # if(!is.null(maxiter)){
  #   maxiter <- 10}
  # if(!is.null(modesearch)){
  #   modesearch <- 10}
  o_dir <- "./Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_RadiometricIndices"
  system(paste(o_dir, "-in", input, "-out", out, "-channels.red", -1, "-channels.nir", 4, 
               "-list Vegetation:NDVI", sep=" "))
}


meanShiftSmoothing <- function(input, fout, foutpos, ranger, spatialr, maxiter, modesearch){
  if(!is.null(input)){
    stop("Please provide input")}
  if(!is.null(fout)){
    stop("Please provide output")}
  if(!is.null(foutpos)){
    stop("Please provide output")} 
   if(!is.null(ranger)){
    ranger <- 30}
  if(!is.null(spatialr)){
    spatialr <- 5}
  if(!is.null(maxiter)){
    maxiter <- 10}
  if(!is.null(modesearch)){
    modesearch <- 10}
  o_dir <- "./Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_MeanShiftSmoothing"
  system(paste(o_dir, "-in", input, "-fout", fout, "-foutpos", foutpos, "-ranger", ranger, 
                     "-spatialr", spatialr, "-maxiter", maxiter, "-modesearch", modesearch, sep=" "))
}


LSMSSegmentation <- function(input, inpos, out, ranger, spatialr, minsize, tilesizex, tilesizey){
  if(!is.null(input)){
    stop("Please provide input")}
  if(!is.null(inpos)){
    stop("Please provide input")}
  if(!is.null(out)){
    stop("Please provide output")} 
  if(!is.null(ranger)){
    ranger <- 30}
  if(!is.null(spatialr)){
    spatialr <- 5}
  if(!is.null(minsize)){
    maxiter <- 0}
  if(!is.null(tilesizex)){
    modesearch <- 256}
  if(!is.null(tilesizey)){
    modesearch <- 256}
  o_dir <- "./Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_LSMSSegmentation"
  system(paste(o_dir, "-in", input, "-inpos", inpos, "-out", out, "-ranger", ranger, 
               "-spatialr", spatialr, "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}

LSMSSmallRegionsMerging <- function(inseg, out, minsize, tilesizex, tilesizey){
  if(!is.null(inseg)){
    stop("Please provide input")}
  if(!is.null(out)){
    stop("Please provide output")}
  if(!is.null(minsize)){
    maxiter <- 0}
  if(!is.null(tilesizex)){
    modesearch <- 256}
  if(!is.null(tilesizey)){
    modesearch <- 256}
  o_dir <- "./Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_LSMSSmallRegionsMerging"
  system(paste(o_dir, "-inseg", inseg, "-out", out, "unint32", "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}

LSMSVectorization <- function(inseg, outshp, tilesizex, tilesizey){
  if(!is.null(inseg)){
    stop("Please provide input")}
  if(!is.null(outshp)){
    stop("Please provide output")}
  if(!is.null(minsize)){
    maxiter <- 0}
  if(!is.null(tilesizex)){
    modesearch <- 256}
  if(!is.null(tilesizey)){
    modesearch <- 256}
  o_dir <- "./Users/lando/OTB/OTB-5.6.1-Darwin64/bin/otbcli_LSMSVectorization"
  system(paste(o_dir, "-inseg", inseg, "-out", outshp, "unint32", "-minsize", minsize, "-tilesizex", tilesizex, "-tilesizey", tilesizey, sep=" "))
}





