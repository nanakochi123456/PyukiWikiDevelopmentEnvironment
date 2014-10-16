######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'authadmin_cookie.inc.cgi'
######################################################################
#
# ���ѥ���ɤΰ��cookie��¸
#
# ��¸���ʤ�cookie�Ȥ��ơ��֥饦���Υ��å����ͭ���ʴ֤���
# ���ѥ���ɤ���¸���ޤ�������������С��֥饦�����Ĥ���ޤ�
# �ѥ���ɤ���¸���ޤ���
#
######################################################################

$::authadmin_cookie_remotehostlist=<<EOM;
192.168.1.1
192.168.1.2
192.168.1.3
192.168.1.4
EOM

$::authadmin_cookie_pass="PAP";
$::authadmin_cookie_enc="PAE";
$::authadmin_cookie_token="PAT";

if(!defined($::authadmin_cookie_admin_name{admin})) {
	$::authadmin_cookie_admin_name{admin}="site admin";
}

if(!defined($::authadmin_cookie_admin_name{attach})) {
	$::authadmin_cookie_admin_name{attach}="site attach manager";
}

if(!defined($::authadmin_cookie_admin_name{frozen})) {
	$::authadmin_cookie_admin_name{frozen}="site frozen manager"
}

$::authadmin_cookie_guest_name="anonymous"
	if(!defined($::authadmin_cookie_guest_name));

$::authadmin_cookie_robot_name="robot agent"
	if(!defined($::authadmin_cookie_robot_name));

$::authadmin_cookie_robot_agent='bot|slurp|crawl|seeker|indexing|y!j.srd|spider|baidu|mobaider|ask|yandex|hatena|blog|infoseek|livedoor|blog|feed|bookmark|sitemaps|virus.*detector|lycos|facebook|grub|htmlparser|html.*lint|htmlparser|ping|search|tcl.*http|w3c.*checklink|w3c.*validator|y!j|yahoo.*blogs|mindset|libwww|checker|discovery|hunter|scanner|sucker'
	if(!defined($::authadmin_cookie_robot_agent));

$::authadmin_cookie_user_name;
$::authadmin_cookie_remotehostauthed=0;

# Initlize										# comment

sub plugin_authadmin_cookie_init {
	&exec_explugin_sub("lang");
	&load_wiki_module("auth");

	foreach(split(/\n/,$::authadmin_cookie_remotehostlist)) {
		$::authadmin_cookie_remotehostauthed=1
			if($ENV{REMOTE_ADDR} eq $_ && $_ ne "");
	}

	my %passwdcookie;
	my %passwdenccookie;
	my %passwdtokencookie;
	%passwdcookie=&getcookie($::authadmin_cookie_pass,%passwdcookie);
	%passwdenccookie=&getcookie($::authadmin_cookie_enc,%passwdenccookie);
	%passwdtokencookie=&getcookie($::authadmin_cookie_token,%passwdtokencookie);
	my %authed;
	$::authadmin_cookie_user_name=$::authadmin_cookie_guest_name;
	$::authadmin_cookie_user_name=$::authadmin_cookie_robot_name
		if($ENV{HTTP_USER_AGENT}=~/$::authadmin_cookie_robot_agent/);

	if(!($passwdcookie{$_} eq '' && $passwdenccookie{$_} eq '' && $passwdtokencooki{$_} eq '')) {
		return ('header'=>$header,'init'=>1
			, 'func'=>'authadminpassword'
			, 'authadminpassword'=>\&authadminpassword)
	}
	foreach("attach", "frozen", "admin") {
		$authed{$_}=0;
		if(&valid_password($passwdcookie{$_}, $_
			, $passwdenccookie{$_}, $passwdtokencookie{$_})) {
			$authed{$_}=1;
			$::authadmin_cookie_user_name=$::authadmin_cookie_admin_name{$_};
			last;
		}
	}

	if($authed{"admin"} eq 1) {
		if($::navi{"admin_url"} eq '') {
			push(@::addnavi,"admin:help");
			$::navi{"admin_url"}="$::script?cmd=admin";
			$::navi{"admin_name"}=$::resource{"adminbutton"};
			$::navi{"admin_type"}="plugin";
		}
	}

	if(&iscryptpass) {
		foreach("attach", "frozen", "admin") {
			if($passwdenccookie{$_} ne '') {
				$passwdenccookie{$_}=&password_encode(&password_decode('',$passwdenccookie{$_},$passwdtokencookie{$_}), $::Token);
				$passwdtokencookie{$_}=$::Token;
			}
		}
		&setcookie($::authadmin_cookie_pass,-1,%passwdcookie);
		&setcookie($::authadmin_cookie_enc,0,%passwdenccookie);
		&setcookie($::authadmin_cookie_token,0,%passwdtokencookie);
	}

	return ('header'=>$header,'init'=>1
		, 'func'=>'authadminpassword', 'authadminpassword'=>\&authadminpassword);
}

