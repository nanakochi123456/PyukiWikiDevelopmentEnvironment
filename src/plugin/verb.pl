######################################################################
# @@HEADER2_YUKI@@
######################################################################

use strict;

package verb;

sub plugin_inline {
	my ($escaped_argument) = @_;
	return qq(<span class="verb">$escaped_argument</span>);
}

sub plugin_usage {
	return {
		name => 'verb',
		version => '1.0',
		author => 'Hiroshi Yuki http://www.hyuki.com/',
		syntax => '&verb(as-is string)',
		description => 'Inline verbatim (hard).',
		example => '&verb(ThisIsNotWikiName)',
	};
}

1;
__END__
=head1 NAME

verb.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &verb(text...);

=head1 DESCRIPTION

Disregards the format rule of PyukiWiki

It is for compatibility with YukiWiki.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/verb

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/verb/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/verb.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_YUKI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_YUKI@@

=cut
