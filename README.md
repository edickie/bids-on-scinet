# bids-on-scinet
A collection of my notes about who to run BIDS apps on the SciNet Niagara cluster 

## stared at Computer Ontario Summer School 2018

So I put some singularity containers for public use on the cluster

There are two fun bits to hack on.

1. How to best stage BIDS data into SciNet (i.e. have SciNet installs of these things + wiki instructions for them) 
  + awscli 
  + s3cmd
  + datalad 
  
 Another part of this would be potentially staging input data to the Niagara burst buffer.
 *Note: the processing nodes cannot see the internet, so data staging must happen before job submission*

2. How to run BIDS apps on SciNet.
  + write some template singularity submission scripts for SciNet slurm system
  + bench marking different BIDS apps to see the best way to run them on SciNet
       + this has to do with the fact that SciNet has "fat" nodes with 40 CPU's each and 12 hrs job allocation. 
       + What is the optimal number of participants to process per node? 
       + should they each be individual containers or multproc?
       + what the optimal walltime to ask for?
       + should some BIDS apps (i.e. fmriprep) be chunked into smaller walltimes, & different number of participants per chunk? (i.e. anat only then fMRI?)
       
## Here we go

Using datalad on SciNet
