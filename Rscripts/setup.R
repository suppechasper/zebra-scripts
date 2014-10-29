source("./Rscripts/read.data.R")
source("./Rscripts/process.data.R")

session = 1
start = 2000
end = 2050
sigma  = 0

outliers = read.table(sprintf("session%d_outliers.csv", session))$V1 +1
files <- list.files(path=sprintf("session_%d/", session), pattern="*.mat", full.names=TRUE)
X <- read.data.time.window(files, start, end, outliers)

#smooth
X = smooth(X, sigma)$X;
X = X[,seq(1, ncol(X), max(1, sigma))]

#Xs = power.spectrum.rows(X)
  
save(X, session, file=sprintf("saved/session_%d_start%d_end%d_sigma_%f.Rdata", session, start, end, sigma) )


v <- apply(X, 1, var)
ind = which(v > 0 & v < mean(v))
Xs = t(scale(t(X[ind, ]) ) )


library(R.matlab)
ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
ref =ref$currentStack
xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]
slices = rev(dim(ref)/2)



library(gmra)
Xs = Xs / sqrt( sum(Xs[1, ]^2) )
gmra <- gmra.create.ikm(Xs, eps=0.1, nKids=128, threshold=0.001, maxIter=200,
    stop=3, nRuns=1, split=3, similarity=2)

library(gyroscopeV2)
gyroscope.slices.gmra( gmra, conv = xyzInd, volume=ref, slices=slices)

