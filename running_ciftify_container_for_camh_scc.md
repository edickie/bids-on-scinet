# running the ZHH data on the SCC


```sh
ssh dev01
bids_dir=/KIMEL/tigrlab/scratch/dmiranda/BIDS_ZHH
scc_scratch=/imaging/scratch/kimel/edickie/
sing_home=/imaging/scratch/kimel/edickie/sing_home
outputdir=/KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep
mkdir -p $sing_home


SIDlist=`cd ${bids_dir}; ls -1d sub* | sed 's/sub-//g'`
cd /KIMEL/tigrlab/scratch/edickie/saba_PINT/ciftify_fmriprep
cd $sing_home
for SID in $SIDlist; do
subject=$SID


echo singularity run -H ${sing_home}:/home -B ${bids_dir}:/input \
-B ${outputdir}:/output \
-B /quarantine/Freesurfer/6.0.0/freesurfer/license.txt:/license_file.txt \
-B ${scc_scratch}:/work \
/KIMEL/tigrlab/archive/code/containers/FMRIPREP_CIFTIFY/tigrlab_fmriprep_ciftify_1.1.2-2.0.9-2018-07-31-d0ccd31e74c5.img \
/input /output participant \
--participant_label=$SID \
--fmriprep-workdir /work/ZHH_work \
--fs-license /license_file.txt \
--n_cpus 4 \
--fmriprep-args="--use-aroma" --debug --dry-run # | qsub -l walltime=0:23:00,nodes=1:ppn=4 -N ciftify_$SID -j oe -o /KIMEL/tigrlab/scratch/dmiranda/ZHH_FMRIPrep/logs/$SID;
done
```
