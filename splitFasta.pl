#*************How to use this script******************
# perl split.pl rmGapFile.fasta
#****************************************************
use strict;
use warnings;
my $fastaFile = shift @ARGV;

open(F,$fastaFile);
my @a=<F>;
open(OUTA, ">odd.fasta");
open(OUTB, ">even.fasta");

my $i=0;
my $n=0;
while($i <=$#a){
	my $j=$i+1;
	if($a[$i]=~/^>/){
		$n++;
		if($n%2){
			print OUTA $a[$i];
			while($j<=$#a){
				if($a[$j]=~/^>/){
					last;
				}else{
					print OUTA $a[$j];
				}
				$j++;
			}
		}else{
			print OUTB $a[$i];
			while($j<=$#a){
				if($a[$j]=~/^>/){
					last;
				}else{
					print OUTB $a[$j];
				}
				$j++;
			}			
		}
	}
	$i = $j;
}
close(F);
close(OUTA);
close(OUTB);
