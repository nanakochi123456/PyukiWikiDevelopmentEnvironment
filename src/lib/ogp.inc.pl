######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'ogp.inc.cgi'
######################################################################
#
# http://webdrawer.net/html/facebookogp.html
#

$ogp::forceallns=0								# xmlnsを全て強制的に出力
	if($ogp::forceallns eq '');

$ogp::meta{title}=""							# タイトル
	if($ogp::meta{title} eq '');
$ogp::meta{type}="website"						# 説明参照
	if($ogp::meta{type} eq '');
$ogp::meta{url}="";								# 変更不可能
$ogp::meta{image}=""							# 画像
	if($ogp::meta{image} eq '');
$ogp::meta{"image:url"}=""						# 画像
	if($ogp::meta{"image:url"} eq '');
$ogp::meta{"image:secure_url"}=""				#
	if($ogp::meta{"image:secure_url"} eq '');
$ogp::meta{"image:type"}=""						#
	if($ogp::meta{"image:type"} eq '');
$ogp::meta{"image:width"}=""					#
	if($ogp::meta{"image:width"} eq '');
$ogp::meta{"image:height"}=""					#
	if($ogp::meta{"image:height"} eq '');

$ogp::meta{description}=""						# 説明
	if($pgp::meta{description} eq '');
$ogp::meta{site_name}=""						# 説明
	if($pgp::meta{site_name} eq '');

$ogp::meta{latitude}=""							# 緯度
	if($ogp::meta{latitude} eq "");
$ogp::meta{longitude}=""						# 経度
	if($ogp::meta{longitude} eq "");
$ogp::meta{"street-address"}=""					# 住所（番地など）
	if($ogp::meta{"street-address"} eq "");
$ogp::meta{locality}=""							# 市区町村
	if($ogp::meta{locality} eq "");
$ogp::meta{region}=""							# 都道府県
	if($ogp::meta{region} eq "");
$ogp::meta{"postal-code"}=""					# 郵便番号
	if($ogp::meta{"postal-code"} eq "");
$ogp::meta{"country-name"}=""					# 国名
	if($ogp::meta{"country-name"} eq "");

$ogp::meta{email}=""							# メールアドレス
	if($ogp::meta{email} eq "");
$ogp::meta{"phone_number"}=""					# 電話番号
	if($ogp::meta{"phone_number"} eq "");
$ogp::meta{"fax_number"}=""						# FAX番号
	if($ogp::meta{"fax_number"} eq "");
$ogp::meta{determiner}=""						#
	if($ogp::meta{determiner} eq "");
$ogp::meta{locale}=""							#
	if($ogp::meta{locale} eq "");
$ogp::meta{"locale:alternate"}=""				#
	if($ogp::meta{"locale:alternate"} eq "");

$ogp::meta{"video"}="";							# 動画のファイルパス
$ogp::meta{"video:height"}="";					# 動画の高さサイズ
$ogp::meta{"video:width"}="";					# 動画の横幅サイズ
$ogp::meta{"video:type"}="";					# 動画のファイルタイプ

$ogp::meta{"audio"}="";							# 音楽のファイルパス
$ogp::meta{"audio:title"}="";					# 音楽のタイトル
$ogp::meta{"audio:artist"}="";					# 音楽のアーティスト名
$ogp::meta{"audio:album"}="";					# 音楽のアルバム名
$ogp::meta{"audio:type"}="";					# 音楽のファイルタイプ

$ogp::fb{admins}=""								# Facebookのユーザー名
	if($ogp::fb{admins} eq "");
$ogp::fb{app_id}=""								# FacebookのアプリID
	if($ogp::fb{app_id} eq "");

$ogp::mixi{content-rating}=""					# 18歳未満非対応サイトの場合、
	if($ogp::mixi{content-rating} eq "");		# 「1」を設定

# XMLNS

$ogp::xmlns{og}='xmlns:og="http://ogp.me/ns#"'
	if($ogp::xmlns{og} eq "");
$ogp::xmlns{mixi}='xmlns:mixi="http://mixi-platform.com/ns#"'
	if($ogp::xmlns{mixi} eq "");
$ogp::xmlns{fb}='xmlns:fb="http://www.facebook.com/2008/fbml"'
	if($ogp::xmlns{fb} eq "");

# MIXI モバイル制御
# http://developer.mixi.co.jp/connect/mixi_plugin/mixi_check/spec_mixi_check/index.html#toc-url

$ogp::link::href{mixi-device-smartphone}=""			# スマートフォン
	if($ogp::link::href{mixi-device-smartphone} eq "");
$ogp::link::type{mixi-device-smartphone}=""
	if($ogp::link::type{mixi-device-smartphone} eq "");

$ogp::link::href{mixi-device-mobile}=""				# 携帯電話（全キャリア）
	if($ogp::link::href{mixi-device-mobile} eq "");
$ogp::link::type{mixi-device-mobile}=""
	if($ogp::link::type{mixi-device-mobile} eq "");

$ogp::link::href{mixi-device-docomo}=""				# DoCoMo
	if($ogp::link::href{mixi-device-docomo} eq "");
$ogp::link::type{mixi-device-docomo}=""
	if($ogp::link::type{mixi-device-docomo} eq "");

$ogp::link::href{mixi-device-au}=""					# au
	if($ogp::link::href{mixi-device-au} eq "");
$ogp::link::type{mixi-device-au}=""
	if($ogp::link::type{mixi-device-au} eq "");

