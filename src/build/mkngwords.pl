#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

%::functions = (
"load_module"=>\&load_module,
"code_convert"=>\&code_convert,
);

$::defaultcode="utf8"; #utf8
$::defaultcode="euc"; #euc

use Nana::Kana;
use Nana::Code;

@table=(
	'ngwords,$::disablewords',
	'ngwords_frozenwrite,$::disablewords_frozenwrite',
	'ngwords_username,$::disablewords_username',
	'ngwords_ja,$::disablewords{ja}',
	'ngwords_frozenwrite_ja,$::disablewords_frozenwrite{ja}',
	'ngwords_username_ja,$::disablewords_username{ja}',
);

open(W, ">ngwords.ini.cgi")||die;

print W <<EOM;
######################################################################
# \@\@HEADER1\@\@
######################################################################
use strict;

# fix NG words.

# http://monoroch.net/kinshi/
# http://dic.nicovideo.jp/a/%E3%83%8B%E3%82%B3%E3%83%8B%E3%82%B3%E7%94%9F%E6%94%BE%E9%80%81%3A%E9%81%8B%E5%96%B6ng%E3%83%AF%E3%83%BC%E3%83%89%E4%B8%80%E8%A6%A7
# http://www.vector.co.jp/soft/data/net/se475480.html


# if not use this database, written to info/setup_ngwords.ini.cgi
if(0) {

\$::disablewords{ja}="";
\$::disablewords="";
\$::disablewords_frozenwrite{ja}="";
\$::disablewords_frozenwrite="";
\$::disablewords_username{ja}="";
\$::disablewords_username="";

}

######################################################################
EOM
@all=();

$k=new Nana::Kana(code=>"euc");

foreach $tbl(@table) {
	@t=();
	($f, $v)=split(/,/,$tbl);
	open(R, "build/$f.txt")||die "build/$f.txt";
	$words="";
	foreach(<R>) {
		chomp;
		next if(/^\/\//);
		next if($_ eq "");

		$words.="$_ ";
	}
	close(R);
	$words=~s/[\t\r\n\s]/ /g;
	foreach $w (split(/ /,$words)) {
		next if($w eq "");
		$w=lc $w;
		$flg=0;
		foreach(@all) {
			$flg=1 if($w eq $_);
		}
		push(@all, $w) if($flg eq 0);
		$flg=0;
		foreach(@t) {
			$flg=1 if($w eq $_);
		}
		push(@t, $w) if($flg eq 0);
		$char=lc $k->yomi1($w);
#print "$w->$char\n";
		$flg=0;
		foreach(@all) {
			$flg=1 if($char eq $_);
		}
		push(@all, $char) if($flg eq 0);
		$flg=0;
		foreach(@t) {
			$flg=1 if($char eq $_);
		}
		push(@t, $char) if($flg eq 0);
	}
	@t=sort @t;
	@all=sort @all;
	print W "$v=<<EOM;\n";
	$tmp=join(" ",@t);
	$tmp=~s/^\s+//g;
	print W $tmp;
	print W "\nEOM\n";
}

sub code_convert {
	my ($contentref, $kanjicode, $icode) = @_;
	return Nana::Code::conv($contentref, $kanjicode, $icode);
}
sub load_module{
	my $mod = shift;
	return $mod if $::_module_loaded{$mod}++;
	# bug fix 0.2.0-p3								# comment
	if($mod=~/^[\w\:]{1,64}$/) {
		eval qq( require $mod; );
		unless($@) {						# debug
			$::debug.="Load perl module $mod\n";		# debug
		} else {							# debug
			$::debug.="Load perl module $mod failed\n";# debug
		}									# debug
		$mod=undef if($@);
		return $mod;
	}
	return undef;
}
