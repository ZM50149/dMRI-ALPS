#!/bin/bash

main_path="/mnt/f/Project_AD"
code_path=${main_path}/Code
orig_path=${main_path}/Data_orig
prep_path=${main_path}/Data_prep
proc_path=${main_path}/Data_proc

mni_path=${main_path}/Data_template/MNI152/FMRIB58_FA_1mm.nii.gz

while IFS=',' read -r PTID TIME_S
do
	TIME_S="${TIME_S//[$'\r\n']/}"
	fit_path=${prep_path}/${PTID}/DTI/${TIME_S}/FWDKIfit
	echo ${fit_path}

	ants_path=${prep_path}/${PTID}/DTI/${TIME_S}/DTIfit_ANTs

	# FRACTION
	antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DKI_fraction.nii.gz -o ${fit_path}/DTI_frac_ants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n Gaussian

	# evec1
	# antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DKI_evec1.nii.gz -o ${fit_path}/DTI_evec1ants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor

	# DTI_tensor
	# antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DKI_tensor.nii.gz -o ${fit_path}/DTI_tensorants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor
	
	# DTI_MD
	# antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DKI_MD.nii.gz -o ${fit_path}/DTI_MDants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor

done < ${code_path}/DTI/Subject_DKI.txt
