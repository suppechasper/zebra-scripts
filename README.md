R scripts for setting up gyroscopeV2 viewer in R for zebrafish data. Requires gmra and gyroscopeV2 (available from www.math.duke.edu/~sgerber/software) and R.matlab packages. 

The setup script expects to have the session recordings in subfolders in this directory named session_x, the outliers files save in this directory and the reference stacks in  saved in a subfolder reference_stacks and name dreferenceX.mat.
Note that you might need to resave the reference stacks from matlb witha different version number since RMatlab csometimes has trouble reading newer matlab versions data files.

Adjust time frames, sigma and if necessary file paths if your setup differs from above in setup.R. Then run source("Rscript/setup.R") and then source("Rscripts/run.gyroscope.R") i in R. Note that this will save the processed data in the folder saved. For later session you can load this data and only  run  source("Rscrips/run.gyroscope.R").
If naming of varibales in the matlab files changed adjust read.data.R to reflect those changes. 
