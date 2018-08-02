# How to run BIDS/ciftify workflow on scinet

## In three simple steps

1. Get you shiz into BIDS format
2. Run the fmriprep (--anat) container
      + note: this is useful because it can be resubmitted if it times out more easily
3. Run the fmriprep_ciftify container

# 1. Get you shiz into BIDS format

TBA but there's lots of help for this  

# 2. Run the fmriprep (--anat) container

see `examples/sbatch_fmriprep1.1.2_anat_p08.sh` script for example code..

# 3. Run the fmriprep_ciftify container

see `examples/sbatch_fmriprep_ciftify_p08.sh` script for example code..

# For example, what I did today with ds00003

getting it onto scinet using datalad

##### Now that we have datalad working..we can install one openfmri dataset

This bit installs the ds000003 folder structure and metadata into my $SCRATCH folder

```sh
singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg install -s ///openfmri/ds000003 /scratch/ds000003
```

This bit will actually pull the data for one subject into my scratch.

```sh
singularity run -B $SCRATCH/datalad:/scratch /scinet/course/ss2018/3_bm/8_publicdataneuro/datalad-datalad-master-fullmaster.simg get /scratch/ds000003/sub-01
```

## running fmriprep anat

first I moved these script into my scinet home using git.
Note: this is highly recommended

```sh
cd ${home}/code
git clone https://github.com/edickie/bids-on-scinet.git
```

note that as the progect progresses I will add new scripts to the repo and run them using ...
```sh
cd ${home}/code/bids-on-scinet
git pull
```

```sh
mkdir $SCRATCH/sing_home
sbatch ~/code/bids-on-scinet/examples/sbatch_fmriprep1.1.2_anat_p08.sh
```

I will them check if my job ran using:

```sh
squeue -u $USER
```

### now check to make sure that this step is done or near complete..

First (easy way to check) is to look for the words "no errors" in you fmriprep reports



### ALSO NOTE: if this step times out you can restart it..

When things time out there is usually a IsRunning.lh+rh in the subjects output
for example this output from

```sh
cd ${SCRATCH}/bids_outputs/ds000003/fmriprep_p08/freesurfer/sub-02/scripts
ls
```
gave me this output

```
edickie@nia-login07:/scratch/a/arisvoin/edickie/bids_outputs/ds000003/fmriprep_p08/freesurfer/sub-02/scripts$ ls -lrt
total 2048
-rw-rw-r-- 1 edickie arisvoin     58 Aug  2 15:58 build-stamp.txt
-rw-rw-r-- 1 edickie arisvoin   7983 Aug  2 15:58 recon-all.env.bak
-rw-rw-r-- 1 edickie arisvoin      1 Aug  2 16:11 patchdir.txt
-rw-rw-r-- 1 edickie arisvoin     58 Aug  2 16:11 lastcall.build-stamp.txt
-rw-rw-r-- 1 edickie arisvoin   7836 Aug  2 16:11 recon-all.env
-rw-rw-r-- 1 edickie arisvoin    360 Aug  2 16:11 IsRunning.lh+rh
-rwxrwxr-x 1 edickie arisvoin 327555 Aug  2 16:11 recon-all.local-copy
-rw-rw-r-- 1 edickie arisvoin    616 Aug  2 16:18 recon-all-status.log
-rw-rw-r-- 1 edickie arisvoin   2871 Aug  2 16:18 recon-all.cmd
-rw-rw-r-- 1 edickie arisvoin 102921 Aug  2 17:32 recon-all.log
```

To rerun if would delete the `IsRunning.*` file and resubmit the script

```sh
rm IsRunning.lh+rh
cd $SCRATCH/sing_home
sbatch ~/code/bids-on-scinet/examples/sbatch_fmriprep1.1.2_anat_p08.sh
```

## running the rest of ciftify

Before we start, we should use git to pull in the newest version of our scripts.
(Which, I assume, we have been busy writing...)

```sh
cd ${home}/code/bids-on-scinet
git pull
```

submit them to the queue
```sh
cd $SCRATCH/sing_home
sbatch ~/code/bids-on-scinet/examples/sbatch_fmriprep_ciftify_p08.sh
```
