library(R.matlab)
library(focus)

source("Rscripts/run.gmra.R")


#use spatial information for hierarchical clustering?
jointSpatial = T

#if data files are powerspectura decide whether to use mean or not
#X = X[ 2, ncol(X)] 

#threshold based on variance
v <- apply(X, 1, var)
ind = which( v > 0  )
X = X[ind, ]

#tradeoff between spatial and signal influence for clustering
lambda = 100 / mean( sqrt(rowSums(X^2)) )


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
  gmra <- run.gmra.joint(X, lambda, xyzInd, standardize=FALSE)
}else{
  gmra <- run.gmra(X, standardize=FALSE)
}

#setup and run visualization
data <- focus.create.gmra.data(gmra, ncol(X) )

hproj <- focus.create.single.point.focus.projection( data, scaled=TRUE, fixed=FALSE,
    tripod=TRUE, hyperbolic=TRUE )
cproj <- focus.create.correlation.projection( data )
pproj <- focus.create.orthogonal.projection( data, scaled=TRUE,
    fixed=FALSE, tripod=TRUE, hyperbolic=TRUE )
vproj <- focus.create.three.point.focus.projection( data )

focus.create.projection.group( list(hproj, cproj, pproj, vproj) )


hdel = focus.add.projection.display( hproj, 0, 0.25, 0.25, 0.35)
focus.add.center.shadow.background(hdel, 0.25)
focus.add.center.shadow.background(hdel, 0.5)
focus.add.center.shadow.background(hdel, 1.0)
focus.add.circle.background(hdel, 1.0)

cdel = focus.add.projection.display( cproj, 0, 0.6, 0.25, 0.35)
focus.add.circle.background(cdel, 1.0)
focus.add.vertical.circle.lines.background(cdel, 1.0, 10)

pdel = focus.add.projection.display( pproj, 0.25, 0.25, 0.25, 0.35)
focus.add.center.shadow.background(pdel, 0.25)
focus.add.center.shadow.background(pdel, 0.5)
focus.add.center.shadow.background(pdel, 1.0)
focus.add.circle.background(pdel, 1.0)


vdel = focus.add.projection.display( vproj, 0.25, 0.6, 0.25, 0.35)
for(i in 0:2){
  focus.add.projector.shadow.background(vdel, 0.5, i)
  focus.add.projector.shadow.background(vdel, 1.0, i)
  focus.add.projector.shadow.background(vdel, 2.0, i)
}


focus.add.profile.display(hproj, 0, 0.0, 0.5, 0.25)

focus.add.pca.display(hproj, 0.75, 0, 0.25, 0.25)

focus.add.image.display(data, xy, xyInd, 0.5, 0.25, 0.25, 0.5)
focus.add.image.display(data, xz, xzInd, 0.75, 0.25, 0.25, 0.5)
focus.add.image.display(data, t(zy), zyInd, 0.5, 0.75, 0.25, 0.25)
  

focus.start()

