#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:00:00
#SBATCH --job-name fmriprep_p05
#SBATCH --output=fmriprep_p05_%j.txt

cd $SLURM_SUBMIT_DIR

module load singularity
module load gnu-parallel/20180322

dataset="ds000003"
export freesufer_license=$HOME/.licenses/freesurfer/license.txt

## build the mounts
sing_home=$SCRATCH/sing_home/fmriprep
outdir=$SCRATCH/bids_outputs/${dataset}/fmriprep_p05
workdir=/dev/shm/work

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

function cleanup_ramdisk {
    echo -n "Cleaning up ramdisk directory /dev/shm/$USER on "
    date
    rm -rf ${workdir}
    echo -n "done at "
    date
}

#trap the termination signal, and call the function 'trap_term' when
# that happens, so results may be saved.
trap cleanup_ramdisk TERM

parallel -j 5 "singularity run \
  -H ${sing_home} \
  -B $SCRATCH/datalad/${dataset}:/bids \
  -B ${outdir}:/output \
  -B ${freesufer_license}:/freesurfer_license.txt \
  -B ${workdir}:/work \
  /scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/poldracklab_fmriprep_1.1.1-2018-06-07-2f08547a0732.img \
      /bids /output participant \
      --participant_label {} \
      --anat-only \
      --nthreads 16 \
      --omp-nthreads 16 \
      --output-space T1w template \
      --work-dir /work \
      --notrack --fs-license-file /freesurfer_license.txt --resource-monitor" \
      ::: "01" "02" "03" "04" "05"

cleanup_ramdisk
