######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# Usage: &color(color,bgcolor) { body };
# Usage: &color(color) { body };
# Usage: &color(,bgcolor) { body };
# v0.2.0-p3 : îwåiêFÇÃÇ›ÇÃê›íËÇÇ≈Ç´ÇÈÇÊÇ§Ç…ÇµÇΩÅB
######################################################################

use strict;
package color;

sub plugin_inline {
	my @args = split(/,/, shift);
	my ($color, $bgcolor, $body);

	if (@args == 3) {
		$color = $args[0];
		$bgcolor = $args[1];
		$body = $args[2];
		if ($body eq '') {
			$body = $bgcolor;
			$bgcolor = '';
		}
	} elsif (@args == 2) {
		$color = $args[0];
		$body = $args[1];
	} else {
		return '';
	}
	if ($color eq '' && $bgcolor eq '' || $body eq '') {
		return '';
	}
	my $style;
	$style.="color:$color;" if($color ne '');
	$style.="background-color:$bgcolor;" if($bgcolor ne '');

	return "<span style=\"$style\">$body</span>";
}

1;
__END__

=head1 NAME

color.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &color(color, [background-color]){text};
 &color(red){Sample Text};
 &color(#ff0000,#000000){Sample Text};
 &color(,white){Sample Text};

=head1 DESCRIPTION

The character color and background color of a text are specified.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/color

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/color/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/color.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
