######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################

$PLUGIN="html";
$VERSION="1.1";

$html::nofreezeexec=0
	if(!defined($html::nofreezeexec));

sub plugin_html_convert {
	my ($eom)=@_;
	if($html::nofreezeexec eq 0) {
		return ' ' if(!&is_frozen($::form{mypage}));
	}
	$::linedata="";
	$::linesave=1;
	$::eom_string=$eom;
	$::eom_string="#html" if($eom eq '');
	$::exec_inlinefunc=\&plugin_html_display;
	return ' '
}

sub plugin_html_display {
	my($text)=@_;
	if($html::nofreezeexec eq 0) {
		return ' ' if(!&is_frozen($::form{mypage}));
	}
	return $text;
}

1;
__END__
=head1 NAME

html.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #html(EOM)
 <font size="7">BIG FONT</font>
 EOM

=head1 DESCRIPTION

Display HTML

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/sh

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/html/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/html.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
