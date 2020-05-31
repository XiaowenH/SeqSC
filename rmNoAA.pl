#!/usr/bin/perl
#**************How to use this script********************
#example
#perl rmNoAA.pl refProt.fasta
#This script can remove the bases which is not "ATGC" in DNA sequence and unusual amino acid in protein sequence.
#********************************************************

use warnings;
use strict;

my $seq_file = shift @ARGV;
open(F, $seq_file);
open(OUT, ">./newSeq.fasta");

my @a =<F>;
my $i = 0;


while($i <= $#a){
	my $j = $i + 1;
	if($a[$i]=~/^>/){
		print OUT $a[$i];
		my $seq = "";
		while( $j <= $#a){
			if($a[$j]=~/^>/){
				last;
			}else{
				if($a[$i]=~/[FQIPEL]/){
					$a[$j]=~s/[^WCMHYFQNIRDPTKEVSGALwcmhyfqnirdptkevsgal]//g;				
				}else{
					$a[$j]=~s/[^ATGCatgc]//g;
				}
				$a[$j]=~s/\s+$//;
				$seq .= $a[$j];	
			}
			$j = $j + 1;
		}
		for(my $n=0;$n<length($seq);$n=$n+80){
			print OUT substr($seq,$n,80);
			print OUT "\n";
		}
	}
	$i = $j;
}

close(F);
close(OUT);

