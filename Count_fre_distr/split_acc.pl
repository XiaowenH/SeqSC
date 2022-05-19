#!/usr/bin/perl
use warnings;
use strict;

my $global_all_tsv_file = "../global_all_2022_04_29_human_complete_2022_dates.tsv";
my $acc2date_file = "../acc2date.tsv";
system(" cut -f3-4 $global_all_tsv_file >$acc2date_file");

############Convert the date formate to decimal year#######
my $acc2date_one_file = "../acc2date_one.tsv";
&convert_date_format();

###########Sort the accession by date################
my $acc2date_one_sort_file = "../acc2date_one_sort.tsv";
system("cat $acc2date_one_file |csvtk sort -j 15 -t -H -k 2:n -o $acc2date_one_sort_file");

###########Split accession to a single file by date step(ten days)########
my $date2genome_num_file = "../date_genome_num.tsv";
my $split_acc_dir = "../split_acc";
system("mkdir $split_acc_dir") unless(-e $split_acc_dir);
&split_acc();

sub convert_date_format{
	open(F, $acc2date_file)or die "Can not find acc2date file $!\n";
	my @a=<F>;
	open(OUT, ">$acc2date_one_file");
	foreach my $line(@a){
		$line=~s/\s+$//;
		my ($acc, $date)=split/\t/,$line;
		if($date=~/(\d+)-(\d+)-(\d+)/){
			my $date_one = $1 + (($2-1)/12) + ($3/365);
			$date_one = sprintf("%.6f", $date_one);
			print OUT $acc."\t".$date_one."\n";
		}
	}
}

sub split_acc{
	open(FA, $acc2date_one_sort_file);
	my @a=<FA>;

	my $start=2019.982420;	###2019-12-24####
	my $n = 1;
	my $step = 0.02739726;  ###Ten days######
	my $outfile = "$split_acc_dir/".$n.".txt";

	open(OUT, ">$outfile");
	open(MARKER, ">$date2genome_num_file");
	my $num = 0;
		
	foreach(@a){
		s/\s+$//;
		my ($acc, $date) = split/\t/;
		my $end = $start + $step;
		if($date < $end and $date >=$start){
			print OUT $acc."\n";
			$num=$num+1;
		}else{
			print MARKER  $n."\t".$num."\n";
			$num = 0;
			close(OUT);
			$n=$n+1;
			$outfile = "$split_acc_dir/".$n.".txt";
			open(OUT, ">$outfile");
			$start = $end;
		}
	}
	close(OUT);
	close(MARKER);
	close(FA);
}