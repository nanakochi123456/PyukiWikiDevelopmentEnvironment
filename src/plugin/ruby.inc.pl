######################################################################
# @@HEADER2_NEKYO@@
######################################################################

sub plugin_ruby_inline {
	@arg = split(/,/, shift);
	my $ruby = $arg[0];
	my $body = $arg[1];

	if ($ruby eq '' or $body eq '') {
		return '';
	}
	my $s_ruby = &escape($ruby);
	return "<ruby><rb>$body</rb><rp>(</rp><rt>$s_ruby</rt><rp>)</rp></ruby>";
}
1;
__END__
=head1 NAME

ruby.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &ruby(yomigana){string};

=head1 DESCRIPTION

A kana of ruby set as a character string.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/ruby

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/ruby/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/ruby.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
