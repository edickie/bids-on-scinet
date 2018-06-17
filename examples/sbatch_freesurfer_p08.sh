#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:00:00
#SBATCH --job-name freesurfer_p08
#SBATCH --output=freesurfer_p08_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity
module load gnu-parallel/20180322

dataset="ds000003"
export freesufer_license=$HOME/.licenses/freesurfer/license.txt

## build the mounts
sing_home=$SCRATCH/sing_home/freesurfer
outdir=$SCRATCH/bids_outputs/${dataset}/freesurfer_p08

mkdir -p ${sing_home} ${outdir}

parallel -j 8 "singularity run \
  -H ${sing_home} \
  -B $SCRATCH/datalad/${dataset}:/bids \
  -B ${outdir}:/output \
  -B ${freesufer_license}:/freesurfer_license.txt \
  /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/bids_freesurfer_v6.0.1-4-2018-04-22-77961085015a.img \
      /bids /output participant \
      --participant_label {} \
      --n_cpus 10 \
      --license_file /freesurfer_license.txt" \
      ::: "01" "02" "03" "04" "05" "06" "07" "08"
