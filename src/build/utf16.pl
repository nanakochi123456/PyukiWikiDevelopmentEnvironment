#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

use utf8;
use encoding ("utf-8");
use Encode qw( from_to );

$in=$ARGV[0];
$out=$ARGV[1];

$buf="";
open(R,"<:utf8",$in)||die;
#binmode(R,":utf8");
open(W, ">$out")||die;
foreach(<R>) {
	for($i=0; $i<length($_); $i++) {
		$c=substr($_, $i, 1);
		if(utf8::is_utf8($c) && (ord($c) > 0x7f)) {
			utf8::encode($c);
			from_to($c, "utf8", "utf16");
			$c=~s/(.)/unpack('H2',$1)/eg;
			$c=~s/(feff)/\\u/g;

			$buf.=$c;
		} else {
			$buf.=$c;
		}
	}
#	print W "\n";
}
$buf=~s/\\u4e\n/\\u4e0a/g;

print W $buf;
close(W);
close(R);
