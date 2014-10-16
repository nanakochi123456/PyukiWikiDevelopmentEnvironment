######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;
package size;

sub plugin_inline {
	my ($size, $body) = split(/,/, shift);
	if ($size eq '' or $body eq '') {
		return "";
	}
	return "<span style=\"font-size:" . $size . "px;display:inline-block;line-height:130%;text-indent:0px\">$body</span>";
}

1;
__END__

=head1 NAME

size.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &size(20){Display Size 20px};

=head1 DESCRIPTION

Specify size of a character.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/size

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/size/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/size.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
