# release file perl script for pyukiwiki
# $Id$

use Jcode;
use Encode;

sub textinit {
	($fn,$pyukiversion,$mode,$TYPE,$CHARSET)=@_;
	($sec, $min, $hour, $mday, $mon, $year,
		$wday, $yday, $isdst) = localtime;
	$year+=1900;
	$text{YEAR}=$year;

#############################################################
# �إå�

$text{YEAR}=$year;
if($TYPE=~/compact/) {
$text{BASEHEAD1}=<<EOM;
\@\@FILENAME\@\@ - \$Id\$
EOM
} elsif($TYPE=~/release/) {
$text{BASEHEAD1}=<<EOM;
\@\@FILENAME\@\@ - This is PyukiWiki yet another Wiki clone
# \$Id\$
EOM
} else {
$text{BASEHEAD1}=<<EOM;
\@\@FILENAME\@\@ - This is PyukiWiki yet another Wiki clone
# \$Id\$
# Build @{[&date("Y-m-d h:i:s")]}
EOM
}

if($TYPE=~/compact/) {
$text{BASEHEAD2}=<<EOM;
(C)2005-$year PyukiWiki Developers Team/2004-2007 Nekyo
# \@\@PYUKI_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ TAB=4Spaces GPL3 and/or Artistic License
EOM
$text{BASEHEAD4}=<<EOM;
(C)2000-$year - Laurent Destailleur - eldy@users.sourceforge.net
# \@\@AWSTATS_URL\@\@
# (C)2005-$year PyukiWiki Developers Team/2004-2007 Nekyo
# \@\@PYUKI_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ TAB=4Spaces GPL3 and/or Artistic License
EOM
} else {
$text{BASEHEAD2}=<<EOM;
(C)2004-2007 Nekyo
# (C)2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ TAB=4Spaces GPL3 and/or Artistic License
EOM
$text{BASEHEAD4}=<<EOM;
(C)2000-$year - Laurent Destailleur - eldy@users.sourceforge.net
# \@\@AWSTATS_URL\@\@
# (C)2004-2007 Nekyo
# (C)2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ TAB=4Spaces GPL3 and/or Artistic License
EOM
}

if($TYPE=~/compact/) {
$text{HEADER1}=<<EOM;
\@\@BASEHEAD1\@\@
# \@\@PYUKIWIKIVERSION\@\@
# $text{BASEHEAD2}
EOM
} else {
$text{HEADER1}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# $text{BASEHEAD2}
EOM
}

if($TYPE=~/compact/) {

$text{HEADER2_NEKYO}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@NEKYO\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@NANAMI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@YUKI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_JUNICHI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@JUNICHI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YASHIGANIMODOKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@YASHIGANIMODOKI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author \@\@NANAMI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER4_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# XS Module build library
# Author \@\@NANAMI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author \@\@YUKI\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER4_AWS}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@NANAMI\@\@
# $text{BASEHEAD4}
EOM

} else {

$text{HEADER2_NEKYO}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@NEKYO\@\@ \@\@NEKYO_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@YUKI\@\@ \@\@YUKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_JUNICHI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@JUNICHI\@\@ \@\@JUNICHI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER2_YASHIGANIMODOKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@YASHIGANIMODOKI\@\@
#         \@\@YASHIGANIMODOKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author \@\@NANAMI\@\@
# \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER4_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author \@\@NANAMI\@\@
# \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER3_YUKI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@MODULEVERSION\@\@
# Author \@\@YUKI\@\@
# \@\@YUKI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADER4_AWS}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PYUKIWIKIVERSION\@\@
# Author \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD4}
EOM

}

$text{HEADERPLUGIN_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PLUGINVERSION\@\@
# Author \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADEREXPLUGIN_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PLUGINVERSION\@\@
# Author \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# $text{BASEHEAD2}
EOM

$text{HEADERPLUGIN_SYNTAXHIGHLIGHTER_NANAMI}=<<EOM;
\@\@BASEHEAD1\@\@
#
# \@\@PLUGINVERSION\@\@
#
# SyntaxHighlighter
# http://alexgorbatchev.com/SyntaxHighlighter
#
# SyntaxHighlighter is donationware. If you are using it, please donate.
# http://alexgorbatchev.com/SyntaxHighlighter/donate.html
#
# Version 3.0.83 (July 02 2010)
# (C)2004-2010 Alex Gorbatchev.
#
# Author: \@\@NANAMI\@\@ \@\@NANAMI_URL\@\@
# (C)2004-2007 Nekyo
# (C)2005-$year PyukiWiki Developers Team
# \@\@PYUKI_URL\@\@
# Based on YukiWiki \@\@YUKIWIKI_URL\@\@
# Powerd by PukiWiki \@\@PUKIWIKI_URL\@\@
# @\@CRLF\@\@ \@\@CODE\@\@ 4Spaces GPL3 and MIT License
EOM

#############################################################
# pod�Υ饤����

$text{LICENSE_BASE}=<<EOM;
(C)2005-$year by PyukiWiki Developers Team

License is GNU GENERAL PUBLIC LICENSE 3 and/or Artistic 1 or each later version.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
EOM

$text{LICENSE}=<<EOM;
(C)2004-2007 by \@\@NEKYO\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_NEKYO}=$text{LICENSE};

$text{LICENSE_NANAMI}=<<EOM;
(C)2005-$year by \@\@NANAMI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_JUNICHI}=<<EOM;
(C)2005 by \@\@JUNICHI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_YASHIGANIMODOKI}=<<EOM;
(C)2004 by \@\@YASHIGANIMODOKI\@\@.

