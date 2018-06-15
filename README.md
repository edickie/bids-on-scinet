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

So I've build a datalad container inside course repo

```sh
module load singularity
cd /scinet/course/ss2018/3_bm/8_publicdataneuro
singularity pull shub://datalad/datalad:fullmaster
```

This nicely created a container:

`/scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg`

But now how to use it?

So singularity containers can (by default) do stuff in your home folder. But I don't wanna do that. Because my SciNet /home/ is not that big. So I will try to mount a folder into my $SCRATCH space for datalad to work inside...

However... from what I can tell you cant get around installing the "superdataset" in you SciNet home. Luckily this is not too too big

```sh
mkdir $SCRATCH/datalad
singularity run -B $SCRATCH/datalad /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg install ///
```

*Note: datalad will refuse to do anything untill we first configure our git*
  + I don't think you need a github account to run the next two lines
 
Replace the name and email in the next bit with your own

```sh
git config --global user.name "My Name"
git config --global user.email myemail@me.com
```

##### Now that we have datalad working..we can install one openfmri dataset

This bit installs the ds000003 folder structure and metadata into my $SCRATCH folder

```sh
singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg install -s ///openfmri/ds000003 /scratch/ds000003
```

This bit will actually pull the data for one subject into my scratch.

```sh
singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg get /scratch/ds000003/sub-01
```


