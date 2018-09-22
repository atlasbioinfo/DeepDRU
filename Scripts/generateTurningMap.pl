use strict;use warnings;
# This perl script is used to convert predicted 
# data into turning map data.
# Usage: perl generateTurningMap.pl predictedFile > output

open F,"$ARGV[0]"; #Predicted data

my %gene;
# The %gene hash array is used to hold the prediction 
# information of the structure.
# The array structure is a hash array + array, 
# $gene{"Structure Info"}[$num]

while (<F>){
	chomp;
	my @in=split(/ /);
	# 0.5 is the threshold of the binary classification
	if ($in[4]>=0.5){
		$in[4]=1;
	}else{
		$in[4]=0;
	}
	push @{$gene{"$in[0]\t$in[1]"}},$in[4];
}
close F;

# 
for my $key(keys %gene){
	my $str=join "",@{$gene{$key}};
	
	# When making a turning map, the prediction error may lead 
	# to an increase in the turning point. 
	# Therefore, we use a regular expression to smooth out 
	# three consecutive prediction sites.
	
	# trimmed head part
	$str=~s/^0111/1111/;
	$str=~s/^00111/11111/;
	$str=~s/^000111/111111/;
	$str=~s/^1000/0000/;
	$str=~s/^11000/00000/;
	$str=~s/^111000/000000/;

	# trimmed tail part
	$str=~s/1110$/1111/;
	$str=~s/11100$/11111/;
	$str=~s/111000$/111111/;
	$str=~s/0001$/0000/;
	$str=~s/00011$/00000/;
	$str=~s/000111$/000000/;

	# trimmed middle part
	$str=~s/0001000/0000000/g;
	$str=~s/00011000/00000000/g;
	$str=~s/000111000/000000000/g;
	$str=~s/1110111/1111111/g;
	$str=~s/11100111/11111111/g;
	$str=~s/111000111/111111111/g;

	# Statistics on the turningMap sequence.
	my @seq=split(//,$str);
	my $index=$seq[0];
	my $count=1;
	my $turn=0;
	my @pos;
	# Statistic of turning point.
	for my $i(1..$#seq){
		unless ($index==$seq[$i]){
			push @pos,$i;
			$turn++;
			$index=$seq[$i];
			$count=1;
		}else{
			$count++;
		}
	}
	print "$key\t$turn\t$str\t";
	if ($turn==0){
		push @pos,"NA";
	}
	print join ";",@pos;
	print "\n";
}
