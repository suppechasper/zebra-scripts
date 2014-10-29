source("./Rscripts/read.data.R")

session=9
outliers = read.table(sprintf("session%d_outliers.csv", session))$V1 +1

files <- list.files(path=sprintf("session_%d/", session), pattern="*.mat", full.names=TRUE)
X <- transpose.data(files, outliers = outliers, prefix=sprintf("session_%d_cols/", session) )

