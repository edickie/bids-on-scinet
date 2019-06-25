# Running a singularity container

## fmriprep is one of the most popular - let's run fmriprep

BUT - for our demo we are going to run in "dryrun" which mean fmriprep will just start up and do nothing.

## preamble - let's get the dataset with datalad?

```sh
ssh <username>@teach.scinet.utoronto.ca
module load git-annex/2.20.1  # we need this for datalad to work
module load anaconda3         # in order for the conda load bit to work
source activate /scinet/course/ss2019/3/5_neuroimaging/conda_envs/datalad

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
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
singularity run ${fmriprep_image} --help
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

```sh
singularity run --cleanenv ${fmriprep_image} --help
```

So that's great but what about running real data?
i.e.

```sh
fmriprep bids-root/ output-folder/ participant --participant-label sub-10171 -w work/
```

BUT - we need to "bind" our data  - we think of our singularity image as a virtual machine, so we need to tell the "bind" our input and output folders to the image..

a "bind" within a command has three parts:
  `-B <path/outside/container>:</path/inside/container>`
  ie `-B $SCRATCH/datalad/ds000003:/bids-input`

Note: here I am using escape `\` charaters to put a "one line" command on multiple lines
The escape character tells the computer to ignore the next charater afterwards (which in this case is the return) so the computer is "tricked" into thinking this was written on one line.

When copying this yourself - make sure that the `\` is present on everyline and that the next character after teh `\` is a return!


```sh
ciftify_image=/scinet/course/ss2019/3/5_neuroimaging/containters/tigrlab_fmriprep_ciftify_1.3.0.post2-2.3.1-2019-04-04-8ebe3500bebf.img
singularity run ${ciftify_image} --help
```

```sh
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
singularity run \
  --cleanenv \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  ${fmriprep_image} \
  /bids-input output-folder/ participant \
  --participant_label 10171 \
  --boilerplate
```

```sh
ciftify_image=/scinet/course/ss2019/3/5_neuroimaging/containters/tigrlab_fmriprep_ciftify_1.3.0.post2-2.3.1-2019-04-04-8ebe3500bebf.img
singularity run \
  --cleanenv \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  ${ciftify_image} \
  /bids-input output-folder/ participant \
  --participant_label=10171 \
  --debug
```

Note: for fMRIprep and ciftify you need to also "BIND" the freesurfer license file into the container


We recommend you get one from FreeSurfer (it take 5min) but for now we will use Erin's (in the course folder)

/scinet/course/ss2019/3/5_neuroimaging/fs_license/license.txt

The last bit fails becuase there is no output directory - we need to create it first..

```sh
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg
mkdir -p $SCRATCH/ds000030/fmriprep-out
singularity run \
  --cleanenv \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  ${fmriprep_image} \
  bids-root/ output-folder/ participant \
  --participant_label 10171 \
  --boilerplate
```


## note: with fMRIprep - we normally only want to call it on

```sh
ciftify_image=/scinet/course/ss2019/3/5_neuroimaging/containters/tigrlab_fmriprep_ciftify_1.3.0.post2-2.3.1-2019-04-04-8ebe3500bebf.img
fs_license=/scinet/course/ss2019/3/5_neuroimaging/fs_license/license.txt
mkdir -p $SCRATCH/ds000030/fmriprep-out
singularity run \
  --cleanenv \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  -B ${fs_license}:/freesurfer_license.txt \
  ${ciftify_image} \
  /bids-input output-folder/ participant \
  --participant_label=10171 \
  --fs-license /freesurfer_license.txt \
  --anat_only --debug --dry-run
```

## two more things to do...

binding $HOME

Normally a singularity container has access to you $HOME directory. On SciNet we especially don't like this (because home is not writable within a job..)

so we can make a random folder on our $SCRATCH and tell the container to use that as our $HOME instead...

```sh
ciftify_image=/scinet/course/ss2019/3/5_neuroimaging/containters/tigrlab_fmriprep_ciftify_1.3.0.post2-2.3.1-2019-04-04-8ebe3500bebf.img
fs_license=/scinet/course/ss2019/3/5_neuroimaging/fs_license/license.txt
mkdir -p $SCRATCH/ds000030/fmriprep-out
mkdir $SCRATCH/sing_home
singularity run \
  --cleanenv \
  -H $SCRATCH/sing_home \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  -B ${fs_license}:/freesurfer_license.txt \
  ${ciftify_image} \
  /bids-input output-folder/ participant \
  --participant_label=10171 \
  --fs-license /freesurfer_license.txt \
  --anat_only --debug --dry-run
