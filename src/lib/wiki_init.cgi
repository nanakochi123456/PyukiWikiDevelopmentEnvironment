######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_init.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_init.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_init.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_init.cgi>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut

=lang ja

=head1 FUNCTIONS

=head2 writablecheck

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

不可

=item 概要

書き込み可能かチェックする関数

=back

=cut

sub _writablecheck {
	my $err;
	$err.=&writechk($::data_dir);
	$err.=&writechk($::diff_dir);
	$err.=&writechk($::cache_dir);
	$err.=&writechk($::counter_dir);
	$err.=&writechk($::backup_dir);#nocompact
	$err.=&writechk($::upload_dir);
	&print_error($err) if($err ne '');
}

=lang ja

=head1 FUNCTIONS

=head2 writechk

=over 4

=item 入力値

ディレクトリ

=item 出力

エラーメッセージ

=item オーバーライド

不可

=item 概要

書き込み可能かチェックするメインの関数

=back

=cut

sub _writechk {
	my($dir)=shift;
	return "Directory is not found or not writable ($dir)<br />\n"
		if(!-w $dir);
	return '';
}


=lang ja

=head2 init_global

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

不可

=item 概要

speedy_cgiで実行可能にするため等の初期化。

ただし、現在speedy_cgiでの動作はサポートされていない。

=back

=cut

	# 2005.10.27 pochi: speedy_cgiで実行可能に				# comment

sub _init_global {
	&close_db;
	%::form = ();
	%::database = ();
	%::infobase = ();
	%::diffbase = ();
	%::interwiki = ();
	%::_resource_loaded = ();
	$lastmod = "";
	%::_plugined = ();
	$::pageplugin=0;
	%::_exec_plugined=();
	%::_exec_plugined_func=();
	%::_exec_plugined_value=();
	%::_module_loaded=();
	# 0〜255のテーブル生成
	foreach my $i (0x00 .. 0xFF) {
		$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
		$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
		$::_dbmname_decode{sprintf('%02X', $i)} = chr($i);
	}
	$::_urlescape{chr(32)} ='+';
}

=lang ja

=head2 init_lang

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

言語の初期化をする。

=back

=cut

sub _init_lang {
	$::defaultcode="utf8";#utf8
	$::charset="utf-8";#utf8
	$::kanjicode="utf8";#utf8

	if ($::lang eq 'ja') {#euc
		$::defaultcode='euc';	# do not change#euc
		if(lc $::charset eq 'utf-8') {#euc
			$::kanjicode='utf8';#euc
		} else {#euc
			$::charset=(#euc
				$::kanjicode eq 'euc' ? 'EUC-JP' :#euc
				$::kanjicode eq 'utf8' ? 'UTF-8' :#euc
				$::kanjicode eq 'sjis' ? 'Shift-JIS' :#euc 
				$::kanjicode eq 'jis' ? 'iso-2022-jp' : '')#euc
		}#euc
	# 中国語時の処理	#euc								# comment
	} elsif ($::lang eq 'zh') {	# cn is not allow, use zh	#euc	# comment
		$::defaultcode='gb2312';	#euc
		$::charset = 'gb2312' if(lc $::charset ne 'utf-8');#euc
	# 台湾語時の処理	#euc								# comment
	} elsif ($::lang eq 'zh-tw') {#euc
		$::defaultcode='big5';#euc
		$::charset = 'big5' if(lc $::charset ne 'utf-8');#euc
	# 韓国語時の処理	#euc								# comment
	} elsif ($::lang eq 'ko' || $::lang eq 'kr') {#euc
		$::defaultcode='euc-kr';#euc
		$::charset = 'euc-kr' if(lc $::charset ne 'utf-8');#euc
	# その他			#euc								# comment
	} else {#euc
		$::defaultcode='iso-8859-1';#euc
		$::charset = 'iso-8859-1' if(lc $::charset ne 'utf-8');#euc
	}#euc
	# $::modifierlinkが存在しない時、基準URLを代入			# comment
	$::modifierlink=$::basehref if($::modifierlink eq '');}

