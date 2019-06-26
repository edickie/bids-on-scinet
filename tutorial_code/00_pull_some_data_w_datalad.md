# Using a datalad to download data



## preamble - let's get datalad env on scient

```sh
ssh <username>@teach.scinet.utoronto.ca
module load git-annex/2.20.1  # we need this for datalad to work
module load anaconda3         # in order for the conda load bit to work
source activate /scinet/course/ss2019/3/5_neuroimaging/conda_envs/datalad

```

One thing to check - that you have your git configured no SciNet. Check by typing this:

```sh
 git config --list --show-origin

```

Mine showed me that it is reading my git config from my SciNet home... it you do not see this take two minutes to run the following:

P.S. if you are not John Doe, you might want to use your own name and email

```sh
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```



# one SciNet I will put the data in my $SCRATCH

The line below install's the data - which for a dataset means that we get the "small" data (i.e. the text files)
and the download instructions for the larger files

We can now navigate the dataset like it's a file system and plan our analysis

```sh
cd $SCRATCH
mkdir datalad; cd datalad;

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
