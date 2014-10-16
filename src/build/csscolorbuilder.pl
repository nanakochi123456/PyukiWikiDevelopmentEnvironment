#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

# usage csscolorbuilder.pl basecss colortable > outputcss

$basecss=$ARGV[0];
$table=$ARGV[1];

if(-r $basecss && -r $table) {
	open(R,$table)||exit 1;
	foreach(<R>) {
		chomp;
		s/\^#.*//g;
		s/[\s\t]+#.*//g;
		s/[\s\t]+//g;
		next if($_ eq '');
		if(/color:\#(......)=\#(......)/) {
			$colortable{$1}=$2;
		}
	}
	close(R);

	open(R,$basecss)||exit 1;
	foreach(<R>) {
		$buf.=$_;
	}
	close(R);
	foreach(keys %colortable) {
		$buf=~s/\#$_/\#$colortable{$_}/g;
	}
	print $buf;
}
