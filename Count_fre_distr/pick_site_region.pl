#!/usr/bin/perl
use warnings;
use strict;

###****************************************************************
###Pick the site with high frequency at all of the time step####
###****************************************************************

my $region = "0.01-0.3";
my($cutoff_s, $cutoff_e)=split/-/,$region;

my $fre_file_s = "../high_fre".$cutoff_s.".txt";
my $fre_file_e = "../high_fre".$cutoff_e.".txt";

open(FA, $fre_file_s);
open(FC, $fre_file_e);
my %marker_h;
while(<FC>){
	s/\s+$//;
	my @tmp=split/\t/;
	$marker_h{$tmp[1]}=$tmp[2];
}


my %site_ref;
my %site;
while(<FA>){
	s/\s+$//;
	my @tmp=split/\t/;
	unless(exists $marker_h{$tmp[1]}){
		if($tmp[1]=~/(\d+)([A,T,G,C])>([A,T,G,C])/){
			$site_ref{$1}=$2;
		}
		$site{$tmp[1]}=$tmp[2]; ################site to column###########		
	}
}

open(FB, "../together_stat.txt");
my $outfile = "../together_stat_site_".$region.".txt";
open(OUT, ">$outfile");

my @seq_base=("A", "T", "G", "C");
while(<FB>){
	s/\s+$//;
	my @l=split/\t/;
	$l[1]=~s/s//;
	if(exists $site_ref{$l[1]}){
		for(my $i=2;$i<=5;$i++){
			my $j=$i-2;
			my $site_key = $l[1].$site_ref{$l[1]}.">".$seq_base[$j];
			if(exists $site{$site_key}){
				my $fre=0;
				if($site{$site_key} <= $#l){
					$fre = $l[$site{$site_key}];
				}
				print OUT $l[0]."\t".$site_key."\t".$fre."\n";
			}	
		}

	}
}
