#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --time=11:00:00
#SBATCH --job-name fmriprep
#SBATCH --output=fmripreplog_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity

dataset="ds000003"
export freesufer_license=$HOME/.licenses/freesurfer/license.txt

## build the mounts
mkdir -p $SCRATCH/sing_home/fmriprep
mkdir -p $SCRATCH/bids_outputs/${dataset}/fmriprep
mkdir -p $SCRATCH/bids_work/${dataset}/fmriprep

# singularity run \
# -H $SCRATCH/sing_home/fmriprep \
# -B $SCRATCH/datalad/${dataset}:/bids \
# -B $SCRATCH/bids_outputs/${dataset}/mriqc:/output \
# -B ${freesufer_license}:/freesurfer_license.txt \
# -B $SCRATCH/bids_work/${dataset}/mriqc:/work \
# /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img \
#     /bids /output participant \
#     --participant_label 01 \
#     --anat-only \
#     --nthreads 4 \
#     --output-space T1w template \
#     --work-dir /work \
#     --notrack --fs-license-file /freesurfer_license.txt --resource-monitor

singularity run \
  -H $SCRATCH/sing_home/fmriprep \
  -B $SCRATCH/datalad/${dataset}:/bids \
  -B $SCRATCH/bids_outputs/${dataset}/fmriprep:/output \
  -B ${freesufer_license}:/freesurfer_license.txt \
  -B $SCRATCH/bids_work/${dataset}/fmriprep:/work \
  /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img \
      /bids /output participant \
      --anat-only \
      --nthreads 40 \
      --output-space T1w template \
      --work-dir /work \
      --notrack --fs-license-file /freesurfer_license.txt --resource-monitor
