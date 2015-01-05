source("./Rscripts/read.data.R")
source("./Rscripts/process.data.R")


#prerprocess and save data

#compute power specturm?
powerspectrum = T

#which session folder
session = 9

#start and end time  of signal to extract
start = 1201
end = 1400

#amount of smoothing
sigma  = 1

outliers = read.table(sprintf("session%d_outliers.csv", session))$V1 +1
files <- list.files(path=sprintf("session_%d/", session), pattern="*.mat", full.names=TRUE)
X <- read.data.time.window(files, start, end, outliers)

#smooth
X = smooth(X, sigma)$X;

if(powerspectrum){
  X = power.spectrum.rows(X)[ 1:(ceil(ncol(X))/2) ]
  save(X, session,
      file=sprintf("saved/session_%d_start%d_end%d_sigma_%f_spectrum.Rdata", session, start, end, sigma) )
}

X = X[,seq(1, ncol(X), max(1, sigma))]
save(X, session, file=sprintf("saved/session_%d_start%d_end%d_sigma_%f.Rdata", session, start, end, sigma) )


