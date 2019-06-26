# Pre-amble using a datalad singularity container to download data

#

```sh
shell -B $SCRATCH:/scratch/ /scinet/course/ss2019/3/5_neuroimaging/containters/datalad-datalad-master-fullmaster.simg
```

from not on the prompt should look different

```
Singularity datalad-datalad-master-fullmaster.simg:/scratch> git config --list --show-origin

```

Mine showed me that it is reading my git config from my SciNet home... it you do not see this take two minutes to run the following:

P.S. if you are not John Doe, you might want to use your own name and email

```sh
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

# Now for the majiks... let's install some datalad data

I am going to install a dataset on OpenNeuro (the CNP) This is our favorite study for this tutorial..

You can check out more datasets in:
+ the datalad public datasets space (http://datasets.datalad.org/)
+ the OpenNeuro github datasets land (https://github.com/OpenNeuroDatasets)

```sh
datalad install
```
