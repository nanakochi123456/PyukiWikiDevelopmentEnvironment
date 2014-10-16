######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# v0.2.1 2012/09/28 ˆÚ“®
######################################################################

sub plugin_rss10page_action {
	&getbasehref;
	&location(
		"$::basehref?cmd=rss10page&ver=1.0"
		. ($::form{lang} ne "" ? ("&lang=" . $::form{lang}) : "")
		, 301);
	exit;
}

sub plugin_rss10page_inline {
	require "$::plugin_dir/rsspage.inc.pl";
	return &plugin_rsspage_inline(@_);
}

sub plugin_rss10page_convert {
	require "$::plugin_dir/rsspage.inc.pl";
	return &plugin_rsspage_convert(@_);
}

1;
__END__

=head1 NAME

rss10page.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=rss10page&page=pagename[&lang=lang]
 #rss10page(- or *)

=head1 DESCRIPTION

Output RSS (RDF Site Summary) 1.0 from it's page

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/rss10page

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/rss10page/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/rss10page.inc.pl>

=item YukiWiki

Using Yuki::RSS

L<http://www.hyuki.com/yukiwiki/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
