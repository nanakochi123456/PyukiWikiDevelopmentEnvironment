#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

my @values=(
	"version", "versionnumber", "buildnumber", "build", "package", "type"
);

if($ARGV[0] eq "write") {
	&writever;
} elsif($ARGV[0] eq "all") {
	&printver("package");
	print " ";
	&printver("version");
	print " Build";
	&printver("buildnumber");
	print " (";
	&printver("build");
	print ")";
} else {
	&printver($ARGV[0]);
}
sub printver {
	my ($v)=@_;
	my $msg;
	$msg=&pyukiver("./lib/wiki.cgi", $v);
	if($msg ne "") { print $msg; return; }
	$msg=&pyukiver("../../lib/wiki.cgi", $v);
	if($msg ne "") { print $msg; return; }
	$msg=&pyukiver("./lib/wiki_version.cgi", $v);
	if($msg ne "") { print $msg; return; }
	$msg=&pyukiver("../../lib/wiki_version.cgi", $v);
	if($msg ne "") { print $msg; return; }
	return "";
}

sub pyukiver {
	my($f,$v)=@_;
	open(R,"$f");
	foreach my $buf(<R>) {
		foreach(@values) {
			if($buf=~/^\$\:\:$_/) {
				eval  "$buf" ;
			}
		}
	}
	close(R);
	my $m;
	if($v ne "") {
		foreach(@values) {
			if($_ eq $v) {
				eval qq(\$m="\$::$v";);
				return $m;
			}
		}
	} else {
		foreach(@values) {
			if($_ eq $v) {
				eval qq($m=\$::$v";);
				return $m;
			}
		}
	}
}

sub writever {
	open(R,"./lib/wiki.cgi")||die;
	my $flg=0;
	foreach my $buf(<R>) {
		foreach(@values) {
			if($buf=~/^\$\:\:$_/) {
				eval  "$buf" ;
			}
		}
		$flg=1 if($buf=~/HEADER/);
	}
	return if($flg eq 0);
	open(R,"./lib/wiki_version.cgi")||die;
	my $flg=0;
	foreach my $buf(<R>) {
		foreach(@values) {
			if($buf=~/^\$\:\:$_/) {
				eval  "$buf" ;
			}
		}
		$flg=1 if($buf=~/HEADER/);
	}
#	return if($flg eq 0);

	my($sec,$min,$hour,$day,$mon,$year)=localtime(time);
	my $dt=sprintf("%04d-%02d-%02d %02d:%02d:%02d",$year+1900,$mon+1,$day,$hour,$min,$sec);

	$::buildnumber++;
	open (W, ">./lib/wiki_version.cgi")||die;
	print W <<EOM;
######################################################################
# \@\@HEADER1\@\@
######################################################################
# This is auto generation code
######################################################################

\$::buildnumber=$::buildnumber;
\$::build="$dt";
\$::type="compact"; # compact
\$::type="full"; # release
\$::type="devel"; # devel
\$::type="develop"; # delete
1;
EOM
	close(W);

	$uname=`uname -a`;
	open (W, ">./src/xslib/xsversion.h")||die;
	print W <<EOM;
/*
######################################################################
# \@\@HEADER4_NANAMI\@\@
######################################################################
# This is auto generation code
######################################################################
*/

#define	XS_PYUKIWIKI_VERSION		"$::version"
#define	XS_PYUKIWIKI_VERSIONNUMBER	$::versionnumber
#define	XS_PYUKIWIKI_BUILDNUMBER	$::buildnumber
#define	XS_PYUKIWIKI_BUILD			"$dt"
#define	XS_PYUKIWIKI_TYPE			"$::type"

/*--------------------------------------------------------------------
Build on

$uname
--------------------------------------------------------------------*/
EOM
	close(W);

}
1;
