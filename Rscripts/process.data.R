smooth <- function(X, sigma, rows=TRUE){
  if (sigma <= 0 ){
    f=NA
  }
  else{
    f = dnorm( floor(-3*sigma):ceiling(3*sigma), sd=sigma )
                               f =f / sum(f);
    if(rows){
      X = t( filter( t(X), f) )
    }
    else{
      X = filter(X, f)
    }
  }
  ind = complete.cases(X[1, ])
  list(X=X[, ind], f=f)
}

smooth.convolve <- function(X, sigma, rows=TRUE){
  f = dnorm( floor(-3*sigma):ceiling(3*sigma), sd=sigma )
  f =f / sum(f);
  if(rows){
    for(i in 1:nrow(X)){
      X[i, ] = convolve(X[i,], f, type="filter")
    }
    X = t( filter( t(X), f) )
    ind = complete.cases(X[1, ])
    X = X[, ind];
  }
  else{
    for(i in 1:ncol(X)){
      X[,i] = convolve(X[,i], f, type="filter")
    }
    ind = complete.cases(X[, 1])
    X = X[ind, ];
  }
  list(X=X, f=f)
}


spectrum.fft <- function(x){
  fx = fft(x)
  power = sqrt(Re(fx)^2+ Im(fx)^2) / length(x)
  power
}

power.spectrum.rows <- function(X){ 
  for(i in 1:nrow(X) ){
#X[i,] = Re(fft(X[i, ]))^2
    X[i,] = spectrum.fft(X[i, ])
  }
  X
}
