source("./Rscripts/read.data.R")
source("./Rscripts/process.data.R")

library(mio)

#prerprocess and save data
#This script has the identical result as setup.R but process individual signal
#in bacthes instead of loading the complte set of signals into memory

#compute power specturm?
powerspectrum = T
#which session folder
session=9
outliers = read.table(sprintf("session%d_outliers.csv", session))$V1 +1

#start and end time of signal
start = 1;
end   = 7201;

#amount of smoothing
sigma = 100


X = c()
Xps = c()
files <- list.files(path=sprintf("session_%d_cols/", session), pattern="*data.hdr", full.names=TRUE)
for(i in 1:length(files) ){
  print( sprintf("Chunk %d out of %d", i, length(files) ) )
  
  Xtmp <- read.matrix.int(files[i])
  if(end > ncol(Xtmp)){
    end = ncol(Xtmp);
  }
  Xtmp <- smooth(Xtmp[,start:end], sigma)$X;
  Xtmp <- Xtmp[,seq(1, ncol(Xtmp), floor( max(1, sigma/2)) )]
  X <- rbind(X, Xtmp)
  
}

save(X, session, file=sprintf("saved/session_%d_start%d_end%d_sigma_%f.Rdata", session, start, end, sigma) )

if(powerspectrum){
  Xps = power.spectrum.rows(X)
  save(Xps, session,
      file=sprintf("saved/session_%d_start%d_end%d_sigma_%f_spectrum.Rdata", session, start, end, sigma) )
}