=lang ja

=head2 init_form

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

フォームを初期化する。

=back

=cut

sub _init_form {
	if ($qCGI->param()) {
		foreach my $var ($qCGI->param()) {
			$::form{$var} = $qCGI->param($var);
		}
	} else {
		$ENV{QUERY_STRING} = $::FrontPage;
	}

	# Thanks Mr.koizumi. v0.1.4							# comment
	my $query = $ENV{QUERY_STRING};
	if ($query =~ /&/) {
		my @querys = split(/&/, $query);
		foreach (@querys) {
			$_ = &decode($_);
			$::form{$1} = $2 if (/([^=]*)=(.*)$/);
		}
	} else {
		$query = &decode($query);
	}

	if (&is_exist_page($query)) {
		$::form{cmd} = 'read';
		$::form{mypage} = $query;
	}
	# mypreview_edit			-> do_edit, with preview.			# comment
	# mypreview_adminedit		-> do_adminedit, with preview.		# comment
	# mypreview_write			-> do_write, without preview.		# comment
	# mypreview_blogedit		-> do_edit, with preview.			# comment
	# mypreview_blogadminedit	-> do_adminedit, with preview.		# comment
	# mypreview_blogwrite		-> do_write, without preview.		# comment

	# mypreviewjs_edit			-> do_edit, with preview.			# comment
	# mypreviewjs_adminedit		-> do_adminedit, with preview.		# comment
	# mypreviewjs_write			-> do_write, without preview.		# comment
	# mypreviewjs_blogedit		-> do_edit, with preview.			# comment
	# mypreviewjs_blogadminedit	-> do_adminedit, with preview.		# comment
	# mypreviewjs_blogwrite		-> do_write, without preview.		# comment

	foreach (keys %::form) {
		if (/^mypreview_blog(.*)$/ || /^mypreviewjs_blog(.*)$/) {
			if($::form{$_} ne '') {
				$::form{cmd} = "blog";
				$::form{mode} = $1;
				$::form{mypreview} = 1;
			}
		} elsif (/^mypreview_(.*)$/ || /^mypreviewjs_(.*)$/) {
			if($::form{$_} ne '') {
				$::form{cmd} = $1;
				$::form{mypreview} = 1;
			}
		}	
	}

	foreach("mymsg", "word", "myname", "mypage", "page"
		  , "refer", "under", "template") {
		$::form{$_} = &code_convert(\$::form{$_}, $::defaultcode,$::kanjicode)
			if($::form{$_});
	}
}

=lang ja

=head2 gzip_init

=over 4

=item 入力値

なし

=item 出力

$::gzip_header

=item オーバーライド

不可

=item 概要

gzip圧縮標準モジュール

=back

=cut

$::gzip_exec;

sub _gzip_init {
	$::gzip_exec=1;
	# force init setting.inc.cgi
	&exec_explugin_sub("setting")  if($::useExPlugin > 0);

	if($::setting_cookie{gzip} ne '') {
		$::gzip_exec=0 if($::setting_cookie{gzip}+0 eq 0);
	}

	if($::gzip_exec eq 1) {
		&load_module("Nana::HTTPCompress");
		$::HTTP_HEADER.=Nana::HTTPCompress::init($::gzip_path);
	}
}

=lang ja

=head2 skin_init

=over 4

=item 入力値

なし

=item 出力

$::skin_file, 
$::skin{default_css}, 
$::skin{print_css}, 
$::skin{common_js}, 

=item オーバーライド

不可

=item 概要

スキンファイルの存在をチェックし、skin.cgiへの初期値をセットする。

=back

=cut

