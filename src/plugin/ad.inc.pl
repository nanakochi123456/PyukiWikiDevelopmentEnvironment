######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################

$PLUGIN="ad";
$VERSION="1.09";

use strict;

$AD::USECOOKIE=0		# only PyukiWiki ver 0.1.6 or later
	if(!defined($AD::USECOOKIE));

$AD::REPLACEURL=1
	if(!defined($AD::REPLACEURL));

$AD::CSS="$::skin_dir/ad.css"
	if(!defined($AD::CSS));

$AD::DATABASE=":AD"
	if(!defined($AD::DATABASE));

$AD::COOKIENAME="PAD"
	if(!defined($AD::COOKIENAME));

$::isurl_ad=qq(s?(?:https?|ftp|news)://[-_.!~*'a-zA-Z0-9;/?:@&=+%#]+);

######################################################################

@::AD_DB;
%::AD_DB_MEMO;
%::AD_DB_ALT;
%::AD_DB_URL;
%::AD_DB_HTML;
%::AD_DB_CREATE;
%::AD_DB_UPDATE;
%::AD_DB_START;
%::AD_DB_EXPIRE;
%::AD_DB_PRIORITY;
%::AD_DB_VIEW;
%::AD_DB_COUNT;
%::AD_DB_NUM;
$::AD_SESSION;

$::AD_LOADED=0;

$::AD_CNT=0;

sub plugin_ad_convert {
	my ($space) = split(/,/, shift);
	return ' ' if($space eq '');
	my $test=$space;
	$test=~s/[0-9A-Za-z]//g;
	if($test eq "") {
		return qq(<div class="ad"><span class="$space">) . &plugin_ad_view($space) . qq(</span></div>\n);
	} else {
		return qq(<div class="ad">) . &plugin_ad_view($space) . qq(</div>\n);
	}
}

sub plugin_ad_inline {
	my ($space) = split(/,/, shift);
	return ' ' if($space eq '');
	my $test=$space;
	$test=~s/[0-9A-Za-z]//g;
	if($test eq "") {
		return qq(<span class="ad"><span class="$space">) . &plugin_ad_view($space) . qq(</span></span>\n);
	} else {
		return qq(<span class="ad">) . &plugin_ad_view($space) . qq(</span>\n);
	}
}

sub plugin_ad_view {
	my($space)=@_;
	&plugin_ad_readdb;
	$space=~ s/(.)/unpack('H2', $1)/eg;
	if($::AD_DB_VIEW{$space} eq '') {
		foreach my $id(split(/\f/,$::AD_DB{$space})) {
			if($::AD_DB_START{"$space\_$id"}<=time
				&& ($::AD_DB_EXPIRE{"$space\_$id"} eq 0
				||  $::AD_DB_EXPIRE{"$space\_$id"} >= time-86400)) {
				for(my $i=0; $i<$::AD_DB_PRIORITY{"$space\_$id"}; $i++) {
					my $tmphtml=$::AD_DB_HTML{"$space\_$id"};
					$::AD_DB_VIEW{$space}.=$tmphtml . "\f$id\0";
					$::AD_DB_NUM{$space}++;
				}
			}
		}
	}
	return ' ' if($::AD_DB_VIEW{$space} eq '');

	if($::AD_SESSION+0 eq 0) {
		if($AD::USECOOKIE eq 1 && &plugin_ad_pyukiver) {
			my %adcookie;
			%adcookie=&getcookie($AD::COOKIENAME,%adcookie);
			if($adcookie{session}+0 ne 0) {
				$::AD_SESSION=$adcookie{session};
			} else {
				$::AD_SESSION=(times)[0]*10000000+int(rand(100000));
				$adcookie{session}=$::AD_SESSION;
				&setcookie($AD::COOKIENAME,0,%adcookie);
			}
		} else {
			$::AD_SESSION=(times)[0]*10000000+int(rand(100000));
		}
	}
	$::AD_DB_COUNT{$space}++;
	my $retval=(split(/\0/,$::AD_DB_VIEW{$space}))[($::AD_SESSION + $::AD_DB_COUNT{$space}*11) % $::AD_DB_NUM{$space}];
	my ($ret,$id)=split(/\f/,$retval);

	# XHTML簡易補正
	$ret=~s/<[Ii][Mm][Gg] (.+?)>/<img $1 \/>/g;
	$ret=~s/<[Ii][Mm][Gg] (.+?) \/ \/>/<img $1 \/>/g;

	# URL書き換え
	if(&plugin_ad_pyukiver >= 2 && $AD::REPLACEURL) {
		if(-r "$::plugin_dir/ad_extend.inc.pl") {
			require "$::plugin_dir/ad_extend.inc.pl";
			my $adspace="$space\_$id";
			$ret=&ad_extend($ret, $::AD_DB_ALT{$adspace}, $::AD_DB_URL{$adspace}, $id);
		}

		if($::AD_LOADED eq 0) {
			$::AD_LOADED=1;
			$::IN_HEAD.=<<EOM;
<link rel="stylesheet" href="$AD::CSS" type="text/css" />
EOM
			$::IN_JSHEADVALUE.=<<EOM;
var script='$::script';
EOM
		}
	}
	return $ret;
}

sub mkurl_ad {
	my($url, $flg, $target)=@_;
	if($flg eq "onclick") {
		if($linktrack::cgilink eq 1) {
			return "";
		}
		if($target eq "") {
			return qq( onclick="return Ck(this,\\u0027$url\\u0027);");
		} else {
			return qq( onclick="return Ck(this,\\u0027$url\\u0027,\\u0027$target\\u0027);");
		}
	}
	if($flg eq "oncontextmenu") {
		if($linktrack::cgilink eq 1) {
			return "";
		}
		return qq( oncontextmenu="return Ck(this,\\u0027$url\\u0027,\\u0027r\\u0027);");
	}
	if($flg eq "ou") {
		return qq( return onclick="ou(\\u0027$url\\u0027,\\u0027$target\\u0027);");
	}
	if($linktrack::cgilink eq 1) {
		my $hs=&dbmname($::form{mypage});
		my $lk=&dbmname($url);
		my $urlbase="$::script?cmd=ck&amp;p=$hs&amp;l=$lk";
		return $urlbase;
	}
	return $url;
}

sub plugin_ad_readdb {
	if($#::AD_DB < 0) {
		my $db=$::database{$AD::DATABASE};
		my $flg=0;
		my $space="";
		my $id="";
		my $hex;
		foreach(split(/\n/,$db)) {
			chomp;
			next if(/^\/\//);
			# 広告名
			if(/^\*\*\*(.*?)\t(.*?)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(.*)/ && $space ne '') {
				$id=$1;
				my $pr=$3;
				my $st=$4;
				my $ex=$5;
				my $cr=$6;
				my $up=$7;
				my ($alt, $displayurl)=split(/\t/,$8);
				$::AD_DB_MEMO{"$hex\_$id"}=$2;
				$::AD_DB_ALT{"$hex\_$id"}=$alt;
				$::AD_DB_URL{"$hex\_$id"}=$displayurl;
				$::AD_DB_PRIORITY{"$hex\_$id"}=$pr;
				$::AD_DB_START{"$hex\_$id"}=$st;
				$::AD_DB_EXPIRE{"$hex\_$id"}=$ex;
				$::AD_DB_CREATE{"$hex\_$id"}=$cr;
				$::AD_DB_UPDATE{"$hex\_$id"}=$up;
				$::AD_DB{$hex}.="$id\f";
			} elsif(/^\*\*\*(.*?)\t(.*?)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)/ && $space ne '') {
				$id=$1;
				my $pr=$3;
				my $st=$4;
				my $ex=$5;
				my $cr=$6;
				my $up=$7;
				$::AD_DB_MEMO{"$hex\_$id"}=$2;
				$::AD_DB_ALT{"$hex\_$id"}="";
				$::AD_DB_URL{"$hex\_$id"}="";
				$::AD_DB_PRIORITY{"$hex\_$id"}=$pr;
				$::AD_DB_START{"$hex\_$id"}=$st;
				$::AD_DB_EXPIRE{"$hex\_$id"}=$ex;
				$::AD_DB_CREATE{"$hex\_$id"}=$cr;
				$::AD_DB_UPDATE{"$hex\_$id"}=$up;
				$::AD_DB{$hex}.="$id\f";
			} elsif(/^\*\*(.+)\t(\d+)x(\d+)/) {
				$space=$1;
				my $w=$2;
				my $h=$3;
				push(@::AD_DB, $space);
				$hex=$space;
				$hex=~ s/(.)/unpack('H2', $1)/eg;
				$::AD_DB{__width}{$hex}=$w;
				$::AD_DB{__height}{$hex}=$h;
			} elsif(/^ (.+)/ && $id ne '') {
				$::AD_DB_HTML{"$hex\_$id"}.="$1\n";
			} else {
				$id="";
			}
		}
	}
}

sub plugin_ad_action {
	my $id=$::form{l};
	my $c=$::form{c};
	my $p=$::form{p};
	if($id eq '' && $c+0 eq 0) {
		require "$::plugin_dir/ad_edit.inc.pl";
		return &plugin_ad_edit_start;
	}
	if(&plugin_ad_pyukiver >= 2) {
		&plugin_ad_readdb;
		foreach my $key(keys %::AD_DB_HTML) {
			if($key=~/$id$/) {
				my $tmphtml=$::AD_DB_HTML{$key};
				my @url=$tmphtml=~/($::isurl_ad)/gm;
				my $url=$url[$c-1];
				&location($url, 302);

				if(&plugin_ad_pyukiver >= 1) {
					require "$::plugin_dir/counter.inc.pl";
					&plugin_counter_do("link\_$url","w");
				}
				if(&plugin_ad_pyukiver >= 2) {
					if($::_exec_plugined{logs}>1) {
						my $cmd="ck";
						$::form{p}=&undbmname($::form{p});
						my $page=&code_convert(\$::form{p}, $::defaultcode);
						my $link=$url;
						$page="$page<>$link";

						my $filename=&date("Y-m-d");

			&getremotehost;
						my $user=$::authadmin_cookie_user_name;
						my $logtxt=<<EOM;
$ENV{REMOTE_HOST} $ENV{REMOTE_ADDR}\t@{[&date($logs::date_format)]} @{[&date($logs::time_format)]}\t$user\t$ENV{REQUEST_METHOD}\t$cmd\t$::lang\t$page\t$ENV{HTTP_USER_AGENT}\t$ENV{HTTP_REFERER}
EOM
						&plugin_logs_add($filename, $logtxt);
					}
				}
				exit;
			}
		}
	}
}

sub plugin_ad_cookie_getcookie {
	my($cookieID,%buf)=@_;
	my @pairs;
	my $pair;
	my $cname;
	my $value;
	my %DUMMY;

	@pairs = split(/;/,&decode($ENV{'HTTP_COOKIE'}));
	foreach $pair (@pairs) {
		($cname,$value) = split(/=/,$pair,2);
		$cname =~ s/ //g;
		$DUMMY{$cname} = $value;
	}
	@pairs = split(/,/,$DUMMY{$cookieID});
	foreach $pair (@pairs) {
		($cname,$value) = split(/:/,$pair,2);
		$buf{$cname} = $value;
	}
	return %buf;
}

sub plugin_ad_cookie_setcookie{
	my($cookieID,$expire,%buf)=@_;
	my $date;
	my $data;
	$expire=$expire+0;
	if($expire > 0) {
		$date=&date("D, j-M-Y H:i:s",gmtime(time)+$expire);
	} elsif($expire < 0) {
		$date=&date("D, j-M-Y H:i:s",1);
	}
	my($name,$value);
	while(($name,$value)=each(%buf)) {
		$data.="$name:$value," if($name ne '');
	}
	$data=~s/\,$//g;
	$data=&encode($data);
	$::HTTP_HEADER.=qq(Set-Cookie: $cookieID=$data;);
	$::HTTP_HEADER.=" expires=$date GMT" if($expire ne 0);
	$::HTTP_HEADER.="\n";
}

# 0.2.0/0.1.6未満かそれ以降かチェック
sub plugin_ad_pyukiver {
	my ($v,$s)=split(/\-/,$::version);
	$v=~s/\.//g;
	return 2 if($v+0>=20);
	return 1 if($v+0>=16);
	return 0;
}

1;
__DATA__

# perse string for admin.inc.pl
# sub plugin_ad_action {
# &authadminpassword();
# resource:ad_edit
__END__

=head1 NAME

ad.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 &ad(space name);
 #ad(space name)
 ?cmd=ad


=head1 DESCRIPTION

Display the advertisement of affiliate advertising service etc.

Since it is the type which registers HTML directly, it can use with many services.

It supports from PyukiWiki 0.1.3.

=head1 WARNING

Since HTML is registered directly, any HTML tags can be put in.

Please set up the freeze password different from a default and be sure to strive for security reservation.

=head1 USING

=over 4

=item &ad(space name);

Display Advertisement on inline at <span class="ad">

=item #ad(space name)

Display Advertisement at <div class="ad">

=item ?cmd=ad

Display management screen which perform advertising addition, edit, and delete.

A freeze password can perform addition, edit, and deletion after attestation.

For details, please look at て just on the following management screens.

=back

=head1 ABOUT MANAGEMENT SCREEN

=over 4

=item Advertisement Addition

On the first screen, the advertising HTML code offered by the advertising provider is stuck as it is.

Do not change the HTML code, without obtaining permission of an advertising provider or an advertiser.

Keep in mind that the advertisement for e-mail cannot be used although it is distinguished automatically whether they are banner size or a text advertisement.

Then, it moves to the selection screen of an advertising space.

An advertising space name is inputted newly or the space of the same existing size is chosen.
Then, priority   (0 non-displaying to 10 maximum) A display opening day and a display end day are chosen.

If a display end day is made "no choice", it will display without a term.

If an advertisement is carried to the same space, based on a priority, it will be displayed at random.

=item Space Edit

Advertising display setup and advertising deletion can be performed in edit of an advertising space.

=item Space Delete

All the advertisements of the space are deleted in deletion of an advertising space.

=back

=head1 SETTINGS

=over 4

=item $AD::USECOOKIE

if it is set as 0 -- completeness -- it is random and an advertisement is displayed.

If it is set as 1, the same advertisement will be displayed until it closes a browser.

When the advertisement is set as one space only for one, only the advertisement is displayed on it.

As for this option, PyukiWiki 0.1.6 or subsequent ones corresponds.

=item $AD::DATABASE=":AD";

Setup wiki page name which saves an advertising database.

We recommend you to use it, changing as it becomes.

=item With PyukiWiki 0.1.5 or earlier

Install resource file of 'ad_edit.en.txt' in   $::data_home. It is not necessary to add to the existing resource file.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/ad/

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/ad/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/ad.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/ad_edit.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
