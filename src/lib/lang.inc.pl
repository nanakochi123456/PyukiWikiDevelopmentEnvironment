######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# This file is UTF-8
# To use this plugin, rename to 'lang.inc.cgi'
######################################################################
# 国際化対応拡張プラグイン
# 以下の言語別wikiディレクトリを作成して下さい。
# attach.(lang)		example attach.en
# diff.(lang)		example diff.ja
# cache.(lang)		example cache.zh-cn
# counter.(lang)	example counter.en-us
# info.(lang)		example info.fr
# wiki.(lang)		example wiki.ja
# デフォルト言語は、従来のディレクトリのままで動作します。
######################################################################

%::langlist=(
	'af'=>'Afrikaans',
	'sq'=>'Albanian',
	'ar'=>'Arabic',
	'ar-sa'=>'Arabic(Saudi Arabia)',
	'ar-iq'=>'Arabic(Iraq)',
	'ar-eg'=>'Arabic(Egypt)',
	'ar-ly'=>'Arabic(Libya)',
	'ar-dz'=>'Arabic(Algeria)',
	'ar-ma'=>'Arabic(Morocco)',
	'ar-tn'=>'Arabic(Tunisia)',
	'ar-om'=>'Arabic(Oman)',
	'ar-ye'=>'Arabic(Yemen)',
	'ar-sy'=>'Arabic(Syria)',
	'ar-jo'=>'Arabic(Jordan)',
	'ar-lb'=>'Arabic(Lebanon)',
	'ar-kw'=>'Arabic(Kuwait)',
	'ar-ae'=>'Arabic(U.A.E.)',
	'ar-bh'=>'Arabic(Bahrain)',
	'ar-qa'=>'Arabic(Qatar)',
	'eu'=>'Basque',
	'bg'=>'Bulgarian',
	'be'=>'Belarusian',
	'ca'=>'Catalan',
#	'zh-cn'=>'Chinese(PRC)',
	'cn'=>'Chinese,中文',
	'zh'=>'Chinese,中文',
	'zh-cn'=>'Chinese,中文',
	'zh-tw'=>'Chinese(Taiwan),台灣語',
	'zh-hk'=>'Chinese(Hong Kong),香港语',
	'zh-sg'=>'Chinese(Singapore),新加坡语',
	'hr'=>'Croatian',
	'cs'=>'Czech',
	'da'=>'Danish',
#	'nl'=>'Dutch(Standard)',
	'nl'=>'Dutch',
	'nl-be'=>'Dutch(Belgian)',
	'en'=>'English',
	'en-us'=>'English(United States)',
	'en-gb'=>'English(British)',
	'en-au'=>'English(Australian)',
	'en-ca'=>'English(Canadian)',
	'en-nz'=>'English(New Zealand)',
	'en-ie'=>'English(Ireland)',
	'en-za'=>'English(South Africa)',
	'en-jm'=>'English(Jamaica)',
#	'en'=>'English(Caribbean)',
	'en-bz'=>'English(Belize)',
	'en-tt'=>'English(Trinidad)',
	'et'=>'Estonian',
	'fo'=>'Faeroese',
	'fa'=>'Farsi',
	'fi'=>'Finnish',
#	'fr'=>'French(Standard)',
	'fr'=>'French',
	'fr-be'=>'French(Belgian)',
	'fr-ca'=>'French(Canadian)',
	'fr-ch'=>'French(Swiss)',
	'fr-lu'=>'French(Luxembourg)',
#	'gd'=>'Gaelic(Scots)',
	'gd'=>'Gaelic',
	'gd-ie'=>'Gaelic(Irish)',
#	'de'=>'German(Standard)',
	'de'=>'German',
	'de-ch'=>'German(Swiss)',
	'de-at'=>'German(Austrian)',
	'de-lu'=>'German(Luxembourg)',
	'de-li'=>'German(Liechtenstein)',
	'el'=>'Greek',
	'he'=>'Hebrew',
	'hi'=>'Hindi',
	'hu'=>'Hungarian',
	'is'=>'Icelandic',
	'in'=>'Indonesian',
#	'it'=>'Italian(Standard)',
	'it'=>'Italian',
	'it-ch'=>'Italian(Swiss)',
	'ja'=>'Japanese,日本語',
	'ko'=>'Korean,한국어',
	'kr'=>'Korean,한국어',
#	'ko'=>'Korean(Johab),한국어',
	'lv'=>'Latvian',
	'lt'=>'Lithuanian',
	'mk'=>'Macedonian',
	'ms'=>'Malaysian',
	'mt'=>'Maltese',
	'no'=>'Norwegian',
	'pl'=>'Polish',
#	'pt'=>'Portuguese(Standard)',
	'pt'=>'Portuguese',
	'pt-br'=>'Portuguese(Brazilian)',
	'rm'=>'Rhaeto-Romanic',
	'ro'=>'Romanian',
	'ro-mo'=>'Romanian(Moldavia)',
	'ru'=>'Russian',
	'ru-mo'=>'Russian(Moldavia)',
#	'sz'=>'Sami(Lappish)',
	'sz'=>'Sami',
#	'sr'=>'Serbian(Cyrillic)',
#	'sr'=>'Serbian(Latin)',
	'sr'=>'Serbian',
	'sk'=>'Slovak',
	'sl'=>'Slovenian',
	'sb'=>'Sorbian',
#	'es'=>'Spanish(Spain - Traditional Sort)',
	'es'=>'Spanish',
	'es-mx'=>'Spanish(Mexican)',
#	'es'=>'Spanish(Spain - Modern Sort)',
	'es-gt'=>'Spanish(Guatemala)',
	'es-cr'=>'Spanish(Costa Rica)',
	'es-pa'=>'Spanish(Panama)',
	'es-do'=>'Spanish(Dominican Republic)',
	'es-ve'=>'Spanish(Venezuela)',
	'es-co'=>'Spanish(Colombia)',
	'es-pe'=>'Spanish(Peru)',
	'es-ar'=>'Spanish(Argentina)',
	'es-ec'=>'Spanish(Ecuador)',
	'es-cl'=>'Spanish(Chile)',
	'es-uy'=>'Spanish(Uruguay)',
	'es-py'=>'Spanish(Paraguay)',
	'es-bo'=>'Spanish(Bolivia)',
	'es-sv'=>'Spanish(El Salvador)',
	'es-hn'=>'Spanish(Honduras)',
	'es-ni'=>'Spanish(Nicaragua)',
	'es-pr'=>'Spanish(Puerto Rico)',
	'sx'=>'Sutu',
	'sv'=>'Swedish',
	'sv-fi'=>'Swedish(Finland)',
	'th'=>'Thai',
	'ts'=>'Tsonga',
	'tn'=>'Tswana',
	'tr'=>'Turkish',
	'uk'=>'Ukrainian',
	'ur'=>'Urdu',
	've'=>'Venda',
	'vi'=>'Vietnamese',
	'xh'=>'Xhosa',
	'ji'=>'Yiddish',
	'zu'=>'Zulu',
);

