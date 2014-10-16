######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# 言語cookie設定用プラグイン
# ExPlugin lang.inc.cgi、$::write_location=1を有効にする必要があります
######################################################################

sub plugin_lang_action {
	my $body;
	return if($::lang_cookie eq '' || $::write_location eq 0);
# 0.1.9 fix
	return if($::useExPlugin eq 1 && $::_exec_plugined{lang} ne 2);

	my $page=$::form{refer} ne "" ? $::form{refer} : $::FrontPage;
	$::lang_cookie{lang}=$::form{lang};
	$::lang_cookie{lang}='' if($::langlist{$::form{lang}} eq '');
	&setcookie($::lang_cookie, 1, %::lang_cookie);
	&location("$::basehref?@{[&encode($page)]}", 302, $::HTTP_HEADER);
	close(STDOUT);
	exit;
}

1;
__END__

=head1 NAME

lang.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

This is explugin/lang.inc.cgi 's sub plugin, look explugin document.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/lang

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/lang/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/lang.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/lang.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
