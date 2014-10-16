#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

$|=1;
use Jcode;

$code=$ARGV[0];
$src=$ARGV[2];
$dest=$ARGV[1];
$destcode=$ARGV[3];

if(open(R,$src)) {
	foreach(<R>) {
		$buf.="$_";
	}
	close(R);
#print STDERR "$src\n";
#print "$src\n";
#$temp=substr($buf, 0, 10000000);
#print "---\n$temp---\n";
	if($destcode ne "") {
#		&Jcode::convert($buf, $code, $destcode);
		&Jcode::convert($buf, $code);
	} else {
		&Jcode::convert($buf, $code);
	}
	if(open(W,">$dest")) {
		print W $buf;
		close(W);
	} else {
		die "$dest can't write";
	}
} else {
	die "$src can't read";
}
