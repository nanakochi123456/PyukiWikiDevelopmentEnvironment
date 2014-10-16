######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'antispam.inc.cgi'
######################################################################
#
# メールアドレス自動収集防止
#
# 使い方：
#   ・antispam.inc.plをantispam.inc.cgiにリネームするだけで使えます
#
######################################################################

# Initlize												# comment

sub plugin_antispam_init {
	$::AntiSpam_Count=0;
	$::AntiSpam="enable";
	$::functions{make_link_mail}=\&make_link_mail;
	return ('init'=>1
		, 'func'=>'make_link_mail', 'make_link_mail'=>\&make_link_mail);
}

# hack wiki.cgi of make_link_mail						# comment

sub make_link_mail {
	my($chunk,$escapedchunk)=@_;
	my $adr=$chunk;
	if($::Token eq '') {
		$::IN_JSHEADVALUE.=&maketoken;
	}
	$adr=~s/^[Mm][Aa][Ii][Ll][Tt][Oo]://g;
	my $mailtoadr="mailto:$adr";
	return qq(<a href="$mailtoadr" class="mail">$escapedchunk</a>) if($::Token eq '');

	my $chunk1=&Enc_UntiSpam("mailto:$adr");

	$::AntiSpam_Count++;
	my $id="antispammail$::AntiSpam_Count";

	if($adr eq $escapedchunk || $mailtoadr eq $escapedchunk) {
		$escapedchunk=&Enc_UntiSpam("$escapedchunk");
		$::AntiSpam_Count++;
		$::IN_JSHEAD.=<<EOM;
addec_text('$escapedchunk','$id');
EOM
		return qq(<span class="mail" id="$id" onclick="addec_link('$chunk1\')" onkeypress="void(0);"></span>);
	} else {
		return qq(<span class="mail" id="$id" onclick="addec_link('$chunk1\','$id')" onkeypress="void(0);">$escapedchunk</span>);
	}
}


sub Enc_UntiSpam {
	my($ad) = @_;
	return &password_encode($ad,$::Token);
}

1;
__DATA__
sub plugin_antispam_setup {
	return(
		ja=>'迷惑メール防止',
		en=>'Anti Spam Plugin',
		override=>'make_link_mail',
		require=>'',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/antispam/'
	);
}
__END__

=head1 NAME

antispam.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Anti Spam Plugin

=head1 DESCRIPTION

All the mail addresses outputted by PyukiWiki are enciphered, and it enables it to decode by the browser for the measure to troublesome mail and a mail address collection program.

=head1 USAGE

rename to antispam.inc.cgi

=head1 OVERRIDE

make_link_mail function was overrided.

=head1 WARNING

The mail address at the time of being outputted like direct html of <a href="mailto:..."> from plug-in is not enciphered.

Please go via a function make_link_mail.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/antispam

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/antispam/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/antispam.inc.pl>

=item The measure against a collection contractor (an automatic collection program and robot) of a mail address

L<http://ninja.index.ne.jp/~toshi/soft/untispam.shtml>

The anti spam library is copy free.

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

=item Toshi(NINJA104)

L<http://ninja.index.ne.jp/~toshi/>

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
