######################################################################
# @@HEADER2_NEKYO@@
######################################################################
#
# �������������֤��롣�����ܸ쥪��꡼��
# :��|
#  #calendar([{[�ڡ���̾],[ǯ��]}])
# -�ڡ���̾����ꤹ�롣��ά�������֥ڡ����Ȥʤ롣
# -ǯ���ɽ����������������ȷ��yyyymm�����ǻ��ꤹ�롣��ά���ϸ���ǯ�

# calendar.inc.pl v0.0.3 cooked up by Birgus-Latro.
# for "PyukiWiki" copyright 2004 by Nekyo.
# based on calendar.inc.php  v1.18  2003/06/04 14:20:36 arino.
#          calendar2.inc.php v1.20  2003/06/03 11:59:07 arino.
#          calendar.pl       v1.2                       Seiji Zenitani.
use strict;

sub plugin_calendar_convert {
	my ($page, $arg_date) = split(/,/, shift);
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);
	my ($disp_wday,$today,$start,$end,$i,$label,$cookedpage,$d);
	my ($prefix,$splitter);
	my $empty = '&nbsp;';
	my $calendar = "";

	($sec, $min, $hour, $mday, $mon, $year) = localtime();
	$today = ($year+1900)*10000 + ($mon+1)*100 + $mday;

	if    ($page eq '') {
		$prefix = $::form{mypage};
		$splitter = '/';
	}
	elsif ($page eq '*') {
		$prefix = '';
		$splitter = '';
	}
	else {
		$prefix = $page;
		$splitter = '/';
	}
	$page = &htmlspecialchars($prefix);
	if ($page eq '') {
		$cookedpage = '*';
	} else {
		$cookedpage = &encode($page);
	}

	if ($arg_date =~ /^(\d{4})[^\d]?(\d{1,2})$/ ) {
		$year = $1 - 1900;
		$mon = ($2-1) % 12;
	}
	my $disp_year  = $year+1900;
	my $disp_month = $mon+1;

	my $start_time = timelocal(0,0,0,1,$mon,$year);
	($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($start_time);
	$label = "$disp_year.$disp_month";
	$start = ($year+1900)*10000 + ($mon+1)*100 + $mday;

	if ( $mon == 11 ) {
		$end = ($year+1900)*10000 + ($mon+1)*100 + 31;
	} else {
		my $end_time = timelocal(0,0,0,1,$mon+1,$year) - 24*60*60;
		($sec, $min, $hour, $mday, $mon, $year ) = localtime($end_time);
		$end = ($year+1900)*10000 + ($mon+1)*100 + $mday;
	}

	my $pagelink;
	if ($::database{$page}) {
		$pagelink = qq(<br />[<a title="$page" href="$::script?$cookedpage">$page</a>]);
	} elsif ($page eq '') {
		$pagelink = '';
	} else {
		$pagelink = qq(<br />[$page<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=adminedit&amp;mypage=$cookedpage">?</a>]);
	}

	my $prev_date_str = ($disp_month ==  1)? sprintf('%04d%02d',$disp_year - 1,12) : sprintf('%04d%02d',$disp_year,$disp_month - 1);
	my $next_date_str = ($disp_month == 12)? sprintf('%04d%02d',$disp_year + 1, 1) : sprintf('%04d%02d',$disp_year,$disp_month + 1);

	$calendar =<<"END";
<table class="style_calendar" summary="calendar body">
<tr>
<td class="style_td_caltop" colspan="7">
  <a href="$::script?cmd=calendar&amp;mymsg=$cookedpage&amp;date=$prev_date_str">&lt;&lt;</a>
  <strong>$label</strong>
  <a href="$::script?cmd=calendar&amp;mymsg=$cookedpage&amp;date=$next_date_str">&gt;&gt;
  $pagelink</td>
</tr>
<tr>
<td class="style_td_week">��</td>
<td class="style_td_week">��</td>
<td class="style_td_week">��</td>
<td class="style_td_week">��</td>
<td class="style_td_week">��</td>
<td class="style_td_week">��</td>
<td class="style_td_week">��</td>
</tr>
<tr>
END

	for ( $i = 0; $i < $wday; $i++ ) {
		$calendar .= "<td class=\"style_td_blank\">$empty</td>";
	}
	my $style = '';
	for ( $i=$start; $i<=$end; $i++ ) {
		$d = $i % 100;
		$disp_wday = ($wday + $i - $start) % 7;
		my $pagename = sprintf "%s%s%04d-%02d-%02d", $page, $splitter, $disp_year, $disp_month, $d;
		my $cookedname = &encode($pagename);

		if (($disp_wday == 0) && ($i > $start)) {
 			$calendar .= "</tr>\n<tr>\n";
		}

		if ( $i == $today ) {		# today
			$style = 'style_td_today';
		} elsif ($disp_wday == 0) {	# Sunday 
			$style = 'style_td_sun';
		} elsif ($disp_wday == 6) {	# Saturday 
			$style = 'style_td_sat';
		} else {
			$style = 'style_td_day';
		}

		if ($::database{$pagename}) {
			$calendar .= qq(<td class="$style"><a title="$pagename" href="$::script?$cookedname"><strong>$d</strong></a></td>);
		} else {
			$calendar .= qq(<td class="$style"><a class="small" title="$::resource{editthispage}" href="$::script?cmd=adminedit&amp;mypage=$cookedname">$d</a></td>);
		}
	}
	for ( $i = $disp_wday + 1; $i < 7; $i++ ) {
		$calendar .= "<td class=\"style_td_blank\">$empty</td>";
	}

	$calendar .= "</tr>\n</table>\n";
	return $calendar;
}

sub plugin_calendar_action {
	my $page = &escape($::form{mymsg});
	my $date = &escape($::form{date});
	my $body = &plugin_calendar_convert(qq($page,$date));

	my $yy = sprintf("%04d.%02d",substr($date,0,4),substr($date,4,2));
	my $s_page = htmlspecialchars($page);
	return ('msg'=>qq(calendar $s_page/$yy), 'body'=>$body);
}

__DATA__

sub plugin_calendar_usage {
	return {
		name => 'calendar',
		version => '1.0',
		type => 'command,convert',
		author => '@@NEKYO@@',
		syntax => '#calendar',
		description => 'Calendar (old style)',
		description_ja => '��������',
		example => '#calendar',
	};
}
1;
__END__

=head1 NAME

calendar.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #calendar(pagename)
 #calendar(pagename|*,yyyymm)

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

=back

=head1 SAMPLES

Date format samples

=over 4

=item #calendar(pagename,,Y-n-j[D])

2006-1-1[Sun]

=item #calendar(pagename,,y/m/J)

06/01/01

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/calendar

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/calendar/>

=item PyukiWiki/Plugin/Standard/calendar2

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/calendar2/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/calendar.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
