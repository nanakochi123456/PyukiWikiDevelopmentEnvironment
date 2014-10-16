######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# Usage: &font(font name) { body };
# v0.2.0-p3 : êVãKçÏê¨
######################################################################

use strict;
package font;

sub plugin_inline {
	my ($font, $body) = split(/,/, shift);
	if ($font eq '' or $body eq '') {
		return "";
	}
	return "<span style=\"font-family:$font;\">$body</span>";
}

1;
__END__

=head1 NAME

font.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &font(font name){text};

=head1 DESCRIPTION

Set display font.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/font

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/font/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/font.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
