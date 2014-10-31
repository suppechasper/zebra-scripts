R scripts for setting up gyroscopeV2 viewer in R for zebrafish data. Requires gmra and gyroscopeV2 (available from www.math.duke.edu/~sgerber/software) and R.matlab packages. 

The setup script expects to have the session recordings in subfolders in this directory named session_x, the outliers files saved in this directory and the reference stacks in  saved in a subfolder reference_stacks and name referenceX.mat.
Note that you might need to resave the reference stacks from matlab with a different version number since R.matlab sometimes has trouble reading newer matlab versions data files.

Adjust time frames, sigma and if necessary file paths if your setup differs from above in setup.R. Then run source("Rscript/setup.R") and then source("Rscripts/run.gyroscope.R") in R. Note that this will save the processed data in the folder saved. For later session you can load this data and only with load("saved/sessionX-....Rdata") and  run  source("Rscrips/run.gyroscope.R"), the gmra construction still has to be run but the preprocessing can be skipped which typically takes the most time.

If naming of variables in the matlab files changes adjust read.data.R to reflect those changes, same holds for reeference stacks. 
