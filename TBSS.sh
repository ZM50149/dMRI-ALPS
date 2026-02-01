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

#while IFS=',' read -r PTID TIME_S
#do
#	TIME_S="${TIME_S//[$'\r\n']/}"
#	orig_seq=${prep_path2}/${PTID}/DTI/${TIME_S}/DTI_fa.nii.gz
#	prep_seq=${main_path2}/Manuscripts_MultiNet/Data_TBSS/${PTID}-${TIME_S}_FA.nii.gz
#	cp ${orig_seq} ${prep_seq}

#done < ${main_path2}/Manuscripts_MultiNet/Code/Subject_T1WI_surf.txt

cd ${main_path2}/Manuscripts_MultiNet/Data_TBSS

#tbss_1_preproc *.nii.gz
#tbss_2_reg -T
tbss_3_postreg -S
tbss_4_prestats 0.2

# tbss_non_FA MD
