# running the ZHH data on the SCC


```sh
ssh dev02
bids_dir=/KIMEL/tigrlab/scratch/dmiranda/BIDS_ZHH
outputdir=/KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep/
sing_home=/KIMEL/tigrlab/scratch/edickie/saba_PINT/sing_home
mkdir -p $sing_home


SIDlist=`cd ${bids_dir}; ls -1d sub* | sed 's/sub-//g'`
cd /KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep
mkdir -p ZHH/out ZHH/work ZHH/logs
cd $sing_home
for SID in $SIDlist; do
  subject=$SID
  echo singularity run -H ${sing_home}:/myhome \
    -B ${bids_dir}:/input \
    -B ${outputdir}:/output \
    -B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
    /KIMEL/tigrlab/archive/code/containers/FMRIPREP_CIFTIFY/tigrlab_fmriprep_ciftify_1.1.2-2.0.9-2018-07-31-d0ccd31e74c5.img \
    /input /output/ZHH/out participant \
    --participant_label=$SID \
    --fmriprep-workdir /output/ZHH/work \
    --fs-license /license_file.txt \
    --n_cpus 4 \
    --fmriprep-args="--use-aroma"  | \
    qsub -l walltime=23:00:00,nodes=1:ppn=4 -N ciftify_$SID -j oe -o ${outputdir}/ZHH/logs;
done
```

## but..23hrs may not have been enough for many subjects..

so we need a script to delete half completed outputs and rerun

There are three types of half completed outputs..

1. freesurfer is still running
    + in which case we need to delete `*Running` file as well as ciftify outputs
2. ciftify_recon_all didn't finish
    + we need to delete all ciftify outputs for that participant
    + if this is due to unifinished freesurfer we should remove the `*IsRunning`
3. ciftify_subject_fmri didn't finish
    + we need to delete the fmri/Results for this person

Then we can just rerun all participants to insure that all qc images are generated..

## 1. remove downstream from unifinished recon_all..

Note: if recon_all did finish..it is on the output folder..if not it is in the workdir..

```sh
outdir=/KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep/ZHH/out/
doneReconAll=`cd ${outdir}/freesurfer ; ls -1d sub* | sort`

for subject in $doneReconAll; do
 cralog_lastline=`tail -3 ${outdir}/ciftify/$subject/cifti_recon_all.log | head -1`
 echo $subject $cralog_lastline
done | grep -v Done

ResultsLogs=`cd ${outdir}/ciftify/sub*/MNINonLinear/Results/*/*.log`
```
