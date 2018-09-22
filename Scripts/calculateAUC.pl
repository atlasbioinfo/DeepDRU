use strict;use warnings;
# Sort the predict results files by predicted values.
` sort -r -n -k 5 $ARGV[0] > temp`;

open F,"temp";

my @rank;my @lab;
my ($index,$prob,$sumR,$countR,$countS,$countD,$sum)=(0,0,0,0,0,0,0);

while (<F>){
	chomp;
	my @in=split(/ /);
	#$in[3] is the state of the mRNA structure. 
	#$in[4] is the predicted state value of mRNA structure.
	#The number of stable and unstable mRNA structures was counted.
	if ($in[3] == 0 ){
		$countS++;
	}elsif($in[3] == 1){
		$countD++;
	}
	
	push @lab,$in[3];
	
	#Put the rank of each mRNA structure after sorting into the array @rank. 
	#If the predicted values were the same, the average of the rank was taken.
	if ($in[4] != $prob || $index==0){
		if($sumR==0){
			push @rank, $index;
			$prob=$in[4];
			$index++;
			next;
		}else{
			my $temp=$sumR/$countR;
			for my $i($index-$countR..$index-1){
				$rank[$i]=$temp;
			}
			push @rank,$index;
			$prob=$in[4];
			$sumR=0;$countR=0;
			$index++;
		}
	}else{
		if ($sumR==0){
			$sumR+=($index-1);
			$countR++;
		}
		$sumR+=$index;
		$countR++;
		$index++;
	}
}
close F;

#Output the final mRNA structure of the file.
if ($sumR != 0){
	my $temp=$sumR/$countR;
	for my $i($index-$countR..$index-1){
		$rank[$i]=$temp;
	}
}

#Add the rank of the stable structure.
for my $i(0..$#rank){
	if ($lab[$i]==0){
		$sum+=$rank[$i];
	}
}
print "$ARGV[0]\t",($sum-($countS)*($countS+1)/2)/($countS*$countD),"\n";

`rm temp`;
