######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'canonical.inc.cgi'
######################################################################

# canonical (url)
$canonical::url=""
	if(!defined($canonical::url));

# Initlize

sub plugin_canonical_init {
	my ($base, $canonicalflg)=&getbase;

	my $hgeader;
	if($canonicalflg && $::form{mypage} && $::form{cmd} eq "read") {
		my $url="$base" . &make_cookedurl($::form{mypage});
		$url=~s/\/\//\//g;
		$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$url" />
EOM
	}
	return ('init'=>1);
}

sub getbase {
	&getbasehref;
	if($canonical::url=~/$::isurl/) {
		if(substr($canonical::url, 0, length($canonical::url)) ne substr($::basehref, 0, length($canonical::url))) {
			if($::IN_HEAD!~/rel="canonical"/) {
				return ($canonical::url, 1);
			}
		}
	}
	return ($::basehref, 0);
}

1;
__DATA__
sub plugin_canonical_setup {
	return(
		ja=>'検索エンジンに対して重複URLのオリジナルを指定する',
		en=>'Identify the original of duplicate URL to search engines',
		override=>'none',
		require=>'',
		url'=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/canonical/'
	);
}
__END__
=head1 NAME

canonical.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Identify the original of duplicate URL to search engines

=head1 USAGE

rename to canonical.inc.cgi

setting $::canonical::url to original url

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/canonical

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/canonical/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/canonical.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
