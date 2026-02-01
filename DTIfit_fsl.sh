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

while IFS=',' read -r PTID TIME_S
do
	TIME_S="${TIME_S//[$'\r\n']/}"
	orig_seq=${orig_path}/${PTID}/DTI/${TIME_S}
	eddy_path=${prep_path}/${PTID}/DTI/${TIME_S}/eddy

	mkdir -p ${prep_path}/${PTID}/DTI/${TIME_S}/DTIfit/DTI
	dtifit --data=${eddy_path}/DTI_eddy.nii.gz --bvecs=${eddy_path}/DTI_eddy.eddy_rotated_bvecs --bvals=${orig_seq}/DTI.bval --mask=${orig_seq}/DTI_b0brain_mask.nii.gz \
		--out=${prep_path}/${PTID}/DTI/${TIME_S}/DTIfit/DTI


done < ${code_path}/T1WI/Subject_T1WI_surf.txt
