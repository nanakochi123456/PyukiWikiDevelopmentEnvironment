######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'iecompatiblehack.inc.cgi'
######################################################################
#
# IEの互換表示ボタンをなくすプラグイン
#
######################################################################


# Initlize

sub plugin_iecompatiblehack_init {
	my $agent=$ENV{HTTP_USER_AGENT};
	my $header;
	if($ENV{HTTP_USER_AGENT}=~/Trident\/\d+.\d+; rv:(\d+).(\d+)/) {
		$header=<<EOM;
X-UA-Compatible: IE=$1
EOM
	}

	if($ENV{HTTP_USER_AGENT}=~/MSIE (\d+).(\d+)/) {
		if($1 > 6) {
			$header=<<EOM;
X-UA-Compatible: IE=$1
EOM
		}
	}
	return ('http_header'=>$header, 'init'=>1, 'func'=>'');
}

1;
__DATA__
sub plugin_iecompatiblehack_setup {
	return(
		ja=>'IEの互換表示ボタンを強制的になくすプラグイン',
		en=>'For Internet Explorer, disable compatible button',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/iecompatiblehack/'
	);
}
__END__
=head1 NAME

iecompatiblehack.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

For Internet Explorer, disable compatible button

=head1 USAGE

rename to iecompatiblehack.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/iecompatiblehack

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/iecompatiblehack/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/iecompatiblehack.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
