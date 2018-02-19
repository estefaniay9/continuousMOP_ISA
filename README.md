# punim0369

This project is a an extension to combine the COCO and PlatEMO platforms. The aim is to automate code to run through the test problems and algorithms to obtain performance metrics across all problems.

So far, the following has been done:
* Automate PlatEMO run for chosen problems and algorithms. COCO problems run in a separate file.
* Automate reading in above chosen problems and algorithms and calculating metrics.
* COCO functions adjusted to read directly into PlatEMO. Functions are still lacking a PF. Will read in when obtained.
* Adjusted Global.m that is used to include the COCO dimensions in the filename.
