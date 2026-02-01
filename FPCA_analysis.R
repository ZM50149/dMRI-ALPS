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
longitudinal_df <- read.xlsx(file.path(main_path, 'Data_longitu.xlsx'), sheet = 1)


time_grid <- seq(
  from = min(longitudinal_df$AGE), # var
  to = max(longitudinal_df$AGE), # var
  length.out = 50
)
ptid_list <- unique(longitudinal_df$PTID)
y_matrix <- matrix(NA, nrow = length(ptid_list), ncol = length(time_grid))


for (i in seq_along(ptid_list)) {
  ptid_data <- longitudinal_df %>% 
    filter(PTID == ptid_list[i]) %>%
    arrange(time_from_baseline)
  
  if(nrow(ptid_data) > 1) {
    approx_values <- approx(ptid_data$AGE, ptid_data$DTI_psmd, 
                            xout = time_grid, 
                            method = "linear", 
                            rule = 2)$y
    y_matrix[i, ] <- approx_values
  }
}

fpca_fds <- fds(
  x = time_grid,          # 相对时间网格
  y = t(y_matrix),        # 转置矩阵（时间点×个体）
  xname = "AGE",
  yname = "DTI psmd Value"
)


Ly <- split(t(fpca_fds$y), seq(ncol(fpca_fds$y)))
Lt <- rep(list(fpca_fds$x), ncol(fpca_fds$y)) 

fpca_result <- FPCA(
  Ly = Ly,
  Lt = Lt,
  optns = list(
    methodMuCovEst = "smooth",   # 平滑协方差估计
    userBwCov = 5,               # 平滑带宽（根据数据调整）
    FVEthreshold = 0.95,         # 保留95%方差的主成分
    verbose = FALSE              # 关闭冗长输出
  )
)

pc_scores <- fpca_result$xiEst
fpca_result$cumFVE
plot(fpca_result, plotPC = TRUE, npc = 2)



# analysis for FPCA
mydata_trag <- read.xlsx(file.path(main_path, 'FPCA_res.xlsx'), sheet = 3)

# creat tabes
sum_vars <- c("DTIV1","DTIV2", "DKIV1", "DKIV2", "PSMDV1", "PSMDV2", "FWV1", "FWV2","PTGENDER", "APOE4")
fac_vars <- c("PTGENDER", "APOE4")
Result_Table_1 <- CreateTableOne(strata="Group", vars=sum_vars, factorVars=fac_vars, data=mydata_trag,
                                 test=TRUE, smd=TRUE, addOverall=TRUE)
Tab1 <- print(Result_Table_1,
              showAllLevels = TRUE, catDigits=2, contDigits=5, pDigits=3, test=TRUE, smd=TRUE, noSpaces=TRUE)

# vlolin plot
load('Violinplot_function.R')
p <- vio_f(mydata_trag, 'DKIV2')
fig_path <- '~/Results'
ggsave(filename =file.path(fig_path, "Violin_DKIV2.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

# cor plot
load('Corplot_function.R')
corplot_f(mydata_trag, "FWV1", "DKIV1")



plot_df <- data.frame(
  PTID = rep(ptid_list, each = length(time_grid)),
  time = rep(time_grid, times = length(ptid_list)),
  value = as.vector(t(y_matrix)),
  group = rep(selected_rows$OS, each = length(time_grid)))

mean_function <- data.frame(
  time = fpca_result$workGrid,
  value = fpca_result$mu,
  type = "MeanFunction")

phi_funcs <- data.frame(
  time = rep(fpca_result$workGrid, 2),
  value = c(fpca_result$phi[,1], fpca_result$phi[,2]),
  component = factor(rep(c("1st FPC", "2nd FPC"), each = length(fpca_result$workGrid))))

y_primary_range <- range(plot_df$value, na.rm = TRUE)
y_secondary_range <- range(phi_funcs$value)

scale_factor <- diff(y_primary_range)/diff(y_secondary_range)
shift_value <- y_primary_range[1] - y_secondary_range[1] * scale_factor

phi_funcs$transformed_value <- phi_funcs$value * scale_factor + shift_value

p <- ggplot() +
  geom_smooth(data = plot_df, aes(x = time, y = value, color = group), method = "loess", se = TRUE ) +
  geom_line(data = mean_function, aes(x = time, y = value), color = "black", linewidth = 1.2, linetype = "solid")+
  geom_line(data = phi_funcs, aes(x = time, y = transformed_value, linetype = component), color = c("darkred","darkblue")[phi_funcs$component], linewidth = 1.2)+
  scale_y_continuous( name = "DTI-ALPS Index", sec.axis = sec_axis(~ (. - shift_value)/scale_factor, name = "Eigenfunction Value"))+
  # theme_minimal(base_size = 14) +
  theme_bw()+ 
  theme(text=element_text(family="serif"),legend.position = "bottom", 
        axis.title.y.right = element_text(color = "darkred"), axis.text.y.right = element_text(color = "darkred"),
        axis.text=element_text(size=20))

ggsave(filename =file.path(fig_path, "Trajectory_wbc.pdf"),
       plot = p, width = 8, height = 6,bg = "white")

