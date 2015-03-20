######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_skin.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_skin.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_skin.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_skin.cgi>

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

use Nana::ImageSize;

=lang ja

=head2 skinex

=over 4

=item 入力値

&skinex(ページ名, 内容(HTML), ページであるかのフラグ, ページ操作のプラグインであるかのフラグ);

=item 出力

stdoutにHTMLを出力

=item オーバーライド

可

=item 概要

指定したページまたは内容を整形し、出力する。

=back

=cut

sub _skinex {
	my ($pagename, $body, $is_page, $pageplugin) = @_;
	my $bodyclass = "normal";
	my $editable = 0;
	my $admineditable = 0;
	my ($page,$msg)=split(/\t/,$pagename);
	$pageplugin+=0;
	$::pageplugin+=0;

#	if (&is_frozen($page) and ($::form{cmd} =~ /^(read|write)$/ || $pageplugin+$::pageplugin > 0)) { # comment
	if($::form{refer} eq '' && &is_frozen($page) || &is_exist_page($::form{refer}) && &is_frozen($::form{refer})) {
		$admineditable = 1;
		$bodyclass = "frozen";
#	} elsif (&is_editable($page) and ($::form{cmd} =~ /^(read|write)$/ || $pageplugin+$::pageplugin>0)) { # comment
	} elsif($::form{refer} eq '' && &is_editable($page) || &is_exist_page($::form{refer}) && &is_editable($::form{refer})) {

		$admineditable = 1;
		$editable = 1;
		if(!&is_exist_page($page) && $is_page) {
			$page=$pagename=$::FrontPage;
			if($::form{mypreview_cancel} ne '' || $::form{mypreview_blogcancel} ne '') {
				if(&is_exist_page($::form{refer}) && $::form{refer} ne '') {
					$page=$pagename=$::form{refer};
				}
			}
			$body=&text_to_html($::database{$pagename});
			$is_page=1;
			$admineditable=1;
			$editable=&is_frozen($pagename) ? 1 : 0;
		}
	}
	# v0.2.1 add										# comment
	$body.=$::addlasthtml;

	&makenavigator($::form{mypage} ne $page ? $::form{mypage} : $page,$is_page,$editable,$admineditable)
		if($::disable_navigator eq 0);

	# last_modifiedのHTML生成								# comment
	if ($::last_modified != 0) {	# v0.0.9
		$lastmod = &date($::lastmod_format, ($::database{"__update__" . $::form{mypage}}));
	}

	if($::IN_META_ROBOTS eq '') {
		$::IN_HEAD.=&meta_robots($::form{cmd},$pagename,$body);
	} else {
		$::IN_HEAD.=$::IN_META_ROBOTS;
	}

	my $output_mime = $::htmlmode eq "xhtml11"
		&& $ENV{'HTTP_ACCEPT'}=~ m!application/xhtml\+xml!
		&& &is_no_xhtml(1) eq 0
		? 'application/xhtml+xml' : 'text/html';

	$::HTTP_HEADER=&http_header("Content-type: $output_mime; charset=$::charset", $::HTTP_HEADER);

	&escapeoff($::use_escapeoff);

	if(!-r $::skin_file) {
		my $body=<<EOM;
<html><head><title>PyukiWiki Error</title></head>
<body><h1>Skin file not found</h1>
Can't read [$::skin_file]
</body></html>
EOM
		&content_output($::HTTP_HEADER, $body);
		exit;
	}

	require $::skin_file;
	foreach("rss10", "rss20", "atom") {
		$::IN_HEAD.=<<EOM if($::rss_lines>0 && $::IN_HEAD!~/rss\+xml/ && $::rssenable{$_} eq 1);
<link rel="alternate" type="application/rss+xml" title="RSS" href="?cmd=rss&amp;@{[$_ eq "rss10" ? "ver=1.0" : $_ eq "rss20" ? "ver=2.0" : $_ eq "atom" ? "ver=atom" : "ver="]}@{[$_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : ""]}" />
EOM
	}

	my $body=&skin($pagename, $body, $is_page, $bodyclass, $editable, $admineditable, $::basehref,$lastmod);
	$body=&_db($body);

	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body, $::kanjicode);
	}
	&content_output($::HTTP_HEADER, $body);
}

=lang ja

=head2 make_title

=over 4

=item 入力値

&make_title(ページ名, メッセージ);

