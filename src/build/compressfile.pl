#!/usr/bin/perl
# yuicompressor script
# $Id$

$maxcompress=1;

use HTML::Packer;
use JavaScript::Packer;
use CSS::Packer;

$mode=$ARGV[0];
$output=$ARGV[1];
$input=$ARGV[2];
$nohead=$ARGV[3];
print "compress $input -> $output\n";
$compress{js}="yuicompressor --type js --charset utf8 -o";
$compress{js21}="yuicompressor --type js --charset utf8 -o";
	#$compress{js22}="php ./build/example-file.php ";
	#$compress{js22}="perl build/jsPacker.pl";
	# fast decode
	#$compress{js22}="perl build/jsPacker.pl -fsq -e62";
	# best decode
	#$compress{js22}="perl build/jsPacker.pl -sq -e62";
$compress{js22}="perl build/jsPacker.pl -q -e62";
$compress{js23}="perl build/jsPacker.pl -q -e62";

#$compress{js22}="php ./build/example-file.php ";
#$compress{js23}="php ./build/example-file.php ";
$compress{css}="yuicompressor --type css --charset utf8 -o";
$convert{utf8}="perl ./build/Jcode-convert.pl utf8";
$convert{euc}="perl ./build/Jcode-convert.pl euc";
$convert2{utf8}="perl Jcode-convert.pl utf8";
$convert2{euc}="perl Jcode-convert.pl euc";

if($ARGV[3] eq '' && $mode ne "html") {
	$top="/* \@\@PYUKIWIKIVERSIONSHORT\@\@\n";
	$top.=" * \$Id\$\n";

if(0) {
	$top.=<<EOM
 *
 * SyntaxHighlighter3.0.83 (July 02 2010)
 * Copyright (C) 2004-2010 Alex Gorbatchev.
 * MIT and GPL licenses.
EOM
		if($output=~/syntaxhighlighter/);

	$top.=<<EOM
 *
 * Video.js - HTML5 Video Player
 * Copyright 2011 Zencoder, Inc.
 * LGPL v3 LICENSE INFO
EOM
		if($output=~/video.js/);

	$top.=<<EOM
 *
 * Copyright 2009 Brandon Leonardo & Ryan McGrath
 * Released under an MIT style license
EOM
		if($output=~/twitstat.js/);

	$top.=<<EOM
 * jQuery JavaScript Library http://jquery.com/
 * Includes Sizzle.js http://sizzlejs.com/
 * jQuery Migrate
 * Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
EOM
		if($output=~/^jquery/);

	$top.=<<EOM
 *
 * jqModal - Minimalist Modaling with jQuery
 * Copyright (c) 2007,2008 Brice Burgess
 * MIT and GPL licenses:
 * 
 * Farbtastic Color Picker 1.2
 * (c)2008 Steven Wittens
 * License GPL2
EOM
		if($output=~/instag.js/ || $output=~/instag.css/);

	$top.=<<EOM
 *
 * flowplayer.js 3.2.6. The Flowplayer API
 * Copyright 2009-2011 Flowplayer Oy
 * License GPL3
EOM
		if($output=~/flowplayer/);
}

	$top.=" */\n\n";

#	$top="/* \@charset \"Shift_JIS\"; */\n/* If use japanese font, use @charset */\n"
#		. $top
#		if($mode eq "css");
}
open(R,"$input")||die("open R $input");
open(W,">$input.commentcut")||die("open W $input.commentcut");
my $buf;
foreach(<R>) {
	$buf.= $_;
}
for(my $i=0; $i<=1; $i++) {
	$buf=~s/\/\*(.|\n)+?\*\///g;
}
for(my $i=0; $i<=1; $i++) {
$buf=~s/^\/\/(.+)\n/\n/g;
$buf=~s/\n\/\/(.+)\n/\n/g;
}
print W $buf;
close(W);
close(R);