# now unuse...reserved											# comment
%::charsetlist=(												# debug
	'ja'=>'EUC-JP,iso-2022-jp,Shift-JIS',						# debug
	'ko'=>'euc-kr,iso-2022-kr',									# debug
	'kr'=>'euc-kr,iso-2022-kr',									# debug
	'cn'=>'gb2312,gb2312-80',									# debug
	'zh'=>'gb2312,gb2312-80',									# debug
	'zh-tw'=>'big5,x-euc-tw,x-cns11643-1,x-cns11643-2',			# debug
	'ar'=>'iso-8859-6',											# debug
	'be'=>'iso-8859-5',											# debug
	'bg'=>'iso-8859-5',											# debug
	'cs'=>'iso-8859-2',											# debug
	'el'=>'iso-8859-7',											# debug
	'hr'=>'iso-8859-2',											# debug
	'hu'=>'iso-8859-2',											# debug
	'hw'=>'iso-8859-8',											# debug
	'lt'=>'iso-8859-2',											# debug
	'lv'=>'iso-8859-2',											# debug
	'mk'=>'iso-8859-5',											# debug
	'pl'=>'iso-8859-2',											# debug
	'ro'=>'iso-8859-2',											# debug
	'ru'=>'iso-8859-5',											# debug
	'sh'=>'iso-8859-5',											# debug
	'sl'=>'iso-8859-5',											# debug
	'sq'=>'iso-8859-5',											# debug
	'sr'=>'iso-8859-5',											# debug
	'th'=>'TIS620',												# debug
	'sr'=>'iso-8859-9',											# debug
	'uk'=>'iso-8859-5',											# debug
	''=>'iso-8859-1',											# debug
);																# debug

