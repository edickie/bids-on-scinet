#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:00:00
#SBATCH --job-name fmriprep
#SBATCH --output=fmripreplog_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity

dataset="ds000003"
export freesufer_license=$HOME/.licenses/freesurfer/license.txt

## build the mounts
sing_home=$SCRATCH/sing_home/fmriprep
outdir=$SCRATCH/bids_outputs/${dataset}/fmriprep_m10
workdir=$SCRATCH/bids_work/${dataset}/fmriprep_m10

mkdir -p ${sing_home} ${outdir} ${workdir}
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
  -H ${sing_home} \
  -B $SCRATCH/datalad/${dataset}:/bids \
  -B ${outdir}:/output \
  -B ${freesufer_license}:/freesurfer_license.txt \
  -B ${workdir}:/work \
  /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img \
      /bids /output participant \
      --participant_label 01 02 03 04 05 06 07 08 09 10 \
      --anat-only \
      --nthreads 80 \
      --omp-nthreads 8 \
      --output-space T1w template \
      --work-dir /work \
      --notrack --fs-license-file /freesurfer_license.txt --resource-monitor