\@\@LICENSE_BASE\@\@
EOM

$text{LICENSE_YUKI}=<<EOM;
(C)2002-$year by \@\@YUKI\@\@.

\@\@LICENSE_BASE\@\@
EOM

#############################################################
# pod��AUTHOR
$text{AUTHOR_PYUKI}=<<EOM;
=item PyukiWiki Developers Team

L<\@\@PYUKI_URL\@\@>
EOM

$text{AUTHOR_NEKYO}=<<EOM;
=item \@\@NEKYO\@\@

obsoleted
EOM

#L<\@\@NEKYO_URL\@\@>

$text{AUTHOR_YUKI}=<<EOM;
=item \@\@YUKI\@\@

L<\@\@YUKI_URL\@\@>
EOM

$text{AUTHOR_JUNICHI}=<<EOM;
=item \@\@JUNICHI\@\@

obsoleted
EOM
#L<\@\@JUNICHI_URL\@\@>

$text{AUTHOR_NANAMI}=<<EOM;
=item \@\@NANAMI\@\@

L<\@\@NANAMI_URL\@\@> etc...
EOM

$text{AUTHOR_YASHIGANIMODOKI}=<<EOM;
=item \@\@YASHIGANIMODOKI\@\@

obsoleted
EOM
#L<\@\@YASHIGANIMODOKI_URL\@\@>

#############################################################
# AUHTOR LIST

$text{XTETSUJI}='OGATA Tetsuji';
$text{XTETSUJI_URL}='http://post.tetsuji.jp/';

$text{YUKI}='Hiroshi Yuki';
$text{YUKI_URL}='http://www.hyuki.com/';

$text{NEKYO}='Nekyo';
$text{NEKYO_URL}='http://nekyo.qp.land.to/';
#$text{NEKYO_URL}='';

$text{JUNICHI}='Junichi';
$text{JUNICHI_URL}='http://www.re-birth.com/';
#$text{JUNICHI_URL}='';

if($fn=~/\.ja/) {
	$text{NANAMI}='�ʤʤ�';
	$text{YASHIGANIMODOKI}='�䤷���ˤ�ɤ�';
} else {
	$text{NANAMI_JA}='�ʤʤ�';
	$text{YASHIGANIMODOKI_JA}='�䤷���ˤ�ɤ�';
	$text{NANAMI}='Nanami';
	$text{YASHIGANIMODOKI}='YashiganiModoki';
}
$text{NANAMI_URL}='http://nano.daiba.cx/';
$text{NANAMI_MAIL}='nanami@daiba.cx';

$text{YASHIGANIMODOKI_URL}='http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi';
#$text{YASHIGANIMODOKI_URL}='';

