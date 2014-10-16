######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;

package sup;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($string) = split(/,/, $escaped_argument);
	return qq(<sup>$string</sup>);
}

sub plugin_usage {
	return {
		name => 'sup',
		version => '1.0',
		author => 'Nekyo',
		syntax => '&sup(string)',
		description => 'Make sub.',
		example => '&sup(string)',
	};
}

1;
__END__
=head1 NAME

sup.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &sup(strings);
 2&sup(2);=4

=head1 DESCRIPTION

Character display at upper.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/sup

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/sup/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/sup.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
