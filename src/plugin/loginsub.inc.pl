######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 First Release
######################################################################

# ユーザー登録用フォーム
#$login::useraddforms="text|userid,password|pass1,password|pass2,mail|email,mailconfirm|emailchk,word|word1,word|word2,word|word3,captcha|captcha,submit2|submit|login_plugin_useradd_button"

$login::useraddforms="text|nickname,select|sex|login_plugin_useradd_sex_value,date|birthday,text|userid,password|pass1,password|pass2,mail|email,mailconfirm|emailchk,word|word1,word|word2,word|word3,captcha|captcha,submit2|submit|login_plugin_useradd_button"
	if(!defined($login::useraddforms));

$login::openidforms="text|nickname,select|sex|login_plugin_useradd_sex_value,date|birthday,hidden|service,readonly|openid,readonly|userid,mail|email,mailconfirm|emailchk,captcha|captcha,submit2|submit|login_plugin_useradd_button"
	if(!defined($login::openidforms));

$login::oauthforms="text|nickname,select|sex|login_plugin_useradd_sex_value,date|birthday,hidden|service,readonly|oauth,readonly|userid,mail|email,mailconfirm|emailchk,captcha|captcha,submit2|submit|login_plugin_useradd_button"
	if(!defined($login::oauthforms));

# confirmフォーム
$login::confirmforms="text|confirm,submit|submit|login_plugin_confirm_button";

# パスワード再発行フォーム
$login::forgetforms="text|femail,mailconfirm|femailchk,date|birthday,captcha|fcaptcha,submit|submit|login_plugin_forget_button";

sub plugin_login_teamofuse {
	my $body;

	%::resource=&login_read_resource("login_teamofuse", %::resource);
	$::nowikiname = 1;
	&init_inline_regex;
	my $body=&replace($::resource{login_teamofuse_msg},
		TITLE=>$::wiki_title,
		script=>$::script,
		DAYS=>$login::writewaitdays,
	);

	return(msg=>"\t$::resource{login_teamofuse_title}", body=>&text_to_html($body));
}

