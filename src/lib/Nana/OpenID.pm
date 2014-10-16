######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::OpenID;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.1';
use LWP::UserAgent;
use CGI;
use Nana::Login;

$Nana::OpenID::List={
	yahoojapan=>{
		name=>$::resource{login_plugin_openid_service_yahoojapan},
		url=>"yahoo.co.jp",
		lang=>"ja",
		logo_small=>"icn_yahooj16",
		alt=>"Login for Yahoo! Japan",
		credit=>{
			url=>"http://developer.yahoo.co.jp/about",
			image=>"http://i.yimg.jp/images/yjdn/yjdn_attbtn1_125_17.gif",
			alt=>"Web Services by Yahoo! JAPAN",
			width=>125,
			height=>17
		},
	},
	mixi=>{
		name=>$::resource{login_plugin_openid_service_mixi},
		url=>"mixi.jp",
		alt=>"Login for mixi",
		lang=>"ja",
		logo_small=>"icn_mixi16",
		small=>"logo1",
		big=>"logo1",
	},
	_excite=>{
		name=>$::resource{login_plugin_openid_service_excite},
		url=>"https://openid.excite.co.jp",
		lang=>"ja",
		logo_small=>"icn_excite16",
		alt=>"Login by Excite Japan",
	},
	hatena=>{
		name=>$::resource{login_plugin_openid_service_hatena},
		url=>"http://www.hatena.ne.jp/",
		plusid=>1,
		lang=>"ja",
		logo_small=>"icn_hatena16",
	},
	livedoor=>{
		name=>$::resource{login_plugin_openid_service_livedoor},
		#url=>"http://profile.livedoor.com/",
		#plusid=>1,
		url=>"http://livedoor.com/",
		lang=>"ja",
	},
	_google=>{
		url=>"https://www.google.com/accounts/o8/id",
		lang=>"",
		logo_small=>"icn_google16",
	},
	openid=>{
		name=>$::resource{login_plugin_openid_service_openid},
		url=>"",
		plusid=>2,
		lang=>"",
		logo_small=>"icn_openid16",
	},
};

sub list {
	my @r;
	foreach(keys %{$Nana::OpenID::List}) {
		push(@r, $_) if($_!~/^\_/);
	}
	@r;
}

sub getid {
	my($id,$size)=@_;

	my $imgid;
	my $url=$Nana::OpenID::List->{$id}->{url};
	my $name=$Nana::OpenID::List->{$id}->{name};
	my $plusid=$Nana::OpenID::List->{$id}->{plusid}+0;
	if($size eq "big") {
		$imgid=$Nana::OpenID::List->{$id}->{logo_big};
	}
	$imgid=$Nana::OpenID::List->{$id}->{logo_small};
	return($url, $id, $name, $imgid, $plusid);
}

# https://dev.twitter.com/apps/new
# http://auth.livedoor.com/openid/user/add


# my $CLAIMED_URL = $cgi->param('openid');

sub login {
	my ($url, $addquery)=@_;
	my $cgi = CGI->new;

	my $csr = Net::OpenID::Consumer->new(
		ua => LWP::UserAgent->new,
		# LWPx::ParanoidAgent->new,
		args => $cgi,
		consumer_secret => 'papu',
		required_root => $::basehref,
	);
	my $claimed_identity = $csr->claimed_identity($url) || die "$url can't auth";

	my $check_url = $claimed_identity->check_url(
		return_to  =>
			"$::basehref?cmd=login&amp;mode=openid&amp;x=v&amp;"
				. &Nana::Login::lf("service") . "=" . $::form{&Nana::Login::lf("service")}
			. ($addquery eq "" ? "" : "&amp;$addquery"),
		trust_root => $::basehref,
	);
	return $check_url;
}

sub verify {
	my $cgi = CGI->new;

	my $csr = Net::OpenID::Consumer->new(
		ua => LWP::UserAgent->new,
		# LWPx::ParanoidAgent->new,
		args => $cgi,
		consumer_secret => 'papu',
		required_root => $::basehref,
	);

	# 認証ページへリダイレクト # comment
	if(my $setup_url = $csr->user_setup_url){
		return(
			status=>"redirect",
			url=>$setup_url,
		);
#		print $cgi->redirect(-uri => $setup_url);
	} elsif(my $verified_identity = $csr->verified_identity){
		# 認証できた時の処理			# comment
		return(
			status=>"login",
			display=>$verified_identity->display,
			url=>$verified_identity->url,
		);
	} elsif($csr->user_cancel){
		return(status=>"cancel");
	} else {
		return(status=>"error",
			code=>$csr->errcode,
			text=>$csr->errtext,
		);
	}
}

package Nana::OpenID::YahooJapan;

# http://developer.yahoo.co.jp/other/oauth/


1;