if($mode ne "html") {
	&shell("$convert{utf8} $input.tmp $input.commentcut");
} else {
	&shell("cp $input.commentcut $input.tmp");
}
if($mode eq "js" || $mode eq "js2" || $mode eq "js3") {
	# JavaScript Math.floow compress
	open(R, "$input.tmp")||die;
	open(W, ">$input.tmp2")||die;
	foreach(<R>) {
		s/\/\*\!START\_DEBUG(?:.|\n)+END\_DEBUG\*\///gm;
		s/Math\.floor/\~\~/g;
		if(/typeof / && /\"undefined\"/) {
			s/typeof //g;
#			s/\"undefined\"/void\(0\)/g;
			s/\"undefined\"/void 0/g;
		}
		print W $_;
	}
	close(R);
	close(W);
	&shell("mv $input.tmp2 $input.tmp");

#	&shell("$compress{js} $input.tmp2 $input.tmp");
#	&shell("mv $input.tmp2 $input.tmp");

#	my $packer=JavaScript::Packer->init();
#	open(R, "$input.tmp")||die("$input.tmp not found");
#	$scalarref=join('', <R>);
#	close(R);
#	$packer->minify( \$scalarref, { compress=>'shrink' });
##	$packer->minify( \$scalarref, { compress=>'best' });
#	open(W, ">$input.tmp2")||die("$input.tmp2 can't write");
#	print W $scalarref;
# 	close(W);

	&shell("$compress{js21} $input.tmp21 $input.tmp");
	if($maxcompress) {
		if($mode eq "js2") {
			&shell("$compress{js22} $input.tmp21 $input.tmp2");
			&shell("$compress{js22} -i $input.tmp21 -o $input.tmp2");
		} elsif($mode eq "js3") {
			&shell("$compress{js23} $input.tmp21 $input.tmp2");
			&shell("$compress{js23} -i $input.tmp21 -o $input.tmp2");
		} else {
			&shell("cp $input.tmp21 $input.tmp2");
		}
	} else {
		&shell("cp $input.tmp21 $input.tmp2");
	}
#	&shell("$compress{js22} -i $input.tmp -o $input.tmp2");

} else {
	$scalarref="";
	if($mode eq "css") {
		my $packer=CSS::Packer->init();
		open(R, "$input.tmp")||die("$input.tmp not found");
		$scalarref=join('', <R>);
		close(R);
		$packer->minify( \$scalarref, { compress=>'best' });
		$packer->minify( \$scalarref, { compress=>'minify' });
		%tbl=(
			00=>0,	11=>1,	22=>2,	33=>3,	44=>4,	55=>5,
			66=>6,	77=>7,	88=>8,	99=>9,
			AA=>a,	BB=>b,	CC=>c,	DD=>d,	EE=>e,	FF=>f,
			aa=>a,	bb=>b,	cc=>c,	dd=>d,	ee=>e,	ff=>f,
		);
#		$scalarref=~s/\#(00|11|22|33|44|55|66|77|88|99|AA|BB|CC|DD|EE|FF|aa|bb|cc|dd|ee|ff)(00|11|22|33|44|55|66|77|88|99|AA|BB|CC|DD|EE|FF|aa|bb|cc|dd|ee|ff)(00|11|22|33|44|55|66|77|88|99|AA|BB|CC|DD|EE|FF|aa|bb|cc|dd|ee|ff)/'#' . $tbl{$1} . $tbl{$2} . $tbl{$3}/ge;
		$scalarref=~s/ !/!/g;
		$scalarref=~s/;}/}/g;
		open(W, ">$input.tmp2")||die("$input.tmp2 can't write");
		print W $scalarref;
	 	close(W);
	} elsif($mode eq "js") {
#		my $packer=JavaScript::Packer->init();
#		open(R, "$input.tmp")||die("$input.tmp not found");
#		$scalarref=join('', <R>);
#		close(R);
#		$packer->minify( \$scalarref, { compress=>'best' });
#		open(W, ">$input.tmp2")||die("$input.tmp2 can't write");
#		print W $scalarref;
#	 	close(W);
	} elsif($mode eq "html") {
		my $packer=HTML::Packer->init();
		open(R, "$input.tmp")||die("$input.tmp not found");
		$scalarref=join('', <R>);
		close(R);
		$packer->minify( \$scalarref, { remove_comments=>1, remove_newlines=>1 });
		open(W, ">$input.tmp2")||die("$input.tmp2 can't write");
		print W $scalarref;
	 	close(W);
	}
#	&shell("$compress{$mode} $input.tmp2 $input.tmp");
}

if($mode ne "html") {
	&shell("$convert{euc} $input.tmp $input.tmp2");
} else {
	&shell("cp $input.tmp2 $input.tmp");
}

open(R,"$input.tmp")||die("open R $input.tmp");
open(W,">$output")||die("open W $output.tmp");
print W $top;
foreach(<R>) {
	print W $_;
}
close(W);
close(R);
unlink("$input.commentcut");
unlink("$input.tmp");
unlink("$input.tmp2");
unlink("$input.tmp21");

$input_size=-s $input;
$output_size=-s $output;
if($input_size+0 > 0) {
	$per=sprintf("%.1f",$output_size / $input_size * 100);
	print STDERR "$input ($input_size bytes) => $output ($output_size bytes) ($per%)\n";
} else {
	print STDERR "--------------------------------------------------------\n";
	print STDERR "$input Error ($input_size bytes) => $output ($output_size bytes) (zero%)\n";
	print STDERR "--------------------------------------------------------\n";
}

sub shell {
	my($shell)=@_;
	my $buf;
	print "$shell\n";
	open(PIPE,"$shell 2>/dev/null|")||die "pipe $shell";
	foreach(<PIPE>) {
		chomp;
		$buf.="$_\n";
	}
	close(PIPE);
#	print $buf;
	$buf;
}
