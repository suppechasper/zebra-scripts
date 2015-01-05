R scripts for setting up focus viewer in R for zebrafish data. Requires the R
packages gmra, RColorBrewer, RMatlab and focus (and gyroscopeV2 to run older
scripts). The package focus needs freeglut (or openglut) to be installed (glut
won't work).


The setup script expects to have the session recordings in subfolders in this
directory named session_x, the outliers files save in this directory and the
reference stacks in  saved in a subfolder reference_stacks and name
dreferenceX.mat.  Note that you might need to resave the reference stacks from
matlb with a different version number since RMatlab sometimes has trouble
reading newer matlab versions data files.

The scripts are divided into preprocessing and running the visualization.

The preprocessing is done through any of tose scripts:
- setup.R
- setup.chunks.R 
- setup.multi.R
Adjust time frames, sigma and if necessary file paths if your setup differs from
the defauls in those scripts. If naming of varibales in the matlab files changed
adjust read.data.R to reflect those changes. 

The visualization is run through the scripts:
- run.focus.R
- run.focus.multi.R
Adjust settings as desired. Options are described in the comments in the scripts.

