######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

sub plugin_time_convert {
	return &plugin_time_inline(@_);
}

sub plugin_time_inline {
	my ($format,$time) = split(/,/, shift);
	my ($h,$m,$s);

	$format=&htmlspecialchars($format);
	$time=&htmlspecialchars($time);

	if($format eq '') {
		return &date($::time_format);
	}
	$time=time if($time eq '');

	if($time=~/\:/) {
		my($sec, $min, $hour, $mday, $mon, $year,$wday, $yday, $isdst) = localtime;
		($h,$m,$s)=split(/\:/,$time);
		$time=Time::Local::timelocal($s,$m,$h,$mday,$mon,$year);
	}
	return &date($format,$time);
}

1;
__END__

=head1 NAME

time.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &time;
 &time();
 &time(time_format, [hh:mm:ss]);

=head1 DESCRIPTION

Display the present or specified time in a specification format.

If it specifies like "&time;" without specifying '()', it will be automatically changed into the time at the time of writing, and will not perform as plugin.

When other, the present time or the specified time is displayed.

=head1 USAGE

=over 4

=item time_format

time_format is an internal function.   The form character string of time can be specified.

'(' and ')' cannot be used for time_format.

Please look at the following detailed samples.

=item hh:mm:ss

Specification time. It becomes a time on the day at the time of an abbreviation.

=back

=head1 SAMPLES

=over 4

Format smples.

=over 4

=item &time(h:i:s,13:03:25)

13:03:25

=item &time(A g:k:S,13:03:25)

PM 1:3:25

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/time

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/time/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/time.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
