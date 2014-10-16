#!/usr/bin/perl
#--------------------------------------------------------------
# PyukiWiki Installer CGI Maker
# $Id$
#--------------------------------------------------------------
# easy tape extract tool
#--------------------------------------------------------------

$sepa1="\x0\xff\x0\xff\x0\xff\x0\xff\x0";
$sepa2="\x0\xff\x5\xff\x0\xff\x5\xff\x0";

open(R, "$ARGV[0]")||die;
$z=-s $ARGV[0];
binmode(R);
$l=sysread(R, $b, $z);
foreach $f(split(/$sepa1/,$b)) {
next if($f eq "");
#	($n, $m, $s, $d)=split(/$sepa2/, $f);
	($n, $s, $d)=split(/$sepa2/, $f);
	if($s eq "d") {
		print "d $n\n";
		open(P, "mkdir -p $n|");while(<P>){}close(P);
	} else {
		print "x $n\n";
		open(W, ">$n")||die;
		binmode(W);
		syswrite(W, $d, $s);
		close(W);
	}
}
close(R);

