######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 First Release
######################################################################

use strict;
use Nana::Enc;

# captcha付になるまでの回数
$login::captchaon=5;

# メール認証の有効期限
$login::confirmexpire=24 * 60 * 60;

# セッションの有効期限
$login::sessionexpire=180 * 24 * 60 * 60;

# パスワードの有効期限
$login::passexpire=30 * 24 * 60 * 60;

# ログインフォーム
$login::loginforms1="text|id,password|password,select|expire|login_plugin_login_expire,submit|submit|login_plugin_login_button";
# captcha付ログインフォーム
$login::loginforms2="text|id,password|password,captcha|captcha,select|expire|login_plugin_login_expire,submit|submit|login_plugin_login_button";

# readuser writeuser readwrite
$login::useraddpolicy="writeuser";

# none, days, admin
$login::useraddpolicy2="days";

$login::writewaitdays=7;

$login::formexpire=24*60*60;


$login::imeon="ime-mode: active;";
$login::imeoff="ime-mode: disabled;";

# cookie
$login::cookie_confirm=$::login_confirm_cookie;
$login::cookie_session=$::login_session_cookie;

$login::style={
	nickname=>{
		style=>$login::imeon,
		size=>"250,15",
		length=>"2,32",
		check=>\&plugin_login_check_userid,
		onfocus=>"j_nickname",
		onblur=>"j_nickname",
		onchange=>"j_nickname",
		onkeypres=>"j_nickname",
		onsubmit=>"j_nickname",
	},
	id=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"4,16",
		check=>\&plugin_login_check_userid,
		onfocus=>"j_form",
		onblur=>"j_form",
#		onsubmit=>"j_nickname",
	},
	userid=>{
		style=>$login::imeoff,
		size=>"250,15",
		length=>"4,16",
		check=>\&plugin_login_check_userid,
		onfocus=>"j_userid",
		onblur=>"j_userid",
		onsubmit=>"j_nickname",
	},
	password=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"6,32",
		check=>\&plugin_login_check_password,
		onfocus=>"j_form",
		onblur=>"j_form",
	},
	pass1=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"6,32",
		check=>\&plugin_login_check_newpass,
		objs=>"pass1,pass2",
		onkeyup=>"j_newpass",
		onfocus=>"j_newpass",
		onblur=>"j_newpass",
		onsubmit=>"j_newpass",
	},
	pass2=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"6,32",
		check=>\&plugin_login_check_newpass,
		objs=>"pass1,pass2",
		onkeyup=>"j_newpass",
		onfocus=>"j_newpass",
		onblur=>"j_newpass",
		onsubmit=>"j_newpass",
	},
	email=>{
		style=>$login::imeoff,
		size=>"250,15",
		length=>"8,256",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	emailchk=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"8,256",
		errform=>"emailchk",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	emailchk1=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"3,256",
		errform=>"emailchk",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	emailchk2=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"8,256",
		errform=>"emailchk",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	confirm=>{
		style=>$login::imeoff,
		size=>"400,15",
		length=>"30,255",
#		check=>\&plugin_login_check_confirm,
	},
	femail=>{
		style=>$login::imeoff,
		size=>"250,15",
		length=>"8,256",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	femailchk=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"8,256",
		errform=>"emailchk",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	femailchk1=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"3,256",
		errform=>"emailchk",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	femailchk2=>{
		style=>$login::imeoff,
		size=>"100,15",
		length=>"8,256",
		errform=>"emailchk",
		check=>\&plugin_login_check_email,
		objs=>"email,emailchk1,emailchk2",
		onfocus=>"j_email",
		onblur=>"j_email",
	},
	expire=>{
		size=>"150,20",
	},
	submit=>{
		size=>"150,20",
	},
};

#$::login_enq_form="enq";
#$::login_enq_form_cols=50;

sub login_read_resource {
	my ($file, %r)=@_;

	if(-r "$::res_dir/$file.$::lang.txt") {
		%r=&read_resource("$::res_dir/$file.$::lang.txt", %r);
	} elsif(-r "$::res_dir/$file.txt") {
		%r=&read_resource("$::res_dir/$file.txt", %r);
	}
	%r;
}

sub plugin_login_submitbutton {
	my($name, $formid, $pform, $value)=@_;
	my $body;
	my $js;
	if(&iscryptpass) {
		$js.="return lsubmit(a,\'$name\',\'$pform\');"
	}
	$body=qq(<input type="submit" name="$formid" value="$value" />)
		if($formid ne $value);
	return($body, $js);
}


sub plugin_login_action {
	my $body;
	my $login_plugin_title=$::resource{login_plugin_login};

	&jscss_include("passwd");
	&jscss_include("img-login");
	my $mode=$::form{mode};
	if($::useExPlugin eq 1 && $::_exec_plugined{login} eq 2) {
		if($mode eq "logout") {
			return &plugin_login_logout;
		} elsif($mode eq "") {
			return &plugin_login_login;
		} elsif($mode eq "login" || $mode eq "loginonly") {
			return &plugin_login_loginonly;
		} elsif($mode eq "mypage") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_mypage;
		} elsif($mode eq "useradd") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_useradd;
		} elsif($mode eq "openid") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_openid;
		} elsif($mode eq "oauth") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_oauth;
		} elsif($mode eq "forget") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_forget;
		} elsif($mode eq "pass") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_pass;
		} elsif($mode eq "word") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_word;
		} elsif($mode eq "mail") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_mail;
		} elsif($mode eq "confirm") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_confirm;
		} elsif($mode eq "unregist") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_unregist;
		} elsif($mode eq "regist") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_regist;
		} elsif($mode eq "teamofuse") {
			require "$::plugin_dir/loginsub.inc.pl";
			return &plugin_login_teamofuse;
		}
	}
	return ('msg'=>"\tError", 'body'=>qq(<span class="error">login.inc.pl error</span>));
}

