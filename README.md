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

## running the rest of ciftify

pull in the newest scripts  
```sh
cd ${home}/code/bids-on-scinet
git pull
```

submit them to the queue
```sh
cd $SCRATCH/sing_home
sbatch ~/code/bids-on-scinet/examples/sbatch_fmriprep_ciftify_p08.sh
```
