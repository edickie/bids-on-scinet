# Building singularity containers

## pre-amble go to SciNet

```sh
ssh <username>@teach.scinet.utoronto.ca
module load singularity
```

```sh
# note - in this example I am adding the new container to my $SCRATCH folder
mkdir $SCRATCH/test_sing_img

singularity build $SCRATCH/test_sing_img/neurodocker_0.5.0.simg docker://kaczmarj/neurodocker:0.5.0


```

### Other option: build as a docker on another machine and convert

*on another machine where you have root access - This can be your personal laptop*

Note1:  I am running on a linux workstation where I have "sudo" access
Note2:  If you use "docker run" on a container that dosen't exist on your system, Docker will build it for you first.  

```sh
sudo docker run -it kaczmarj/neurodocker:0.5.0 --help
```

Now you need to convert from docker to singularity -  this uses a Docker image put out by singularity called `docker2singularity`

Note: we are using the "-v" volume mounts to give it two input paths:

+ `/var/run/docker.sock` is the place were all your docker images are sitting
+ `/scratch/edickie` is the location where I want the output image to end up

```sh
sudo docker run --privileged -t --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /scratch/edickie/:/output \
    singularityware/docker2singularity \
    kaczmarj/neurodocker:0.5.0
```
This created the container:

`kaczmarj_neurodocker_0.5.0-2019-04-18-2fc25b0b83b7.img`

```sh
cd /scratch/edickie
ls -sh kaczmarj_neurodocker_0.5.0-2019-04-18-2fc25b0b83b7.img
rsync -av  ./kaczmarj_neurodocker_0.5.0-2019-04-18-2fc25b0b83b7.img <username>@niagara.scinet.utoronto.ca:<path/on/scinet/>
```

-----------------------------


## Same thing but with MRIQC (a larger container)

### Other option: build as a docker on another machine and convert

*on another machine where you have root access - This can be your personal laptop*

Note1:  I am running on a linux workstation where I have "sudo" access
Note2:  If you use "docker run" on a container that dosen't exist on your system, Docker will build it for you first.  

```sh
sudo docker run -it poldracklab/mriqc:0.14.2 --version
```

Now you need to convert from singularity to docker - this uses a Docker image put out by singularity can docker2singularity

Note: we are using the "-v" mounts to give it two input paths

+ `/var/run/docker.sock` is the place were all your docker images are sitting
+ `/scratch/edickie` is the location where I want the output image to end up

```sh
sudo docker run --privileged -t --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /scratch/edickie/:/output \
    singularityware/docker2singularity \
    poldracklab/mriqc:0.14.2
```
This created the container:

`poldracklab_mriqc_0.14.2-2018-08-21-d8668a28659b.img`

```sh
cd /scratch/edickie
ls -sh poldracklab_mriqc_0.14.2-2018-08-21-d8668a28659b.img
```

Note that is it 12G - because it contains all the software needed to run MRIQC