$ogp::link::href{mixi-device-softbank}=""			# Softbank
	if($ogp::link::href{mixi-device-softbank} eq "");
$ogp::link::type{mixi-device-softbank}=""			# Softbank
	if($ogp::link::type{mixi-device-softbank} eq "");

######################################
# types list
#
#	Activities
#		activity
#		sport
#
#	Businesses
#		bar
#		company
#		cafe
#		hotel
#		restaurant
#
#	Groups
#		cause
#		sports_league
#		sports_team
#
#	Organizations
#		band
#		government
#		non_profit
#		school
#		university
#
#		People
#		actor
#		athlete
#		author
#		director
#		musician
#		politician
#		profile
#		public_figure
#
#	Places
#		city
#		country
#		landmark
#		state_province
#
#	Products and Entertainment
#		album
#		book
#		drink
#		food
#		game
#		movie
#		product
#		song
#		tv_show
#
#	Websites
#		article
#		blog
#		website
#
######################################################################

sub plugin_ogp_init {
	return('init'=>1, 'header'=>&plugin_ogp_header);

}

sub plugin_ogp_header {
	my $header;
	my %xmlns;

	my $url=&make_cookedurl($::pushedpage ne '' ? $::pushedpage : $::form{mypage});
	&getbasehref;
	my $base=$::basehref;
	$base=~s/\/$//;
	$url="$base$url";
	$ogp::meta{url}=$url;
	my @title=$database{$::form{mypage}}=~/#title\((.*?)\)/;
	my $title=$title[0];
	$title="" if($database{$::form{mypage}}!~/#freeze\n/);

	if($ogp::meta{title} eq "") {
		$ogp::meta{title}=$title eq "" ? $::form{mypage} : $title;
	}
	if($ogp::meta{site_name} eq "") {
		$ogp::meta{site_name}="$::wiki_title";
	}
	if($ogp::meta{description} eq"") {
		$ogp::meta{description}=&get_subjectline($::form{mypage}, 1, delimiter=>"");
		$ogp::meta{description}=~s/\n/ /g;
	}

	if($ogp::meta{image} eq "" && $ogp::meta{"image:url"} eq "") {
		if($::logo_url=~/^$::isurl/) {
			$ogp::meta{"image:url"}=$::logo_url;
		} else {
			$ogp::meta{"image:url"}="$::basehost/$::basepath/$::logo_url";
		}
		$ogp::meta{"image:width"}=$::logo_width;
		$ogp::meta{"image:height"}=$::logo_height;
	}

	&exec_explugin_sub("antispam");
	if($::AntiSpam eq "" && $ogp::meta{email} eq "") {
		$ogp::meta{email}=$::modifier_mail
			if($::modifier_mail ne "");
	}

	foreach("title","type","url","image","description","site_name", "image:url"
		  , "image:secure_url", "image:type", "image:width", "image:height"
		  , "latitude","longitude","street-address","locality"
		  , "region", "postal-code", "country-name", "email", "phone_number"
		  , "fax_number", "determiner", "locale", "locale:alternate"
		  , "video", "video:height", "video_width", "video:type"
		  , "audio", "audio:title", "audio:artist", "audio:album", "audio:type"
		) {
		if($ogp::meta{$_} ne "") {
			foreach my $vv (split(/\t/, $ogp::meta{$_})) {
				$header.=<<EOM;
<meta property="og:$_" content="$vv" />
EOM
			}
			$xmlns{og}=$ogp::xmlns{og};
		}
	}

	foreach("admins", "app_id") {
		if($ogp::fb{$_} ne "") {
			$header.=<<EOM;
<meta property="fb:$_" content="$ogp::fb{$_}" />
EOM
			$xmlns{fb}=$ogp::xmlns{fb};
		}
	}

	foreach("content-rating") {
		if($ogp::mixi{$_} ne "") {
			$header.=<<EOM;
<meta property="mixi:$_" content="$ogp::mixi{$_}" />
EOM
			$xmlns{mixi}=$ogp::xmlns{mixi};
		}
	}

	foreach("smrtphone", "mobile", "docomo", "au", "softbank") {
		my $v="mixi-device-$_";
		if($ogp::link::href{$v} ne '' && $ogp::link::type{$v} ne '') {
			$header.=<<EOM;
<link rel="mixi-check-alternate" media="$v" type="$ogp::link::type{$v}" href="$ogp::link::href{$v}" />
EOM
		}
	}
	my $xmlns;
	if($ogp::forceallns) {
		$xmlns="$ogp::xmlns{og} $ogp::xmlns{fb} $ogp::xmlns{mixi}";
	} else {
		foreach(keys %xmlns) {
			$xmlns.=" $xmlns{$_}";
		}
	}
	&init_dtd($xmlns);
	return $header;
}

1;
__DATA__
sub plugin_ogp_setup {
	return(
		ja=>'The Open Graph protocol',
		en=>'The Open Graph protocol',
		url=>'http://pyukiwiki.sfjp.jp/PyukiWiki/Plugin/ExPlugin/ogp/'
	);
}
__END__

=head1 NAME

ogp.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

The Open Graph protocol

=head1 DESCRIPTION

The Open Graph protocol

This plugin is Japanese only

=head1 USAGE

rename to ogp.inc.cgi

setting info/setup.cgi

=head1 OVERRIDE

do_read

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/ogp

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/ogp/>

=item The Open Graph protocol

L<http://ogp.me/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/ogp.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
