setwd("../")
library(ggplot2)
library(stringr)

together_stat_site_file <- "together_stat_site_0.3.txt";
df <- read.table(together_stat_site_file, sep = "\t", header = F)
colnames(df) <- c("date", "location", "frequence")

date_list <- unique(df$date)
days_list <- round((date_list - 2019.98242)/0.002739726)
date_list <- as.Date(days_list,origin='2019-12-24')

split_together_sta_dir <- "../split_together_sta_0.3/"
file_list <- list.files(split_together_sta_dir, pattern = ".tsv")
for(filename in file_list){
  sta_file <- paste(split_together_sta_dir, filename, sep = "")
  df_single <- read.table(sta_file, sep = "\t", header = F)
  colnames(df_single) <- c("frequence")
  new_df <- data.frame(date=date_list[1:nrow(df_single)], frequence=df_single$frequence)
  
  outfile <- paste(split_together_sta_dir, str_replace(filename, "tsv", "png"), sep = "") 
  png(outfile, width = 1600, height = 900)
  p <- ggplot(new_df, aes(x = date, y = frequence)) + geom_line() + theme_bw() + 
    theme(legend.position = 'none',
          plot.background = element_blank(),
          axis.text = element_text(size = 16),
          axis.title= element_text(face = "bold", size=16),
          axis.title.x = element_blank(),
          panel.grid = element_blank()) +
    scale_x_date(expand = c(0,10),breaks = seq(as.Date("2020/1/1"), as.Date("2022/4/1"), by = "3 month"),date_labels="%Y-%m") +
    scale_y_continuous(expand = c(0,0.01), breaks = seq(0.1,1,0.1)) +
    ylab("Site frequency")
  print(p)
  dev.off()
}
