source("./Rscripts/read.data.R")
source("./Rscripts/process.data.R")

library(mio)

session=9
outliers = read.table(sprintf("session%d_outliers.csv", session))$V1 +1
vtl = 1000
vtu = 200000

start1 = 1;
end1   = 7201;
start2 = 5000;
end2   = 5300;

sigma = 100


X1 = c();
X2 = c();
files <- list.files(path=sprintf("session_%d_cols/", session), pattern="*data.hdr", full.names=TRUE)
for(i in 1:length(files) ){
  print( sprintf("Chunk %d out of %d", i, length(files) ) )
  
  Xtmp1 <- read.matrix.int(files[i])
  if(end1 > ncol(Xtmp1)){
    end1 = ncol(Xtmp1);
  }
  Xtmp1 <- smooth(Xtmp1[,start1:end1], sigma)$X;
  Xtmp1 <- Xtmp1[,seq(1, ncol(Xtmp1), floor( max(1, sigma/2)) )]
  X1 <- rbind(X1, Xtmp1)
  
# Xtmp2 <- smooth(Xtmp[,start2:end2], sigma)$X;
# Xtmp2 <- Xtmp2[,seq(1, ncol(Xtmp2), max(1, sigma))]
# X2 <- rbind(X2, Xtmp2)

}


v1 <- apply(X1, 1, var)
m = mean(v1)
ind1 = which(v1 > 0)

#v2 <- apply(X2, 1, var)
#m = mean(v2)
#ind2 = which(v2 > 0.5*m)

X = X1
ind = ind1


Xs = t(scale(t(X[ind, ]) ) )


library(R.matlab)
ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
ref =ref$currentStack
xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]
slices = rev(dim(ref)/2)

  
save(X, file=sprintf("saved/session_%d_start%d_end%d_sigma_%f.Rdata", session, start1, end1, sigma) )




library(gmra)
Xs = Xs / sqrt( sum(Xs[1, ]^2) )
gmra <- gmra.create.ikm(Xs, eps=0.25, nKids=10, threshold=0.001, maxIter=200,
    stop=3, nRuns=1, split=2, similarity=2)

library(gyroscopeV2)
gyroscope.slices.gmra( gmra, conv = xyzInd, volume=ref, slices=slices)


