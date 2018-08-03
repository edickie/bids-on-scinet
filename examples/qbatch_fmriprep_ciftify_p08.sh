#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:00:00
#SBATCH --job-name ciftify_p08
#SBATCH --output=ciftify_p08_%j.txt


module load singularity
module load gnu-parallel/20180322


export freesufer_license=$HOME/.licenses/freesurfer/license.txt
export ciftify_container=/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/tigrlab_fmriprep_ciftify_1.1.2-2.0.9-2018-07-31-d0ccd31e74c5.img

## build the mounts
dataset="ds000003"
bids_input=$SCRATCH/datalad/${dataset}
sing_home=$SCRATCH/sing_home/ciftify/$dataset
outdir=$SCRATCH/bids_outputs/${dataset}/fmriprep_p05
workdir=$BBUFFER/fmriprep_p05/${dataset}

mkdir -p ${sing_home} ${outdir} ${workdir}

#trap the termination signal, and call the function 'trap_term' when
# that happens, so results may be saved.
## note..due to a silly bug in datman..the folder above the workdir needs to be readable
cd ${outdir}/fmriprep; ls -1d sub* | sed 's/sub-//g' | \
  parallel -j "echo singularity run \
    -H ${sing_home} \
    -B ${bids_input}:/bids \
    -B ${outdir}:/output \
    -B ${freesufer_license}:/freesurfer_license.txt \
    -B ${BBUFFER}:/bbuffer \
    ${ciftify_container} \
        /bids /output participant \
        --participant_label={} \
        --fmriprep-workdir /bbuffer/fmriprep_p05/${dataset} \
        --fs-license /freesurfer_license.txt \
        --n_cpus 10 \
        --fmriprep-args='--use-aroma'" | \
      qbatch \
       --walltime 11:00:00 --nodes 1 --ppj 80 \
       --chunksize 8 --cores 8 \
       --workdir $sing_home \
       --jobname ${dataset}_ciftify \
       --env none --header "module load singularity gnu-parallel/20180322" \
       -
