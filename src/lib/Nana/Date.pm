######################################################################
# @@HEADER3_NANAMI@@
######################################################################

use Time::Local;

package	Nana::Date;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);
$VERSION = '0.1';
@EXPORT_OK = qw(gettz getwday lastday dateinit date);

######################################################################

sub gettz {
	if($::TZ eq '') {
		my $now=time();
		$::TZ=(timegm(localtime($now))-timegm(gmtime($now)))/3600;
	}
	return $::TZ;
}

sub getwday {
	my($year, $mon, $mday) = @_;

	if ($mon == 1 or $mon == 2) {
		$year--;
		$mon += 12;
	}
	return int($year + int($year / 4) - int($year / 100) + int($year / 400)
		+ int((13 * $mon + 8) / 5) + $mday) % 7;
}

sub lastday {
	my($year,$mon)=@_;
	return  (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon - 1]
		+ ($mon == 2 and $year % 4 == 0 and
		($year % 400 == 0 or $year % 100 != 0));
}

sub getres {
	my($res, $c)=@_;

	return (split(/,/,$::resource{$res}))[$c];
}

sub date {
	my ($format, $tm, $gmtime) = @_;
	my %weekday;
	my %ampm;

	# yday:0-365 $isdst Summertime:1/not:0
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
		$gmtime ne '' && @_ > 2
			? ($tm+0 > 0 ? gmtime($tm) : gmtime(time))
			: ($tm+0 > 0 ? localtime($tm) : localtime(time));

	$year += 1900;
	my $hr12=$hour>=12 ? $hour-12:$hour;

	# am / pm strings										# comment
	$ampm{en}=&getres("date_ampm_en", $hour>11 ? 1 : 0);
	$ampm{$::lang}=&getres("date_ampm_".$::lang, $hour>11 ? 1 : 0);

	# weekday strings										# comment
	$weekday{en}=&getres("date_weekday_en", $wday);
	$weekday{en_short}=&getres("date_weekday_en_short", $wday);
	$weekday{$::lang}=&getres("date_weekday_".$::lang, $wday);
	$weekday{$::lang."_short"}=&getres("date_weekday_".$::lang."_short", $wday);

	# RFC 822 (only this)									# comment
	if($format=~/r/) {
		return &date("D, j M Y H:i:s O",$tm,$gmtime);
	}
	# gmtime & インターネット時間							# comment
	if($format=~/[OZB]/) {
		my $gmt=&gettz;
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time	# comment
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...	# comment
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00にして、１日を1000beatにする	# comment
														# 日本時間の場合、AM08:00=000	# comment
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time	# comment
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape 日-土			# comment
	$format=~s/DL/\x2\x14/g;	# DL:escape 日曜日-土曜日	# comment
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat			# comment
	$format=~s/aL/\x1\x13/g;	# aL:escape 午前 or 午後	# comment
	$format=~s/AL/\x1\x14/g;	# AL:escape ↑の大文字		# comment
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday	# comment
	$format=~s/a/\x1\x11/g;		# a:escape am pm			# comment
	$format=~s/A/\x1\x12/g;		# A:escape AM PM			# comment
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec			# comment
	$format=~s/F/\x3\x12/g;		# F:escape January-December	# comment

	# うるう年、この月の日数								# comment
	if($format=~/[Lt]/) {
		my $uru=($year % 4 == 0 and ($year % 400 == 0 or $year % 100 != 0)) ? 1 : 0;
		$format=~s/L/$uru/ge;
		$format=~s/t/(31, $uru ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon]/ge;
	}

	# year													# comment
	$format =~ s/Y/$year/ge;	# Y:4char ex)1999 or 2003	# comment
	$year = $year % 100;
	$year = "0" . $year if ($year < 10);
	$format =~ s/y/$year/ge;	# y:2char ex)99 or 03		# comment

	# month													# comment
	my $month = ('January','February','March','April','May','June','July','August','September','October','November','December')[$mon];
	$mon++;									# mon is 0 to 11 add 1	# comment
	$format =~ s/n/$mon/ge;					# n:1-12				# comment
	$mon = "0" . $mon if ($mon < 10);
	$format =~ s/m/$mon/ge;					# m:01-12				# comment

	# day													# comment
	$format =~ s/j/$mday/ge;				# j:1-31		# comment
	$mday = "0" . $mday if ($mday < 10);
	$format =~ s/d/$mday/ge;				# d:01-31		# comment

	# hour													# comment
	$format =~ s/g/$hr12/ge;				# g:1-12		# comment
	$format =~ s/G/$hour/ge;				# G:0-23		# comment
	$hr12 = "0" . $hr12 if ($hr12 < 10);
	$hour = "0" . $hour if ($hour < 10);
	$format =~ s/h/$hr12/ge;				# h:01-12		# comment
	$format =~ s/H/$hour/ge;				# H:00-23		# comment

	# minutes												# comment
	$format =~ s/k/$min/ge;					# k:0-59		# comment
	$min = "0" . $min if ($min < 10);
	$format =~ s/i/$min/ge;					# i:00-59		# comment

	# second												# comment
	$format =~ s/S/$sec/ge;					# S:0-59		# comment
	$sec = "0" . $sec if ($sec < 10);
	$format =~ s/s/$sec/ge;					# s:00-59		# comment

	$format =~ s/w/$wday/ge;				# w:0(Sunday)-6(Saturday)	# comment

	$format =~ s/I/$isdst/ge;	# I(Upper i):1 Summertime/0:Not	# comment

	$format =~ s/\x1\x11/$ampm{en}/ge;			# a:am or pm		# comment
	$format =~ s/\x1\x12/uc $ampm{en}/ge;		# A:AM or PM		# comment
	$format =~ s/\x1\x13/$ampm{$::lang}/ge;		# A:午前 or 午後	# comment
	$format =~ s/\x1\x14/uc $ampm{$::lang}/ge;	# ↑の大文字		# comment

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday	# comment
	$format =~ s/\x2\x12/$weekday{en_short}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x13/$weekday{"$::lang" . "_short"}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x14/$weekday{$::lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec				# comment
	$format =~ s/\x3\x12/$month/ge;				# F:January-December	# comment

	$format =~ s/z/$yday/ge;	# z:days/year 0-366					# comment
	return $format;

	# moved date format document to plugin/date.inc.pl or date.inc.pl.ja.pod	# comment
}

1;
__END__

=head1 NAME

Nana::Date - Simple Date module fork from Yuichat.

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Date.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
