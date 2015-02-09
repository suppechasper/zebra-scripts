source("./Rscripts/read.data.R")
source("./Rscripts/process.data.R")


#prerprocess and save data

#compute power specturm?
powerspectrum = T
#which session folder
session = 9

#start time signal to extract
start = 1001
#length of signal to extract
inc = 200
#repreat n times with start incrementing by inc
n = 5

#amount of smoothing
sigma  = 1

outliers = read.table(sprintf("session%d_outliers.csv", session))$V1 +1
files <- list.files(path=sprintf("session_%d/", session), pattern="*.mat", full.names=TRUE)

for(i in 1:n){

  end = start +inc -1

  X <- read.data.time.window(files, start, end, outliers)

#smooth
  X = smooth(X, sigma)$X;
  Xps = power.spectrum.rows(X)
  X = X[,seq(1, ncol(X), max(1, sigma))]


  save(X, session, file=sprintf("saved/session_%d_start%d_end%d_sigma_%f.Rdata", session, start, end, sigma) )

  if(powerspectrum){
    save(Xps, session,
      file=sprintf("saved/session_%d_start%d_end%d_sigma_%f_spectrum.Rdata", session, start, end, sigma) )
  }

  start = end + 1

}