=item 出力

(タイトル文字, タイトルタグ)

=item オーバーライド

可

=item 概要

タイトルを生成する

=back

=cut

sub _maketitle {
	my($page, $message)=@_;
	my $title;
	my $title_tag;
	my $escapedpage = &htmlspecialchars($page);

	if($::wiki_title ne '') {
		$title="$::wiki_title";
	}

	if($page eq '') {
		if($title eq '') {
			$title_tag="$message";
		} else {
			$title_tag="$message - $title";
		}
	} else {
		if($::IN_TITLE eq '') {
			if($title eq '') {
				$title_tag="$escapedpage";
			} else {
				$title_tag="$escapedpage - $title";
			}
		} else {
			if($::IN_TITLE=~/\t/) {
				$::IN_TITLE=~s/\t//;
				$title_tag="$escapedpage - $::IN_TITLE - $title";
			} else {
				$title_tag="$::IN_TITLE - $title";
			}
		}
	}

	return($title, $title_tag);
}

=lang ja

=head2 convtime

=over 4

=item 入力値

なし

=item 出力

文字列

=item オーバーライド

可

=item 概要

PyukiWikiのHTML変換にかかったCPU時間を返す。

=back

=cut

sub _convtime {
	my $buf;

	if($::enable_last) {
		$buf.="Powered by Perl $]";
		if($::enable_last_os) {
			my $os=ucfirst($^O);
			$os=~s/bsd/BSD/;
			$buf.= " and $os";
		}

		if($::enable_convtime) {
			$buf.=" HTML convert time to ";
			my $convtime;
			eval {
				$convtime=Time::HiRes::tv_interval(
						$::_conv_start_hires,
						[Time::HiRes::gettimeofday]);
			};
			if(!$convtime) {
				$buf.=sprintf("%.3f sec",
					(times)[0] - $::_conv_start);
			} else {
				$buf.=sprintf("%.3f sec.", $convtime);
			}
		}

		if($gzip::header ne '') {
			$buf.=" Compressed";
		}
		return $buf;
	}
}

=lang ja

=head2 skinsubpage

=over 4

=item 入力値

&skinsubpage(ページ名, ...);

=item 出力

上記読み出したページの連想配列

=item オーバーライド

可

=item 概要

スキンが必要なページを読み出す関数

=back

=cut

sub skinsubpage {
	my @pages=@_;
	my %body;
	my $mypage=$::form{mypage};
	foreach my $page(@pages) {
		$::pushedpage=$::form{mypage};
		$::form{mypage}=$page;
		$body{$page}=$::body{$page}
					. &print_content($::database{$page}, $::pushedpage)
			if(&is_exist_page($page));
		$::form{mypage}=$::pushedpage;
	}
	$::pushedpage="";
	$::form{mypage}=$mypage;
	return %body;
}

=lang ja

=head2 cssloader

=over 4

=item 入力値

&cssloader;

=item 出力

$::IN_CSSFILES

=item オーバーライド

可

=item 概要

CSSローダーを定義する

=back

=cut

sub _cssloader {
	my %cssload;
	foreach(@::CSSFILES) {
		my ($file, $sub)=split(/\t/, $_);
		if(!$cssload{$file}++) {
			$::IN_CSSFILES.=<<EOM;
<link rel="stylesheet" href="$::skin_url/$file" type="text/css" $sub charset="$::charset" />
EOM
		}
	}
}

=lang ja

=head2 jsloader

=over 4

=item 入力値

&jsloader;

=item 出力

$::IN_JSLOADER
$::IN_JSLOADMAIN

=item オーバーライド

可

=item 概要

JavaScriptローダーを定義する

=back

=cut

