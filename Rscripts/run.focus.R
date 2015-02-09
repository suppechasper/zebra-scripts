library(R.matlab)
library(focus)

source("Rscripts/run.gmra.R")


#use spatial information for hierarchical clustering?
jointSpatial = T
#standardize data / i.e. use corrrelation for clustering and visualization
standardize = F

#if data files are powerspectura decide whether to use mean or not
#X = X[ 2, ncol(X)] 

#threshold based on variance
X = scale(X, center=T, scale=F)
v <- apply(X, 1, var)
ind = which( v > 0  )
X = X[ind, ]

#tradeoff between spatial and signal influence for clustering
#more details in run.gmra.R 
if(standardize){
  lambda = 0.01 
}else{
  lambda = 10 / mean( sqrt(rowSums(X^2)) )
}


#load referenc stack
ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
ref =ref$currentStack
xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]
slices = rev(dim(ref)/2)
  
xy = ref[,,slices[1]]
xz = ref[,slices[2],]
zy = ref[slices[3],,]

xyInd = xyzInd[, c(1,2)]
xzInd = xyzInd[, c(1,3)]
zyInd = xyzInd[, c(3,2)]


#run gmra (settings for gmra computations can be chnaged in run.gmra.R)
if(jointSpatial){
  gmra <- run.gmra.joint(X, lambda, xyzInd, standardize=standardize)
}else{
  gmra <- run.gmra(X, standardize=standardize)
}

#setup and run visualization
data <- focus.create.gmra.data(gmra, ncol(X) )
if(standardize){
  proj <- focus.create.orthogonal.projection( data, scaled=FALSE, fixed=TRUE, tripod=TRUE  )
}else{
  proj <- focus.create.single.point.focus.projection( data )
}



pdel = focus.add.projection.display(proj, 0, 0.25, 0.5, 0.75)

if(standardize){
  focus.add.circle.background(pdel, 1.0)
  focus.add.vertical.circle.lines.background(pdel, 1.0, 10)
}else{
  for( r in c(0.25, 0.5, 1.0, 2,0) ){
    focus.add.center.shadow.background(pdel, r)
  }
  focus.add.circle.background(pdel, 1.0)
}    


focus.add.profile.display(proj, 0, 0.0, 0.5, 0.25)

focus.add.pca.display(proj, 0.75, 0, 0.25, 0.25)

focus.add.image.display(data, xy, xyInd, 0.5, 0.25, 0.25, 0.5)
focus.add.image.display(data, xz, xzInd, 0.75, 0.25, 0.25, 0.5)
focus.add.image.display(data, t(zy), zyInd, 0.5, 0.75, 0.25, 0.25)
  


focus.start()
