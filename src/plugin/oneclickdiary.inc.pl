######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# Usage :
# #oneclickdiary(Basepage, eom)
# DiaryHeader
# DiaryFooter
# format wiki
# DiaryClickComment
# DiaryClickComment
# ...
# #oneclickdiary
#
# format wiki parameter
# $date = 日付
# $time = 時刻
# $datetime = 日時
# $action = 行動記録
# $comment = 任意テキスト
######################################################################
# MenuBar等に設置した場合、月の前後をMenuBarだけで動かす場合 1
$oneclickdiary::menubaronly=1;
$oneclickdiary::addline="// oneclickdiary - addline\n";
#
######################################################################

use strict;
#use Time::Local;

#require "plugin/calendar2.inc.pl";
$oneclickdiary::basepage="";
$oneclickdiary::eom="";
$oneclickdiary::cnt=0;

# メールのヘッダー
$::mail_head{oneclickdiary}="oneclickdiary";
$oneclickdiary::mailheader = "$::mail_head{oneclickdiary}"
	if(!defined($oneclickdiary::mailheader));

sub oreplacen {
	my $s=shift;
	$s=~s/\\n/\n/g;
	$s;
}
sub oreplace {
	my($str, $target, $data, $cnt)=@_;
	my @line=split(/\n/,$str);
	my $body;
	$target=~s/\n//g;
	my $targetlen=length($target);
	my $count=0;
	foreach(@line) {
		if(substr($_, 0, $targetlen) eq substr($target, 0, $targetlen)) {
			$count++;
			if($cnt eq $count) {
				$body.="$data\n";
			}
		}
		$body.="$_\n";
	}
	$body;
}

sub addselect {
	my ($form, $min, $max, $addstr, $rev)=@_;
	my $body=<<EOM;
<select name="$form">
EOM
	$body.=<<EOM;
<option value="">$::resource{oneclickdiary_noselect}</option>
EOM
	if($rev) {
		for (my $i=$max; $i >= $min; $i--) {
			$body.=<<EOM;
<option value="$i">$i$addstr</option>
EOM
		}
	} else {
		for (my $i=$min; $i <= $max; $i++) {
			$body.=<<EOM;
<option value="$i">$i$addstr</option>
EOM
		}
	}
	$body.=<<EOM;
</select>
EOM
	$body;
}

sub plugin_oneclickdiary_action {
	my $mypage=$::form{mypage};
	my $page=$::form{page};
	my $header=&oreplacen($::form{header});
	my $footer=&oreplacen($::form{footer});
	my $cnt=$::form{cnt};
	my $add=$::form{add};
	my $submit=$::form{submit};
	$submit=$add if($add ne "");
	my $comment=$::form{comment};
	my $eom=$::form{eom};
	my $wiki=$::form{wiki};

	my $dt=$::date_format;

	my $year=$::form{year} eq "" ? "" : sprintf("%04d", $::form{year});
	my $month=$::form{month} eq "" ? "" : sprintf("%02d", $::form{month});
	my $day=$::form{day} eq "" ? "" : sprintf("%02d", $::form{day});

	$dt=~s/yyyy/$year/g if($year ne "");
	$dt=~s/[Yy]/$year/g if($year ne "");
	$dt=~s/mm/$month/g if($month ne "");
	$dt=~s/[Mm]/$month/g if($month ne "");
	$dt=~s/[Dd]/$day/g if($day ne "");

	my $tm=$::time_format;
	my $hour=$::form{hour} eq "" ? "" : sprintf("%02d", $::form{hour});
	my $min=$::form{min} eq "" ? "" : sprintf("%02d", $::form{min});
	my $sec=$::form{sec} eq "" ? "" : sprintf("%02d", $::form{sec});

	$tm=~s/[Hh]/$hour/g if($hour ne "");
	$tm=~s/[Ii]/$min/g if($min ne "");
	$tm=~s/[Ss]/$sec/g if($sec ne "");

	my $date=&date($dt);
	my $time=&date($tm);
	my $datetime=&date($::now_format);
	$wiki=~s/\$datetime/$datetime/g;
	$wiki=~s/\$date/$date/g;
	$wiki=~s/\$time/$time/g;
	$wiki=~s/\$action/$submit/g;
	$wiki=~s/\$comment/$comment/g;

	my ($prefix, $splitter);
	if ($page eq '') {
		$prefix = $::form{mypage};
		$splitter = $::separator;
	} elsif ($page eq '*') {
		$prefix = '';
		$splitter = '';
	} else {
		$prefix = $page;
		$splitter = $::separator;
	}

	my $pdate=&date("Y-m-d");
	my $pagename = sprintf "%s%s%s", $page, $splitter, $pdate;
	my $body;
	if (!&is_exist_page($pagename)) {
		$body=<<EOM;
$header
$oneclickdiary::addline
$footer
EOM
	} else {
		$body=$::database{$pagename};
	}

	my $basebody=$::database{$mypage};
#41	if($add ne "") {
#		$basebody=&oreplace($basebody, $eom, $add, $cnt);
#		$::form{mymsg} = $basebody;
#		$::form{mypage}=$basepage;
#		$::form{mytouch} = 'on';
#		&do_write("FrozenWrite", "", $oneclickdiary::mailheader);
#	}
	
	if($submit ne "") {
		$body=&oreplace($body, $oneclickdiary::addline, $wiki, $cnt);
		$::form{mymsg} = $body;
		$::form{mypage}=$pagename;
		$::form{mytouch} = 'on';
		&do_write("FrozenWrite", "", $oneclickdiary::mailheader);
	}
	&location($pagename);
	return;
#	return ("msg"=>"ok", 'body'=>"ok");
}

