vio_f <- function(Feature_All, Index, y){
  mydata <- Feature_All[Index, ]
  p <- ggplot(mydata,aes(x=DX_a,y=!!sym(y),fill=DX_a))+  # Var
    geom_half_violin(position=position_nudge(x=-0.2),side="l",width=0.5,color=NA)+
    geom_boxplot(width=0.25,size=1.2,outlier.color='black', fill = NA)+
    geom_sina(alpha=0.5,size=2,aes(color=DX_a), maxwidth=0.5)+ # Var
    stat_summary(fun.y = mean, geom = "point", shape = 23, size=4, fill = "black")+
    scale_fill_manual(values=c("#4B7AA3","#CA3430","#5AA058"))+
    scale_color_manual(values=c("#4B7AA3","#CA3430","#5AA058"))+
    scale_y_continuous(breaks = seq(min(mydata[,y]), (max(mydata[,y])-min(mydata[,y]))*0.35 + max(mydata[,y]), length.out = 5), limits = c(min(mydata[,y]), (max(mydata[,y])-min(mydata[,y]))*0.35 + max(mydata[,y])))+ 
    theme_bw()+ 
    theme(panel.grid=element_blank(),
          text=element_text(family="serif"),
          axis.text=element_text(color='black',size=20),
          axis.title=element_text(color='black',size=20), legend.position="none")
  p
}
