#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

$|=1;
$fn=$ARGV[0];
$tx=$ARGV[1];
open(R, $tx)||die;

%word=();
foreach(<R>) {
	chomp;
	my($a, $b, $c)=split(/ /,$_);
	if($a+0>1 && $c ne "") {
		$wd=lc $b;
	} else {
		$wd=lc $a;
	}
	if(length($wd)>2 && length($wd)<6) {
		$word{$wd}=1;
	}
}

@wd=sort keys %word;
$maxcount=$#wd;
%wd=%word;

foreach my $a(@wd) {
	$count++;
	$per=int($count/$maxcount*100);

	print STDERR "$per\% / 100\%\r";
	foreach my $b(@wd) {
		next if($a eq $b);
		delete $wd{$a} if($a=~/$b/);
	}
}

@list=sort keys %wd;

close(R);

$d="s='";
foreach(@list) {
	$d.="$_\_";
}
$d=~s/\_$//g;
$d=~s/^\_//g;
$d.="';\n";

open(R, $fn)||die;

foreach(<R>) {
	s/\$\$INSERT\$\$/$d/ge;
	print $_;
}
close(R);

