# BIDS example run through

```
Hey Rea,

Great to see you at the conference last month. Here;s the data we talked about for that
new project. We tested 5 participant 4 months apart with diffusion, resting-state and our new favorite task.

The data is organized according to modality. I attached a spreadsheet of the participant demographics for you.

Looking forward to seeing how this project works out!
Cole Labo
```

Set-up for interactive bit.  

```sh
ssh <username>@teach.scinet.utoronto.ca
module load singularity
```

This bit is will allow us to call the BIDS validator on the contents of the current directory

```sh
alias bids-validator='singularity run -H $PWD /scinet/course/ss2019/3/5_neuroimaging/containters/bids-validator.img'
```

This bit will add the raw data to your own scratch folder
```sh
cd $SCRATCH
tar -xzf /scinet/course/ss2019/3/5_neuroimaging/data/ss2019_fake_cole_labo_data.tgz -C $SCRATCH
```

So let's deal with this..

1. it looks like we have some 9 subject and 2 sessions so we can start by making directories for those.

```sh
mkdir cole_labo_bids
cd cole_labo_bids
for subject in "01" "02" "03" "04" "05" "06" "07" "08" "09"; do
  mkdir sub-${subject}
  mkdir sub-${subject}/ses-01
  mkdir sub-${subject}/ses-02
done
```

We have some anatomical data (with no session given) - after email Cole Labo we found out they are all session 1. So let's move them into ses-01/anat folder

