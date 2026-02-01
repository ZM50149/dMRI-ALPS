library(openxlsx)
library(ggplot2)
library(palmerpenguins)
library(gghalves)
library(ggdist)
library(tidyverse)
library(ggforce)
library(ggpubr)
library(ggpmisc)
library(psych)
library(fdapace)
library(rainbow)
library(tableone)
library(survey)


# Load data
main_path <- '~'
Feature_All <- read.xlsx(file.path(main_path, 'Data.xlsx'), sheet = 1)

# Data Transformation
num <- c("AGE", "PTEDUCAT", 
         "MMSE", "MOCA", "FAQ", "CDRSB", "RAVLT_immediate", "RAVLT_learning", "RAVLT_forgetting", "RAVLT_perc_forgetting", 
         "ADAS11", "ADAS13", "ADASQ4", "LDELTOTAL", "TRABSCOR", 
         "ABETA_bl", "TAU_bl", "PTAU_bl", "FDG_bl", "PIB_bl", "AV45_bl", "FBB_bl", "ABETA_IMG", 
         "FreeWater","DTI_alps_l", "DTI_alps_r", "DTI_alps_mean", "DKI_alps_l", "DKI_alps_r", "DKI_alps_mean", "DTI_psmd", "DKI_psmd")
Feature_All[num] <- lapply(Feature_All[num], as.numeric)

fac <- c("DX_a", "PTGENDER", "APOE4")
Feature_All[fac] <- lapply(Feature_All[fac], as.factor)


# Creat tables
sum_vars <- c("AGE", "PTGENDER", "PTEDUCAT","APOE4", 
              "MMSE", "MOCA", "FAQ", "CDRSB", 
              "RAVLT_immediate", "RAVLT_learning", "RAVLT_forgetting", "RAVLT_perc_forgetting", 
              "ADAS11", "ADAS13", "ADASQ4", "LDELTOTAL", "TRABSCOR", 
              "ABETA_bl", "TAU_bl", "PTAU_bl", "FDG_bl", "PIB_bl", "AV45_bl", "FBB_bl", "ABETA_IMG", 
              "DTI_alps_l", "DTI_alps_r", "DTI_alps_mean", "DKI_alps_l", "DKI_alps_r", "DKI_alps_mean",
              "DTI_psmd", "FreeWater")
fac_vars <- c("PTGENDER", "APOE4")

mydata <- Feature_All

Result_Table_1 <- CreateTableOne(strata="Group", vars=sum_vars, factorVars=fac_vars, data=mydata,
                                 test=TRUE, smd=TRUE, addOverall=TRUE)
Tab1 <- print(Result_Table_1,
              showAllLevels = TRUE, catDigits=2, contDigits=2, pDigits=3, test=TRUE, smd=TRUE, noSpaces=TRUE)
write.csv(Tab1,file=file.path(main_path, 'Results/Table_1.csv'))


# violin plot 
load('Violinplot_function.R')
mydata <- Feature_All
p <- vio_f(mydata,  'DKI_alps_mean')
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_DKI_alps_mean.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

p <- vio_f(mydata,  'DKI_alps_l')
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_DKI_alps_l.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

p <- vio_f(mydata,  'DKI_alps_r')
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_DKI_alps_r.pdf"),
       plot = p, width = 8, height = 6,bg = "white")


p <- vio_f(mydata,  'DTI_psmd')
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_DKI_psmd.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

# Glm
mydata <- Feature_All
fit_dti <- glm(DTI_alps_mean~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_dki <- glm(DKI_alps_mean~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_psmd <- glm(DTI_psmd~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_fw <- glm(FreeWater~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())

fit_dti1 <- glm(DTI_alps_mean~AGE+PTGENDER+PTEDUCAT+DTI_psmd+FreeWater, data=mydata, family=gaussian())
fit_dki1 <- glm(DKI_alps_mean~AGE+PTGENDER+PTEDUCAT+DTI_psmd+FreeWater, data=mydata, family=gaussian())


fit_dtil <- glm(DTI_alps_l~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_dkil <- glm(DKI_alps_l~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_dtil1 <- glm(DTI_alps_l~AGE+PTGENDER+PTEDUCAT+DTI_psmd+FreeWater, data=mydata, family=gaussian())
fit_dkil1 <- glm(DKI_alps_l~AGE+PTGENDER+PTEDUCAT+DTI_psmd+FreeWater, data=mydata, family=gaussian())
fit_dtir <- glm(DTI_alps_r~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_dkir <- glm(DKI_alps_r~AGE+PTGENDER+PTEDUCAT, data=mydata, family=gaussian())
fit_dtir1 <- glm(DTI_alps_r~AGE+PTGENDER+PTEDUCAT+DTI_psmd+FreeWater, data=mydata, family=gaussian())
fit_dkir1 <- glm(DKI_alps_r~AGE+PTGENDER+PTEDUCAT+DTI_psmd+FreeWater, data=mydata, family=gaussian())

mydata[,'res_dti'] <- residuals(fit_dti, type="deviance")
mydata[,'res_dki'] <- residuals(fit_dki, type="deviance")
mydata[,'res_psmd'] <- residuals(fit_psmd, type="deviance")
mydata[,'res_fw'] <- residuals(fit_fw, type="deviance")
mydata[,'res_dti1'] <- residuals(fit_dti1, type="deviance")
mydata[,'res_dki1'] <- residuals(fit_dki1, type="deviance")

mydata[,'res_dtil'] <- residuals(fit_dtil, type="deviance")
mydata[,'res_dkil'] <- residuals(fit_dkil, type="deviance")
mydata[,'res_dtil1'] <- residuals(fit_dtil1, type="deviance")
mydata[,'res_dkil1'] <- residuals(fit_dkil1, type="deviance")

mydata[,'res_dtir'] <- residuals(fit_dtir, type="deviance")
mydata[,'res_dkir'] <- residuals(fit_dkir, type="deviance")
mydata[,'res_dtir1'] <- residuals(fit_dtir1, type="deviance")
mydata[,'res_dkir1'] <- residuals(fit_dkir1, type="deviance")


# plot residual
p <- vio_f(mydata,'res_dti')
p
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_res_dti.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

p <- vio_f(mydata,'res_dki')
p
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_res_dki.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

p <- vio_f(mydata,'res_psmd')
p
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_res_psmd.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

p <- vio_f(mydata,'res_fw')
p
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_res_fw.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

p <- vio_f(mydata,'res_dti1')
p
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_res_dti1.pdf"),
       plot = p, width = 8, height = 6,bg = "white")


# correlation analysis
load('Corplot_function.R')
corplot_f(Feature_All, "ABETA_IMG", "DKI_alps_mean")
corplot_f(Feature_All, "res_dti1", "res_dki1")

load('corr_function.R')
corr_DTIalpsm <- corr_f(mydata, 'DTI_alps_mean')
corr_DTIalpsl <- corr_f(mydata,  'DTI_alps_l')
corr_DTIalpsr <- corr_f(mydata, 'DTI_alps_r')
corr_DKIalpsm <- corr_f(mydata, 'DKI_alps_mean')
corr_DKIalpsl <- corr_f(mydata, 'DKI_alps_l')
corr_DKIalpsr <- corr_f(mydata, 'DKI_alps_r')
corr_DTIpsmd <- corr_f(mydata, 'DKI_psmd')
corr_freewater <- corr_f(mydata,  'FreeWater')

corr_df <- rbind(corr_DTIalpsm, corr_DTIalpsl, corr_DTIalpsr, 
                 corr_DKIalpsm, corr_DKIalpsl, corr_DKIalpsr,
                 corr_DTIpsmd,corr_freewater)
