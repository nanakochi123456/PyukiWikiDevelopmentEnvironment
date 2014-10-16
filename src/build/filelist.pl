#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

$filelist="./build/filelist.txt";

open(R, $filelist)||die;
foreach(<R>) {
	s/[\r\n]//g;
	$filelistdata.="$_\n";
}
close(R);

require "pyukiwiki.ini.cgi";

$dirlist{devel}=<<EOM;
build	doc
document
image	image/src	image/src/_lang	image/src/_login	image/src/exedit	image/src/face	image/src/lang	image/src/login16	image/src/login32	image/src/navi	image/src/org
lib	lib/Nana	lib/Yuki
lib/Algorithm	lib/AWS	lib/Digest	lib/Digest/Perl	lib/File	lib/HTTP	lib
IDNA	lib/Jcode	lib/Jcode/Unicode	lib/Time
plugin
resource
sample
skin
src	src/NanaXS-func	src/NanaXS-func/t	src/xslib	src/xsmake
wiki
attach/*	backup/*	cache/*	counter/*	diff/*	info/*	wiki/*

EOM

	$extlist{devel}=<<EOM;
.inc.pl	.pl	.cgi	.ini.cgi
.inc.pl.ja.pod
.js	.js.gz	.js.org	.js.src
.css	.css.gz	.css.org	.css.src
.en.txt	.ja.txt	.txt
.en.js	.en.js.gz	.en.js.src
.lang.js.src
.unicode.ja.js	.unicode.ja.js.gz	.unicode.ja.js.src
.default.css	.default.css.gz	.default.css.org
.print.css	.print.css.gz	.print.css.org
.skin.cgi
.table.src
.pm
.xs	.PL	.h	.c	.t	MANIFEST	Makefile
.ico
.html	.htaccess
Makefile	MANIFEST
EOM

$dirlist{release}=<<EOM;
document
image
lib	lib/Nana	lib/Yuki
lib/Algorithm	lib/AWS	lib/Digest	lib/Digest/Perl	lib/File	lib/HTTP	lib
IDNA	lib/Jcode	lib/Jcode/Unicode	lib/Time
plugin
resource
sample
skin
src	src/NanaXS-func	src/NanaXS-func/t	src/xslib	src/xsmake
wiki
attach/*	backup/*	cache/*	counter/*	diff/*	info/*	wiki/*

EOM

	$extlist{release}=<<EOM;
.inc.pl	.pl	.cgi	.ini.cgi
.js	.js.gz
.css	.css.gz	.css.org
.en.txt	.ja.txt	.txt
.en.js	.en.js.gz
.unicode.ja.js	.unicode.ja.js.gz
.default.css	.default.css.gz	.default.css.org
.print.css	.print.css.gz	.print.css.org
.skin.cgi
.pm
.xs	.PL	.h	.c	.t	MANIFEST	Makefile
.ico
.html	.htaccess
Makefile	MANIFEST
EOM

$dirlist{compact}=<<EOM;
document
image
lib	lib/Nana	lib/Yuki
plugin
resource
skin
wiki
attach/*	cache/*	counter/*	diff/*	info/*	wiki/*

EOM

	$extlist{compact}=<<EOM;
.inc.pl	.pl	.cgi	.ini.cgi
.js
.css
.ja.txt	.txt
.unicode.ja.js
.default.css
.print.css
.skin.cgi
.pm
.ico
.html	.htaccess
EOM

$mode=$ARGV[0];
@DIRLIST=&readlist($dirlist{$mode});
@EXTLIST=&readlist($extlist{$mode});
&main;

sub main {
	foreach my $line(split(/\n/, $filelistdata)) {
		next if(/^\#/ || /^\s/ || $line eq "");
		($file, $type, $mod, $list, $doc)=split(/\t/, $line);
		$flg=0;
		foreach(split(/,/,$mod)) {
			$flg=1 if(lc $mode eq lc $_);
		}
		next if($flg eq 0);
		$files=&getfiles("$file.");
		$files=~s/\s//g;
		foreach(split(/,/,$files)) {
			$f{$_}=$type;
		}
	}
	foreach(sort keys %f) {
		print "$_\n";
	}
}

sub readlist {
	my ($list)=@_;
	my @list;
	foreach my $a(split(/\n/,$list)) {
		foreach my $b(split(/\t/,$a)) {
			foreach my $c(split(/ /,$b)) {
				foreach my $d(split(/,/,$c)) {
					push(@list,$d);
				}
			}
		}
	}
	@list;
}

sub getfiles {
	my ($orgfile)=@_;
	$orgfile=~s/^\.\///g;

	my $filelist="";
	foreach my $line(split(/\n/, $filelistdata)) {
		next if(/^\#/ || /^\s/ || $line eq "");

		my($file, $type, $mod, $list, $doc)=split(/\t/, $line);
		next if($orgfile!~/$file\./);

		my %list=();
		my $all="$file,$list";
		foreach my $flist(split(/,/,$all)) {
			foreach my $ext(@EXTLIST) {
				if(-r "$flist$ext") {
					$list{"$flist$ext"}=$type;
				} elsif(-r "$flist") {
					$list{"$flist"}=$type;
				}
				$flist=~s/.*\///g;
				foreach my $dirs(@DIRLIST) {
					if($dirs=~/\/\*$/) {
						$dirs=~s/\/\*$//g;
						opendir(DIR,"$dirs")||die;
						while($ff=readdir(DIR)) {
							next if($ff eq "." || $ff eq "..");
							$list{"$dirs/$ff"}=$type;
						}
						closedir(DIR);
					} else {
						if(-r "$dirs/$flist$ext") {
							$list{"$dirs/$flist$ext"}=$type;
						}
					}
				}
			}
		}
		foreach my $flist(sort keys %list) {
			$flist=~s/^\.\///g;
			foreach my $ext(@EXTLIST) {
				if($flist=~/$ext$/) {
					if($flist eq "img.css") {
						$filelist.="$flist:system, ";
					} elsif($flist=~/Makefile.PL/) {
						$filelist.="$flist:xssrc, ";
					} elsif($flist=~/index.html/ || $flist=~/.htaccess/) {
						$filelist.="$flist:dir, ";
					} elsif(-r $flist) {
						$filelist.="$flist:$list{$flist}, ";
					}
				}
			}
		}
	}
	$filelist;
}

