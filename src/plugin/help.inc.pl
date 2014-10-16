######################################################################
# @@HEADER2_NANAMI@@
######################################################################

sub plugin_help_action {
	$::form{mypage}=$::resource{help};
	if(!&is_readable($::form{mypage})) {
		&print_error($::resource{auth_readfobidden});
	}
	# 2005.11.2 pochi: •”•ª•ÒW‚ð‰Â”\‚É				# comment
	&plugin_help_skinex($::form{mypage}, &text_to_html($::database{$::form{mypage}}, mypage=>$::form{mypage}), 2, @_);
	&close_db;
	exit;
}

sub plugin_help_skinex {
	my ($page, $body, $is_page, $pageplugin) = @_;
	my $bodyclass = "normal";
	my $editable = 0;
	my $admineditable = 0;
	$pageplugin+=0;
	$::pageplugin+=0;

	if (&is_frozen($::form{refer}) && &is_exist_page($::form{refer})) {
		$admineditable = 1;
		$bodyclass = "frozen";
	} elsif (&is_editable($::form{refer}) && &is_exist_page($::form{refer})) {
		$admineditable = 1;
		$editable = 1;
	}
	&makenavigator($page,$is_page,$editable,$admineditable);

	$::IN_HEAD.=&meta_robots($::form{cmd},$page,$body);
	my $output_mime = $::htmlmode eq "xhtml11"
		&& $ENV{'HTTP_ACCEPT'}=~ m!application/xhtml\+xml!
		&& &is_no_xhtml(1) eq 0
		? 'application/xhtml+xml' : 'text/html';
	$::HTTP_HEADER=&http_header("Content-type: $output_mime; charset=$::charset", $::HTTP_HEADER);
	require $::skin_file;
	my $body=&skin($page, $body, $is_page, $bodyclass, $editable, $admineditable, $::basehref);
	$body=&_db($body);

	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body,   $::kanjicode);
	}
	&content_output($::HTTP_HEADER, $body);
}

1;
__END__

=head1 NAME

help.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=help [& refer=refer page]

=head1 DESCRIPTION

Display help page

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/help

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/help/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/help.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
