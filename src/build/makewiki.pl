#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

require './build/text.pl';

open(R,"lib/wiki.cgi");
foreach(<R>) {
	if(/^\$\:\:version/) {
		eval  $_ ;
	}
}
close(R);

&textinit($old,$::version,$filemode,$TYPE,$CHARSET);


$inst=$ARGV[0];

$srcdir="./src/wiki";
$srcdir2="./doc";
$dstdir="./resource";
$lang="$srcdir/lang.wiki";

foreach $langs(split(/\n/,&readfile($lang))) {
	next if($langs eq "");
	$lines="";
	$outfile="$dstdir/wiki-$inst.$langs.txt";
	$deffile="$srcdir/all.$langs.wiki";
	$defdata=&readfile($deffile);
	$defdata=~s/\/\*(.+?)\*\///g;
	$defdata=~s/^\n//g;
	$defdata=~s/^\n//g;
	$defdata=~s/^\n//g;
	$defdata=~s/^\n//g;
	$defdata=~s/^\n//g;
	foreach $fdata(split(/\n/,$defdata)) {
		next if($fdata=~/^\>/);
		my ($fn, $pagename, $install, $type, $lang, $code)=split(/\t/,$fdata);
		print "Make $fn $pagename ($install) $type\n";
		$dt=&readfile("$srcdir/$fn");
		$dt=&readfile("$srcdir2/$fn") if($dt eq "");
		$dt=~s/\/\*(.+?)\*\///g;
		$dt=~s/^\n//g;
		$dt=~s/^\n//g;
		$dt=~s/^\n//g;
		$dt=~s/^\n//g;
		$dt=~s/^\n//g;
		$flg=0;
		foreach(split(/,/,$install)) {
			$flg=1 if($inst eq $_);
		}
		next if(!$flg);

		$lines.=">>>>>>>>>>\t$pagename\t$type\t$lang\t$code\n";
		foreach $line(split(/\n/,$dt)) {
			$line=&rep($line);
			$lines.="$line\n";
		}
	}
	open(W, ">$outfile")||die;
#	print W $defdata;
	print W $lines;
	close(W);
}

sub rep {
	my ($line)=@_;
	$ii=0;
	$line=~s/L\<\@\@CVSURL\@\@(.*)\>/L\<\@\@CVSURL\@\@$1\?view\=log\>/g;
	if($line=~/\@\@include\=\"(.+)\"\@\@/) {
		my $file=$1;
		$FILE=&readfile($file);
		$FILE=&readfile($file) if($FILE eq "");
		$line=~s/\@\@include\=\"(.+)\"\@\@/$FILE/;
	}

	if($line=~/\@\@CVSURL\@\@/) {
		my $tmps=$line;
		$tmps=~s!\@\@CVSURL\@\@/PyukiWiki\-Devel/!\@\@CVSURL\@\@/PyukiWiki\-Devel\-UTF8/!g;
		$line.="\n\n$tmps";
		$tmps=$line;
		$tmps=~s!\@\@CVSURL\@\@/!\@\@CVSURLDEV\@\@/!g;
		$tmps=~s!\?view\=log$!!g;
		$line.="\n\n$tmps";
	}
	while($line=~/\@\@(.+?)\@\@/) {
		my $rep=$1;
		$line=~s/\@\@$rep\@\@/$text{$rep}/g;
		if($filemode eq 'crlf') {
			$line=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
		} else {
			$line=~s/\x0D\x0A|\x0D|\x0A/\n/g;
		}
		last if($ii++>10);
	}
	while($line=~/\\\@\\\@\\\@(.+?)\\\@\\\@\\\@/) {
		my $rep=$1;
		$line=~s/\\\@\\\@\\\@$rep\\\@\\\@\\\@/$text{$rep}/g;
		if($filemode eq 'crlf') {
			$line=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
		} else {
			$line=~s/\x0D\x0A|\x0D|\x0A/\n/g;
		}
		last if($ii++>10);
	}
	return $line;
}

sub readfile {
	my ($fname)=@_;
	my $buf;
	open(R, $fname)||return "";
	$lll=0;
	foreach(<R>) {
		$lll++;
		next if($lll < 3); 
		next if(/\$Id/);
		s/[\r\n]//g;
		$buf.="$_\n";
	}
	close(R);
	$buf;
}
