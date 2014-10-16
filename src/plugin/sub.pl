######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;

package sub;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($string) = split(/,/, $escaped_argument);
	return qq(<sub>$string</sub>);
}

sub plugin_usage {
	return {
		name => 'sub',
		version => '1.0',
		author => 'Nekyo <nekyo (at) yamaneko (dot) club (dot) ne (dot) jp>',
		syntax => '&sub(string)',
		description => 'Make sub.',
		example => '&sub(string)',
	};
}

1;
__END__

=head1 NAME

sub.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &sub(strings);
 011101010101&sub(2);=0x755

=head1 DESCRIPTION

Character display at bottom.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/sub

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/sub/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/sub.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
