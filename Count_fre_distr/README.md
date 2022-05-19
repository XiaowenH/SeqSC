## 1. Split the accession by time step

The script of split_acc.pl will split the accession from the annotation file of SARS-COV-2 in  GISAID by time step. Firstly, this script will cut the columns of accession and date, and create a tsv file acc2date.tsv, and then convert the date to digital format, and sort the acc2date.tsv file by date, using a soft named csvtk, which will create the file acc2date_one.tsv and acc2date_one_sort.tsv. Secondly, split the file acc2date_one_sort.tsv to a folder named split_acc by step time, the start day is 2019-12-24, and the step time is 10 days, moreover it will count the genome number of each step to a file named date_genome_num.tsv.

## 2. Extract the sequences from the split accession file

The script of extract_split_acc_seq.pl will extract the sequences from the split accession file that obtained in the previous step, and store the sequences to a folder named .  The method of extracting sequence is using a blast program named makeblastdb built the blastdb, and batch extraction the sequencing using the program of blastdbcmd  according the accession file.

## 3. Count the bases frequency of each step time

The script of cal_fre.pl will count the frequency of ATGC at a step time from the sequence file, the result will store in a folder named split_sta.  

## 4. Get the location of genome with high frequency 

The script of get_high_fre_loc.pl will extract the location of genome with high frequency by a cutoff value, and generate a file named high_fre.txt.

## 5. Collect the statistics of frequency

The script of together_stat.pl will collect the statistics of frequency which obtained from step 3 to a file named together_stat.tsv.

## 6. Remove the repeat location with multiple high frequency bases

The script of rm_repeat_site.pl will remove the repeat location with multiple high frequency bases, and generate a single site file.

## 7. Pick the location with high frequency at any step time

The script of pick_site.pl will pick the location with high frequency at any step time.

## 8. Split the frequency of each time step by the location

The script of split_together_stat.pl will split the frequency of each time step by the location, one location one file, the split file is from the step 7.

## 9. Plot the distribution of frequency in the time line

The R script of plot_together_stat.R will plot the frequency distribution from step 7. 

The R script of plot_split_together_stat.R will batch plotting the frequency distribution from step 8. 