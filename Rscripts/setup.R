source("./Rscripts/read.data.R")
source("./Rscripts/process.data.R")

#read and smooth data time frame
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


