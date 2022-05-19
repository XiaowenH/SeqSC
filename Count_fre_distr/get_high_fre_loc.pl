#!/usr/bin/perl
use warnings;
use strict;

###################Build reference base index#######
my $refseq_file = "../ref.fa";
open(FA, $refseq_file);
my $seq="";
while(<FA>){
	unless(/^>/){
		s/\s+$//;
		$seq .= $_;
	}
}
my @seq_base = ("A", "T", "G", "C");

my @refseq;
for(my $i=0;$i<length($seq);$i++){
	my $base=substr($seq, $i, 1);
	$refseq[$i]=$base;
}

#####################################################
my $cutoff = 0.01;   #######The high frequency cutoff
my $outfile = "../high_fre".$cutoff.".txt";
open(OUT, ">$outfile");

my $split_stat_dir = "../split_sta/";
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
	open(F, $split_stat_dir.$filename);
	my @a=<F>;
	
	my $loc = 2019.982420 + ($n-1)*0.02739726; #######Get the decimal year of each time step
	for(my $i=1;$i<=$#a;$i++){
		$a[$i]=~s/\s+$//;
		my @l=split/\t/,$a[$i];
		my $site = shift @l;
		my ($base_index,$base) = &ref_fre($site);
		
		$site = $site + 1;
		my $marker=-1;
		my $fre=1;
		
		my $sum=0;
		foreach(@l){
			$sum += $_;
		}
		if($sum >= 0.9){
			for(my $j=0;$j<=$#l;$j++){
				if($l[$j] >= $cutoff and $j != $base_index){    ######Pick the most high frequncy >= cutoff, but not the frequncy of refence base
					if($l[$j] < $fre){
						$fre = $l[$j];
					}
					$marker = $j + 2;
				}
			}			
		}
		unless($marker == -1){
			my $k = $marker-2;
			$site = $site.$base.">".$seq_base[$k];
			print OUT $loc."\t".$site."\t".$marker."\t".$fre."\n";
		}
	}
}
sub ref_fre{
	my($loc)=@_;
	my $result="";
	if($refseq[$loc] eq "A"){
		$result=0;
	}elsif($refseq[$loc] eq "T"){
		$result=1;
	}elsif($refseq[$loc] eq "G"){
		$result=2;
	}elsif($refseq[$loc] eq "C"){
		$result=3;
	}
	return $result, $refseq[$loc];
}

