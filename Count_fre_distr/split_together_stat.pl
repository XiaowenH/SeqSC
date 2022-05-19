#!/usr/bin/perl
use warnings;
use strict;
####******************************************************
####split the frequency of each time step by the location
####******************************************************
my $cutoff="0.01-0.3";
my $infile = "../together_stat_site_".$cutoff.".txt";
open(FA, $infile);
my %h;
my @site;
my @date;
while(<FA>){
	s/\s+$//;
	my @l=split/\t/;
	my $date = shift @l;
	my $n = 1 + ($date - 2019.98242)/0.02739726;
	$n = sprintf("%0.0f", $n);
	my $loc = shift @l;
	$loc=~s/>/-/;
	my $key = $n."_".$loc;
	$h{$key}= shift @l;
	push(@site, $loc) unless(grep{$_ eq $loc}@site);
	push(@date, $n) unless(grep{$_ eq $n}@date);
}

my $outdir = "../split_together_sta_".$cutoff;
system("mkdir $outdir") unless(-e $outdir);

foreach my $s(@site){
	my $outfile = $outdir."/".$s.".tsv";
	open(OUT, ">$outfile");
	foreach my $d(@date){
		my $key = $d."_".$s;
		if(exists $h{$key}){
			print OUT $h{$key}."\n";
		}
	}
	close(OUT);
}