$text{SOURCEFORGE_JP_DOMAIN}="sfjp.jp";
$text{SOURCEFORGE_NET_DOMAIN}="sf.net";
$text{PYUKI_SFJP_URL}="http://pyukiwiki.$text{SOURCEFORGE_JP_DOMAIN}/";
$text{PYUKI_URL}="http://pyukiwiki.info/";

$text{YUKIWIKI_URL}="http://www.hyuki.com/yukiwiki/";
$text{PUKIWIKI_URL}="http://pukiwiki.$text{SOURCEFORGE_JP_DOMAIN}/";
$text{PUKIWIKIDEV_URL}="http://pukiwiki.$text{SOURCEFORGE_JP_DOMAIN}/";

$text{AWSTATS_URL}="http://awstats.$text{SOURCEFORGE_NET_DOMAIN}/";

#$text{BASEURL}="http://pyukiwiki.$text{SOURCEFORGE_JP_DOMAIN}";
$text{BASEURL}="http://pyukiwiki.info";
$text{CVSURL}="http://$text{SOURCEFORGE_JP_DOMAIN}/cvs/view/pyukiwiki";
$text{CVSURLDEV}="http://cvs.pyukiwiki.info/cgi-bin/cvsweb.cgi";

$text{RECENTDATE}=&date("Y-m-d (D)");

$text{GPLJP_URL}="http://$text{SOURCEFORGE_JP_DOMAIN}/projects/opensource/wiki/GPLv3_Info";
$text{GPL_URL}="http://www.gnu.org/licenses/gpl.html";
$text{ARTISTICJP_URL}="http://www.opensource.jp/artistic/ja/Artistic-ja.html";
$text{ARTISTIC_URL}="http://www.perl.com/language/misc/Artistic.html";

