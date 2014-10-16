######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;
package hr;

sub plugin_block {
	return &plugin_inline;
}

sub plugin_inline {
	return '<hr class="short_line" />';
}

sub plugin_usage {
	return {
		name => 'hr',
		version => '1.0',
		author => 'Nanami <nanami (at) daiba (dot) cx>',
		syntax => '#hr',
		description => '',
		example => '#hr',
	};
}

1;
__END__

=head1 NAME

hr.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 #hr;

=head1 DESCRIPTION

A horizone of 60% line.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/hr

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/hr/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/hr.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
