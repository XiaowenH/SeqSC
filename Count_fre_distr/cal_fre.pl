#!/usr/bin/perl
use warnings;
use strict;

##**********************************************************
###Count the frequency of bases between each step genome
##**********************************************************
my $split_stat_dir = "../split_sta";
system("mkdir $split_stat_dir") unless(-e $split_stat_dir); ###Create the output dir#########

opendir(DIR, "../split_seq/");
while(my $filename=readdir(DIR)){
	unless($filename=~/\./){
		&base_sta($filename);
	}
}


sub base_sta{
	my ($filename)=@_;
	open(F, "../split_seq/$filename");
	my @a=<F>;
###################Build index#######################
	my %h;
	my $i=0;
	while($i<=$#a){
		my $j=$i+1;
		my $id="";
		my $seq="";
		if($a[$i]=~/^>(\S+)/){
			$id=$1;
			while($j<=$#a){
				if($a[$j]=~/^>/){
					last;
				}else{
					$a[$j]=~s/\s+$//;
					$seq.=$a[$j];
				}
				$j++;
			}
		}
		unless(exists $h{$id}){
			$h{$id}=$seq;
		}
		$i=$j;
	}

#####################Count base number on each location#########
	my %base_num;
	my @key = keys %h;
	my $genome_num = $#key + 1;

	for(my $i=0;$i<29891;$i++){
		foreach(@key){
			my $base=substr($h{$_},$i,1);
			my $b2n = $i."_".$base;
			if(exists $base_num{$b2n}){
				$base_num{$b2n}++;
			}else{
				$base_num{$b2n}=1;
			}
		}
		
	}

######################Calculation and output of frequency of each location#########
	my @bases=("A", "T", "G", "C");
	$filename=~s/fa/tsv/;
	open(OUT, ">$split_stat_dir/$filename");
	print OUT join("\t", ("loc", "A", "T", "G", "C"))."\n";
	for(my $i=0;$i<29891;$i++){
		print OUT $i;
		foreach(@bases){
			my $b2n = $i."_".$_;
			if(exists $base_num{$b2n}){
				$base_num{$b2n}=sprintf("%.3f", $base_num{$b2n}/$genome_num);
			}else{
				$base_num{$b2n}=0;
			}
			print OUT "\t".$base_num{$b2n};
		}
		print OUT "\n";
	}
}

