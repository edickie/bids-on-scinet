#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --time=11:00:00
#SBATCH --job-name fmriprep
#SBATCH --output=fmripreplog_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity

dataset="ds000003"
freesufer_license=$HOME/.licenses/freesurfer/license.txt

## build the mounts
mkdir -p $SCRATCH/bids_outputs/${dataset}/mriqc

singularity run \
-H $SLURM_SUBMIT_DIR \
-B $SCRATCH/datalad/${dataset}:/bids \
-B $SCRATCH/bids_outputs/${dataset}/mriqc:/output \
-B ${freesufer_license}:freesurfer_license.txt \
/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img \
    /bids /output participant \
    --anat-only --n_procs 40 --output-space T1w template \
    --notrack --fs-license-file freesurfer_license.txt --resource-monitor 