#############################################################
#	($fn,$pyukiversion,$mode)=@_;

	$pyukiversion=~s/[\r|\n]//g;
	$text{FILENAME}=$fn;
	$text{FILENAME}=~s/.*\///g;
	$text{CRLF}=$mode eq 'lf' ? 'LF' : 'CRLF';
	$text{PYUKIWIKIVERSION}=qq("PyukiWiki" ver $pyukiversion \$\$);
	$text{PYUKIWIKIVERSIONSHORT}=qq("PyukiWiki" $pyukiversion \$\$);
	$text{PYUKIVER}=qq($pyukiversion);
	$VERSION="";
	$pkg="";
	$PLUGIN="";
	$EXPLUGIN="";
	$chkbuf="";
	open(R,"$fn");
	foreach(<R>) {
		$chkbuf.=$_;
		if(/^\$VERSION/) {
			eval  $_ ;
		} elsif(/^package\s?(.*?);/) {
			$pkg=$1;
		} elsif(/^\$PLUGIN/) {
			eval $_;
		} elsif(/^\$EXPLUGIN/) {
			eval $_;
		}
		$dd=$fn;
		$dd=~s/\/([^\/]+)$//g;
		$dd.="/version.h";
		my $xfpflg=0;
		if(open(RR, $dd)) {
			foreach(<RR>) {
				s/[\r\n]//g;
				chomp;
#				$xfpflg=1 if(/#define	XS_PYUKIWIKIMOD_HEADER	"XSPKG"/);
				$xfpflg=1 if(/XS_PYUKIWIKIMOD_HEADER/);
				if($xfpflg) {
					if(/XS_PYUKIWIKIMOD_NAME/) {
						s/\"$//g;
						s/.*"//g;
						$xspkg=$_;
#print STDERR "\$xspkg : $xspkg\n";
					}
					if(/XS_PYUKIWIKIMOD_VERSION/) {
						s/\"$//g;
						s/.*"//g;
						$VERSION=$_;
#print STDERR "\$VERSION(xs) : $VERSION\n";
					}
				}
			}
			close(RR);
		}
	}
	close(R);
	if($CHARSET eq 'utf8') {
		$text{CODE}="UTF-8";
	} elsif($chkbuf=~/\$charset\: (.+)\$/) {
		$text{CODE}=$1;
	} else {
		($code)=Jcode::getcode($chkbuf);
		if($code eq 'sjis') {
			$text{CODE}="Shift-JIS";
		} elsif($code eq 'utf8') {
			$text{CODE}="UTF-8";
		} else {
			$text{CODE}="EUC-JP";
		}
	}
	if($VERSION ne '' && $PLUGIN ne '') {
		$text{PLUGINVERSION}=qq("$PLUGIN" ver $VERSION \$\$);
	} elsif($VERSION ne '' && $EXPLUGIN ne '') {
		$text{PLUGINVERSION}=qq("$EXPLUGIN" ver $VERSION \$\$);
	} elsif($VERSION ne '' && $pkg ne '') {
		$text{MODULEVERSION}=qq("$pkg" ver $VERSION \$\$);
	} elsif($VERSION ne '' && $xspkg ne '') {
	#	$text{MODULEVERSION}=qq("$xspkg" ver $VERSION \$\$);
	} else {
		$text{MODULEVERSION}=$text{PYUKIWIKIVERSION};
	}
	foreach (keys %text) {
#print STDERR "key [$_]\n";
#print "key [$_]\n";
		my $hash=$text{$_};
		$hash=~s/[\@\.\r\n\$]//g;
#		use Digest::MD5;
#		$hash=Digest::MD5::md5_hex($hash);
		if($text{CODE} eq "Shift-JIS") {
			if($::cache_sjis{$hash} ne "") {
				$text{$_}=$::cache_sjis{$hash};
			} else {
				$enctemp=&mktemp("$fn.enctemp");
				$outtemp=&mktemp("$fn.outtemp");
				open(W,">$enctemp");
				print W $text{$_};
#				syswrite(W, $text{$_}, length($text{$}}) );
				close(W);
				&convertsjis($enctemp,$outtemp);
				open(R, $outtemp);
#				read(R, $buf, 100000000);
#				$text{$_}=$buf;
				$buf="";
				foreach my $r(<R>) {
					$buf.=$r;
				}
				$text{$_}=$buf;
				close(R);
				unlink($enctemp);
				unlink($outtemp);
#				&Jcode::convert($text{$_}, "sjis","euc");
#				$text{$_}=encode( 'shiftjis', decode( 'euc-jp', $text{$_} ) );
				$::cache_sjis{$hash}=$text{$_};
			}
		} elsif($text{CODE} eq "UTF-8") {
			if($::cache_utf8{$hash} ne "") {
				$text{$_}=$::cache_utf8{$hash};
			} else {
				$enctemp=&mktemp("$fn.enctemp");
				$outtemp=&mktemp("$fn.outtemp");
				open(W,">$enctemp");
				print W $text{$_};
#				syswrite(W, $text{$_}, length($text{$}}) );
				close(W);
				&convertutf8($enctemp,$outtemp);
				open(R,$outtemp);
#				read(R, $buf, 100000000);
#				$text{$_}=$buf;
				$buf="";
				foreach my $r(<R>) {
					$buf.=$r;
				}
				$text{$_}=$buf;
				close(R);
				unlink($enctemp);
				unlink($outtemp);
#				&Jcode::convert($text{$_}, "utf8","euc");
#				$text{$_}=encode( 'utf-8', decode( 'euc-jp', $text{$_} ) );
				$::cache_utf8{$hash}=$buf;
			}
		}
		$text{$_}=~s/\n$//g;
	}
}