my $bot_agent='[Bb]ot|Spider|inktomi|moget|Slurp|archiver|NG|Hatena';

%::lang_cookie;
$::lang_cookie="PWL_"
				. &dbmname($::basepath);

sub plugin_lang_init {
	my @langlist;
	return('init'=>0) if($::lang_list eq '');
	return('init'=>0) if($ENV{HTTP_USER_AGENT}=~/$bot_agent/);
	push(@langlist,$::lang);
	foreach(split(/ /,$::lang_list)) {
		if(-d "$::data_dir.$_" && $_ ne $::lang) {
			push(@langlist,$_);
		}
	}
	return('init'=>0) if($#langlist < 1);

	$::defaultlang=$::lang;

	%::lang_cookie=();
	%::lang_cookie=&getcookie($::lang_cookie,%::lang_cookie);

	if($::langlist{$::form{lang}} ne '') {
		$::lang=$::form{lang};
	} elsif($::lang_cookie{lang} ne '') {
		$::lang=$::lang_cookie{lang};
	} else {
		my $detectacq=0;
		my $http_accept_language=$ENV{HTTP_ACCEPT_LANGUAGE};
		$http_accept_language=~s/['"]//g;
		foreach(split(/,/,$http_accept_language)) {
			my($aclang,$acq)=split(/;q=/,$_);
			$acq="1.0" if($acq eq '');
			if($detectacq+0<$acq+0) {
				foreach(@langlist) {
					if($_ eq $aclang) {
						$detectacq=$acq;
						$::lang=$aclang;
					} else {
						$aclang=~s/\-.*//g;
						if($_ eq $aclang) {
							$detectacq=$acq;
							$::lang=$aclang;
						}
					}
				}
			}
		}
	}
	foreach(@langlist) {
		if($::navi{"lang" . $_ . "_url"} eq '') {
			push(@::addnavi,"lang_$_:help");
			$::navi{"lang_" . $_ . "_title"}=&getlangname($_);
			$::navi{"lang_" . $_ . "_url"}="$::script?cmd=lang&amp;lang=$_";
			$::navi{"lang_" . $_ . "_name"}=&getlangname($_)
				if($::lang ne $_);
			$::navi{"lang_" . $_ . "_type"}="plugin";
			$::navi{"lang_" . $_ . "_height"}=14;
			$::navi{"lang_" . $_ . "_width"}=16;
		}
	}
	# 0.2.0-p4 add security fix # comment
	return('init'=>0) if($::lang!~/^\w{1,64}$/);

	&init_lang;
	&init_dtd("");
	%::resource = &read_resource("$::res_dir/resource.$::lang.txt",%::resource);
	&dateinit;
	if($::defaultlang ne $::lang) {
		$::wiki_title=$::wiki_title{$::lang} if($::wiki_title{$::lang} ne '');
		&close_db;
		$::backup_dir.=".$::lang";
		$::data_dir.=".$::lang";
		$::diff_dir.=".$::lang";
		$::cache_dir.=".$::lang";
		$::cache_url.=".$::lang";
		$::upload_dir.=".$::lang";
		$::upload_url.=".$::lang";
		$::counter_dir.=".$::lang";
		$::info_dir.=".$::lang";
		if(-r "$::image_dir.$::lang") {
			$::image_dir.=".$::lang";
			$::image_url.=".$::lang";
		}
		&writablecheck;
		&open_db;
	}
#	my $req=&decode($ENV{QUERY_STRING});						# debug
#	if(&is_exist_page($req)) {									# debug
#		$::form{cmd}='read';									# debug
#		$::form{mypage}=$req;									# debug
#	}															# debug
	return('init'=>1, 'func'=>'init_lang', 'init_lang'=>\&init_lang);
}

sub getlangname {
	my ($v)=@_;
	my ($lang,$langutf)=split(/,/,$::langlist{$v});
	return $lang;
}

sub init_lang {
	$::defaultcode="utf8";#utf8
	$::kanjicode="utf8";#utf8
	$::charset="utf-8";#utf8
	if ($::lang eq 'ja') {#euc
		$::defaultcode='euc';	# do not change	#euc		# comment
		if(lc $::charset eq 'utf-8') {#euc
			$::kanjicode='utf8';#euc
		} else {#euc
			$::charset=(#euc
				$::kanjicode eq 'euc' ? 'EUC-JP' :#euc
				$::kanjicode eq 'utf8' ? 'UTF-8' :#euc
				$::kanjicode eq 'sjis' ? 'Shift-JIS' : #euc
				$::kanjicode eq 'jis' ? 'iso-2022-jp' : '')#euc
		}#euc
	# 中国語時の処理										# comment
	} elsif ($::lang eq 'zh') {	# cn is not allow, use zh#euc # comment
		$::defaultcode='gb2312';#euc
		$::charset = 'gb2312' if(lc $::charset ne 'utf-8');#euc
	# 台湾語時の処理										# comment
	} elsif ($::lang eq 'zh-tw') {#euc
		$::defaultcode='big5';#euc
		$::charset = 'big5' if(lc $::charset ne 'utf-8');#euc
	# 韓国語時の処理										# comment
	} elsif ($::lang eq 'ko' || $::lang eq 'kr') {#euc
		$::defaultcode='euc-kr';#euc
		$::charset = 'euc-kr' if(lc $::charset ne 'utf-8');#euc
	# その他												# comment
	} else {#euc
		$::defaultcode='iso-8859-1';#euc
		$::charset = 'iso-8859-1' if(lc $::charset ne 'utf-8');#euc
	}#euc
	# lang.inc.cgiが有効時、言語ごとの修正者情報を代入		# comment
	if($::_exec_plugined{lang} > 0) {
		$::wiki_title=$::wiki_title{$::lang} if($::wiki_title{$::lang} ne '');
		$::modifier=$::modifier{$::lang} if($::modifier{$::lang} ne '');
		$::modifierlink=$::modifierlink{$::lang} if($::modifierlink{$::lang} ne '');
		$::modifier_mail=$::modifier_mail{$::lang} if($::modifier_mail{$::lang} ne '');
		$::meta_keyword=$::meta_keyword{$::lang} if($::meta_keyword{$::lang} ne '');
	}
	# $::modifierlinkが存在しない時、基準URLを代入			# comment
	$::modifierlink=$::basehref if($::modifierlink eq '');
}

1;
__DATA__
# $charset: UTF-8$
sub plugin_lang_setup {
	return(
		ja=>'Wiki国際化プラグイン',
		en=>'International Plugin',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/lang/'
	);
__END__

=head1 NAME

lang.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Plugin corresponding to Wiki internationalization

=head1 DESCRIPTION

It enables it to create wiki according to language.

Automatic detect of HTTP_ACCEPT_LANGUAGE, the language to which priority is given is displayed, and it enables to display the language setup by plugin lang.inc.pl.

=head1 USAGE

rename to lang.inc.cgi

Make that's directory.

 attach.(lang)  example attach.en
 backup.(lang)  example backup.en
 diff.(lang)    example diff.ja
 cache.(lang)   example cache.zh-cn
 counter.(lang) example counter.en-us
 info.(lang)    example info.fr
 wiki.(lang)    example wiki.ja

=head2 pyukiwiki.ini.cgi

=over 4

=item $::lang

Setting default language

ja en fr en-us etc...

=item $::charcode

Unmounting...reserved.

=item $::kanjicode

The kanji code which displays only in the case of Japanese is specified.

 euc sjis utf8

=$::lang_list

The language list to need is specified by space pause.

 $::lang_list="ja en";

=$::write_location=1;

This plugin use location move.

=back

=head1 BUG

It is specification, although the following initialization will be performed twice if this function is used.

 init_lang is called twice.
 Reading of a resource is performed twice (it overwrites).
 A database is closed, and a directory is re-set up and open in a database

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/lang

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/lang/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/lang.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/lang.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
