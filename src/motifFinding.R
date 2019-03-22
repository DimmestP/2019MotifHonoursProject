setwd("~/Documents/WallaceLab/postXmas2018Work/honourProject/2019MotifHonoursProject/")
life <- read.table("./data/ScerevisiaeChromVIII.txt",skip=1)
hope <- ""
for(i in 1 : 18183) hope <- paste0(hope,life[i,1])
library(stringr)
str_extract_all(hope,".TGTTGGAATA.")