sub _skin_init {
	$::skin_file="$::skin_dir/" . &skin_check("$::skin_name.skin%s.cgi",".$::lang","");
	$::skin{default_css}=&skin_check("$::skin_name.default%s.css",".$::lang","");
	$::skin{print_css}=&skin_check("$::skin_name.print%s.css",".$::lang","");
	$::skin{common_js}=&skin_check("common%s.js",".unicode.$::lang",".$::kanjicode.$::lang",".$::lang");

	$::IN_CSSFILES.=<<EOM;
<link rel="stylesheet" href="$::skin_url/$::skin{default_css}" type="text/css" media="screen" charset="$::charset" />
<link rel="stylesheet" href="$::skin_url/$::skin{print_css}" type="text/css" media="print" charset="$::charset" />
EOM
	my $common=$::skin{common_js};
	$common=~s/\.js$//g;
	&jscss_include($common);
	$::IN_JSFILES=~s/^,//g;
#	$::IN_JSFILES.='"' . "6,$::skin_url/$::skin{common_js}" . '"'
#		if($::IN_JSFILES eq "");
}

=lang ja

=head2 skin_check

=over 4

=item 入力値

&skin_check(filename of sprintf format, lists...);

=item 出力

なし

=item オーバーライド

可

=item 概要

スキンで必要なファイルが存在するかチェックする。

=back

=cut

sub _skin_check {
	my($fmt)=shift;
	my(@arg)=@_;
	foreach(@arg) {
		my $f=sprintf($fmt,$_);
		next if($f eq '');
		return $f if(-r "$::skin_dir/$f");
	}
#	$::debug.="skin_check: $::skin_dir/$fmt not found\n";	# debug
	return '';
}

=lang ja

=head2 init_InterWikiName

=over 4

=item 入力値

なし

=item 出力

%::interwiki, %::interwiki2

=item オーバーライド

可

=item 概要

InterWikiの初期化をする。

書式は以下のとおり

[[YukiWiki http://www.hyuki.com/yukiwiki/wiki.cgi?euc($1)]]

[http://www.hyuki.com/yukiwiki/wiki.cgi?$1 YukiWiki] euc

=back

=cut

sub _init_InterWikiName {
	my $content = $::database{$InterWikiName};
	while ($content =~ /$interwiki_definition/g) {
		my ($name, $url) = ($1, $2);
		#v0.1.6												# comment
		$name=~tr/A-Z/a-z/;
		$::interwiki{$name} = $url;
	}
	while ($content =~ /$interwiki_definition2/g) {
		#v0.1.6												# comment
		my ($url,$name,$code)=($1,$2,$3);
		$name=~tr/A-Z/a-z/;
		$::interwiki2{$name}{$code} = $url;
	}
}

=lang ja

=head2 init_inline_regex

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

インラインでリンクするための正規表現を生成する。

=back

=cut

sub _init_inline_regex {
	$::inline_regex =qq(($::bracket_name)|($::embedded_inline));
	$::inline_regex.=qq(|($::isurl))				# Direct URL	# comment
		if($::autourllink eq 1);
	$::inline_regex.=qq(|(mailto:$::ismail)|($::ismail))# Mail			# comment
		if($::automaillink eq 1);
	$::inline_regex.=qq(|($::wiki_name)) # LocalLinkLikeThis (WikiName) # comment
		if($::nowikiname ne 1);
}

=lang ja

=head2 init_follow

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

followタグを初期化する。

=back

=cut

sub _init_follow {
	if($::follow eq 2) {
		$::followtag_pub=qq( rel="follow");
	} elsif($::follow eq 0) {
		$::followtag_pub=qq( rel="nofollow");
	} else {
		$::followtag_pub=qq( rel="follow");
	}
}

=lang ja

=head2 init_recovery

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

自働リカバリー

=back

=cut

sub init_recovery {
	return if($::auto_recovery eq 0);
	return if($::form{mypage} eq $::FrontPage);
	return if($::FrontPage ne "FrontPage");
	return if($::database{$::FrontPage} ne "");
	return if($::form{cmd} ne "");
	$::form{cmd} = "recovery";
	$::form{all} = 1;
}

1;
