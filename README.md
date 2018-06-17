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


*Note: datalad will refuse to do anything untill we first configure our git*
  + I don't think you need a github account to run the next two lines

Replace the name and email in the next bit with your own

```sh
git config --global user.name "My Name"
git config --global user.email myemail@me.com
```

This action creates a hidden file into your home `~/.gitconfig`.

```sh
module load singularity
singularity run /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg install ///
```

This will create the "superdataset" inside `$SCRATCH/datasets.datalad.org`

##### Now that we have datalad working..we can install one openfmri dataset

This bit installs the ds000003 folder structure and metadata into my $SCRATCH folder

```sh
singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg install -s ///openfmri/ds000003 /scratch/ds000003
```

This bit will actually pull the data for one subject into my scratch.

```sh
singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg get /scratch/ds000003/sub-01
```

# Part Deux - running BIDS apps

So the BIDS apps singularity containers have been placed in:

`/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers`

they are:

bids_freesurfer_v6.0.1-4-2018-04-22-77961085015a.img
poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img
poldracklab_mriqc_0.11.0-2018-06-05-1e4ac9792325.img

## MRIQC

So..mriqc I'm gonna bet (for any dataset with less than 20 subs) is probably run best by just sitting on one node in multiproc mode...

Note: according to the profiling that is reported [here](https://mriqc.readthedocs.io/en/latest/running.html#requesting-resources) mriqc takes about 45 minutes and *most* of the computation uses one CPU per scan (i.e. one per run).

Let's try it.

code in:

examples/sbatch_mriqc.sh

## FMRIPREP

Looking at the early outputs.. If given the whole dataset (20 subs). It runs the first 8 in parallel first.

The freesurfer calls have an embedded omp thread = 8 which would imply up to 5 would compute at the same time

note: --omp-nthreads 80 will cause only one freesurfer subject to run at a time..fail do not do that

So given this..I decided to chunk into groups of 10 subjects (with the freesurfer steps using openmp of 8 task)

We tried this by either doing the 8 subjects in one fmriprep call  OR using parallel to call fmriprep 8 times.
We turns out that using 8 calls (with gnu-parallel) actually did a little better than using one call. Which is great because this means the gnu-parallel version is easier to scale (using qbatch).

gnuparallel version

JobID    JobName    Account    Elapsed  MaxVMSize     MaxRSS  SystemCPU    UserCPU ExitCode
------------ ---------- ---------- ---------- ---------- ---------- ---------- ---------- --------
158328         fmriprep def-arisv+   10:01:23                        00:50.613  28:13.236      0:0
158328.batch      batch def-arisv+   10:01:23  63250740K  24662340K  00:50.613  28:13.236      0:0

fmriprep-multiproc version

JobID    JobName    Account    Elapsed  MaxVMSize     MaxRSS  SystemCPU    UserCPU ExitCode
------------ ---------- ---------- ---------- ---------- ---------- ---------- ---------- --------
158327         fmriprep def-arisv+   10:28:36                        00:38.818  26:32.419      0:0
158327.batch      batch def-arisv+   10:28:36  67817464K  27573820K  00:38.818  26:32.419      0:0

One issue here is that we are writing the working dir to $SCRATCH. This might be a lot faster if it was written to a faster drive (ramdisk or the burst buffer)

OK so lets's run two other versions with less subjects (8 and 5) in parallel, using a tmpdir using ramdisk as the workdir.

So we should chunk jobs into groups of 8 subjects?

examples/sbatch_fmriprep_anat.sh
