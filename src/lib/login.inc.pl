######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'login.inc.cgi'
######################################################################
#
# 認証プラグイン
#
# 使い方：
#   ・login.inc.plをlogin.inc.cgiにリネームするだけで使えます
#
######################################################################

$::user_dir = "$::data_home/user"
	if(!defined($::user_dir));

$::session_dir = "$::data_home/session"
	if(!defined($::session_dir));

# for https://dev.twitter.com/apps
# read-onlyでよい

$login::oauth{twitter}{ConsumerKey}=""
	if($login::oauth{twitter}{ConsumerKey} eq "");
$login::oauth{twitter}{ConsumerSecret}=""
	if($login::oauth{twitter}{ConsumerSecret} eq "");

# for https://developers.facebook.com/apps/
$login::oauth{twitter}{ConsumerKey}=""
	if($login::oauth{twitter}{ConsumerKey} eq "");
$login::oauth{twitter}{ConsumerSecret}=""
	if($login::oauth{twitter}{ConsumerSecret} eq "");

use Nana::Login;
use Nana::Crypt;
use Nana::Cookie;

%::login_session_cookie;
$::login_confirm_cookie="PWLC"
				. length($::basepath);
$::login_session_cookie="PWLS"
				. length($::basepath);

$Nana::OAuth::Cook="oauthcook";
$Nana::OAuth::CookService="svc";
$Nana::OAuth::CookRefer="ref";
$Nana::OAuth::CookExpire=30*60;

%::session;
%::user;
%::SESSIONDB;
%::USERDB;

$::session_length=256;

# Initlize

sub lf {
	return Nana::Login::lf(@_);
}

sub ln {
	return Nana::Login::ln(@_);
}

sub plugin_login_init {
	&load_module("Nana::OpenID");
	&load_module("Nana::OAuth");
	&load_module("Net::OpenID::Consumer");
	&load_module("Net::OAuth");

	%::login_session_cookie=Nana::Cookie::getcookie($::login_session_cookie,$::login_session_cookie);
#	%::login_user_cookie=Nana::Cookie::getcookie($::login_session_cookie,$::login_user_cookie);
	&dbopen($::session_dir,\%::SESSIONDB);
	&dbopen($::user_dir,\%::USERDB);

	if($::login_session_cookie{&ln("session")}) {
		%::session=Nana::Login::readsession(\%::SESSIONDB, $::login_session_cookie{&ln("session")}, $::login_session_cookie{&ln("sessionpass")});
		if($::session{userid} ne "") {
			%::user=Nana::Login::readuser(\%::USERDB, $::session{userid});
		}
	}

	my $page=&encode(
			$::form{refer} ne "" ? $::form{refer}
		:	$::form{mypage} ne "" ? $::form{mypage}
		:	$::FrontPage
		);

	if($::session{userid} ne "") {
		push(@::addnavi,"loginmypage::help");
		$::navi{"loginmypage_url"}="$::script?cmd=login&amp;mode=mypage&amp;refer=$page";
		my $tmp=$::resource{"login_plugin_navi_mypage"};
		$tmp=~s/\$NAME/$::session{nickname}/;
		$::navi{"loginmypage_name"}=$tmp;
		$::navi{"loginmypage_type"}="plugin";

		push(@::addnavi,"logout::help");
		$::navi{"logout_url"}="$::script?cmd=login&amp;mode=logout&amp;refer=$page";
		my $tmp=$::resource{"login_plugin_navi_logout"};
		$tmp=~s/\$NAME/$::session{nickname}/;
		$::navi{"logout_name"}=$tmp;
		$::navi{"logout_type"}="plugin";
	} else {
		push(@::addnavi,"login::help");
		$::navi{"login_url"}="$::script?cmd=login&amp;refer=$page";
		$::navi{"login_name"}=$::resource{"login_plugin_navi_login"};
		$::navi{"login_type"}="plugin";
	}
	return ('init'=>1, 'func'=>'', 'last_func'=>'plugin_login_last');
}

sub plugin_login_last {
	&dbclose(\%::SESSIONDB);
	&dbclose(\%::USERDB);
}

sub searchsession {
	Nana::Login::searchsession(\%::SESSIONDB, @_)}

sub readsession {
	%::session=Nana::Login::readsession(\%::SESSIONDB, @_);
}

sub writesession {
	Nana::Login::writesession(\%::SESSIONDB, @_);
}

sub writesessionsub {
	my $sub=shift;
		&load_module("Nana::Fork");
	Nana::Fork::exec(
		undef,
		sub {
			Nana::Login::writesession(\%::SESSIONDB, @_);
			&$sub;
		}
	);
}

sub logindo {
	my($userid, $pass, $passenc, $passtoken)=@_;
	my ($passwd, $tmp)=split(/\t/, &password_decode($pass, $passenc, $passtoken));
	Nana::Login::logindo(\%::SESSIONDB, \%::USERDB, $userid, $passwd);
}

sub createsession {
	Nana::Login::createsession(\%::SESSIONDB, @_);
}

sub existsession {
	Nana::Login::existsession(\%::SESSIONDB, @_);
}

sub deletesession {
	Nana::Login::deletesession(\%::SESSIONDB, @_);
}

sub readuser {
	%::user=Nana::Login::readuser(\%::USERDB, @_);
}

sub writeuser {
	Nana::Login::writeuser(\%::USERDB, @_);
}

sub existuser {
	Nana::Login::existuser(\%::USERDB, @_);
}

sub createuser {
	Nana::Login::createuser(\%::USERDB, @_);
}

sub deleteuser {
	Nana::Login::deleteuser(\%::USERDB, @_);
}

