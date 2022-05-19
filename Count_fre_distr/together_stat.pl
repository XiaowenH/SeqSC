#!/usr/bin/perl
use warnings;
use strict;

my $outfile = "../together_stat.txt";
open(OUT, ">$outfile");

my $split_stat_dir = "../split_sta";
opendir(DIR, $split_stat_dir);
while(my $filename=readdir(DIR)){
	if($filename=~/^\d+/){
		&base_sta($filename);
	}
}

close(OUT);

sub base_sta{
	my ($filename)=@_;
	my $n;
	if($filename=~/^(\d+)/){
		$n=$1;
	}
	open(F, "$split_stat_dir/$filename");
	my @a=<F>;
	
	my $loc = 2019.982420 + ($n-1)*0.02739726;
	for(my $i=1;$i<=$#a;$i++){
		$a[$i]=~s/\s+$//;
		my @l=split/\t/,$a[$i];
		my $site = shift @l;
			$site = $site + 1;
			$site = "s".$site;
		print OUT $loc."\t".$site."\t";
		print OUT join("\t", @l);
		print OUT "\n";
	}
}
