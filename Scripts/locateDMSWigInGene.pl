use strict;use warnings;
#This script can map the DMS signal to the gene, requiring a gene location annotation file ($ARGV[0]) and a DMS signal value file ($ARGV[1]).
#The default output is terminal and needs to be redirected.
#eg: perl locateDMSWigInGene.pl geneInfo DMSInfo > DMSInGene

open F,"$ARGV[0]";
#$ARGV[0] is a file on gene position information extracted from the GFF3 annotation file of the yeast genome.
#The format is:
#chrI	YAL069W	335	649	+
#split by TAB

my %gene;
while (<F>){
	chomp;
	my @in=split(/\t/);
	@{$gene{$in[1]}}=($in[0],$in[2],$in[3],$in[4]);
}
close F;

open K,"$ARGV[1]";
#$ARGV[1] is a file containing the value of the DMS signal, which is obtained from the simple processing of the WIG file.
#The format is :
#chrI	31156	1.0	+
#split by TAB

my %chr;
while (<K>){
	chomp;
	my @in=split(/\t/);
	$chr{$in[0]}[$in[1]]=0 unless defined $chr{$in[0]}[$in[1]];
	$chr{$in[0]}[$in[1]]+=$in[2];
}
close K;

for my $gene (keys %gene){
	my $chr=$gene{$gene}[0];
	my $temp="*";
	my $sumd=0;my $count=0;
	for my $i($gene{$gene}[1]..$gene{$gene}[2]){
		$chr{$chr}[$i]=0 unless defined $chr{$chr}[$i];
		next if $chr{$chr}[$i]==0;
			$count++;
			$sumd+=$chr{$chr}[$i];
	}
	$count=1 if $count==0;
	my $mean=$sumd/$count;
	$mean=1 if $mean==0;
	my @data;my $temp;
	for my $i($gene{$gene}[1]..$gene{$gene}[2]){
		$temp=$chr{$chr}[$i];
		$temp=$temp/$mean;
		push @data,$temp;
	}
	@data=reverse(@data) if $gene{$gene}[3] eq "-";
	print "$gene\t",$#data+1,"\t";
	print join ";",@data;
	print "\n";
}