sub _jsloader {
	my $load;
	my $script;

	my $flg=$::jsloader;

	if($ENV{HTTP_USER_AGENT}=~/MSIE\s(\d+)\./) {
		if($1 < 9) {
			if(!$ENV{HTTP_USER_AGENT}=~/Opera/) {
				$flg=0;
			}
		}
	}
	if($flg) {
		$::IN_JSLOADER.=<<EOM;
<script type="text/javascript" src="$::skin_url/loader.js" charset="$::charset"></script>
EOM
		my $jsloader="ld(initfunction,";
		my $first=0;
		for(my $i=$::IN_JSMAX; $i >= 0; $i--) {
			my $jsarray=$::IN_JSARRAY[$i];
			$jsarray=~s/^\t//g;
			next if($jsarray eq "");
			foreach(split(/\t/, $jsarray)) {
				$jsloader.=qq(") . $_ . qq(",);
			}
			$jsloader=~s/\,$//g;
			$jsloader.=',"",';
		}
		$jsloader=~s/\,$//g;
		$jsloader.=");\n";
		$::IN_JSLOADMAIN=$jsloader;
	} else {
		for(my $i=$::IN_JSMAX; $i >= 0; $i--) {
			my $jsarray=$::IN_JSARRAY[$i];
			foreach(split(/\t/, $jsarray)) {
				next if($_ eq "");
				$::IN_JSLOADER.=<<EOM;
<script type="text/javascript" src="$::skin_url/$_" charset="$::charset"></script>
EOM
			}
			$::IN_JSLOADMAIN="window.onload=initfunction;\n";
		}
	}
}

=lang ja

=head2 skin_head

=over 4

=item 入力値

&skin_head(ページ名, HTML);

=item 出力

なし

=item オーバーライド

可

=item 概要

スキンが初期化を完了したら、呼び出される関数

=back

=cut

=lang ja

=head2 skin_head

=over 4

=item 入力値

&skin_head(ページ名, HTML);

=item 出力

なし

=item オーバーライド

可

=item 概要

head内を表示する関数

=back

=cut

sub _skin_head {
	my($page, $body)=@_;
	# add v0.2.1
	&cssloader;
	&jsloader;

	my $tmp;
	$tmp=<<EOM;
@{[$basehref eq '' ? '' : qq(<base href="$basehref" />)]}
@{[$::AntiSpam ne "" || $::modifier_mail eq "" ? '' : qq(<link rev="made" href="mailto:$::modifier_mail" />)]}
<link rel="top" href="$::script" />
<link rel="index" href="$::script?cmd=list" />
@{[$::use_SiteMap eq 1 ? qq(<link rel="contents" href="$::script?cmd=sitemap" />) : '<link rel="contents" href="' . $::script . '?cmd=list" />']}
<link rel="search" href="$::script?cmd=search" />
<link rel="help" href="$::script?$HelpPage" />
<link rel="author" href="$::modifierlink" />@{[$description]}
<meta name="author" content="$::modifier" />
<meta name="copyright" content="$::modifier" />
$::IN_CSSFILES
$::IN_HEAD
EOM

	if($::IN_CSSHEAD) {
		$tmp.=<<EOM;
<style type="text/css"><!--
$::IN_CSSHEAD
//--></style>
EOM
	}

	if(!$::js_lasttag) {
		$tmp.=<<EOM;
$::IN_JSLOADER
<script type="text/javascript"><!--
var pyukiwiki=$::versionnumber;
$::IN_JSLOADMAIN
$::IN_JSHEADVALUE
function initfunction() {
$::IN_JSHEAD
}
//--></script>
EOM
	}
	return $tmp . $body;
}

=lang ja

=head2 skin_last

=over 4

=item 入力値

&skin_last(ページ名, HTML);

=item 出力

なし

=item オーバーライド

可

=item 概要

head内を表示する関数

=back

=cut

sub _skin_last {
	my($page, $body)=@_;
	my $tmp;
	if($::js_lasttag) {
		$tmp=<<EOM;
$::IN_JSLOADER
<script type="text/javascript"><!--
var pyukiwiki=$::versionnumber;
$::IN_JSLOADMAIN
$::IN_JSHEADVALUE
function initfunction() {
$::IN_JSHEAD
}
//--></script>
EOM
	}
	return $tmp . $body;
}

=lang ja

=head2 makenavigator

=over 4

=item 入力値

&makenavigator(ページ名, ページであるかのフラグ, 編集可能フラグ, 管理者編集可能フラグ);

=item 出力

@::navi

=item オーバーライド

可

=item 概要

ナビゲータの文字列、リンク先、画像ファイルを初期化する。

=back

=cut

