# punim0369

This project is an extension to combine the COCO and PlatEMO platforms. The aim is to automate code to run through the test problems and algorithms to obtain performance metrics across all problems.

So far, the following has been done:
* Automate PlatEMO run for chosen problems and algorithms. COCO problems run in a separate file.
* Automate reading in above chosen problems and algorithms and calculating metrics.
* COCO functions adjusted to read directly into PlatEMO. Functions are still lacking a PF. Will read in when obtained.
* Adjusted Global.m that is used to include the COCO dimensions in the filename.

***Updates September 2020***

*Pre-requisites*

PlatEMO v2.2.1: https://github.com/BIMK/PlatEMO.git

bbobela: https://github.com/andremun/bbobela.git

MATSuMoTo: https://github.com/Piiloblondie/MATSuMoTo.git

* Updated to be compatible with PlatEMO v2.2.1
* New Global file generated for problem variants (including a probindex flag)
* Added files relating to generating pseudo-random walks in continuous multi-objective space across problems
* Added pseudo-algorithm for random walk sequence

* Adding input files for DACE modelling with MATSuMoTo for continuous ZDT, DTLZ, WFG problems for 8 algorithms.