sub makesession {
	my ($rnd)=@_;
	my $dmy;
	my $i=0;
	&load_module("Nana::Crypt");
	do {
		$dmy.=&rnd($dmy);
	} while(&existsession($dmy) && $i++ < 1000);
	$dmy;
}
sub rnd {
	my($dmy)=@_;
	srand();
	foreach(keys %ENV) {
		$dmy.=$ENV{$_};
	}
	foreach(keys %::form) {
		$dmy.=$::form{$_};
	}
	for(my $i=0; $i < int(rand(100)); $i++) {
		$dmy.=rand(65536);
		$dmy.=time;
	}
	$dmy.=Nana::Crypt::encode($dmy);
	foreach(keys %ENV) {
		$dmy.=$ENV{$_};
	}
	foreach(keys %::form) {
		$dmy.=$::form{$_};
	}
	for(my $i=0; $i < int(rand(100)); $i++) {
		$dmy.=rand(65536);
	}
	$dmy=Nana::Crypt::encode($dmy, "", "base64");
	$dmy=~s/.*\}//g;
	$dmy=~s/\///g;
	$dmy=~s/\+//g;
	$dmy;
}

sub _writesession {
	if($ENV{REMOTE_HOST} eq '') {
		my $host
		 = gethostbyaddr(pack("C4", split(/\./, $ENV{REMOTE_ADDR})), 2);
		if($host eq '') {
			$host=$ENV{REMOTE_ADDR};
		}
		$ENV{REMOTE_HOST}=$host;
	}

	$::session{"view_view"}=$::session{"view"};
	$::session{"view_FIRST_TIME"}=time if($::session{'view_FIRST_TIME'} eq '');
	$::session{"view_FIRST_REMOTE_ADDR"}=$ENV{'REMOTE_ADDR'} if($::session{'view_FIRST_REMOTE_ADDR'} eq '');
	$::session{"view_FIRST_REMOTE_HOST"}=$ENV{'REMOTE_HOST'} if($::session{'view_FIRST_REMOTE_HOST'} eq '');
	$::session{"view_FIRST_HTTP_USER_AGENT"}=$ENV{'HTTP_USER_AGENT'} if($::session{'view_FIRST_HTTP_USER_AGENT'} eq '');
	$::session{"view_TIME"}=time;
	$::session{"view_REMOTE_ADDR"}=$ENV{'REMOTE_ADDR'};
	$::session{"view_REMOTE_HOST"}=$ENV{'REMOTE_HOST'};
	$::session{"view_HTTP_USER_AGENT"}=$ENV{'HTTP_USER_AGENT'};
	$::session{"view_HTTP_REFERER"}=$ENV{'HTTP_REFERER'};
	# 初回訪問時の前のURL（検索エンジン等）
	if($::session{"view_FIRST_HTTP_REFERER"} eq '') {
		if($ENV{'HTTP_REFERER'} !~ /$ENV{'HTTP_HOST'}/) {
			$::session{"view_FIRST_HTTP_REFERER"}=$ENV{'HTTP_REFERER'};
		}
	}
	my $tmp='';
	while(($name,$value)=each(%session)) {
		if($name=~/^view_/) {
			$n=$name;
			$n=~s/^view_//g;
			$tmp.="$n=$value\n";
		}
	}
	$::SESSIONDB{$::session{view}}=$tmp if($::session{view} ne '');
}

sub _makesession {
	for($i=0; $i<255; $i++) {
		$str=$ENV{'REMOTE_HOST'}.$ENV{'REMOTE_ADDR'}.$i.time.$ENV{'HTTP_USER_AGENT'}.$i.$ENV{'HTTP_REFERER'}.$i;
		$hash=makehash($str);
		$::session{'view'}=substr($hash,0,$::session_length);
		next if(exists $::SESSIONDB{$::session{'view'}});	# セッションファイルが存在したら繰り返し
		last;
	}
	$str=time.$ENV{'REMOTE_ADDR'}.$ENV{'REMOTE_HOST'}.$i.time.$ENV{'HTTP_USER_AGENT'}.$i.time.$ENV{'HTTP_REFERER'}.$i.time;
	$hash=&makehash($str);
	$::session{'view_pass'}=substr($hash,0,$::session_length);
	$::session{"view_read"}="allow";
	$::session{"view_write"}="deny";
}

sub _readusersession {
	my $userdata=$::USERDB{$::session{'view_loginname'}};
	$userdata=$::USERDB{$::form{'user'}} if($userdata eq '');
	if ($userdata ne '') {
		foreach(split(/\n/,$userdata)) {
			s/(\r|\n)//g;
			($name,$value)=split(/=/,$_);
			$::session{"user_$name"}=$value;
		}
	}
}

sub _makehash {
	my($str)=shift;
	return md5_hex($str);
}


1;
__DATA__
sub plugin_login_setup {
	return(
		ja=>'ログインプラグイン',
		en=>'Login plugin',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/login/'
	);
}
=head1 NAME

login.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Login plugin

=head1 DESCRIPTION

Login plugin

=head1 USAGE

=head2 Enable plugin

Rename to login.inc.cgi

Make directory ./session

Make directory ./user

=head1 SETTING

=over 4

=item $::user_dir

Login user directory

=item $::session_dir

Session directory

=item $login::oauth{twitter}{ConsumerKey}, $login::oauth{twitter}{ConsumerSecret}

Twitter ConsumerKey

L<https://dev.twitter.com/apps>

=back

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/login

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/login/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/login.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/login.pm>

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/OAuth.pm>

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/OpenID.pm>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/login.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/loginsub.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
