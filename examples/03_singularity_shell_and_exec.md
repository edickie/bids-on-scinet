# Using singularity shell and exec to do custom things..

## Ways to use singularity

So far we have only talked about `singularity run`. This run's a specific script (or program) within the container's software env that the developer wrote that container to do (like the fmriprep pipeline).

BUT - there is more software in a container that we might want access to - we can also `shell` and `exec` to play with these.

## Using `shell` to get an interactive env

fMRIprep depends on FSL, freesurfer, ANTS, python - and all those things are in the fmriprep singularity image.

says we just want to run `fslinfo` from the FSL package to check on of the files..

```sh
ssh <username>@teach.scinet.utoronto.ca
module load singularity
```

when running `shell` many of the arguments are the same as `run`. We still need to use binds to attach data to the container software.

Rememeber - when we use a bind - the path to the data is relative to the what we bound.

```sh
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg

singularity shell --cleanenv -B $SCRATCH:/scratch ${fmriprep_image}
```

inside the container - we can explore

```sh
cd /
ls

cd /scratch
ls
fslinfo datalad/ds000030/sub-10171/anat/sub-10171_T1w.nii.gz

fslmaths datalad/ds000030/sub-10171/func/sub-10171_task-rest_bold.nii.gz -Tmean test_tmean.nii.gz

exit
```

now that we have exited the container - we can see if the file we just created `test_tmean.nii.gz` is still there.

```sh
ls $SCRATCH
```

Look there it is!

## singularity exec

So `singularity shell` is a great way to expore how a container looks on the inside, and to run things interactively. But what if we want to do some perform some custom calculation on the HPC cluster?

We can use `singularity exec` to make a call to any command that would worked in our interactive `singularity shell` env.

The format of singularity exec

```sh
singularity exec <singularity-options> <singularity-image> <command-line-argument>
```

For example - let's run that call to fslmaths again..

```sh
fmriprep_image=/scinet/course/ss2019/3/5_neuroimaging/containters/poldracklab_fmriprep_1.3.2-2019-03-18-573e99cc5d39.simg

singularity exec --cleanenv -B $SCRATCH:/scratch ${fmriprep_image} fslmaths /scratch/datalad/ds000030/sub-10171/func/sub-10171_task-rest_bold.nii.gz -Tmean /scratch/test_tmean_exec.nii.gz
```