```

## second last thing - for some apps we can make use of the $BBUFFER

fMRIprep and MRIQC are pipelines that are written with Nipype.

Nipype has the concept of a "working directory", which is different from the "output directory"

A Nipype pipeline generates hundered of files in the working directory, these include:
+ many many small log files (that are needed to restart pipelines from the middle)
+ intermediate (temporary) outputs of images from different steps.

If you do not ask the pipeline to save these files, they will remain in a `/tmp` folder inside the container, and get deleted when the container stops running.

Most of the outputs you will even want from a pipeline go in the output directory. But the working directory is a good thing to hold onto in case something goes wrong and needs to be debugged or restarted.

Because these files are many and small - they are the perfect candidate for SciNet's Burst Buffer storage.

This is a drive with super fast io, that gets purged every few weeks.

```sh
echo $BBUFFER
```

Let's mount the `$BBUFFER` to the working directory input

```sh
ciftify_image=/scinet/course/ss2019/3/5_neuroimaging/containters/tigrlab_fmriprep_ciftify_1.3.0.post2-2.3.1-2019-04-04-8ebe3500bebf.img
fs_license=/scinet/course/ss2019/3/5_neuroimaging/fs_license/license.txt
mkdir -p $SCRATCH/ds000030/fmriprep-out
mkdir $SCRATCH/sing_home
singularity run \
  --cleanenv \
  -H $SCRATCH/sing_home \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  -B ${fs_license}:/freesurfer_license.txt \
  -B ${BBUFFER}:/bbuffer \
  ${ciftify_image} \
  /bids-input output-folder/ participant \
  --participant_label=10171 \
  --fs-license /freesurfer_license.txt \
  --fmriprep-workdir /bbuffer \
  --anat_only --debug --dry-run
```

## Lastly - setting a "good" number of threads

Different HPC systems have different configuations. For these pipelines have extra flags to allow the user to tell the pipeline what resources are the best to use for their cluster. If we don't specify anything - it will default to the fewest resources possible in order to not break things..

Niagara is a powerful machine so let's give our process more resources.

```sh
ciftify_image=/scinet/course/ss2019/3/5_neuroimaging/containters/tigrlab_fmriprep_ciftify_1.3.0.post2-2.3.1-2019-04-04-8ebe3500bebf.img
fs_license=/scinet/course/ss2019/3/5_neuroimaging/fs_license/license.txt
mkdir -p $SCRATCH/ds000030/fmriprep-out
mkdir $SCRATCH/sing_home
singularity run \
  --cleanenv \
  -H $SCRATCH/sing_home \
  -B $SCRATCH/datalad/ds000030:/bids-input \
  -B $SCRATCH/ds000030/fmriprep-out/:/output-folder \
  -B ${fs_license}:/freesurfer_license.txt \
  -B ${BBUFFER}:/bbuffer \
  ${ciftify_image} \
  /bids-input output-folder/ participant \
  --participant_label=10171 \
  --fs-license /freesurfer_license.txt \
  --fmriprep-workdir /bbuffer \
  --n_cpus 8 \
  --anat_only --debug --dry-run
  ```

## Bringing if all together into an array job..

```sh
#!/usr/bin/env bash

#SBATCH --partition=compute
#SBATCH --array=1-108%80
#SBATCH --cpus-per-task=40
#SBATCH --time=24:00:00
#SBATCH --export=ALL
#SBATCH --job-name fmriprep
#SBATCH --output=fmriprep_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity/2.5.2
module load gnu-parallel/20180322

dataset='ds001205'

bids_dir=${SCRATCH}/narps/data/${dataset}
output_dir=${bids_dir}/derivatives
work_dir=${BBUFFER}/${dataset}/fmriprep
tmp_dir=${SCRATCH}/tmp
freesurfer_license=${HOME}/.licenses/freesurfer/license.txt

mkdir -p ${tmp_dir} ${output_dir} ${work_dir}

subject_list=${SCRATCH}/narps/bin/subject_list.txt

index() {
  head -n $SLURM_ARRAY_TASK_ID $sublist \
  | tail -n 1
}

sing_container=${SCRATCH}/sing_containers/poldracklab_fmriprep_1.1.8-2018-10-04-b75ee0ceaf13.img

singularity run \
  -H ${tmp_dir} \
  -B ${bids_dir}:/bids \
  -B ${output_dir}:/out \
  -B ${work_dir}:/work \
  -B ${freesurfer_license}:/li \
  ${sing_container} \
  /bids /out participant \
  --participant_label=`index` \
  -w /work \
  --fs-license-file /li \
  --n_cpus 10 \
  --omp-nthreads 10 \
  --low-mem \
  --output-space T1w template \
  --debug --resource-monitor --notrack

```

Message Input
Direct message with michael






The _best_ place for these files to be on SciNet is the

## Also - we want to up the number of processor
