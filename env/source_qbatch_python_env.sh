# source the conda env with nothing but qbatch in it
source activate /scinet/course/ss2018/3_bm/2_imageanalysis/qbatch_env

## set these environment variables as presets
export QBATCH_PPJ=40                   # requested processors per job
export QBATCH_CHUNKSIZE=$QBATCH_PPJ    # commands to run per job
export QBATCH_CORES=$QBATCH_PPJ        # commonds to run in parallel per job
export QBATCH_NODES=1                  # number of compute nodes to request for the job, typically for MPI jobs
export QBATCH_MEM="0"                  # requested memory per job
export QBATCH_MEMVARS="mem"            # memory request variable to set
export QBATCH_SYSTEM="slurm"           # queuing system to use ("pbs", "sge","slurm", or "local")
export QBATCH_QUEUE=""             # Name of submission queue
export QBATCH_OPTIONS=""               # Arbitrary cluster options to embed in all jobs
export QBATCH_SCRIPT_FOLDER=".qbatch/" # Location to generate jobfiles for submission
export QBATCH_SHELL="/bin/sh"          # Shell to use to evaluate jobfile
