use strict;use warnings;
open F,"$ARGV[0]";
my $count=0;
my $t=0;
while (<F>){
	chomp;
	my @in=split(/ /);
	$t++ if ($in[3]==0 and $in[4]<0.5 ) or ($in[3]==1 and $in[4]>0.5);
	$count++;
}

print "$t\t$count\t",$t/$count,"\n";
