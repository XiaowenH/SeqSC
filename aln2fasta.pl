#*************How to use this script******************
# perl aln2fasta.pl rmGapFile.aln
#****************************************************
use strict;
use warnings;

my $alnFile = shift @ARGV;

my $fastaFile = $alnFile;
$fastaFile="new.fasta" unless($fastaFile=~s/aln/fasta/);
my $lineBases=100;
&aln2fasta();

sub aln2fasta{
	open(F,$alnFile)or die "can not open the .aln file\n";
	my @a=<F>;
	close(F);
	my %acc2seq;
	my @acc_list=();

	for(my $i=3;$i<=$#a;$i++){
		$a[$i]=~s/\s+$//;
		my ($acc, $seq)=split/\s+/,$a[$i];
		if($acc){
			if(exists $acc2seq{$acc}){
				$acc2seq{$acc} = $acc2seq{$acc}.$seq;
			}else{
				$acc2seq{$acc} = $seq;
				push(@acc_list, $acc);
			}
		}
	}
	my $len = length($acc2seq{$acc_list[0]});
	my $n=@acc_list;
	
	open(OUT,">$fastaFile");
	my $seqLen=length($acc2seq{$acc_list[0]}) if(exists $acc2seq{$acc_list[0]});
	foreach(@acc_list){
		print OUT ">".$_."\n";
		for(my $i=0;$i<$seqLen; $i=$i + $lineBases){
			print OUT substr($acc2seq{$_}, $i, $lineBases)."\n";
		}
		print OUT "\n";
	}
	close(OUT);
}
