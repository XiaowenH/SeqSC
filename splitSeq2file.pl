#*************How to use this script******************
#Example
#perl splitSeq2file.pl rmGapFile.fasta
#This script will split the fasta file which have many sequence 
#to one sequence one file, it can reccongnite protein or DNA automatically, the protein sequence will save as ".faa", 
#and the DNA sequence will save as "fna".
#****************************************************
use strict;
use warnings;
my $fastaFile = shift @ARGV;
my $dir = $ENV{'PWD'};
system("mkdir $dir/seq")  unless(-d "$dir/seq");

open(F,$fastaFile);
my @a=<F>;
my $i=0;
while($i <= $#a){
	my $seq="";
	my $acc="";
	my $type = "";
	my $j = $i + 1;
	if($a[$i]=~/^>(\S+)\s+/){
		$acc = $1;
		$acc=~s/\..*//;
		while($j<=$#a){
			if($a[$j]=~/^>/){
				last;
			}else{
				$seq = $seq.$a[$j];
			}
			$j++;
		}
		if($seq=~/[FQIPEL]/i){
			$type = "faa";
		}else{
			$type = "fna";
		}
	}
	my $Loc="$dir/seq/$acc".".".$type;
	open(OUT,">$Loc");
	print OUT $a[$i].$seq;
	close(OUT);
	$i = $j;
}
close(F);
