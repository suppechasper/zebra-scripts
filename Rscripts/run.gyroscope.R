library(gyroscopeV2)
library(R.matlab)
source("Rscripts/run.gmra.R")  


#if data files are powerspectura decide wheteher to use mean or not
#X = X[ 2, ncol(X)] 

#threshold based on variance
v <- apply(X, 1, var)
ind = which( v > 0  )
X = X[ind, ]

#load referenc stack
ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
ref =ref$currentStack
xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]
slices = rev(dim(ref)/2)

lambda = 0.01
jointSpatial = T
#run gmra
if(jointSpatial){
  gmra <- run.gmra.joint(X, lambda, xyzInd)
}else{
  gmra <- run.gmra(X)
}

#run visualization
gyroscope.slices.gmra( gmra, nCor= ncol(X), conv = xyzInd, volume=ref, slices=slices)

