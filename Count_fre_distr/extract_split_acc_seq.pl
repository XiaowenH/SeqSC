#!/usr/bin/perl
use warnings;
use strict;

############Build blastdb############
my $genome_seq_file = "../global_all_2022_04_29_human_complete_2022_dates_genomes.fasta.aln";
my $blastdb_dir = "../blastdb";
system("mkdir $blastdb_dir") unless(-e $blastdb);
my $blastdb_name = $blastdb."/Cov_genome_seqs";
system("makeblastdb -in $genome_seq_file -dbtype nucl -parse_seqids -hash_index -out $blastdb_name");

###########Fetch the split accession sequence############
my $split_acc_dir = "../split_acc/";
opendir(DIR, $split_acc_dir);

while(my $filename=readdir(DIR)){
	if($filename=~/^\d+/){
		my $infile = $split_acc_dir.$filename;
			$filename=~s/txt/fa/;
		my $outfile = $split_acc_dir.$filename;
		system("blastdbcmd -db $blastdb_name -entry_batch $infile -out $outfile");		
	}
}
