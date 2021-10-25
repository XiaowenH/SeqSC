#!/usr/bin/perl 
###=======Usage==================================================================================================
###This script can randomly select samples of given number each with given number of taxa from a give fasta format sequence.
###Example: run " perl fetch_nNum_seq.pl test.fa 800 6", that will select the input number sequence into a list of file which pre-name with 'sample' ."
###==============================================================================================================

use strict;
use warnings;

my ($file, $num, $sample_num)=@ARGV;
#print $file."\n".$num."\n";
open(F, $file)or die "Can not open the give fasta file.\n";
unless($num){
	print "Can not get the selected number.\n";
}

###########build the hash of id to sequence############
my @a=<F>;
my %id2seq;

my $i=0;
my $sum_seq=0;
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
				$seq=$seq.$a[$j];
			}
			$j++;
		}
		$id2seq{$id}=$seq;
		$sum_seq++;
	}
	$i=$j;
}

############rand select the sequence id##############
my $input_num=0;
my @pick_key=();
my @ids=keys %id2seq;
my $id_nums=$#ids;
for(my $i=1;$i<=$sample_num;$i++){
	for(my $j=1;$j<=$num;$j++){
		my $picked_id=int(rand($id_nums));
		push(@pick_key, $ids[$picked_id]);
		splice @ids,$picked_id,1;
		$id_nums=$#ids;
		if($sum_seq<$#pick_key or $id_nums<=0){
			last;
		}
	}
}

#####print the select sequence##########
for(my $i=1;$i<=$sample_num;$i++){
	my $outfile=">$file."."sample".$i.".fa";
	open(OUT, $outfile);
	for(my $j=1;$j<=$num;$j++){
		my $id=shift @pick_key;
		print OUT ">".$id."\n".$id2seq{$id} if(exists $id2seq{$id});
	}
	close(OUT);
}


