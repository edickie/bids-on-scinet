# Running a singularity container

## fmriprep is one of the most popular - let's run fmriprep

BUT - for our demo we are going to run in "dryrun" which mean fmriprep will just start up and do nothing.

## preamble - let's get the dataset with datalad?

```sh
ssh <username>@teach.scinet.utoronto.ca
module load git-annex/2.20.1  # we need this for datalad to work
module load anaconda3         # in order for the conda load bit to work
source activate /scinet/course/ss2019/3/5_neuroimaging/conda_envs/ss2019_dm_ni

```

# one SciNet I will put the data in my $SCRATCH

This install's the data - which for a dataset means that we get the "small" data (i.e. the text files)
and the download instructions for the larger files

We can now navigate the dataset like it's a file system and plan our analysis

```sh
datalad install ///openfmri/ds000030
```
When we know what we want to run we can use the "get" command to download those files we need
Let's get all the imaging files for sub-10171

```sh
cd ds000030
datalad get sub-10171/
```

We can also use linux patterns here - i.e. lets get only the T1w images from teh first few subjects
```sh
datalad get sub-101*/anat/*T1w.nii.gz
```

When we are done our analysis. We can "drop" the data (i.e. delete the big files, but keep a record of where they came from)
Note: the drop command will only run when datalad knows that another copy of that file exists somewhere (i.e. the server you download from).

```sh
datalad drop sub-1015*/anat/*T1w.nii.gz
```

Another note: in the first version we use the datalad "datasets" shortcut (`///` these are download links that the datalad developers have curated)
But anyone can build a datalad repo, and these can be published to anywhere git repo's are housed.

OpenNeuro Curates some of it's own repo's they are at:
https://github.com/OpenNeuroDatasets

Let's get another dataset using this.

```sh
datalad install https://github.com/OpenNeuroDatasets/ds000003.git
```

Note: I get a warning that I need to "enable a sibling" - just literally copy and paste the line and all other datalad functions should work..

## 02 actually running the container

```sh
mriqc bids-root/ output-folder/ participant --participant-label sub-10171
```

```sh
fmriprep bids-root/ output-folder/ participant --participant-label sub-10171 -w work/
```

```sh
singularity run <singularity-image> <arguments>
```

WE have an fmriprep image in the /scinet/courses folder..

It has a crazy long name so we will set it at the top of our script

```sh
fmriprep-image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
singularity run ${fmriprep-image} bids-input/ output-folder/ participant
```

Note: in "participant" mode I recommend only calling fMRIprep on one participant at a time (and we only downloaded on participant of data)
So let's tell it to only run the participant data we have
(sub-10171 --> --participant_label 10171)
```sh
fmriprep-image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
singularity run ${fmriprep-image} bids-input/ output-folder/ participant --participant_label 10171
```

When running on an HPC - there are two more things that are highly recommended. These give you something closer to way a
Docker runs - i.e. a "clean" contained environment inside the containers

+ `--cleanenv` tells us NOT to let enviroment variables outside the container exist inside the container
    + this is especially important if to not let python enviroments from outside your container effect your pipeline
+ `--no-home` tells singularity not to mount your $HOME folder into the container
    + is is especially important on SciNet were your $HOME becomes read-only inside a pipeline
    + better to let the container create an empty home folder inside the container for any little logs it writes

```sh
singularity run --cleanenv --nohome ${fmriprep-image} --help
```

BUT - we need to "bind" our data  - we think of our singularity image as a virtual machine, so we need to tell the "bind" our input and output folders to the image..

a "bind" within a command has three parts:
  `-B <path/outside/container>:</path/inside/container>`
  ie `-B $SCRATCH/datalad/ds000003:/bids-input`

Note: here I am using escape `\` charaters to put a "one line" command on multiple lines
The escape character tells the computer to ignore the next charater afterwards (which in this case is the return) so the computer is "tricked" into thinking this was written on one line.

When copying this yourself - make sure that the `\` is present on everyline and that the next character after teh `\` is a return!



```sh
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
singularity run \
  --cleanenv --no-home \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  ${fmriprep_image} \
  bids-root/ output-folder/ participant \
  --participant_label 10171 \
  --boilerplate
```

The last bit fails becuase there is no output directory - we need to create it first..

```sh
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
mkdir -p $SCRATCH/ds000030/fmriprep-out
singularity run \
  --cleanenv --no-home \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  ${fmriprep_image} \
  bids-root/ output-folder/ participant \
  --participant_label 10171 \
  --boilerplate
```
## note: with fMRIprep - we normally only want to call it on
