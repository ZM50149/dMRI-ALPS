#!/bin/bash

main_path="/mnt/f/Project_AD"
code_path=${main_path}/Code
orig_path=${main_path}/Data_orig
prep_path=${main_path}/Data_prep
proc_path=${main_path}/Data_proc

main_path2="/mnt/g/Project_AD"
code_path2=${main_path2}/Code
orig_path2=${main_path2}/Data_orig
prep_path2=${main_path2}/Data_prep
proc_path2=${main_path2}/Data_proc

mni_path=${main_path2}/Data_template/MNI152/FMRIB58_FA_1mm.nii.gz

while IFS=',' read -r PTID TIME_S
do
	TIME_S="${TIME_S//[$'\r\n']/}"
	fit_path=${prep_path2}/${PTID}/DTI/${TIME_S}
	echo ${fit_path}

	ants_path=${prep_path2}/${PTID}/DTI/${TIME_S}/DTIfit_ANTs
	mkdir -p ${ants_path}

	antsRegistrationSyN.sh -d 3 -f ${mni_path} -m ${fit_path}/DTI_fa.nii.gz -o ${ants_path}/DTI_FAants_ -n 10
	
	# DTI_tensor
	antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DTI_tensor.nii.gz -o ${ants_path}/DTI_tensorants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor
	# DTI_AD
	antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DTI_ad.nii.gz -o ${ants_path}/DTI_ADants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor
	# DTI_V
#	antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DTI_V1.nii.gz -o ${ants_path}/DTI_V1ants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor
#	antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DTI_V2.nii.gz -o ${ants_path}/DTI_V2ants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor
#	antsApplyTransforms -d 3 -e 3 -i ${fit_path}/DTI_V3.nii.gz -o ${ants_path}/DTI_V3ants.nii.gz -r ${mni_path} -t ${ants_path}/DTI_FAants_1Warp.nii.gz -t ${ants_path}/DTI_FAants_0GenericAffine.mat -n NearestNeighbor

done < ${code_path}/DTI/Subject_DTIants.txt