sub plugin_login_useradd {
	my $title;
	my $body;
	my %err;

	%::resource=&login_read_resource("login_useradd", %::resource);
	$err{ok}=1;
	if(&chksubmit("back") || $ENV{REQUEST_METHOD} eq "GET") {
		$err{ok}=0;
	} elsif(&chksubmit("submit2")) {
		%err=&loginchk("useradd", "$login::useraddforms","","",%err);
		return &login_adduser($login::useraddforms);
	} elsif(&chksubmit("submit")) {

		%err=&loginchk("useradd", "$login::useraddforms","","",%err);
#		return (msg=>"test", body=>"test");
	} else {
		%err=&loginchk("useradd", "$login::useraddforms","","",%err);
	}
	$body.=&loginhtml("useradd", "$login::useraddforms","","",%err);

	return (msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
}

sub plugin_login_openid {
	my $body;
	if($::_module_loaded{"Net::OpenID::Consumer"}) {
		if($::form{x} eq "v") {
			my %hash=Nana::OpenID::verify();
			if($hash{status} eq "login") {
				my $service=$::form{ls_service};
				my %tmpuser=&readuser($hash{url});
 				if($tmpuser{session} eq "") {
					$::form{lf("openid")}=$::resource{"login_plugin_openid_service_" . $service};
					$::form{lf("userid")}=$hash{url};
					%::resource=&login_read_resource("login_useradd", %::resource);
					my %err;
					$body.=&loginhtml("useradd", "$login::openidforms","","",%err);

					return (msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
#					%err=&loginchk("useradd", "$login::openidforms","","",%err);
#					return &login_adduser($login::openidforms);
				} else {
					my $session=$tmpuser{session};
					my $sessionpass;
					foreach(keys %::session) {
						$sessionpass=&rnd($sessionpass . $::session{$_});
					}
					$::session{sessionpass}=$sessionpass;
					my %scookie;
					$scookie{&ln("session")}=$session;
					$scookie{&ln("sessionpass")}=$sessionpass;
					&setcookie($login::cookie_session, $login::sessionexpire , %scookie);
					my $url="$::script?$::form{refer}";
					&location($url, 302, $::HTTP_HEADER);
				}
#				$body.=qq(<a href="$hash{url}">$hash{url}</a><br />);
#				$body.=qq(<a href="?@{[&encode($::form{refer})]}">$::form{refer}</a><br />);
			} elsif($hash{status} eq "redirect") {
				&location($hash{url}, 302, $::HTTP_HEADER);
				exit;
			} elsif($hash{status} eq "cancel") {
				my($url, $name)=Nana::OpenID::getid($::form{lf("service")});
				my $res=$::resource{login_plugin_openid_cancel};
				$res=~s/\$1/$name/g;
				$body.=&loginhtml("login", "$login::loginforms1", $res, &plugin_login_openidform);
			} else {
				my($url, $id, $name)=Nana::OpenID::getid($::form{lf("service")});
				my $res=$::resource{login_plugin_openid_error};
				$res=~s/\$1/$name/g;
				$res=~s/\$2/$hash{code}/g;
				$res=~s/\$3/$hash{text}/g;
				$body.=&loginhtml("login", "$login::loginforms1", $res, &plugin_login_openidform);
			}
		} else {
			eval {
				my $url=Nana::OpenID::login($::form{lf("url")}, "refer=$::form{refer}");
				&location($url, 302, $::HTTP_HEADER);
				exit;
			};
			if($@) {
				my($url, $id, $name)=Nana::OpenID::getid($::form{lf("service")});
				my $res=$::resource{login_plugin_openid_autherr};
				$res=~s/\$1/$name/g;
				$res=~s/\$2/@$/g;
				$body.=&loginhtml("login", "$login::loginforms1", $res, &plugin_login_openidform);
			}
		}
	}
	return(msg=>"\ttest", body=>$body);
}

sub plugin_login_oauth {
	my $body="";
	if($::_module_loaded{"Net::OAuth"}) {
		if($::form{oauth_token} ne "") {
			my %cook;
			%cook=&getcookie($Nana::OAuth::Cook, %cook);
			my $svc=$cook{$Nana::OAuth::CookService};
			if($svc eq "") {
				&location("?cmd=login");
				exit;
			}
			my %hash=Nana::OAuth::verify($svc);
			if($hash{status} eq "login") {
				my $service=$svc;
				my %tmpuser=&readuser($hash{access_token});
 				if($tmpuser{session} eq "") {
					$::form{lf("oauth")}=$::resource{"login_plugin_oauth_service_" . $service};
					my $feed=$Nana::OAuth::List->{$svc}->{userid};
					$::form{lf("userid")}=$hash{$feed};
					%::resource=&login_read_resource("login_useradd", %::resource);
					my %err;
					$body.=&loginhtml("useradd", "$login::oauthforms","","",%err);
					return (msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
#					%err=&loginchk("useradd", "$login::oauthforms","","",%err);
#					return &login_adduser($login::oauthforms);
				} else {
					my $session=$tmpuser{session};
					my $sessionpass;
					foreach(keys %::session) {
						$sessionpass=&rnd($sessionpass . $::session{$_});
					}
					$::session{sessionpass}=$sessionpass;
					my %scookie;
					$scookie{&ln("session")}=$session;
					$scookie{&ln("sessionpass")}=$sessionpass;
					&setcookie($login::cookie_session, $login::sessionexpire , %scookie);
					my $url="$::script?$::form{refer}";
					&location($url, 302, $::HTTP_HEADER);
				}
			} elsif($hash{status} eq "redirect") {
				&location($hash{url}, 302, $::HTTP_HEADER);
				exit;
			} elsif($hash{status} eq "cancel") {
				my($url, $name)=Nana::OAuth::getid($::form{lf("service")});
				my $res=$::resource{login_plugin_oauth_cancel};
				$res=~s/\$1/$name/g;
				$body.=&loginhtml("login", "$login::loginforms1", $res, &plugin_login_openidform);
			} else {
				my($url, $id, $name)=Nana::OAuth::getid($::form{lf("service")});
				my $res=$::resource{login_plugin_oauth_error};
				$res=~s/\$1/$name/g;
				$res=~s/\$2/$hash{code}/g;
				$res=~s/\$3/$hash{text}/g;
				$body.=&loginhtml("login", "$login::loginforms1", $res, &plugin_login_openidform);
			}
		} else {
			eval {
				my $url=Nana::OAuth::login($::form{lf("url")}, "refer=$::form{refer}", $::form{lf("service")});
				&location($url, 302, $::HTTP_HEADER);
				exit;
			};
			if($@) {
				my($url, $id, $name)=Nana::OAuth::getid($::form{lf("service")});
				my $res=$::resource{login_plugin_oauth_autherr};
				$res=~s/\$1/$name/g;
				$res=~s/\$2/@$/g;
				$body.=&loginhtml("login", "$login::loginforms1", $res, &plugin_login_openidform);
			}
		}
	}
	return(msg=>"\ttest", body=>$body);
}

sub plugin_login_check_userid {
	my($f, $s, %err)=@_;
	&load_wiki_module("write");
	my $flg=0;
	$flg=1 if(&disablewords("useradd", $s, $::disablewords{ja},1));
	$flg=1 if(&disablewords("useradd", $s, $::disablewords,1));
	$flg=1 if(&disablewords("useradd", $s, $::disablewords_username{ja},1));
	$flg=1 if(&disablewords("useradd", $s, $::disablewords_username,1));
	$err{$f}=$::resource{"login_plugin_useradd_$f\_disable"}
		if($flg);
	%err;
}

sub plugin_login_check_password {
	my($f, $s, %err)=@_;
	%err;
}

sub plugin_login_check_newpass {
	my($f, $s, %err)=@_;
	return %err if($err{$f} ne "");
	if($::form{lf("pass1")} ne $::form{lf("pass2")}) {
		$err{$f}=$::resource{"login_plugin_useradd_$f\_err"};
	} elsif($s=~/[\,\=\\\$\'\"]/) {
		$err{$f}=$::resource{"login_plugin_useradd_$f\_ignorestr"};
	} else {
		my $flg=0;
		$flg++ if($s=~/[A-Za-z]/);
		$flg++ if($s=~/[0-9]/);
		if($flg < 2) {
			$err{$f}=$::resource{"login_plugin_useradd_$f\_char"};
		}
	}
	%err;
}

sub plugin_login_check_email {
	my($f, $s, %err)=@_;
	return %err if($err{"email"} ne "");

	%::resource=&login_read_resource("login_mailaddr", %::resource);

	if($::form{lf("email")} ne
		$::form{lf("emailchk1")} . '@' . $::form{lf("emailchk2")}) {
		$err{$f}=$::resource{"login_plugin_useradd_email_diff"};
	}
	if($::form{lf("email")}!~/$::ismail/o) {
		$err{$f}=$::resource{"login_plugin_useradd_email_err"};
	}
	my @mx;
	if(&load_module("Net::DNS")) {
		@mx=Net::DNS::mx($::form{lf("emailchk2")});
		$err{$f}=$::resource{"login_plugin_useradd_email_notdomain"}
			if($#mx < 0);
	}

	foreach("mobile", "sp", "msnlive", "freemail") {
		%err=&chkmaildomain($_, $f, $::form{lf("emailchk2")}, %err);
	}

	%err;
}

sub chkmaildomain {
	my($m, $f, $domain, %err)=@_;
	my $list=$::resource{"login_$m"};
	my $flg=0;
	my @mx;
	if(&load_module("Net::DNS")) {
		@mx=Net::DNS::mx($::form{lf("emailchk2")});
	}

	foreach my $l(split(/\n/,$list)) {
		$flg=1 if($domain=~/$l/);
		$flg=1 if($l=~/$domain/);
		foreach my $mx(@mx) {
			my $m=$mx->exchange;
			$flg=1 if($l=~/$m/);
			$flg=1 if($m=~/$l/);
		}
	}
	$err{$f}=$::resource{"login_plugin_useradd_email_$m\_match_pc"} if($flg);
#	$err{$f}=$::resource{"login_plugin_useradd_email_$m\_match_sp"} if($flg);
#	$err{$f}=$::resource{"login_plugin_useradd_email_$m\_match_mobile"} if($flg);
	%err;
}

sub loginchk {
	my ($title, $forms, $status, $add, %err)=@_;

	foreach(split(/,/,$forms)) {
		my($fmode, $form, $res)=split(/\|/,$_);
		%err=&loginformchk($fmode, $title, $form, $res, %err);
	}
	%err;
}

sub loginformchk {
	my($fmode, $formid, $form, $res, %err)=@_;
	my($minlength, $maxlength)=split(/,/,$login::style->{$form}->{length});
	my $value=$::form{lf($form)};
	my $chkmethod=undef;
	if(defined($login::style->{$form}->{check})) {
		$chkmethod=$login::style->{$form}->{check};
	}

	if($fmode eq "text" || $fmode eq "mail") {
		if($minlength+0 > 0) {
			if(length($value) eq 0) {
				$err{$form}=$::resource{"login_plugin_useradd_$form\_noinput"};
				$err{ok}=0;
			}
		}
		if($err{$form} eq "" && $minlength+0 > 0 && $maxlength+0 > 0) {
			if(length($value) < $minlength || length($value) > $maxlength) {
				$err{$form}=$::resource{"login_plugin_useradd_$form\_length"};
				$err{$form}=~s/\$MIN/$minlength/g;
				$err{$form}=~s/\$MAX/$maxlength/g;
				$err{ok}=0;
			}
		}
	}
	if($fmode eq "password") {
		my $f=lf($form);
		$value=&password_decode($::form{$f}, $::form{"$f\_enc"}, $::form{"$f\_token"});
		$value=~s/\t.*//g;
		if($minlength+0 > 0) {
			if(length($value) eq 0) {
				$err{$form}=$::resource{"login_plugin_useradd_$form\_noinput"};
				$err{ok}=0;
			}
		}
		if($err{$form} eq "" && $minlength+0 > 0 && $maxlength+0 > 0) {
			if(length($value) < $minlength || length($value) > $maxlength) {
				$err{$form}=$::resource{"login_plugin_useradd_$form\_length"};
				$err{$form}=~s/\$MIN/$minlength/g;
				$err{$form}=~s/\$MAX/$maxlength/g;
				$err{ok}=0;
			}
		}
	}
	if($fmode eq "word") {
	}
	if($chkmethod ne undef) {
		%err=&$chkmethod($form, $value, %err);
		$err{ok}=0 if($err{$form} ne "");
	}

	%err;
}

sub mail {
	my($res, $to, %s)=@_;
	my %hash;
	$hash{wiki_title}=$::wiki_title;
	$hash{modifier_mail}=$::modifier_mail;
	my($url, $dmy, $dmy)=&getbasehref;
	$hash{url}=$::basehref;
	$hash{modifier_name}=$::modifier;
	$hash{DATETIME}=&date($::now_format, time);
	$hash{EXPIREDATETIME}=&date($::now_format, time + $login::confirmexpire);
	foreach(keys %s) {
		$hash{$_}=$s{$_};
	}
	foreach(keys %ENV) {
		$hash{$_}=$ENV{$_};
	}
	$hash{expire}=int($login::confirmexpire / 3600);

	%::resource=&login_read_resource("login_mail", %::resource);
	my $mail=$::resource{"login_mail_" . $res};
	$mail=&replace($mail, %hash);
	my $body;
	my $subject;
	my $from_name;
	my $to_name;
	foreach(split(/\n/, $mail)) {
		if(/^Subject:(.*)/ && $subject eq "") {
			$subject=&trim($1);
		} elsif(/^From:(.*)/ && $from_name eq "") {
			$from_name=&trim($1);
		} elsif(/^To:(.*)/ && $to_name eq "") {
			$to_name=&trim($1);
		} else {
			$body.="$_\n";
		}
	}
	&load_module("Nana::Mail");
	Nana::Mail::send(
		to=>$to,
		to_name=>$to_name,
		from=>$::modifier_mail,
		from_name=>$from_name,
		subject=>$subject,
		pgp=>0,
		data=>$body
	);
}

sub plugin_login_confirm {
	my $title;
	my $body;
	my %err;

	%::resource=&login_read_resource("login_useradd", %::resource);
	$err{ok}=0;
	if($::form{x} eq "") {
		$::form{x}=$::form{lf("confirm")};
	}
	if($::form{x} ne "") {
		my $s=&searchsession("confirm", $::form{x});
		if($s ne undef) {
			&readsession($s);
			my %cook;
			%cook=getcookie($login::cookie_confirm, %cook);
			if($::session{sessionpass} eq $cook{p}) {
				if($::session{confirmexpire} < time) {
#					delete $::session{confirm};
#					delete $::session{sessionpass};
					&deleteuser($::session{userid});
					&deleteuser($::session{email});
					&deletesession($::session{session})
;
					$body.=qq(<span class="error">$::resource{login_plugin_confirm_expire}</span>);
					$body.=&loginhtml("useradd", "$login::useraddforms","","",%err);

					return (msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
				} else {
					&setcookie($login::cookie_confirm, -1, %cook);
					$::session{confirm}="";
					$::session{confirmexpire}="";
					$::session{sessionpass}="";
					&writesession($s, %::session);
					&location("?cmd=login&amp;mode=loginonly", 302, $::HTTP_HEADER);
					exit;
				}
			} else {
				$body.=qq(<span class="error">$::resource{login_plugin_confirm_cookieerror}</span>);
			}
		}
		if($body eq "") {
			$body.=qq(<span class="error">$::resource{login_plugin_confirm_error}</span>);
		}
	}
	$body.=&loginhtml("confirm", "$login::confirmforms","","",%err);

	return (msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
}

sub login_adduser {
	my ($forms, %hash)=@_;
	my $body;
	my %err;
	$err{ok}=1;
	my %v;
	foreach(split(/,/,$forms)) {
		my($mode, $form, $dmy)=split(/\|/,$_);
		my $chkmethod=undef;
		if($form eq "emailchk" || $form eq "captcha" || $form eq "submit") {
			next;
		}
		if(defined($login::style->{$form}->{check})) {
			$chkmethod=$login::style->{$form}->{check};
		}
		if($chkmethod ne undef) {
			if($mode eq "text" || $mode eq "mail") {
				%err=&$chkmethod($form, $::form{lf($form)}, %err);
				$err{ok}=0 if($err{$form} ne "");
			}
		}
	}
	if($err{ok}) {
		foreach(split(/,/,$forms)) {
			my($mode, $form, $dmy)=split(/\|/,$_);
			if($form eq "emailchk" || $form eq "captcha" || $form eq "submit") {
				next;
			} elsif($mode eq "text") {
				$v{$form}=$::form{lf($form)};
			} elsif($mode eq "select") {
				$v{$form}=$::form{lf($form)};
			} elsif($mode eq "date") {
				$v{$form}=
					$::form{lf($form . "y")} . "/"
				.	$::form{lf($form . "m")} . "/"
				.	$::form{lf($form . "d")};
			} elsif($mode eq "password") {
				$v{$form}=&password_decode($::form{lf($form)}, $::form{lf($form) . "_enc"}, $::form{lf($form) . "_token"});
				$v{$form}=~s/\t.*//g;
				&load_module("Nana::Crypt");
				$v{$form}=Nana::Crypt::encode($v{$form});
			} elsif($mode eq "mail") {
				$v{$form}=$::form{lf($form)};
			}
		}
		&createuser($v{userid});
		&createuser($v{email});
		my $session=&makesession;
		$::user{session}=$session;
		$::user{userid}=$v{userid};
		$::user{email}=$v{email};
		&writeuser($v{userid}, %::user);
		$::user{session}=$session;
		$::user{userid}=$v{userid};
		$::user{email}=$v{email};
		&writeuser($v{email}, %::user);

		$::session{session}=$session;
		foreach(keys %v) {
			$::session{$_}=$v{$_};
		}

		$::session{password}=$::session{pass1};
		delete $::session{pass1};
		delete $::session{pass2};

		&createsession($session);
		my $confirm;
		do {
			foreach(keys %::session) {
				$confirm=&rnd($confirm . $::session{$_});
			}
		} while(&searchsession("confirm", $confirm) ne undef);

		my $sessionpass=$confirm;
		foreach(keys %::session) {
			$sessionpass=&rnd($sessionpass . $::session{$_});
		}
		$::session{confirmexpire}=time + $login::confirmexpire;
		$::session{passexpire}=time + $login::passexpire;
		$::session{confirm}=$confirm;
		$::session{sessionpass}=$sessionpass;
		my %scookie;
		$scookie{p}=$sessionpass;
		&setcookie($login::cookie_confirm, $login::confirmexpire , %scookie);
		$::session{confirm}=$confirm;
		$login::value::email=$v{email};
		%login::value::session=%::session;

		&writesession($session, %::session);
		&plugin_login_confirm_mail;
		$body.=&plugin_login_confirm;
	}
	return (msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
}

sub plugin_login_confirm_mail {
	&mail("confirmmail", $login::value::email, %::login::value::session);
}

sub chksubmit {
	my ($form)=@_;
	return 1 if($::form{lf($form)} ne "");
	return 1 if($::form{"_" . lf($form)} ne "");
	return 0;
}

1;
