#threshold based on variance
v <- apply(X, 1, var)
ind = which( v > 0  )
Xs = t(scale(t(X[ind, ]) ) )


#load referenc stack
library(R.matlab)
ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
ref =ref$currentStack
xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]
slices = rev(dim(ref)/2)


#run gmra
library(gmra)
Xs = Xs / sqrt( sum(Xs[1, ]^2) )
gmra <- gmra.create.ikm(Xs, eps=0.1, nKids=128, threshold=0.001, maxIter=200,
    stop=3, nRuns=1, split=3, similarity=2)

#run visualization
library(gyroscopeV2)
gyroscope.slices.gmra( gmra, conv = xyzInd, volume=ref, slices=slices)