sub date {
	my ($format, $tm, $gmtime) = @_;
	my %weekday;
	my $weekday_lang;
	my $ampm_lang;
	my %ampm;

	# yday:0-365 $isdst Summertime:1/not:0
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = 
		$gmtime ne '' && @_ > 2
			? ($tm+0 > 0 ? gmtime($tm) : gmtime(time))
			: ($tm+0 > 0 ? localtime($tm) : localtime(time));

	$year += 1900;
	my $hr12=$hour=>12 ? $hour-12:$hour;

	# am / pm strings
	$ampm{en}=$hour>11 ? 'pm' : 'am';
	$ampm{ja}=$hour>11 ? '���' : '����';

	# weekday strings
	$weekday{en} = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')[$wday];
	$weekday{en}{length}=3;
	$weekday{ja} = ('������', '������', '������', '������', '������', '������', '������')[$wday];
	$weekday{ja}{length}=2;

	$weekday_lang=$weekday{$::lang} eq '' ? 'en' : $::lang;
	$ampm_lang=$ampm{$::lang} eq '' ? 'en' : $::lang;

	# RFC 822 (only this)
	if($format=~/r/) {
		return &date("D, j M Y H:i:s O",$tm,$gmtime);
	}
	# gmtime & ���󥿡��ͥåȻ���
	if($format=~/[OZB]/) {
		my $gmt=&gettz;
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00�ˤ��ơ�������1000beat�ˤ���
														# ���ܻ��֤ξ�硢AM08:00=000
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape ��-��
	$format=~s/DL/\x2\x14/g;	# DL:escape ������-������
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat
	$format=~s/aL/\x1\x13/g;	# aL:escape ���� or ���
	$format=~s/AL/\x1\x14/g;	# AL:escape ������ʸ��
	$format=~s/a/\x1\x11/g;		# a:escape am pm
	$format=~s/A/\x1\x12/g;		# A:escape AM PM
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec
	$format=~s/F/\x3\x12/g;		# F:escape January-December

	# ���뤦ǯ�����η������
	if($format=~/[Lt]/) {
		my $uru=($year % 4 == 0 and ($year % 400 == 0 or $year % 100 != 0)) ? 1 : 0;
		$format=~s/L/$uru/ge;
		$format=~s/t/(31, $uru ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon]/ge;
	}

	# year
	$format =~ s/Y/$year/ge;	# Y:4char ex)1999 or 2003
	$year = $year % 100;
	$year = "0" . $year if ($year < 10);
	$format =~ s/y/$year/ge;	# y:2char ex)99 or 03

	# month
	my $month = ('January','February','March','April','May','June','July','August','September','October','November','December')[$mon];
	$mon++;									# mon is 0 to 11 add 1
	$format =~ s/n/$mon/ge;					# n:1-12
	$mon = "0" . $mon if ($mon < 10);
	$format =~ s/m/$mon/ge;					# m:01-12


	# day
	$format =~ s/j/$mday/ge;				# j:1-31
	$mday = "0" . $mday if ($mday < 10);
	$format =~ s/d/$mday/ge;				# d:01-31

	# hour
	$format =~ s/g/$hr12/ge;				# g:1-12
	$format =~ s/G/$hour/ge;				# G:0-23
	$hr12 = "0" . $hr12 if ($hr12 < 10);
	$hour = "0" . $hour if ($hour < 10);
	$format =~ s/h/$hr12/ge;				# h:01-12
	$format =~ s/H/$hour/ge;				# H:00-23

	# minutes
	$format =~ s/k/$min/ge;					# k:0-59
	$min = "0" . $min if ($min < 10);
	$format =~ s/i/$min/ge;					# i:00-59

	# second
	$format =~ s/S/$sec/ge;					# S:0-59
	$sec = "0" . $sec if ($sec < 10);
	$format =~ s/s/$sec/ge;					# s:00-59

	$format =~ s/w/$wday/ge;				# w:0(Sunday)-6(Saturday)


	$format =~ s/I/$isdst/ge;	# I(Upper i):1 Summertime/0:Not

	$format =~ s/\x1\x11/$ampm{en}/ge;			# a:am or pm
	$format =~ s/\x1\x12/uc $ampm{en}/ge;		# A:AM or PM
	$format =~ s/\x1\x13/$ampm{$ampm_lang}/ge;	# A:���� or ���
	$format =~ s/\x1\x14/uc $ampm{$ampm_lang}/ge;# ������ʸ��

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday
	$format =~ s/\x2\x12/substr($weekday{en},0,$weekday{en}{length})/ge;	# D:Mon-Sun
	$format =~ s/\x2\x13/substr($weekday{$weekday_lang},0,$weekday{$weekday_lang}{length})/ge;	# D:Mon-Sun
	$format =~ s/\x2\x14/$weekday{$weekday_lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec
	$format =~ s/\x3\x12/$month/ge;				# F:January-December

	$format =~ s/z/$yday/ge;	# z:days/year 0-366
	return $format;
}

1;
