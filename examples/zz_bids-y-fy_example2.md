# BIDS example run through

```
Hey Rea,

Great to see you at the conference last month. Here;s the data we talked about for that
new project. We tested 5 participant 4 months apart with diffusion, resting-state and our new favourite task.

The data is organized according to modality. I attached a spreadsheet of the participant demographics for you.

Looking forward to seeing how this project works out!
Cole Labo
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