sub form_generate {
	my($flg)=@_;
	my $body;
	my $token_form=lf("token");
	my $expire_form=lf("generate");

	$body.=<<EOM if($::form{refer} ne "");
<input type="hidden" name="refer" value="$::form{refer}" />
EOM
	if($flg+0) {
		my $token=$::form{$token_form};
		my $expire=$::form{$expire_form};
		if(Nana::Enc::decode("", $expire, $token) +0 < time + $login::formexpire) {
			return "-";
		}
	}
	&maketoken;
	my $token=$::Token;
	my $expire=Nana::Enc::encode(time, $token);
	return <<EOM;
$body<input type="hidden" name="$token_form" value="$token" />
<input type="hidden" name="$expire_form" value="$expire" />
EOM
}

sub plugin_login_login {
	my $body;

	%::resource=&login_read_resource("login_useradd", %::resource);

	$body.=&loginhtml("login", "$login::loginforms1", "", &plugin_login_openidform);
	my $sub=&loginhtml("loginsub");

	$sub=&replace($sub,
		1=>$::wiki_title,
		2=>"$::script?cmd=login&amp;mode=useradd&amp;refer=$::form{refer}",
		3=>"$::script?cmd=login&amp;mode=forget&amp;refer=$::form{refer}"
	);
	$body.=$sub;

#	$body.=&loginhtml("useradd", "$login::useraddforms");
#	$body.=&loginhtml("forget", "$login::forgetforms");
	return(msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
}

sub plugin_login_openidform {
	my $services;
	if($::_module_loaded{"Net::OAuth"}) {
		foreach my $oauthservice (Nana::OAuth::list()) {
			my ($url, $id, $name, $imageid, $plusid, $urlid)=Nana::OAuth::getid($oauthservice, "small");
			my $refer=&encode(&encode(exists($::form{refer}) ? $::form{refer} : $::FrontPage));
			if($plusid+0 eq 0) {
				$services.=<<EOM;
<a href="javascript:void(0);" class="oauthimage" id="$imageid" onclick="return oauthlogin('$::script','$refer', '@{[lf("url")]}','@{[&encode($url)]}','@{[lf("service")]}','$id');"><span>$name</span></a>
EOM
			} elsif($plusid+0 eq 2) {
				$services.=<<EOM;
<a href="javascript:void(0);" class="oauthimage" id="$imageid" onclick="return oauthlogin('$::script','$refer','@{[lf("url")]}','@{[&encode($url)]}','@{[lf("service")]}','$id','','','login','@{[lf("id")]}');"><span>$name</span></a>
EOM
			} else {
				$services.=<<EOM;
<a href="javascript:void(0);" class="oauthimage" id="$imageid" onclick="return oauthlogin('$::script','$refer','@{[lf("url")]}','@{[&encode($url)]}','@{[lf("service")]}','$id','login','@{[lf("id")]}');"><span>$name</span></a>
EOM
			}
		}
	}

	if($::_module_loaded{"Net::OpenID::Consumer"}) {
		foreach my $openidservice (Nana::OpenID::list()) {
			my ($url, $id, $name, $imageid, $plusid, $urlid)=Nana::OpenID::getid($openidservice, "small");
			my $refer=&encode(&encode(exists($::form{refer}) ? $::form{refer} : $::FrontPage));
			if($plusid+0 eq 0) {
				$services.=<<EOM;
<a href="javascript:void(0);" class="openidimage" id="$imageid" onclick="return openidlogin('$::script','$refer', '@{[lf("url")]}','@{[&encode($url)]}','@{[lf("service")]}','$id');"><span>$name</span></a>
EOM
			} elsif($plusid+0 eq 2) {
				$services.=<<EOM;
<a href="javascript:void(0);" class="openidimage" id="$imageid" onclick="return openidlogin('$::script','$refer','@{[lf("url")]}','@{[&encode($url)]}','@{[lf("service")]}','$id','','','login','@{[lf("id")]}');"><span>$name</span></a>
EOM
			} else {
				$services.=<<EOM;
<a href="javascript:void(0);" class="openidimage" id="$imageid" onclick="return openidlogin('$::script','$refer','@{[lf("url")]}','@{[&encode($url)]}','@{[lf("service")]}','$id','login','@{[lf("id")]}');"><span>$name</span></a>
EOM
			}
		}
	}
	$services;
}

sub plugin_login_logout {
	my %scookie;
	&setcookie($login::cookie_session, -1 , %scookie);
	my $url="$::script?$::form{refer}";
	&location($url, 302, $::HTTP_HEADER);
}

sub plugin_login_loginonly {
	my $body;

	my $userid=$::form{lf("id")};
	if($::form{mode} eq "login") {
		my $stat=&logindo($userid
			, $::form{lf("password")}
			, $::form{lf("password") . "_enc"}
			, $::form{lf("password") . "_token"}
		);

		my $err=$::resource{"login_plugin_login_err_$stat"};
		if($err ne "") {
			$body.=<<EOM;
<span class="error">$err</span>
EOM
		} elsif($stat ne "") {
			my %tmpuser=&readuser($stat);
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
	}
	$body.=&loginhtml("login", "$login::loginforms1", "", &plugin_login_openidform);
	return(msg=>"\t$::resource{login_plugin_title_msg}", body=>$body);
}

# HTML

my $plugin_login_jsadd=0;

sub loginhtml {
	my ($title, $forms, $status, $add, %err)=@_;
	my $body;
	my $bodytmp;
	my $jsform;
	my %jsform;
	foreach(split(/,/,$forms)) {
		my($fmode, $form, $res)=split(/\|/,$_);
		my ($tmp, %fjs)=&loginform($fmode, $title, $form, $res, %err);
		$bodytmp.=$tmp;
		foreach(keys %fjs) {
			$jsform{$_}.=$fjs{$_}
				if(!/^_/);
		}
		foreach(keys %fjs) {
			if(/^_/) {
				s/^_//g;
				$jsform{$_}.=$fjs{$_}
			}
		}
	}
	foreach(keys %jsform) {
		$jsform.=qq( $_=");
		$jsform.=qq(var a=true,b;);
		$jsform.=qq($jsform{$_});
		$jsform.="return a;";
		$jsform.=qq(");
	}

	$body=<<EOM if($status ne "");
<span class="error">$status</span>
EOM
	$body.=<<EOM;
<h3>$::resource{"login_plugin\_$title\_title"}</h3>
<form action="$::script" method="post" id="$title" name="$title"$jsform>
@{[&form_generate]}
<input type="hidden" name="cmd" value="login" />
<input type="hidden" name="mode" value="$title" />
<table>
$bodytmp
EOM

	my $msg=$::resource{"login_plugin\_$title\_msg"};
	$msg.=$::resource{"login_plugin\_$title\_msg\_$login::useraddpolicy"};

	$msg=&replace($msg,
		MAIL=>$::form{lf("email")},
		TITLE=>$::wiki_title,
		script=>$::script,
		DAYS=>$login::writewaitdays,
		login_plugin_useradd_msg=>$::resource{"login_plugin\_$title\_msg\_$login::useraddpolicy2"}
	);
	$body.=<<EOM;
<tr><td>&nbsp;</td><td colspan="2">$msg</td></tr>
EOM
	$body.=<<EOM if($add ne "");
<tr><td>&nbsp;</td><td>$add</td></tr>
EOM

	$body.=<<EOM;
</table>
</form>
EOM
	$body;
}

my @reminders;

sub loginform {
	my($fmode, $formid, $form, $res, %err)=@_;
	my $body;
	my $value;
	my($width, $height)=split(/,/,$login::style->{$form}->{size});
	my($minlength, $maxlength)=split(/,/,$login::style->{$form}->{length});
	my $style=$login::style->{$form}->{style};

	$style.=qq( width:@{[$width]}px;) if($width+0 > 0);
	$style.=qq( height:@{[$height]}px;) if($height+0 > 0);

#	$value=$value ne "" ? $value : $::form{lf($form)};
	$value=$::form{lf($form)};

	my $class;
	my $defclass="def$fmode";
	my $inclass="input$fmode";
	my $errclass="err$fmode";

	if($value eq "" || $err{$form} ne "") {
		$value=$::resource{"login_plugin\_$formid\_$form\_default"};
		$value=~s/\$MIN/$minlength/g;
		$value=~s/\$MAX/$maxlength/g;

		$class=$defclass;
	} else {
		$class=$inclass;
	}

	my ($js, %jsform)=&jsform($formid, $form, $class, $defclass, $inclass, $errclass, $minlength, $maxlength);

	if($fmode eq "text" || $fmode eq "mail") {
		if($err{ok}) {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
			$body.=$value;
			$body.=qq(<input type="hidden" name="@{[lf($form)]}" value="$value" />);
		} else {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
			$body.=qq(<input type="text" name="@{[lf($form)]}" id="@{[lf($form)]}" minlength="$minlength" maxlength="$maxlength" default="$value" value="$value" class="$class" inclass="$inclass" defclass="$defclass" errclass="$errclass" @{[$style eq "" ? "" : qq( style="$style")]}$js autocomplete="off" />\n);
		}
#			$jsform{$_}.=qq(b=$login::style->{$form}->{$_}(a,'$_','$formid','@{[lf($form)]}','$errform',this,'$objs','$value','$inclass','$defclass', '$errclass', $minlength,$maxlength););

	} elsif($fmode eq "readonly") {
		$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
		$body.=$value;
		$body.=qq(<input type="hidden" name="@{[lf($form)]}" value="$value" />);

	} elsif($fmode eq "hidden") {
		$body.=qq(<input type="hidden" name="@{[lf($form)]}" value="$value" />);

	} elsif($fmode eq "password") {
		if($err{ok}) {
			my $f=lf($form);
#			$value=&password_decode($::form{$f}, $::form{"$f\_enc"}, $::form{"$f\_token"});
#			$value=~s/\t.*//g;
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
			my $passwd_form;
			eval {
				$passwd_form=&passwordform($value, "hidden", lf($form), $::form{lf($form) . "_enc"}, $::form{lf($form) . "_token"}, 8, $minlength, $maxlength, "$style");
#				$passwd_form.="test:$value ($form $f)	";
			};
			$body.=$passwd_form;
			$body.=$::resource{login_plugin_useradd_hiddenpasswd};
		} else {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
			my $passwd_form;
			eval {
				$passwd_form=&passwordform($value, "", lf($form), $::form{"$login::passform\_enc"}, $::form{"login::passform\_token"}, 8, $minlength, $maxlength, $style, qq(class="$class" $js));
			};
			$body.=$passwd_form;
		}

	} elsif($fmode eq "word") {
		my $formno=$form;
		$formno=~s/.*(\d.*)$/$1/g;
		my $f=lf($form);
		my $ef=Nana::Login::ef($form);
		my $wtitle=$::resource{"login_plugin_forget_title_" . $formno};

		if($err{ok}) {
			$body.=qq(<tr><td>$wtitle</td><td>);
			$body.=qq(a<br />b</td></tr>);
		} else {

			$body.=qq(<tr><td>$wtitle</td><td>);
			$body.=qq(<select name="@{[$f]}_s" onchange="j_word('sel', '$formid', '@{[$f]}_s', '@{[$f]}_c', '@{[$f]}', '@{[$f]}_p', '@{[$ef]}');">);

			my $rmax=0;
			for(my $i=1; ; $i++) {
				last if($::resource{"login_plugin_forget_questions_@{[$i]}_text"} eq "");
				$rmax=$i;
			}
			my $fi=0;
			my $fl=0;
			srand();
			do {
				$fi=int(rand(10000)) % $rmax;
				foreach(@reminders) {
					$fl=$fi eq $_ ? 1 : 0;
					last if($fl);
				}
			} while($fl eq 1);
			push(@reminders, $fi);

			for(my $i=1; ; $i++) {
				last if($::resource{"login_plugin_forget_questions_@{[$i]}_text"} eq "");
				my $text=$::resource{"login_plugin_forget_questions_@{[$i]}_text"};
				my $minlength=$::resource{"login_plugin_forget_questions_@{[$i]}_minlength"};
				my $maxlength=$::resource{"login_plugin_forget_questions_@{[$i]}_maxlength"};
				my $unknown=$::resource{"login_plugin_forget_questions_@{[$i]}_unknown"};
				my $sample=$::resource{"login_plugin_forget_questions_@{[$i]}_sample"};
				$body.=qq(<option value="@{[$i]}|$text|$minlength|$maxlength|$unknown|$sample"@{[$i eq $fi ? ' selected="selected"' : '']}>$text</option>);
			}
			$body.=qq(</select><br />);
			$body.=qq(<input type="text" name="@{[$f]}" value="" onfocus="j_word('onfocus', '$formid', '@{[$f]}_s', '@{[$f]}_c', '@{[$f]}', '@{[$f]}_p', '@{[$ef]}', '$wtitle', '');" onblur="j_word('onblur', '$formid', '@{[$f]}_s', '@{[$f]}_c', '@{[$f]}', '@{[$f]}_p', '@{[$ef]}', '$wtitle', '');">);
			$body.=qq(<input type="checkbox" name="@{[$f]}_c" id="@{[$f]}_c" style="display:none;"  onchange="j_word('chk', '$formid', '@{[$f]}_s', '@{[$f]}_c', '@{[$f]}', '@{[$f]}_p', '@{[$ef]}');"><span id="@{[$f]}_p"></span>);
		}
	} elsif($fmode eq "date") {
		if($err{ok}) {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
			$body.=<<EOM;
$::form{lf($form . "y")}$::resource{login_plugin_useradd_date_year}
$::form{lf($form . "m")}$::resource{login_plugin_useradd_date_mon}
$::form{lf($form . "d")}$::resource{login_plugin_useradd_date_day}
<input type="hidden" name="@{[lf($form . "y")]}" value="$::form{lf($form . "y")}" />
<input type="hidden" name="@{[lf($form . "m")]}" value="$::form{lf($form . "m")}" />
<input type="hidden" name="@{[lf($form . "d")]}" value="$::form{lf($form . "d")}" />
EOM

		} else {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
			$value=$::form{lf($form . "y")};
			$body.=qq(<select onchange="j_date(0, this.value);" name="@{[lf($form . "y")]}"@{[$style eq "" ? "" : qq( style="$style")]}>);
			my @years;
			for(my $i=1900; $i<=&date("Y"); $i++) {
				my $s="$i$::resource{login_plugin_date_year}";
				if($::lang eq "ja") {
					foreach(split(/,/,$::resource{login_plugin_date_wareki})) {
						my($start, $end, $str)=split(/\|/,$_);
						if($i >= $start && $i <= $end) {
							my $wa=$i-$start+1;
							$wa=$::resource{login_plugin_date_gannen} if($wa+0 <= 1);
							push(@years, "$i\t$s ($str$wa$::resource{login_plugin_date_year})");
						}
					}
				} else {
					push(@years, "$i\t$s");
				}
			}
			foreach(reverse @years) {
				my($y, $s)=split(/\t/, $_);
				$body.=qq(<option value="$y"@{[$y eq $value ? ' selected="selected"' : '']}>$s</option>);
			}
			$body.=qq(</select>);
			$value=$::form{lf($form . "m")};
			$body.=qq(<select onchange="j_date(1, this.value);" name="@{[lf($form . "m")]}"@{[$style eq "" ? "" : qq( style="$style")]}>);
			for(my $i=1; $i<=12; $i++) {
				$body.=qq(<option value="$i"@{[$i eq $value ? ' selected="selected"' : '']}>$i$::resource{login_plugin_date_mon}</option>);
			}
			$body.=qq(</select>);
			$value=$::form{lf($form . "d")};
			$body.=qq(<select onchange="j_date(2, this.value);" name="@{[lf($form . "d")]}"@{[$style eq "" ? "" : qq( style="$style")]}>);
			for(my $i=1; $i<=31; $i++) {
				$body.=qq(<option value="$i"@{[$i eq $value ? ' selected="selected"' : '']}>$i$::resource{login_plugin_date_day}</option>);
			}
			$body.=qq(</select>);
		}

	} elsif($fmode eq "mailconfirm") {
		my $value1=$::resource{"login_plugin_useradd_emailchk1_default"};
		$value1=~s/\$MIN/$minlength/g;
		$value1=~s/\$MAX/$maxlength/g;
		my $value2=$::resource{"login_plugin_useradd_emailchk2_default"};
		$value2=~s/\$MIN/$minlength/g;
		$value2=~s/\$MAX/$maxlength/g;
		if($::form{lf($form . "1")} eq ""|| $::form{lf($form . "2")} eq ""
		|| $::form{lf($form . "1")} eq $value1|| $::form{lf($form . "2")} eq $value2) {
			$class=$defclass;
		} else {
			$value1=$::form{lf($form . "1")};
			$value2=$::form{lf($form . "2")};
			$class=$inclass;
		}
		if($err{ok}+0) {
			$body.=qq(<input type="hidden" name="@{[lf($form . "1")]}" value="$value1" />\n);
			$body.=qq(<input type="hidden" name="@{[lf($form . "2")]}" value="$value2" />\n);
		} else {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);

			($minlength, $maxlength)=split(/,/,$login::style->{emailchk1}->{length});
			($js, %jsform)=&jsform($formid, "emailchk1", $class, $defclass, $inclass, $errclass, $minlength, $maxlength);

			$body.=qq(<input type="text" name="@{[lf($form . "1")]}" maxlength="$maxlength" value="$value1"@{[$style eq "" ? "" : qq( style="$style")]} class="$class" $js />\n);
			$body.='@';

			($minlength, $maxlength)=split(/,/,$login::style->{emailchk2}->{length});
			($js, %jsform)=&jsform($formid, "emailchk2", $class, $defclass, $inclass, $errclass, $minlength, $maxlength);

			$body.=qq(<input type="text" name="@{[lf($form . "2")]}" maxlength="$maxlength" value="$value2"@{[$style eq "" ? "" : qq( style="$style")]} class="$class" $js />\n);
		}
	} elsif($fmode eq "captcha") {
		if($err{ok}+0 eq 0) {
			$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td colspan="2">);
			my $captcha_form;
			eval {
				$captcha_form=&plugin_captcha_form;
			};
			$body=$captcha_form eq "" ? "" : $body . $captcha_form;
		}
	} elsif($fmode eq "select") {
		my $sel=$::resource{$res} eq "" ? $res : $::resource{$res};
		$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
		if($err{ok}) {
			foreach(split(/,/,$sel)) {
				my($n, $v)=split(/\|/,$_);
				if($n eq $value) {
					$body.=$v;
				}
			}
			$body.=qq(<input type="hidden" name="@{[lf($form)]}" value="$value" />);
		} else {
			$body.=qq(<select name="@{[lf($form)]}"@{[$style eq "" ? "" : qq( style="$style")]}>);
			foreach(split(/,/,$sel)) {
				my($n, $v)=split(/\|/,$_);
				if($n eq $value) {
					$body.=qq(<option value="$n" selected="selected">$v</option>);
				} else {
					$body.=qq(<option value="$n">$v</option>);
				}
			}
			$body.=qq(</select>\n);
		}
	} elsif($fmode eq "radio") {
	} elsif($fmode=~/submit/) {
		my $pform=$fmode eq "submit" ? lf("password") : lf("pass1") . "," . lf("pass2");
		my $sel;
		$body.=qq(<tr><td>$::resource{"login_plugin\_$formid\_$form\_title"}</td><td>);
		$sel=$::resource{"$res\_back"} eq "" ? $res : $::resource{"$res\_back"};
		my($tmpbody, $tmpjs)=&plugin_login_submitbutton($formid, lf("back"), $pform, $sel);
		if($err{ok}) {
			$body.=$tmpbody;
			$jsform{onsubmit}=$tmpjs;
		}
		$sel=$::resource{$res} eq "" ? $res : $::resource{$res};
		if($err{ok}) {
			my($tmpbody, $tmpjs)=&plugin_login_submitbutton($formid, lf("$form" . "2"), $pform, $sel);
			$body.=$tmpbody;
			$jsform{onsubmit}=$tmpjs;

		} else {
			my($tmpbody, $tmpjs)=&plugin_login_submitbutton($formid, lf("$form"), $pform, $sel);
			$body.=$tmpbody;
			$jsform{onsubmit}=$tmpjs;
		}
	}
	$body.=qq(</td>);
	if(!$err{ok}+0) {
		$body.=qq(<td><span id="@{[Nana::Login::ef($form)]}" class="error">$err{$form}</span></td>);
	}
	if($err{ok}) {
		$jsform{onsubmit}="";
	}
	return ($body eq "" ? "" : "$body</tr>\n", %jsform);
}

sub jsform {
	my ($formid, $form, $class, $defclass, $inclass, $errclass, $minlength, $maxlength)=@_;
	my $js;
	my %jsform;

	my $value=$::resource{"login_plugin\_$formid\_$form\_default"};
	$value=~s/\$MIN/$minlength/g;
	$value=~s/\$MAX/$maxlength/g;

	my $errform=$login::style->{$form}->{"errform"} ? $login::style->{$form}->{"errform"} : $form;
	$errform=Nana::Login::ef($errform);
	foreach(sort keys $login::style->{$form}) {
		my $objs;
		foreach(split(/,/,$login::style->{$form}->{objs})) {
			$objs.=&lf($_) . ",";
		}
		$objs=~s/\,$//g;
		if(/^(onsubmit|onreset)/) {
			$jsform{$_}.=qq(b=$login::style->{$form}->{$_}(a,'$_','$formid','@{[lf($form)]}','$errform',this,'$objs','$value','$inclass','$defclass', '$errclass', $minlength,$maxlength););
			$jsform{$_}.=qq(a=(a==true?b:a););
		} elsif(/^on/) {
#			$js.=qq( $_="return $login::style->{$form}->{$_}(a,'$_','$formid','@{[lf($form)]}','$errform',this,'$objs','$value','$inclass','$defclass', '$errclass', $minlength,$maxlength);");
			$js.=qq( $_="return $login::style->{$form}->{$_}(a,'$_','$formid','@{[lf($form)]}','$errform',this,'$objs');");
		}
	}
	return($js, %jsform);
}

1;