sub _makenavigator {
	my($pagename,$is_page,$editable,$admineditable)=@_;

	my($page,$message,$errmessage)=split(/\t/,$pagename);
	my $cookedpage = &encode($page);

	# リンクの設定											# comment
	my $refer=&encode($::form{refer} eq '' ? $::form{mypage} : $::form{refer});
	my $mypage=&encode($::form{refer} eq '' ? $page : $::form{refer});

	&makenavigator_sub1("newpage","refer",$mypage);
	if($::form{refer} eq '' || &is_exist_page($::form{refer})) {
		&makenavigator_sub1("edit","mypage",$mypage)
			if($editable);
		if($admineditable) {
			&makenavigator_sub1("adminedit","mypage",$mypage);
			&makenavigator_sub1("diff","mypage",$mypage);
			if($::useBackUp eq 1) {
				&makenavigator_sub1("backup","mypage",$mypage);
			}
			&makenavigator_sub1("attach","mypage",$mypage) if($::file_uploads > 0);
			&makenavigator_sub1("rename","refer",$mypage);
		}
	}
	&makenavigator_sub1("sitemap","refer",$refer)
		if($::use_Sitemap eq 1 && -f "$::plugin_dir/sitemap.inc.pl");
	&makenavigator_sub1("list","refer",$refer);
	&makenavigator_sub1("search","refer",$refer);
	&makenavigator_sub1("recent","refer",$refer);

	&makenavigator_sub2("top",$::FrontPage);
	&makenavigator_sub2("reload",$::form{refer} eq '' ? $page : $::form{refer});
	if($::use_HelpPlugin eq 0) {
		&makenavigator_sub2("help",$::resource{help});
	} else {
		$::resource{helpbutton}=$::resource{help};
		&makenavigator_sub1("help","refer",$refer);
	}
	&makenavigator_sub3("rss10", "rss", "ver=1.0")
		if($::rssenable{rss10} eq 1);
	&makenavigator_sub3("rss20", "rss", "ver=2.0")
		if($::rssenable{rss20} eq 1);
	&makenavigator_sub3("atom", "rss", "ver=atom")
		if($::rssenable{atom} eq 1);
	&makenavigator_sub3("opml")
		if($::rssenable{opml} eq 1);

	# リンクの並び順を設定									# comment
	my @naviindex;
	my $backupnavi="backup" if($::useBackUp);
	if($::naviindex eq 0) {
		@naviindex=(
			"reload","","newpage","edit","adminedit","diff",$backupnavi,"attach","",
			"top","list","sitemap","search","recent","help",
			"rss10","rss20","atom","opml");

	} else {

		if($::useBackUp) {
			@naviindex=(
				"top","","edit","adminedit","diff",$backupnavi,"attach","reload","",
				"newpage","list","sitemap","search","recent","help",
				"rss10","rss20","atom","opml");
		} else {
			@naviindex=(
				"top","","edit","adminedit","diff",$backupnavi,"attach","reload","",
				"newpage","list","sitemap","search","recent","help",
				"rss10","rss20","atom","opml");
		}
	}

	# 追加リンクの設定										# comment
	foreach(@naviindex) {
		foreach my $addnavi(@::addnavi) {
			my($index,$before,$next)=split(/:/,$addnavi);
			push(@::navi,$index) if($_ eq $before && $before ne '');
		}
		push(@::navi,$_) if($::navi{"$_\_url"} ne '' || $::navi{"$_\_html"} ne ''|| $_ eq '');
		foreach my $addnavi(@::addnavi) {
			my($index,$before,$next)=split(/:/,$addnavi);
			push(@::navi,$index) if($_ eq $next && $next ne '');
		}
	}
	# ヘルプを使用しない場合								# comment
	my @navitemp;
	if($::no_HelpLink eq 1) {
		foreach (@::navi) {
			push(@navitemp,$_)
				if($_ ne "help");
		}
		@::navi=@navitemp;
	}
}

sub _makenavigator_sub1 {
	my($t,$r,$p)=@_;
	if($t ne '') {
		if($::navi{$t."_url"} eq '') {
			$::navi{$t."_title"}=$::resource{$t."thispage"};
			$::navi{$t."_title"}=$::resource{$t."button"}
				if($::navi{$t."_title"} eq '');
			$::navi{$t."_url"}="$::script?cmd=$t&amp;$r=$p";
			$::navi{$t."_name"}=$::resource{$t."button"}
				if($t!~/rename/);
			$::navi{$t."_type"}="edit";
		}
	}
}

