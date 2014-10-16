######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# v0.2.1 2012/09/28 °ÜÆ°
######################################################################

sub plugin_rss10_action {
	&getbasehref;
	&location(
		"$::basehref?cmd=rss&ver=1.0"
		. ($::form{lang} ne "" ? ("&lang=" . $::form{lang}) : "")
		, 301);
	exit;
}
1;
__END__
=head1 NAME

rss10.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=rss10[&lang=lang]

=head1 DESCRIPTION

Output RSS (RDF Site Summary) 1.0 from RecentChanges

for compatible plugin.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/rss10

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/rss10/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/rss10.inc.pl>

=item YukiWiki

using Yuki::RSS.

L<http://www.hyuki.com/yukiwiki/>

=back

=head1 AUTHOR

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
