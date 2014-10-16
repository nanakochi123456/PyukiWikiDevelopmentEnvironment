#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

use utf8;
#use encoding ("utf-8");
use Encode;

open(R, "./build/shiftjis_unicode.txt")||die;
$before="";
$c=0;
foreach(<R>) {
	chomp;
	next if(/^#/);
	$c++;
#	exit if($c>300);
	($shiftjis, $unicode)=split(/\t/, $_);
	$shiftjis=~s/^0x//;
	$unicode=~s/^0x//g;
	$shiftjischar=pack("H*", $shiftjis);
	$unicodechar=decode("sjis", $shiftjischar);
	$eucchar=encode("euc-jp", $unicodechar);
	utf8::encode($unicodechar);
	$unicode=unpack("H*", $unicodechar);
	$euc=unpack("H*", $eucchar);
	print "$shiftjis $euc $unicode\n";
}
close(R);
