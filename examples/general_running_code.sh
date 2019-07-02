
WALLTIME="24:00:00"
JOBS_PER_NODE=10
CPU_PER_JOB=4
JOBNAME="ciftify"
ALLOC_NAME="sci-alloc"

# put variables for the next bit here
BIDS_DIR=$SCRATCH/datalad/ds000030
OUTPUT_DIR=
SUBMIT_DIR=


mkdir -p sing_home

parallel echo "singularity run --cleanenv \
  -H ${SUBMIT_DIR} \
  -B ${BIDS_DIR}:/input-data \
  -B ${OUTPUT_DIR}:/output \
  -B ${fs_license}:/fs_license.txt \
 ${ciftify_image} \
 /input-data /output participant \
 --participant_label={} \
 --fs-license /fs_license.txt \
 --anat_only --debug --dry-run" ::: ${SUBJECTS} > mycmds.txt \

if ALLOC_NAME=="none"
qbatch --dryrun \
 -b slurm --nodes 1 --ppj 40 \
 --env none --header "module load singularity gnu-parallel" \
 --options "-A myalloc" \
 -w ${WALLTIME} \
 -c ${JOBS_PER_NODE} \
 -j ${CPU_PER_JOB} \
 mycmds.txt
