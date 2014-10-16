######################################################################
# @@HEADER2_NANAMI@@
######################################################################
#
# 自動逆リンクプラグイン
#
######################################################################

use strict;
use Nana::HTTP;

$links::maxview=50
	if(!defined($links::maxview));

$links::maxlength=80
	if(!defined($links::maxlength));

$links::maxsavelength=1024
	if(!defined($links::maxsavelength));

$links::directory="./links"
	if(!defined($links::directory));

$links::ignoredomain=<<EOM if(!defined($links::ignoredomain));
a8.net
e-click
valuecommerce
linkshare
trafficgate
bannerbridge
j-a-net
accesstrade
xmax
affiliate
cross-a
ad-link
find-a
EOM

$links::enableword{en}=<<EOM if($links::enableword{en} eq "");
[0-9A-Za-z]
EOM

$links::enableword{ja}=<<EOM if($links::enableword{ja} eq "");
[あ-ん]
[ア-ン]
EOM

$links::ignoreword{en}=<<EOM if($links::ignoreword{en} eq "");
[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]
EOM

$links::ignoreword{ja}=<<EOM if($links::ignoreword{ja} eq "");
[Rr][Ee][Dd][Ii][Rr][Ee][Cc][Tt]
リダイレクト
EOM

$PLUGIN_LINKS::Load=0;
@links::RobotsSearchIDOrder;

sub plugin_links_init {
	if($PLUGIN_LINKS::Load eq 0) {
		require "$::explugin_dir/AWS/browsers.pm";
		require "$::explugin_dir/AWS/domains.pm";
		require "$::explugin_dir/AWS/operating_systems.pm";
		require "$::explugin_dir/AWS/robots.pm";
		require "$::explugin_dir/AWS/search_engines.pm";
		$LOGS::Load=1;
		push(@links::RobotsSearchIDOrder, @links::RobotsSearchIDOrder_list1);
		push(@links::RobotsSearchIDOrder, @links::RobotsSearchIDOrder_list2);
		push(@links::RobotsSearchIDOrder, @links::RobotsSearchIDOrder_listgen);
	}
	$PLUGIN_LINKS::Load=1;
}

sub plugin_links_convert {
	return &plugin_links_inline(@_);
}

sub plugin_links_inline {
	my ($mode)=split(/,/,shift);

	return " " if($::form{cmd} ne "read");
	return " " if(!&is_frozen($::form{mypage}));

	my $err=&writechk($links::directory);
	if($err ne '') {
		&print_error($err);
		exit;
	}

	my $uabrowser;
	my $uabrowserver;
	my $browser=lc $ENV{HTTP_USER_AGENT};
	&plugin_links_init;

	foreach(@links::RobotsSearchIDOrder) {
		if($browser =~ /$_/) {
			$uabrowser='robot';
		}
	}

	my %links;
	&dbopen($links::directory,\%links);
	my $ref=&htmlspecialchars($ENV{HTTP_REFERER});
	my $myurl=$::basehref;
	my $mypage=$::pushedpage eq "" ? $::form{mypage} : $::pushedpage;
	my @links=split(/\n/, $links{$mypage});

	my $_title=&htmlspecialchars(&gettitle($ref));

	if($mypage ne "" && $uabrowser ne "robot" &&
			substr($ref, 0, length($myurl))
		 ne substr($myurl, 0, length($myurl))
		) {
		my $flg=0;
		for(my $i=0; $i <= $#links; $i++) {
			my($time, $count, $ip, $refurl, $title)=split(/\t/,$links[$i]);
			if(($refurl eq $ref) && ($ref ne "")) {
				$flg=1;
				if($ip ne $ENV{REMOTE_ADDR}) {
					$time=time;
					$count++;
					$ip=$ENV{REMOTE_ADDR};
					$refurl=&strcutbytes($refurl, $links::maxsavelength);
					$_title=&strcutbytes($_title, $links::maxsavelength);

					$links[$i]="$time\t$count\t$ip\t$refurl\t_$title";
				}
			}
		}
		if(($flg eq 0) && ($ref ne "")) {
			my $time=time;
			push(@links, "$time\t1\t$ENV{REMOTE_ADDR}\t$ref\t$_title");
			$flg=1;
		}
		if($flg eq 1) {
			@links=sort {
				(split(/\t/,$a))[1]+0 <=> (split(/\t/,$b))[1]+0
				} @links;
			$links{$mypage}=join("\n", @links);
		}
	}
	&dbclose(\%links);
	my $body;
	for(my $i=0; $i <= $#links && $i < $links::maxview; $i++) {
		my ($time, $count, $ip, $url, $title)=split(/\t/,$links[$i]);
		$title=&strcutbytes($title, $links::maxlength);
		$title=&linksesc($title);
		my $flg=0;
		foreach(split(/\n/,$links::ignoredomain)) {
			$flg=1 if($url=~/$_/);
		}
		next if($flg eq 1);

		foreach(split(/\n/,$links::ignoreword{$::lang})) {
			$flg=1 if($title=~/$_/);
		}
		next if($flg eq 1);

		my $titledecode=$title;
		foreach(split(/\n/,$links::enableword{$::lang})) {
			utf8::decode($_);
			utf8::decode($titledecode);
			$flg=1 if($titledecode=~/$_/);
#			my $a=$_;
#			utf8::encode($a);
#			$body.="($title $a)\n" if($titledecode=~/$_/);
		}

		$body.="-[[$title>$url]]\n"
			if($flg eq 1 || $title=~/$::isurl/o);
	}
	my $ret=$::resource{links_msg};
	if($body eq "") {
		my $res=$::resource{links_nodata};
		$res=~s/\$PAGE/$mypage/g;
		$ret=~s/\$LINK/$res/g;
	} else {
		my $txt=&text_to_html($body);
		$ret=~s/\$LINK/$txt/g;
	}
	return $ret;
}

sub linksesc {
	$_=shift;
	s/\#/\fx23;/g;
	s/\&/\&#x26;/g;
	s/\fx23;/\&#x23;/g;
	s/\//\&#x2f;/g;
	s/\'/\&#x27;/g;
	s/\"/\&#x22;/g;
	s/\!/\&#x21;/g;
	s/\$/\&#x24;/g;
	s/\%/\&#x25;/g;
	s/\[/\&#x5b;/g;
	s/\]/\&#x5d;/g;
	s/\(/\&#x28;/g;
	s/\)/\&#x29;/g;
#	s/\(//g;
#	s/\)//g;
	return $_;

}
sub gettitle {
	my($url)=shift;
	my $title;

	if($url=~/$::isurl/o) {
		my $http=new Nana::HTTP('ua'=>"URL shorten of http://$ENV{HTTP_HOST}/");
		my ($result, $stream) = $http->get($url);
		$stream=~s/[\xd\xa]//g;
		$stream=&code_convert(\$stream, $::defaultcode);
		if($stream=~/[Tt][Ii][Tt][Ll][Ee]/) {
			$stream=~s/<\/[Tt][Ii][Tt][Ll][Ee]>.*//g;
			$stream=~s/.*<[Tt][Ii][Tt][Ll][Ee]>//g;
			$title=$stream;
		}
		if($title eq '') {
			$title=$url;
			$title=~s/(https?|ftp|news)\:\/\///g;
		}
		return $title;
	}
	return "";
}

1;
__END__
=head1 NAME

links.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=links

=head1 DESCRIPTION

Automatic reverse link.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/links

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/links/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/links.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