sub _makenavigator_sub2 {
	my($t,$p)=@_;
	if(    $t eq "top"
		|| $t eq "help" && &is_exist_page($p)
		|| &is_exist_page($p) && (&is_exist_page($::form{refer}) || $::form{refer} eq '')) {
		if($::navi{$t."_url"} eq '') {
			$::navi{$t."_url"}=&make_cookedurl(&encode(@{[
				&is_exist_page($p) ? $p :
				&is_exist_page($::form{refer}) ? $::form{refer} :
				$::FrontPage]}));
			$::navi{$t."_name"}=$::resource{$t};
			$::navi{$t."_type"}="page";
		}
	}
}

sub _makenavigator_sub3 {
	my($t, $r, $arg)=@_;
	if(-f "$::plugin_dir/$t.inc.pl"
	 ||-f "$::plugin_dir/$r.inc.pl") {
		if($::navi{$t."_url"} eq '') {
			if($r eq "") {
				$::navi{"$t\_url"}="$::script?cmd=$t"
					. ($_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : "");
			} else {
				$::navi{"$t\_url"}="$::script?cmd=$r&amp;$arg"
					. ($_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : "");
			}
			$::navi{"$t\_title"}=$::resource{$t . "button"};
			if(-r "$::image_dir/$t.png") {
				($::navi{"$t\_width"}, $::navi{"$t\_height"})
					= Nana::ImageSize::imgsize("$::image_dir/$t.png");
				$::navi{$t."_type"}="rsslink";
			} else {
				$::navi{$t."_type"}="rsslinkspan";
			}
		}
	}
}

=lang ja

=head2 skin_footer

=over 4

=item 入力値

&navi_toolbar;

=item 出力

HTML

=item オーバーライド

可

=item 概要

ナビゲーターのツールバーのHTMLを返す

=back

=cut

sub _navi_toolbar {
	my $body;
	foreach $name (@::navi) {
		if($name eq '') {
			$body.=" &nbsp; ";
		} else {
			if($::toolbar eq 2) {
				$body.=<<EOD;
<a title="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" href="$::navi{"$name\_url"}" class="icntool" id="icn_$name"><span>@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}</span></a>
EOD
			}
		}
	}
	$body;
}

=lang ja

=head2 skin_footer

=over 4

=item 入力値

&skin_footer(埋め込むwiki文書);
ラグ);

=item 出力

HTML

=item オーバーライド

禁止

=item 概要

フッターのCopyrightを設定する。

=back

=cut

sub _skin_footer {
	my ($skinfooterbody)=@_;
	my $htmlbody;
	my $footerbody=<<EOM;
@{[$::wiki_title ne '' ? qq(''[[$::wiki_title>$basehref f]]'' ) : '']}Modified by [[$::modifier>$::modifierlink f]]~
\$skinfooterbody
~
EOM
	my $_lang=$::lang eq "ja" ? "?cmd=lang&amp;lang=ja" : "?cmd=lang&amp;lang=en";

	$footerbody.=<<EOM;
''[[PyukiWiki $::version>http://pyukiwiki.sfjp.jp/$_lang f]]''
Copyright&copy; 2004-2013 by Nekyo, [[PyukiWiki Developers Team>http://pyukiwiki.sfjp.jp/$_lang f]]
EOM
	if(!$::easy_footer) {
		if($::lang eq "ja") {
			$footerbody.=<<EOM;
License is [[GPL>http://sfjp.jp/projects/opensource/wiki/GPLv3_Info f]], [[Artistic>http://www.opensource.jp/artistic/ja/Artistic-ja.html f]]~
EOM
		} else {
			$footerbody.=<<EOM;
License is [[GPL>http://www.gnu.org/licenses/gpl.html f f]], [[Artistic>http://dev.perl.org/licenses/artistic.html f]]~
EOM
		}
		$footerbody.=<<EOM;
Based on "[[YukiWiki>http://www.hyuki.com/yukiwiki/ f]]" 2.1.0 by [[yuki>http://www.hyuki.com/ f]]
and [[PukiWiki>http://pukiwiki.sfjp.jp/ f]] by [[PukiWiki Developers Term>http://pyukiwiki.sfjp.jp/ f]]~
EOM
	}
	$footerbody= &text_to_html($footerbody);
	$footerbody=~s/\$skinfooterbody/$skinfooterbody/;
	$footerbody=~s/(<p>|<\/p>)//g;
	$htmlbody.= $footerbody;
	$htmlbody;
}

1;
