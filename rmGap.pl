#*************How to use this script******************
# perl rmGap.pl Australia_Jan.aln
#This script can transfer the '.aln' file to '.phylip' file, it also can remove the gap from the '.aln' file and create a new '.aln' file.
#It can control how many bases in one line by change the $lineBases variable, the default value is 100.
#****************************************************
use strict;
use warnings;

my $alnFile = shift @ARGV;

my $phylipFile = $alnFile;
$phylipFile="new.phylip" unless($phylipFile=~s/aln/phylip/);
&aln2phylip() unless(-e $phylipFile);

open(F,$phylipFile);
my @a=<F>;
close(F);
my $head=$a[0];
$head=~s/^\s+//;   ####remove blank
$head=~s/\s+$//;
my ($accNum,$seqLen)=split/\s/,$head;

my ($star_line, @dels) = &getDelSites();

my $lineBases=100;
&output();

sub aln2phylip{
	open(F,$alnFile)or die "can not open the .aln file\n";
	my @a=<F>;
	close(F);
	my %acc2seq;
	my @acc_list=();

	unless($a[0]=~/^CLUSTAL/){
		print "The input file is not a 'aln' format file\n";
		exit;
	}
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
	
	open(OUT,">$phylipFile");
	print OUT " $n $len\n";
	foreach(@acc_list){
		print  OUT $_."\t".$acc2seq{$_}."\n";
	}
	close(OUT);
}

sub getDelSites{
	my $conservedSite = $phylipFile;
	$conservedSite="new.conservedSiteFre" unless ($conservedSite=~s/phylip/conservedSiteFre/);
	my @delSites;
	my $stars="";
	
	for(my $i=0;$i<$seqLen;$i++){
		my %count;
		for(my $j=1;$j<=$accNum;$j++){
			$a[$j]=~s/\s+$//;
			my ($acc, $seq)=split/\t/,$a[$j];
			my $base=substr($seq,$i,1);
			if(exists $count{$base}){
				$count{$base}++;
			}else{
				$count{$base}=1;
			}
		}
		my $marker=&JudgeSite(\%count,$accNum);
		if($marker == 1){
			push(@delSites, $i);
		}elsif($marker == 2){
			$stars = $stars." ";print $i."\n";
		}else{
			$stars = $stars."*";
		}
	}
	return $stars,@delSites;
}

sub JudgeSite{
	my($hashName,$accNum)=@_;
	my %count=%$hashName;
	my @bases=keys %count;
	my $marker = 0;
	
	my $n = keys %count;
	if(exists $count{"-"}){
		$marker = 1;
	}elsif($n > 1){
		$marker = 2;
	}
	return $marker;
}

sub output{
	open(OUT, ">rmGapFile.aln");

	my %acc2seq;
	my @acc_list=();
	
	for(my $j=1;$j<=$accNum;$j++){
		$a[$j]=~s/\s+$//;
		my ($acc, $seq)=split/\t/,$a[$j];
		push(@acc_list, $acc);
		my @bases=split//,$seq;
		foreach(@dels){
			$bases[$_]="";
		}
		$seq = join("", @bases);
		$acc2seq{$acc}=$seq;
		@bases=();
	}
	$acc2seq{"                                   "}=$star_line;
	push(@acc_list, "                                   ");
	
	print OUT "CLUSTAL O(1.2.4) multiple sequence alignment\n\n\n";
	
	my $seqLen=length($acc2seq{$acc_list[0]}) if(exists $acc2seq{$acc_list[0]});
	for(my $i=0;$i<$seqLen;$i = $i + $lineBases){
		foreach(@acc_list){
			print OUT $_."      ".substr($acc2seq{$_}, $i, $lineBases)."\n";
		}
		print OUT "\n";
	}
	close(OUT);
}
