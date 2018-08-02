#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:00:00
#SBATCH --job-name fmriprep112_p08
#SBATCH --output=fmriprep112_p08_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity
module load gnu-parallel/20180322

dataset="ds000003"
export freesufer_license=$HOME/.licenses/freesurfer/license.txt

## build the mounts
sing_home=$SCRATCH/sing_home/fmriprep
outdir=$SCRATCH/bids_outputs/${dataset}/fmriprep112_p08
workdir=$BBUFFER/${dataset}/fmriprep112_p08

mkdir -p ${sing_home} ${outdir} ${workdir}

## acutally running the tasks (note we are using gnu-parallel to run across participants)
parallel -j 8 "singularity run \
  -H ${sing_home} \
  -B $SCRATCH/datalad/${dataset}:/bids \
  -B ${outdir}:/output \
  -B ${freesufer_license}:/freesurfer_license.txt \
  -B ${workdir}:/workdir \
  /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.2-2018-07-06-c9e7f793549f.img \
      /bids /output participant \
      --participant_label {} \
      --anat-only \
      --nthreads 10 \
      --omp-nthreads 10 \
      --output-space T1w template \
      --work-dir /workdir \
      --notrack --fs-license-file /freesurfer_license.txt" \
      ::: "01" "02" "03" "04" "05" "06" "07" "08"
