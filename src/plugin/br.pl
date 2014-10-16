######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;
package br;

sub plugin_block {
	return &plugin_inline;
}

sub plugin_inline {
	return qq(<br />);
}

sub plugin_usage {
	return {
		name => 'br',
		version => '1.0',
		type => 'yukiwiki,block,inline',
		author => '@@NEKYO@@',
		syntax => '&br;',
		description => 'line break.',
		description_ja => '‰üs‚ð‚µ‚Ü‚·',
		example => '&br;',
	};
}

1;
__END__

=head1 NAME

br.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &br;
 line&br;break

=head1 DESCRIPTION

A new line is started in the specified position.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/br

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/br/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/br.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
