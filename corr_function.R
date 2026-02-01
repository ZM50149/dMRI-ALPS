corr_f <- function(mydata,  var){
  index_CN <- mydata$Group == 'A_CN'
  index_CI <- mydata$Group == 'B_CI'
  var_c <- c(var,
             "MMSE", "MOCA", "FAQ", "CDRSB",
             "RAVLT_immediate", "RAVLT_learning", "RAVLT_forgetting", "RAVLT_perc_forgetting",
             "ADAS11", "ADAS13", "ADASQ4", "LDELTOTAL", "TRABSCOR")
  t.cor<-corr.test(mydata[index_CN,var_c], method="spearman", adjust = 'fdr')
  n.cor<-corr.test(mydata[index_CI,var_c], method="spearman", adjust = 'fdr')
  a.cor<-corr.test(mydata[,var_c], method="spearman", adjust = 'fdr')
  
  var_c <- c(var, 
             "ABETA_IMG")
  # a.cor<-corr.test(mydata[,var_c], method="pearson")
  
  cor_df <- rbind(round(a.cor[["r"]][1,],digits = 3), round(a.cor[["p"]][1,],digits = 3) ,
                  t.cor[["r"]][1,], t.cor[["p"]][1,],
                  n.cor[["r"]][1,], n.cor[["p"]][1,]
  )
  return(cor_df)
}