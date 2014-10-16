######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################

$PLUGIN="head";
$VERSION="1.1";

$head::nofreezeexec=0
	if(!defined($head::nofreezeexec));

sub plugin_head_convert {
	my ($eom)=@_;
	if($head::nofreezeexec eq 0) {
		return ' ' if(!&is_frozen($::form{mypage}));
	}
	$::linedata="";
	$::linesave=1;
	$::eom_string=$eom;
	$::eom_string="#head" if($eom eq '');
	$::exec_inlinefunc=\&plugin_head_display;
	return ' '
}

sub plugin_head_display {
	my($text)=@_;
	if($head::nofreezeexec eq 0) {
		return ' ' if(!&is_frozen($::form{mypage}));
	}
	$::IN_HEAD.=$text;
	return ' '
}

1;
__END__
=head1 NAME

head.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #head(EOM)
 <script type="text/javascript"><!--
 alert("Hello world");
 //--></script>
 EOM

=head1 DESCRIPTION

Insert head tags.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/sh

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/head/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/head.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
