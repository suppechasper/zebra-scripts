
run.gmra.joint <- function(X, lambda, xyzInd, standardize=TRUE ){
  library(gmra)


  if(standardize){
    X = t(scale(t(X) ) )
    X = X / sqrt( sum(X[1, ]^2) )
  }



  #trade off betwen spatial (measurred in one unit per voxel) and correlation
  #similarity for clustering 
  #distance(x, y) = (1-cor( signal(x, y) ) ) + lambda * || spatial distance(x, y) ||  
  lambda = 0.01
  X = cbind(X, lambda * xyzInd)


  #Stopping is based on radius less than epsilon.
  #This means that at the leaf ndoes the following relation is approximately satisified
  #  stdev( cor(signals) ) < epsilon - lambda*stdev( spatial ) 
  if(standardize){
    gmra <- gmra.create.ikm(X, eps=0.1, nKids=8, threshold=0.0001, maxIter=200,
        stop=3, nRuns=1, split=3, similarity=3, nCor = ncol(X)-3, nSpatial=3)
  }
  else{
    gmra <- gmra.create.ikm(X, eps=0.1, nKids=8, threshold=0.0001, maxIter=200,
        stop=3, nRuns=1, split=3, similarity=1)
  }


  #Prune hierarchical tree at nodes with less than nPoints points.
  #The pruning starts from the leaves and removes iteratively any nodes with less
  #than nPoints and updating it's parent.
  #With the above stopping criteria this means that at least 5 points have to be
  #in a diameter of eps/lambda if they are perfectly correlated. For less correlated
  #points the diameter has to be smaller

  #gmra.prune.min.points.at.scale(gmra = gmra, scale = 1000, npoints = 10)

  gmra

}

run.gmra <- function(X, standardize=TRUE ){
  library(gmra)

  if(standardize){
    X = t(scale(t(X) ) )
    X = X / sqrt( sum(X[1, ]^2) )
  }


  if(standardize){
    gmra <- gmra.create.ikm(X, eps=0.1, nKids=8, threshold=0.001, maxIter=200,
        stop=3, nRuns=1, split=3, similarity=2)
  }
  else{
    gmra <- gmra.create.ikm(X, eps=0.1, nKids=8, threshold=0.001, maxIter=200,
        stop=3, nRuns=1, split=3, similarity=1)
  }




  #Prune hierarchical tree at nodes with less than nPoints points.
  #The pruning starts from teh leaves and removes iteratively any nodes with less
  #than nPoints and updating it's parent.
  #With the above stopping criteria this means that at least 5 points have to be
  #in a diameter of eps/lambda if they are perfectly correlated. For less correlated
  #points the diameter has to be smaller

  #gmra.prune.min.points.at.scale(gmra = gmra, scale = 1000, npoints = 10)

  gmra

}
