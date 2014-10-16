######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

sub plugin_ipv6check_inline {
	return &plugin_ipv6check_convert(shift);
}

sub plugin_ipv6check_convert {
	my($ipv6page,$ipv4page)=split(/,/,shift);
	my $ipmode="v4";
	my $addr=$ENV{REMOTE_ADDR};
	if($addr=~/^(?:::(?:f{4}:)?)?((?:0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)\.){3}0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)|(?:\d+))$/) {
		$ipmode="v4";
	} elsif($addr=~/:/) {
		$ipmode="v6";
	} else {
		$ipmode="v4";
	}
	if($ipmode eq 'v6') {
		return &text_to_html($::database{$ipv6page}) . " ";
	} else {
		return &text_to_html($::database{$ipv4page}) . " ";
	}
}
1;
__END__

=head1 NAME

ipv6check.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &ipv6check([ipv6page],[ipv4page]);

=head1 DESCRIPTION

Display cliant access for IPV4 or IPV6 check

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/ipv6check

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/ipv6check/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/ipv6check.inc.pl>

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
