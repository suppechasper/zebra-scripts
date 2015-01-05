library(R.matlab)
library(gyroscopeV2)

source("Rscripts/run.gmra.R")

lambda = 0.01
jointSpatial = T

files <- list.files(path= "saved/multi-test/", pattern="*.Rdata", full.names=TRUE)

gmras = list()
convs = list()

for(i in 1:length(files)){


  print(files[i])

  #if data files are powerspectura decide wheteher to use mean or not
  #X = X[ 2, ncol(X)]

  #threshold based on variance
  v <- apply(X, 1, var)
  ind = which( v > 0  )
  X = X[ind, ]

  ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
  ref =ref$currentStack
  xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]
  slices = rev(dim(ref)/2)

  if(jointSpatial){
    gmras[[i]] <- run.gmra.joint( X, lambda, xyzInd )
  }else{
    gmras[[i]] <- run.gmra( X )
  }
  convs[[i]] = xyzInd
}

#run visualization

#gyroscope.slices.multi.gmra( gmras, nCor = ncol(X), convs = convs, volume=ref, slices=slices)
gyroscope.slices.multi.independent.gmra( gmras, nCor = ncol(X), convs = convs, volume=ref, slices=slices)

