######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

sub plugin_now_convert {
	return &plugin_now_inline(@_);
}

sub plugin_now_inline {
	my ($format,$now) = split(/,/, shift);
	my ($y,$m,$d);
	my ($h,$m,$s);

	$format=&htmlspecialchars($format);
	$now=&htmlspecialchars($now);

	if($format eq '') {
		return &date($::now_format);
	}
	$now=time if($now eq '');

	if($now=~/ /) {
		my($date,$time)=split(/ /,$now);
		if($date=~/-/) {
			($y,$m,$d)=split(/\-/,$date);
		} elsif($now=~/\//) {
			($y,$m,$d)=split(/\//,$now);
		}
		if($time=~/\:/) {
			($h,$m,$s)=split(/\:/,$time);
		}
		$now=Time::Local::timelocal($s,$m,$h,$m-1,$y-1900);
	} else {
		$now=time;
	}
	return &date($format,$now);
}

1;
__END__

=head1 NAME

now.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &now;
 &now();
 &now(now_format, [yyyy/mm/dd hh:mm:ss]);

=head1 DESCRIPTION

Display the present or specified date and time in a specification format.

If it specifies like "&now;" without specifying '()', it will be automatically changed into the date at the time of writing, and will not perform as plugin.

When other, the present date and time or the specified date and time is displayed.

=head1 USAGE

=over 4

=item now_format

now_format is an internal function.   The form character string of date and time can be specified.

'(' and ')' cannot be used for now_format.

Please look at the following detailed samples.

=item yyyy/mm/dd hh:mm:ss

Specification date and time. It becomes a date on the day at the time of an abbreviation.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/now

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/now/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/now.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