sub authadminpassword {
	my($mode,$title,$type)=@_;
	my $body;
	my $auth=0;
	$type=($type eq "attach" ? "attach" : $type eq "frozen" ? "frozen" : "admin");
	my $cookie=$type;
	$cookie="admin" if($::adminpass{admin} eq '' && $::adminpass{frozen} eq '' && $::adminpass{attach} eq '');

	my %passwdcookie;
	my %passwdenccokie;
	my %passwdtokencookie;

	%passwdcookie=&getcookie($::authadmin_cookie_pass,%passwdcookie);
	%passwdenccookie=&getcookie($::authadmin_cookie_enc,%passwdenccookie);
	%passwdtokencookie=&getcookie($::authadmin_cookie_token,%passwdtokencookie);

	if($::authadmin_cookie_remotehostauthed) {
		$auth=2;
	} elsif($::form{mypassword} eq '' && $::form{mypassword_enc} eq ''
	 && $::form{mypassword_token} eq '' && (
			   &valid_password($passwdcookie{$cookie},$cookie
				, $passwdenccookie{$cookie}, $passwdtokencookie{$cookie})
			|| &valid_password($passwdcookie{"admin"},"admin"
				, $passwdenccookie{"admin"}, $passwdtokencookie{"admin"})
			|| &valid_password($passwdcookie{"attach"},"admin"
				, $passwdenccookie{"admin"}, $passwdtokencookie{"admin"})
			|| &valid_password($passwdcookie{"frozen"},"admin"
				, $passwdenccookie{"admin"}, $passwdtokencookie{"admin"})
			)) {
		$::form{"mypassword_$type"}=$passwdcookie{$cookie};
		$::form{"mypassword_$type\_enc"}=$passwdenccookie{$cookie};
		$::form{"mypassword_$type\_token"}=$passwdtokencookie{$cookie};
		$auth=1;
	} elsif(&valid_password($::form{"mypassword_$type"},$type
		, $::form{"mypassword_$type\_enc"}, $::form{"mypassword_$type\_token"})
		 || &valid_password($::form{"mypassword_$type"},"admin"
		, $::form{"mypassword_$type\_enc"}, $::form{"mypassword_$type\_token"})) {
		$passwdcookie{$cookie}=$::form{"mypassword_$type"};
		$passwdenccookie{$cookie}=$::form{"mypassword_$type\_enc"};
		$passwdtokencookie{$cookie}=$::form{"mypassword_$type\_token"};

		if(&iscryptpass) {
			&setcookie($::authadmin_cookie_pass,-1,%passwdcookie);
			&setcookie($::authadmin_cookie_enc,0,%passwdenccookie);
			&setcookie($::authadmin_cookie_token,0,%passwdtokencookie);
		} else {
			&setcookie($::authadmin_cookie_pass,0,%passwdcookie);
			&setcookie($::authadmin_cookie_enc,-1,%passwdenccookie);
			&setcookie($::authadmin_cookie_token,-1,%passwdtokencookie);
		}
		$auth=1;
	}

	if($mode=~/submit|page|form/) {
		$title=$::resource{admin_passwd_prompt_title} if($title eq '');
		if(!$auth) {
			$body=<<EOM;
<h2>$title</h2>
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>\n)]}
<form action="$::script" method="post" id="adminpasswordform" name="adminpasswordform">
$::resource{admin_passwd_prompt_msg}@{[&passwordform('','',"mypassword_$type")]}
EOM
			if(&iscryptpass) {
				$body.=<<EOM;
<span id="submitbutton"></span>
<noscript><input type="submit" value="$::resource{admin_passwd_button}" /></noscript>
EOM
				$::IN_JSHEAD.=<<EOM;
	gid("submitbutton").innerHTML='<input type="button" value="$::resource{admin_passwd_button}" onclick="fsubmit(\\'adminpasswordform\\',\\'$type\\');" onkeypress="fsubmit(\\'adminpasswordform\\',\\'$type\\',event);" />';
EOM
			} else {
				$body.=<<EOM;
<input type="submit" value="$::resource{admin_passwd_button}" />
EOM
			}
			foreach my $forms(keys %::form) {
				$body.=qq(<input type="hidden" name="$forms" value="$::form{$forms}" />\n)
					if($forms!~/^mypassword/);
			}
			$body.="</form>\n";
			return('authed'=>0,'html'=>$body, 'crypt'=>&iscryptpass);
		} else {
#			$body.=	qq(<span id="authed">) .	# comment
#				$::resource{					# comment
#				$auth eq 2 ? "auth_adminauthed_ipaddress"	# comment
#				: "auth_adminauthed_passwd"} . "</span>";	# comment
			$body.=qq(@{[&passwordform($::form{"mypassword\_$type"},"hidden","mypassword\_$type",$::form{"mypassword\_$type\_enc"},$::form{"mypassword\_$type\_token"})]}\n);
			return('authed'=>1,'html'=>$body, 'crypt'=>&iscryptpass);
		}
	} else {
		if(!$auth) {
			$body.=<<EOM;
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>)]}
EOM
			$body.=qq(@{[$title ne '' ? $title : $::resource{admin_passwd_prompt_msg}]}@{[&passwordform('','',"mypassword_$type")]}\n);
			return('authed'=>0,'html'=>$body, 'crypt'=>&iscryptpass);
		} else {
			$body.= qq(<span id="authed">) . 
				$::resource{
				$auth eq 2 ? "auth_adminauthed_ipaddress"
				: "auth_adminauthed_passwd"} . "</span>";
			$body.=qq(@{[&passwordform($::form{"mypassword\_$type"},"hidden","mypassword\_$type",$::form{"mypassword\_$type\_enc"},$::form{"mypassword\_$type\_token"})]}\n);
			return('authed'=>1,'html'=>$body, 'crypt'=>&iscryptpass);
		}
	}
}

1;
__DATA__
sub plugin_authadmin_cookie_setup {
	return(
		en=>'Frozen password saved on temporary cookie',
		jp=>'���ѥ���ɤ������å�������¸����',
		override=>'authadminpassword',
		require=>'',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/authadmin_cookie/'
	);
__END__
=head1 NAME

authadmin_cookie.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Frozen password saved on temporary cookie

=head1 USAGE

rename to authadmin_cookie.inc.cgi

=head1 OVERRIDE

authadminpassword function was overrided.

=BUGS

This plugin is evaluation version. In 1.0, the mounting method is be changed.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/authadmin_cookie

L<@@PYUKI_URL@@PyukiWiki/Plugin/ExPlugin/authadmin_cookie/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/authadmin_cookie.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
