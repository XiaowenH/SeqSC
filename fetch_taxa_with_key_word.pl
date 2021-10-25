#!/usr/bin/perl 
################select_seq.pl##########
##Created on May 21 2021 
##@author: Xiaowen Hu xiaowenhu@catas.cn
##Example: perl select_seq.pl India_total_gisaid_hcov-19_rename.fasta India/AP , AP is the keyword of which want to select.


use strict;
use warnings;

my ($file, $str)=@ARGV;

open(F, $file);
my @a=<F>;
open(OUT, ">selected_seq.fa");

my $i=0;
while($i<=$#a){
	my $j=$i+1;
	if($a[$i]=~/^>.*\Q$str\E/){
		print OUT $a[$i];
		while($j<=$#a){
			if($a[$j]=~/^>/){
				last;
			}else{
				print OUT $a[$j];
			}
			$j++;
		}
	}
	$i=$j;
}
