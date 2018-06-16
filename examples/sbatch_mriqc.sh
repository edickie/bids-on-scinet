#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --time=2:00:00
#SBATCH --job-name mri_qc
#SBATCH --output=log_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity

dataset="ds000003"

## build the mounts
mkdir -p $SCRATCH/sing_home/mri_qc
mkdir -p $SCRATCH/bids_outputs/${dataset}/mriqc
mkdir -p $SCRATCH/bids_work/${dataset}/mriqc


singularity run \
-H $SCRATCH/sing_home/mri_qc \
-B $SCRATCH/datalad/${dataset}/:/bids/ \
-B $SCRATCH/bids_outputs/${dataset}/mriqc:/output \
-B $SCRATCH/bids_work/${dataset}/mriqc:/work \
/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_mriqc_0.11.0-2018-06-05-1e4ac9792325.img \
    /bids /output participant \
    --no-sub --n_procs 40 --profile \
    -w /work

singularity run \
  -H $SCRATCH/sing_home/mri_qc \
  -B $SCRATCH/datalad/${dataset}/:/bids/ \
  -B $SCRATCH/bids_outputs/${dataset}/mriqc:/output \
  -B $SCRATCH/bids_work/${dataset}/mriqc:/work \
  /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_mriqc_0.11.0-2018-06-05-1e4ac9792325.img \
      /bids /output group \
      --no-sub --n_procs 40 --profile \
      -w /work
