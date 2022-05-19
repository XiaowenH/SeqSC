setwd("../")
library(ggplot2)
library(stringr)

together_stat_site_file <- "together_stat_site_0.3.txt";
df <- read.table(together_stat_site_file, sep = "\t", header = F)
colnames(df) <- c("date", "location", "frequence")

locs <- unique(df$location)
print(paste("There are",length(locs), "high frequency site\n")

days <- round((df$date - 2019.98242)/0.002739726)
date_format <- as.Date(days,origin='2019-12-24')
df2 <- df
df2$date <- date_format

fig_file <- "merged/site_fig0.3.pdf"
pdf(fig_file, width = 16, height = 9)
ggplot(df2, aes(x = date, y = frequence, color=location)) + geom_line() + theme_bw() + 
  theme(legend.position = 'none',
        plot.background = element_blank(),
        axis.text = element_text(size = 16),
        axis.title= element_text(face = "bold", size=16),
        axis.title.x = element_blank(),
        panel.grid = element_blank()) +
  scale_x_date(expand = c(0,10),breaks = seq(as.Date("2020/1/1"), as.Date("2022/4/1"), by = "3 month"),date_labels="%Y-%m") +
  scale_y_continuous(expand = c(0,0.01), breaks = seq(0.1,1,0.1)) +
  ylab("Site frequency")
dev.off()
