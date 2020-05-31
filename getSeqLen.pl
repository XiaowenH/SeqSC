#!/usr/bin/perl
#******************How to use this script****************
#example
#perl getSeqLen.pl refProt.fasta
#********************************************************
use warnings;
use strict;

my $seq_file = shift @ARGV;
open(F, $seq_file);
open(OUT, ">./seqLen.txt");
print OUT (join("\t", ("Accession", "Seq_length", "GC%", "Description")));
print OUT "\n";


my @a =<F>;
my $i = 0;
my $n = 0;

while($i < $#a){
	my $j = $i + 1;
	if($a[$i]=~/^>(\S+)\s+(.*)/){
		my $acc = $1;
		my $descr = $2;
		my $seq = "";
		while( $j < $#a){
			if($a[$j]=~/^>/){
				last;
			}else{
				$a[$j]=~s/\s+$//;
				$seq .= $a[$j];
			}
			$j = $j + 1;
		}
		my $len = length($seq);
		my $GC = $seq =~ tr/gcGC/gcGC/;
		my $GC_percent = $GC/$len;
		$GC_percent = sprintf "%.2f%%", $GC_percent*100;	
		my $line = join("\t", ($acc, $len, $GC_percent, $descr));
		print OUT $line."\n";
		$n = $n + 1
	}
	$i = $j;
}

close(F);
close(OUT);

#*********************count Nx********************************
`cut -d '\t' -f 2 ./seqLen.txt|sort -n -r >./seqLenSort.txt `;
my $n10 = int($n * 0.1);
my $n20 = int($n * 0.2);
my $n30 = int($n * 0.3);
my $n40 = int($n * 0.4);
my $n50 = int($n * 0.5);

open(F, "./seqLenSort.txt");
@a=<F>;

open(OUT, ">Nx.txt");
print OUT "N10"."\t".$a[$n10];
print OUT "N20"."\t".$a[$n20];
print OUT "N30"."\t".$a[$n30];
print OUT "N40"."\t".$a[$n40];
print OUT "N50"."\t".$a[$n50];

close(OUT);
print  "N10"."\t".$a[$n10];
print  "N20"."\t".$a[$n20];
print  "N30"."\t".$a[$n30];
print  "N40"."\t".$a[$n40];
print  "N50"."\t".$a[$n50];
close(F);
close(OUT);