These are MPRAGE files (which is a Seimen's name for a T1w sequence). So we they should go in the anat folder with a `T1w` suffix.

```sh
cd $SCRATCH
for subject in "01" "02" "03" "04" "05" "06" "07" "08" "09"; do
  mkdir cole_labo_bids/sub-${subject}/ses-01/anat
  cp cole_labo_data/anat/s${subject}_mprage.nii.gz cole_labo_bids/sub-${subject}/ses-01/anat/sub-${subject}_ses-01_T1w.nii.gz
done
```

## Check with the BIDS-validator

```sh
cd $SCRATCH
bids-validator --ignoreNiftiHeaders cole_labo_bids/
```

We also have some resting state functional data.  Looks like we have datae from both sessions (with se01 for session 1 and se02 for session 2). According to the BIDS spec. This goes in the "func" folder with "task-rest" in the filename.

Note: as this runs - you might notice that one file is missing!

```sh
cd $SCRATCH
for subject in "01" "02" "03" "04" "05" "06" "07" "08" "09"; do
  for session in "01" "02"; do
    mkdir cole_labo_bids/sub-${subject}/ses-${session}/func
    cp cole_labo_data/rest/s${subject}_rest_se${session}.nii.gz cole_labo_bids/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-rest_bold.nii.gz
  done
done
```

We also have data from one task, after calling Dr Labo back, we found out that this task was only aquired in the second session (ses-02). Let's copy it there.

```sh
cd $SCRATCH
for subject in "01" "02" "03" "04" "05" "06" "07" "08" "09"; do
    session="02"
    cp cole_labo_data/happytask/s${subject}_happybold.nii.gz cole_labo_bids/sub-${subject}/ses-${session}/func/sub-${subject}_ses-${session}_task-happy_bold.nii.gz
done
```

Lastly we have the DWI images they belong in a new folder named DWI.

```sh
cd $SCRATCH
for subject in "01" "02" "03" "04" "05" "06" "07" "08" "09"; do
  for session in "01" "02"; do
    mkdir cole_labo_bids/sub-${subject}/ses-${session}/dwi
    cp cole_labo_data/DWI/s${subject}_dti_se${session}.nii.gz cole_labo_bids/sub-${subject}/ses-${session}/dwi/sub-${subject}_ses-${session}_dwi.nii.gz
    cp cole_labo_data/DWI/s${subject}_dti_se${session}.bvec cole_labo_bids/sub-${subject}/ses-${session}/dwi/sub-${subject}_ses-${session}_dwi.bvec
    cp cole_labo_data/DWI/s${subject}_dti_se${session}.bval cole_labo_bids/sub-${subject}/ses-${session}/dwi/sub-${subject}_ses-${session}_dwi.bval
  done
done
```

We add a README..

```sh
nano README
```

```
This dataset was share with us from Dr Cole Laborator

It includes the Happy task
```

We add a dataset_description.json

```sh
nano dataset_description.json
```

Then copy this inside

```
{
    "BIDSVersion": "1.0.0",
    "Name": "Fake Happy Task",
    "Authors": ["Labo, C.", "Search, R"]
}


```

Note to users:

This is a fake datasets, some of the real nifti images came from the NKI Rockland Serial Scanning Initiative.
Most of the "data" are acutally empty files made to look like a neuroimaging datasets.

2475376 --> s01
3313349 --> s02
3893245 --> s03

```sh
cd /scratch/edickie/ss2019_bids_example_data/super_raw/
 2007  ls
 2008  tar xvf 2475376.tgz
 2009  tar xvf 3313349.tgz
 2010  tar xvf 3893245.tgz
 2011  cd ../
 2012  mkdir cole_labo_data
 2013  cd cole_labo_data/
 2014  ls
 2015* mkdir
 2016  mkdir anat
 2017  mkdir happytask
 2018  mkdir sadtask
 2019  mkdir DWI
 2020  ls
 2021  cd anat/
 2022  cp ../../super_raw/2475376/anat/mprage.nii.gz 2475376_mprage.nii.gz
 2023  cp ../../super_raw/3313349/anat/mprage.nii.gz 3313349_mprage.nii.gz
 2024  cp ../../super_raw/3313349/anat/mprage.nii.gz s02_mprage.nii.gz
 2025  cp ../../super_raw/2475376/anat/mprage.nii.gz s01_mprage.nii.gz
 2026  cp ../../super_raw/3893245/anat/mprage.nii.gz s03_mprage.nii.gz
 2027  ls
 2028  rm 2475376_mprage.nii.gz
 2029  rm 3313349_mprage.nii.gz
 2030  ls
 2031  touch s0[3-9]_mprage.nii.gz
 2032  ls
 2033  echo s0{3-9}
 2034  echo s0[3-9]
 2035  echo s0{3..9}_mprage.nii.gz
 2036  touch s0{3..9}_mprage.nii.gz
 2037  ls
 2038  cd ../
 2039  ls
 2040  cd DWI
 2041  ls
 2042  cp ../../super_raw/2475376/session1/DTI_mx_137/dti.nii.gz s01_dti_se01.nii.gz
 2043  cp ../../super_raw/2475376/session1/DTI_mx_137/dti.nii.gz s01_dti_se01.bvec
 2044  cp ../../super_raw/2475376/session1/DTI_mx_137/dti.bvec s01_dti_se01.bvec
 2045  cp ../../super_raw/2475376/session1/DTI_mx_137/dti.bval s01_dti_se01.bval
 2046  cp ../../super_raw/2475376/session2/DTI_mx_137/dti.bval s01_dti_se02.bval
 2047  cp ../../super_raw/2475376/session2/DTI_mx_137/dti.bvec s01_dti_se02.bvec
 2048  cp ../../super_raw/2475376/session2/DTI_mx_137/dti.nii.gz s01_dti_se02.nii.gz
 2049  cp ../../super_raw/3313349/session2/DTI_mx_137/dti.nii.gz s02_dti_se02.nii.gz
 2050  cp ../../super_raw/3313349/session2/DTI_mx_137/dti.bvec s02_dti_se02.bvec
 2051  cp ../../super_raw/3313349/session2/DTI_mx_137/dti.bval s02_dti_se02.bval
 2052  cp ../../super_raw/3313349/session1/DTI_mx_137/dti.bval s02_dti_se01.bval
 2053  cp ../../super_raw/3313349/session1/DTI_mx_137/dti.bvec s02_dti_se01.bvec
 2054  cp ../../super_raw/3313349/session1/DTI_mx_137/dti.nii.gz s02_dti_se01.nii.gz
 2055  cp ../../super_raw/3893245/session1/DTI_mx_137/dti.nii.gz s03_dti_se01.nii.gz
 2056  cp ../../super_raw/3893245/session2/DTI_mx_137/dti.nii.gz s03_dti_se02.nii.gz
 2057  cp ../../super_raw/3893245/session2/DTI_mx_137/dti.bval s03_dti_se02.bval
 2058  cp ../../super_raw/3893245/session2/DTI_mx_137/dti.bvec s03_dti_se02.bvec
 2059  ls
 2060  touch s0{4..9}_dti_se01.nii.gz
 2061  touch s0{4..9}_dti_se02.nii.gz
 2062  touch s0{4..9}_dti_se02.bvec
 2063  touch s0{4..9}_dti_se02.bval
 2064  touch s0{4..9}_dti_se01.bvec
 2065  touch s0{4..9}_dti_se01.bval
 2066  ls
 2067  cd ../rest/
 2068  ls
 2069  cp ../../super_raw/3893245/session1/RfMRI_std_2500/rest.nii.gz s03_rest_se01.nii.gz
 2070  cp ../../super_raw/3893245/session2/RfMRI_std_2500/rest.nii.gz s03_rest_se02.nii.gz
 2071  cp ../../super_raw/3313349/session2/RfMRI_std_2500/rest.nii.gz s02_rest_se02.nii.gz
 2072  cp ../../super_raw/3313349/session1/RfMRI_std_2500/rest.nii.gz s02_rest_se01.nii.gz
 2073  cp ../../super_raw/2475376/session1/RfMRI_std_2500/rest.nii.gz s01_rest_se01.nii.gz
 2074  cp ../../super_raw/2475376/session2/RfMRI_std_2500/rest.nii.gz s01_rest_se02.nii.gz
 2075  ls
 2076  touch s0{4..9}_rest_se01.nii.gz
 2077  touch s0{4..9}_rest_se02.nii.gz
 2078  ls
 2079  rm s08_rest_se02.nii.gz
 2080  ls
 2081  cd ../
 2082  ls
 2083  rmdir sadtask/
 2084  ls
 2085  cd happytask/
 2086  ls
 2087  cp ../../super_raw/2475376/TfMRI_breathHold_1400/func.nii.gz s01_happybold.nii.gz
 2088  cp ../../super_raw/3313349/TfMRI_breathHold_1400/func.nii.gz s02_happybold.nii.gz
 2089  cp ../../super_raw/3893245/TfMRI_breathHold_1400/func.nii.gz s03_happybold.nii.gz
 2090  ls
 2091  touch s0{5..9}_happybold.nii.gz
 2092  ls
 2093  cd ../
 2094  ;s
 2095  ls
 2096  ls -R
 2097  cd ../
 2098  ls
 2099  du -sh cole_labo_data/
 2100  tar czf ss2019_fake_cole_labo_data.tgz cole_labo_data/
 2101  ls
 2102  rsync -av ss2019_fake_cole_labo_data.tgz edickie@niagara.scinet.utoronto.ca:/scinet/course/ss2019/3/data/

```

```sh
neurodocker generate singularity --base=debian:stretch --pkg-manager=apt \
  --neurodebian os_codename=stretch server=usa-nh \
  --install datalad
```