sub plugin_oneclickdiary_convert {
	my ($page, $eom) = split(/,/, shift);

	$::linedata="";
	$::linesave=1;
	$::eom_string=$eom;
	$::eom_string="#oneclickdiary" if ($eom eq "");
	$oneclickdiary::eom=$::eom_string;
	$::exec_inlinefunc=\&plugin_oneclickdiary_display;
	$oneclickdiary::basepage=$page;
	return ' '
}

sub plugin_oneclickdiary_display {
	my (@list)=split(/\n/, shift);
	my $page=$oneclickdiary::basepage;
	my ($prefix, $splitter);

	my $header=shift @list;
	my $footer=shift @list;
	my $wiki=shift @list;

	my $body;
	my $body=<<EOM;
<form action="$::script" method="post">
<input type="hidden" name="cmd" value="oneclickdiary" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
<input type="hidden" name="page" value="$page" />
<input type="hidden" name="header" value="$header" />
<input type="hidden" name="footer" value="$footer" />
<input type="hidden" name="wiki" value="$wiki" />
<input type="hidden" name="eom" value="$oneclickdiary::eom" />
<input type="hidden" name="cnt" value="@{[++$oneclickdiary::cnt]}" />
EOM

	foreach(@list) {
		if($_ eq "") {
			$body.=<<EOM;
<br />
EOM
		} elsif(/^([Aa][Dd][Dd]|[Ii][Nn][Pp][Uu][Tt])$/) {
			$body.=<<EOM;
<input type="text name="add" value="" />
<input type="submit" name="addsubmit" value="Add" />
EOM
		} elsif(/^[Dd][Aa][Tt][Ee]$/) {
			my ($sec, $min, $hour, $day, $month, $year)=localtime(time);
			$body.=$::resource{oneclickdiary_date} . " : ";
			$body.=&addselect("year", 1900, $year+1900, $::resource{oneclickdiary_year}, "rev");
			$body.=&addselect("month", 1, 12, $::resource{oneclickdiary_month});
			$body.=&addselect("day", 1, 31, $::resource{oneclickdiary_day});
		} elsif(/^[Tt][Ii][Mm][Ee]$/) {
			$body.=$::resource{oneclickdiary_time} . " : ";
			$body.=&addselect("hour", 0, 23, $::resource{oneclickdiary_hour});
			$body.=&addselect("min", 0, 59, $::resource{oneclickdiary_min});
			$body.=&addselect("sec", 0, 59, $::resource{oneclickdiary_sec});
		} else {
			$body.=<<EOM;
<input type="submit" name="submit" value="$_" />
EOM
		}
	}
	$body.=<<EOM;
<br />
$::resource{oneclickdiary_comment} : <input type="text" name="comment" value="" /><br />
</form>
EOM

	return $body;
}
1;
__END__

=head1 NAME

oneclickdiary.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #calendar(pagename)
 #calendar(pagename|*,yyyymm,date_format)
 ?cmd=calendar[&date=yyyymm]

=head1 DESCRIPTION

Display calendar the specified position.

The calendar for the back/following moon can be displayed by choosing link '<<' or '>>' displayed next to the display moon.

If a date called yyyy/mm/dd is chosen on a calendar, display page of / yyyy-mm-dd.

When the page for that day is created, the contents of a page for that day are displayed on the right-hand of a calendar.

=head1 USAGE

=over 4

=item pagename

The page of the higher rank class of the page displayed by the page name can be specified.
It becomes the page of the page installed when the page name was omitted.
When * is specified as a page name, the page of a higher rank class is nothing.
(The page name to display is yyyy-mm-dd)


=item yyyymm

A.D. of the calendar displayed by yyyymm and the moon can be specified.
Years on the day come at the time of an abbreviation.

=item date_format

date_format is an internal function.   The form character string of date can be specified.

'(' and ')' cannot be used for date_format.

Please look at the following detailed samples.

=back

=head1 SETTING

=item $oneclickdiary::initwikiformat

When the contents of the calendar do not exist, the initial value in a new edit screen is set up.

=item $oneclickdiary::menubaronly

If it is set as 1, the link supposing employing a calendar by MenuBar etc. will be carried out.

Even if it clicks '<<' and '>>', the page currently displayed does not change but only a calendar is updated.

=back

=head1 SAMPLES

Date format samples

=over 4

=item #oneclickdiary(pagename,,Y-n-j[D])

2006-1-1[Sun]

=item #oneclickdiary(pagename,,y/m/J)

06/01/01

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/oneclickdiary

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/oneclickdiary/>

=item PyukiWiki/Plugin/Standard/calendar

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/calendar/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/oneclickdiary.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
