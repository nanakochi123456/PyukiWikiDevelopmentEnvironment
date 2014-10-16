######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'setting.inc.cgi'
######################################################################

# Initlize											# comment

%::setting_cookie;
$::setting_cookie="PWS_"
				. &dbmname($::basepath);
%::name_cookie;
$::name_cookie="PWU_"
				. &dbmname($::basepath);

sub plugin_setting_init {
	&exec_explugin_sub("lang");
	&exec_explugin_sub("urlhack");
	if($::navi{"setting_url"} eq '') {
		push(@::addnavi,"setting:help");
		$::navi{"setting_url"}="$::script?cmd=setting&amp;mypage=@{[&encode($::form{mypage} ne '' ? $::form{mypage} : $::form{refer})]}";
		$::navi{"setting_name"}=$::resource{"settingbutton"};
		$::navi{"setting_type"}="plugin";
	}
	%::setting_cookie=();
	%::setting_cookie=&getcookie($::setting_cookie,%::setting_cookie);
	%::name_cookie=&getcookie($::name_cookie,%::name_cookie);
	if($::setting_cookie{savename} eq 0) {
		if($::name_cookie{myname} ne '') {
			$::name_cookie{myname}="";
			$::name_cookie{myurl}="";
			$::name_cookie{mymail}="";
			&setcookie($::name_cookie, -1, %::name_cookie);
		}
	}
	&plugin_setting_setting;
	return ('init'=>1);
}

sub plugin_setting_savename {
	my($name, $url, $mail)=@_;
	$::name_cookie{myname}=$name;
	$::name_cookie{myurl}=$url if($url=~/$::isurl/o && $url ne "");
	$::name_cookie{mymail}=$mail if($mail=~/$::ismail/o && $mail ne "");

	&setcookie($::name_cookie, 1, %::name_cookie);
}

sub plugin_setting_setting {
	if($::setting_cookie{style} ne '') {
		my $style=$::setting_cookie{style};
		if($style!~/\//) {
#			my $push=$::skin_name;			# comment
			# bug fix 0.2.0-p3				# comment
			if($style=~/^\w{1,64}$/) {
				$::skin_name=$style;
				&skin_init;
			}
#			$::skin_name=$push;				# comment
		}
	}
	if($::setting_cookie{fontsize}+0 > 0) {
		$::IN_HEAD.=<<EOM
<style type="text/css"><!--
#body{font-size:@{[$::setting_cookie{fontsize} eq 1 ? '120' : '90']}%;}
//--></style>
EOM
	}

	my $escapeoff=0;
	if(defined($::setting_cookie{escapeoff})) {
		$escapeoff=$::setting_cookie{escapeoff}+0;
	} else {
		$escapeoff=$::use_escapeoff+0;
	}
	&escapeoff($escapeoff);
}
1;
__DATA__
sub plugin_setting_setup {
	return(
		ja=>'cookieに対してWikiの表示設定をする',
		en=>'Setup of Wiki is carried out to cookie.',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/Admin/setting/'
	);
__END__

=head1 NAME

setting.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

This is plugin/setting.inc.pl 's sub plugin, look plugin document.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/setting

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/punyurl/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/setting.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/setting.inc.pl>

=back

=head1 AUTHOR

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
