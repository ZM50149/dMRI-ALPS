
corplot_f <- function(mydata,  y, x){
  index_CN <- mydata$Group == 'A_CN'
  index_CI <- mydata$Group == 'B_CI'
  mydata$diff <- plogis(scale(1/abs(mydata[,y]*(mean(mydata[,x])/mean(mydata[,y])) - mydata[,x])))
  mydata$size <- log10(mydata$diff*10+10)
  mydata$range<- cut(mydata$size, breaks = quantile(mydata$size), include.lowest = T)
  mydata$range2<-as.numeric(gsub("]","",sapply(strsplit(as.character(mydata$range),","), "[",2), fixed = T))
  
  num <- length(unique(mydata$range2))
  ylim <- range(mydata[,y])
  xlim <- range(mydata[,x])
  
  pdf(file.path(fig_path, paste0("Cor_",y, "_", x, ".pdf")), width = 7, height = 6.5)
  par(bty="o", mgp = c(2,0.5,0), mar = c(4.1,4.1,2.1,4.1), tcl=-.25, font.main=3) # 画布基本设置
  par(xpd=F) # 禁止显示超过画布的部分
  plot(NULL, NULL, ylim = ylim, xlim = xlim, # 先绘制一个空的画布，仅有边框和坐标名
       xlab = x, ylab = y,col="white",
       main = "")
  
  rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = "#EAE9E9", border = F)# 给画布设置背景色，掩盖边框
  grid(col = "white", lty = 1, lwd = 1.5)
  
  tmp1 <- mydata[index_CN, ]
  reg1 <- lm(as.formula(paste0(y, '~', x)), data=tmp1) # 计算回归线
  points(tmp1[,x], tmp1[, y], pch = 19, col = ggplot2::alpha("#4B7AA3",0.8), cex = tmp1$size)# 重叠散点透明化
  abline(reg1, lwd = 2, col = "#4B7AA3")
  
  tmp2 <- mydata[index_CI, ]
  reg2 <- lm(as.formula(paste0(y, '~', x)), data=tmp2) # 计算回归线
  points(tmp2[,x], tmp2[, y], pch = 19, col = ggplot2::alpha("#CA3430",0.8), cex = tmp2$size)# 重叠散点透明化
  abline(reg2, lwd = 2, col = "#CA3430")
  
  reg3 <- lm(as.formula(paste0(y, '~', x)), data=mydata)
  abline(reg3, lwd = 2, col = "#5AA058")
  
  rug(mydata[,x], col="black", lwd=1, side=3)
  rug(mydata[,y], col="black", lwd=1, side=4)
  
  
  t.cor<-cor.test(mydata[index_CN,y],mydata[index_CN, x])
  n.cor<-cor.test(mydata[index_CI,y],mydata[index_CI, x])
  a.cor<-cor.test(mydata[,y],mydata[, x])
  text(x = xlim[1]+(xlim[2]-xlim[1])*0.02,
       y = ylim[2]-(ylim[2]-ylim[1])*0.05,
       labels = bquote("Health Control: N ="~bold(.(t.cor[["parameter"]][["df"]]+2))~";"~rho~"="~.(round(t.cor[["estimate"]][["cor"]],3))~";"~
                         italic(P)~.(ifelse(t.cor[["p.value"]] < 0.001, "< 0.001", paste0("= ", formatC(t.cor[["p.value"]], format = "f", digits = 3))))),
       col = "#4B7AA3", adj = 0,family = 'serif', cex=1)
  
  text(x = xlim[1]+(xlim[2]-xlim[1])*0.02,
       y = ylim[2]-(ylim[2]-ylim[1])*0.1,
       labels = bquote("Cognitive Impairment: N ="~bold(.(n.cor[["parameter"]][["df"]]+2))~";"~rho~"="~.(round(n.cor[["estimate"]][["cor"]],3))~";"~
                         italic(P)~.(ifelse(n.cor[["p.value"]] < 0.001, "< 0.001", paste0("= ", formatC(n.cor[["p.value"]], format = "f", digits = 3))))),
       col = "#CA3430", adj = 0,family = 'serif', cex=1)
  
  text(x = xlim[1]+(xlim[2]-xlim[1])*0.02,
       y = ylim[2]-(ylim[2]-ylim[1])*0.15,
       labels = bquote("All Participants: N ="~bold(.(a.cor[["parameter"]][["df"]]+2))~";"~rho~"="~.(round(a.cor[["estimate"]][["cor"]],3))~";"~
                         italic(P)~.(ifelse(a.cor[["p.value"]] < 0.001, "< 0.001", paste0("= ", formatC(a.cor[["p.value"]], format = "f", digits = 3))))),
       col = c("#5AA058"), adj = 0,family = 'serif', cex=1)
  
  par(xpd = T)
  
  points(x = rep(par("usr")[2] + (xlim[2]-xlim[1])*0.05, 2), 
         y = c(ylim[2]*0.9, ylim[2]*0.8),
         pch = 19, bty = "n", cex = 1.8, col = c("#4B7AA3","#CA3430"))
  text(x = rep(par("usr")[2] + (xlim[2]-xlim[1])*0.05, num + 1), 
       y = c(ylim[2]*0.88, ylim[2]*0.78),
       labels = c("Health Control","Cognitive Impairment"),
       adj = 0,cex = 0.8)
  
  # points(x = rep(par("usr")[2] + (xlim[2]-xlim[1])*0.02, num), 
  #        y = seq(ylim[2]*0.7, ylim[2]*0.4, length.out = num),
  #        pch = 19, bty = "n", cex = sort(unique(mydata$range2)), col = "black")
  # text(x = rep(par("usr")[2] + (xlim[2]-xlim[1])*0.02, num+1), 
  #      y = c(ylim[2]*0.68, seq(ylim[2]*0.65, ylim[2]*0.35, length.out = num)),
  #      labels = c("Absolute\nVertical\nShift", round(10^(sort(unique(mydata$range2)-10)/10))), # 还原对数转化
  #      adj = 0,cex = 0.8)
  
  
  par(new = T, bty="o")
  plot(-1, -1, col = "white",
       xlim = xlim, ylim = ylim,
       xlab = "", ylab = "",    
       xaxt = "n", yaxt = "n")
  invisible(dev.off())
}
