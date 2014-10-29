read.data.time.window <- function(files, startIndex, endIndex, outliers){

  library(R.matlab)
  indices = setdiff(startIndex:endIndex, outliers)

  x <- readMat(files[indices[1]])
  X <- matrix(ncol=length(indices), nrow=length(x$outputStack) )
  X[,1] = as.vector(x$outputStack) 
  for(i in 2:length(indices) ){
    x <- readMat(files[indices[i]])
    X[ ,i] = as.vector(x$outputStack) 
  }

  X
}


transpose.data <- function(files, prefix = "col", startIndex = 1 , endIndex =
    length(files), outliers=-1){

  library(mio)
  library(R.matlab)
  indices = setdiff(startIndex:endIndex, outliers)

  x <- readMat(files[indices[1]])
  n = length(x$outputStack)

  nChunks = 50000
  start = 1;
  while(start < n ){
    end = min(n, start+nChunks-1);
    X <- matrix(ncol=length(indices), nrow=length(start:end) )
    for(i in 1:length(indices)){
      x <- readMat(files[indices[i]])
      X[ ,i] = as.vector(x$outputStack)[start:end]
    }
    write.matrix.int(X, filename=sprintf("%schunk-%.7d-%.7d.data", prefix, start, end) )
    start = end+1;
    print( sprintf("Chunk %d out of %d", end, n) )
  }
}


