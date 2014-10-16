######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 add compatible with Pukiwiki
######################################################################

sub plugin_nofollow_convert {
	return if(!&is_frozen($::form{mypage}));

	$::IN_META_ROBOTS=<<EOM;
<meta name="robots" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
<meta name="googlebot" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
EOM
	return ' ';
}

1;
__END__

=head1 NAME

nofollow.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #nofollow

=head1 DESCRIPTION

Same of #metabotos(disable)

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/nofollow

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/nofollow/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/nofollow.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
