#!/usr/bin/perl
use warnings;
use strict;

my $cutoff = 0.3;
my $fre_file = "../together_stat_fre".$cutoff.".txt";
my $site_file = "../site_".$cutoff.".txt";
my $mul_muta_file = "../mul_muta_".$cutoff.".list";
system("cut -f2-3 $fre_file|sort -u >$site_file");
system("cut -f1 $site_file|sort|uniq -d >$mul_muta_file");

open(FA, $mul_muta_file);
my %site;
while(<FA>){
	s/\s+$//;
	$site{$_}="";
}
close(FA);

open(FB, $site_file);

my $single_site_file = "../single_site_".$cutoff.".txt";
my $mul_site_file = "../mul_site_".$cutoff.".txt";;
open(OUTA, ">$single_site_file");
open(OUTB, ">$mul_site_file");

while(<FB>){
	my $line=$_;
	my @l=split/\t/,$line;
	if(exists $site{$l[0]}){
		print OUTB $line;
	}else{
		print OUTA $line;
	}
}
close(FB);
close(OUTA);
close(OUTB);
