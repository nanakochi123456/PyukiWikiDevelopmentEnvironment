######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::OAuth;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.1';
use LWP::UserAgent;
use CGI;
use Nana::Login;
use Nana::Cookie;

$Nana::OAuth::List={
	twitter=>{
		name=>$::resource{login_plugin_oauth_service_twitter},
		ConsumerKey=>$login::oauth{twitter}{ConsumerKey},
		ConsumerSecret=>$login::oauth{twitter}{ConsumerSecret},
		request_url=>"http://twitter.com/oauth/request_token",
		authorize_url=>"http://twitter.com/oauth/authorize",
		access_token_url=>"http://twitter.com/oauth/access_token",
		request_method=>"POST",
		verify_request_method=>"POST",
		signature_method=>'HMAC-SHA1',
		alt=>"Login for twitter",
		lang=>"ja",
		logo_small=>"icn_twitter16",
		small=>"logo1",
		big=>"logo1",
		token=>"oauth_token,user_id,screen_name",
		userid=>"user_id",
	},
};

my $request_token;
my $request_token_secret;

sub list {
	my @r;
	foreach(keys %{$Nana::OAuth::List}) {
		push(@r, $_) if($_!~/^\_/);
	}
	@r;
}

sub getid {
	my($id,$size)=@_;

	my $imgid;
	my $url=$Nana::OAuth::List->{$id}->{url};
	my $name=$Nana::OAuth::List->{$id}->{name};
	my $plusid=$Nana::OAuth::List->{$id}->{plusid}+0;
	if($size eq "big") {
		$imgid=$Nana::OAuth::List->{$id}->{logo_big};
	}
	$imgid=$Nana::OAuth::List->{$id}->{logo_small};
	return($url, $id, $name, $imgid, $plusid);
}

# http://m2m.mino.net/OAuth-sample.cgi

sub login {
	my ($url, $addquery, $id)=@_;

	my $request;
		$request = Net::OAuth->request("request token")->new(
				consumer_key	=> $Nana::OAuth::List->{$id}->{ConsumerKey},
				consumer_secret	=> $Nana::OAuth::List->{$id}->{ConsumerSecret},
				request_url		=> $Nana::OAuth::List->{$id}->{request_url},
				request_method	=> $Nana::OAuth::List->{$id}->{request_method},
				signature_method=> $Nana::OAuth::List->{$id}->{signature_method},
				timestamp		=> time,
				nonce			=> int(rand(2**31 - 999999 + 1)) + 999999,
				callback		=> '',
		);
	$request->sign;

	my $ua = LWP::UserAgent->new(
		agent =>"$::package/$::version OAuth.pm",
		keep_alive => 1,
		timeout => 10
	);
	my $http_hdr = HTTP::Headers->new(
		'Authorization' => $request->to_authorization_header
	);
    my $http_req = HTTP::Request->new(
		$Nana::OAuth::List->{$id}->{request_method},
		$Nana::OAuth::List->{$id}->{request_url},
		$http_hdr
	);
    my $res = $ua->request( $http_req );

    if ($res->is_success) {
		my %oauth=&oauthsplit($res->content);
		if (defined $oauth{oauth_token}) {
			$request_token = $oauth{oauth_token};
			$request_token_secret = $oauth{oauth_token_secret};

			my %cook;
			$cook{$Nana::OAuth::CookService}=$::form{&Nana::Login::lf("service")};
			$cook{$Nana::OAuth::CookRefer}=$::form{refer};

			Nana::Cookie::setcookie($Nana::OAuth::Cook, $Nana::OAuth::CookExpire, %cook);
			return $Nana::OAuth::List->{$id}->{authorize_url} . "?oauth_token=".$request_token."\n\n";
		}
	} else {
		return $res->status_line;
	}
	return "no token";
}

sub verify {
	my ($id)=@_;
	my $request_method = 'POST';
	my $request = Net::OAuth->request("access token")->new(
				consumer_key	=> $Nana::OAuth::List->{$id}->{ConsumerKey},
				consumer_secret	=> $Nana::OAuth::List->{$id}->{ConsumerSecret},
				request_url		=> $Nana::OAuth::List->{$id}->{access_token_url},
				request_method	=> $Nana::OAuth::List->{$id}->{verify_request_method},
				signature_method=> $Nana::OAuth::List->{$id}->{signature_method},
				timestamp		=> time,
				nonce			=> int(rand(2**31 - 999999 + 1)) + 999999,
				callback		=> '',
				token			=> $::form{oauth_token},
				verifier		=> $::form{oauth_verifier},
				token_secret	=> '',
	);
	$request->sign;
#	my %cook;
#	Nana::Cookie::setcookie($Nana::OAuth::Cook, -1, %cook);

	my $ua = LWP::UserAgent->new(
		agent =>"$::package/$::version OAuth.pm",
		keep_alive => 1,
		timeout => 10
	);
	my $http_hdr = HTTP::Headers->new(
		'User-Agent' => "$::package/$::version OAuth.pm"
	);
	my $http_req = HTTP::Request->new(
		$Nana::OAuth::List->{$id}->{verify_request_method},
		$Nana::OAuth::List->{$id}->{access_token_url},
		$http_hdr,
		$request->to_post_body
	);
	my $res = $ua->request($http_req);

	if ($res->is_success) {
		my %oauth=&oauthsplit($res->content);
		return(
			status=>"login",
			%oauth,
		);
	} else {
		return(status=>"cancel");
	}
}

sub oauthsplit {
	my ($str)=@_;
	my %hash;
	foreach my $a (split(/\&/, $str)) {
		my ($l, $r)=split(/=/, $a);
		$hash{$l}=$r;
	}
	return %hash;
}

1;
