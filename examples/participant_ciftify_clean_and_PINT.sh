#!/bin/bash

# This is an example of a script that will three post-processing ciftify functions using singularity exec

# The three functions are:
# ciftify_clean_img - to denoise and smooth the scans
# ciftify_PINT_vertices - to run PINT
# cifti_vis_PINT - to build PINT qc pages

#SBATCH --nodes=1
#SBATCH --cpus-per-task=80
#SBATCH --time=11:00:00
#SBATCH --job-name ciftify_p08
#SBATCH --output=ciftify_p08_%j.txt

subject="sub-02"
func_base="task-rhymejudgment_bold"
## build the mounts
dataset="ds000003"
sing_home=$SCRATCH/sing_home/ciftify/$dataset
outdir=$SCRATCH/bids_outputs/${dataset}/fmriprep_p05

module load singularity
module load gnu-parallel/20180322

export ciftify_container=/scinet/course/ss2018/3_bm/2_imageanalysis/singularity_containers/tigrlab_fmriprep_ciftify_1.1.2-2.0.9-2018-07-31-d0ccd31e74c5.img



mkdir -p ${outdir}/ciftify_clean_img/${subject}

# Step 1. Run the cleaning and smoothing script
# note: before calling this script, you need to place a clean_config file into ${outdir}/ciftify_clean_img
#       sample clean_config.json files can be found in https://github.com/edickie/ciftify/tree/master/ciftify/data/cleaning_configs
#    example: cp ~/code/ciftify/ciftify/data/cleaning_configs/24MP_8Phys_4GSR.json ${outdir}/ciftify_clean_img
# In this case I manually edited to be:
# {
#   "--detrend": true,
#   "--standardize": true,
#   "--cf-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--cf-sq-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--cf-td-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--cf-sqtd-cols": "X,Y,Z,RotX,RotY,RotZ,CSF,WhiteMatter,GlobalSignal",
#   "--low-pass": 0.1,
#   "--high-pass": 0.01,
#   "--drop-dummy-TRs": 3,
#   "--smooth-fwhm": 8
#  }

singularity exec \
    -H ${sing_home} \
    -B ${outdir}:/output \
    ${ciftify_container} ciftify_clean_img \
        --output-file=/output/ciftify_clean_img/${subject}/${subject}_${func_base}_desc-clean_bold.dtseries.nii \
        --clean-config=/output/ciftify_clean_img/24MP_8Phys_4GSR.json \
        --confounds-tsv=/output/fmriprep/${subject}/func/${subject}_${func_base}_confounds.tsv \
        --left-surface=/output/ciftify/${subject}/MNINonLinear/fsaverage_LR32k/${subject}.L.midthickness.32k_fs_LR.surf.gii \
        --right-surface=/output/ciftify/${subject}/MNINonLinear/fsaverage_LR32k/${subject}.R.midthickness.32k_fs_LR.surf.gii \
        /output/ciftify/${subject}/MNINonLinear/Results/${func_base}/${func_base}_Atlas_s0.dtseries.nii

# Step 2. Run PINT, this will run with the default radii or 6 6 12

mkdir -p ${outdir}/ciftify_PINT/${subject}
# for simplicity I have also moved the PINT <input-vertices.csv> file into this folder
# example: cp ~/code/ciftify/ciftify/data/PINT/Yeo7_2011_80verts.csv ${outdir}/ciftify_PINT/
singularity exec \
    -H ${sing_home} \
    -B ${outdir}:/output \
    ${ciftify_container} ciftify_PINT_vertices --pcorr \
      /output/ciftify_clean_img/${subject}/${subject}_${func_base}_desc-clean_bold.dtseries.nii \
      /output/ciftify/${subject}/MNINonLinear/fsaverage_LR32k/${subject}.L.midthickness.32k_fs_LR.surf.gii \
      /output/ciftify/${subject}/MNINonLinear/fsaverage_LR32k/${subject}.R.midthickness.32k_fs_LR.surf.gii \
      /output/ciftify_PINT/Yeo7_2011_80verts.csv \
      /output/ciftify_PINT/${subject}/${subject}_${func_base}_desc-clean_bold

# Step 3. Generate PINT QC
singularity exec \
    -H ${sing_home} \
    -B ${outdir}:/output \
    ${ciftify_container} cifti_vis_PINT subject \
      --ciftify-work-dir /output/ciftify/ \
      --qcdir /output/ciftify_PINT/qc \
      /output/ciftify_clean_img/${subject}/${subject}_${func_base}_desc-clean_bold.dtseries.nii \
      ${subject} \
      /output/ciftify_PINT/${subject}/${subject}_${func_base}_desc-clean_bold_summary.csv
