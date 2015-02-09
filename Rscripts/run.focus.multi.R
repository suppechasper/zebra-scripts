library(R.matlab)
library(focus)
library(RColorBrewer)

source("Rscripts/run.gmra.R")

#use spatial information for hierarchical clustering?
jointSpatial = T
#tradeoff between spatial and signal influence for clustering
#more details in run.gmra.R 
lambda = 0.01
#standardize data / i.e. use corrrelation for clustering and visualization
standardize = T

#Setup for each data set an individual projection? 
#Setting this to false only makes sense if the data sets are comensurable and
#requires them to be of the same dimensionality
independent = T


#pointer to a folder with a set of Rdata files create by setup*.R scripts
files <- list.files(path= "saved/multi-test/", pattern="*.Rdata", full.names=TRUE)



n = length(files)
a = min( 0.1, 1/(n+1) )


cols= brewer.pal(name="Paired", n=12)

projs <- list()
for(i in 1:length(files)){

  load( files[i] )

  print(files[i])
  #if data files are powerspectura decide wheteher to use mean or not
  #X = X[ 2, ncol(X)]

  #threshold based on variance
  v <- apply(X, 1, var)
  ind = which( v > 0  )
  X = X[ind, ]

  ref <- readMat(sprintf("reference_stacks/reference%d.mat",  session))
  ref =ref$currentStack
  xyzInd  = arrayInd( 1:length(ref), .dim=dim(ref) )[ind, ]


  #run gmra (settings for gmra computations can be chnaged in run.gmra.R)
  if(jointSpatial){
    gmra <- run.gmra.joint(X, lambda, xyzInd, standardize=standardize)
  }else{
    gmra <- run.gmra(X, standardize=standardize)
  }
  
  data <- focus.create.gmra.data(gmra, ncol(X) )


  #setup visualization elements for this data set
  if(standardize){
    proj <- focus.create.orthogonal.projection( data, scaled=FALSE, fixed=TRUE,
        tripod=TRUE )
  }else{
    proj <- focus.create.single.point.focus.projection( data )
  }

  projs[i] = proj;

  focus.set.group.colors.ramp( data, colorRamp( c(cols[2*i],cols[2*i-1]) ), 9)
  dcol <- col2rgb( cols[2*i]) / 255
  focus.set.default.color(data, dcol[1], dcol[2], dcol[3])



  pdel = focus.add.projection.display(proj, 0.1, 0.25, 0.5, 0.75)
  if(i == 1){
    if(standardize){
      focus.add.circle.background(pdel, 1.0)
      focus.add.vertical.circle.lines.background(pdel, 1.0, 10)
    }else{
      for( r in c(0.25, 0.5, 1.0, 2,0) ){
        focus.add.center.shadow.background(pdel, r)
      }
      focus.add.circle.background(pdel, 1.0)
    }    
  }

  focus.add.profile.display(proj, 0.1, 0.0, 0.5, 0.25, showBG = (i == 1) )

  focus.add.pca.display(proj, 0, (i-1)*a, 0.1, a)
 
 
  slices = rev(dim(ref)/2)
  xy = ref[,,slices[1]]
  xz = ref[,slices[2],]
  zy = ref[slices[3],,]

  xyInd = xyzInd[, c(1,2)]
  xzInd = xyzInd[, c(1,3)]
  zyInd = xyzInd[, c(3,2)]
 
  focus.add.image.display(data,    xy, xyInd, 0.65 , 0   , 0.225, 0.5 , i==1)
  focus.add.image.display(data,    xz, xzInd, 0.875, 0   , 0.125, 0.5 , i==1)
  focus.add.image.display(data, t(zy), zyInd, 0.65 , 0.5 , 0.225, 0.25, i==1)

  
}

if( !independent ){
  focus.create.projection.group( projs )
}

focus.start()

