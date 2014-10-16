######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

sub plugin_date_convert {
	return &plugin_date_inline(@_);
}

sub plugin_date_inline {
	my ($format,$date) = split(/,/, shift);
	my ($y,$m,$d);

	$format=&htmlspecialchars($format);
	$date=&htmlspecialchars($date);

	if($format eq '') {
		return &date($::date_format);
	}
	$date=time if($date eq '');

	if($date=~/-/) {
		($y,$m,$d)=split(/\-/,$date);
		$date=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900);
	} elsif($date=~/\//) {
		($y,$m,$d)=split(/\//,$date);
		$date=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900);
	}
	return &date($format,$date);
}

1;
__END__

=head1 NAME

date.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &date;
 &date();
 &date(date_format, [yyyy/mm/dd]);

=head1 DESCRIPTION

Display the present or specified date in a specification format.

If it specifies like "&date;" without specifying '()', it will be automatically changed into the date at the time of writing, and will not perform as plugin.

When other, the present date or the specified date is displayed.

=head1 USAGE

=over 4

=item date_format

date_format is an internal function.   The form character string of date can be specified.

'(' and ')' cannot be used for date_format.

Please look at the following detailed samples.

=item yyyy/mm/dd

Specification date. It becomes a date on the day at the time of an abbreviation.

=back

=head1 SAMPLES

Date format samples

=over 4

=item &date(Y-n-j[D],2006/1/1)

2006-1-1[Sun]

=item &date(y/m/J,2006/1/1)

06/01/01

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/date

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/date/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/date.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
