######################################################################
# @@HEADER1@@
######################################################################
# Skin.ja:PyukiWiki標準
# Skin.en:PyukiWiki Default
######################################################################

sub skin {
	my ($pagename, $body, $is_page, $bodyclass, $editable, $admineditable, $basehref, $lastmod) = @_;

	my($page,$message,$errmessage)=split(/\t/,$pagename);
	my $cookedpage = &encode($page);
	my $cookedurl=&make_cookedurl($cookedpage);
	my $escapedpage = &htmlspecialchars($page);
	my $escapedpage_short=$escapedpage;
	$escapedpage_short=~s/^.*\///g if($::short_title eq 1);
	my $HelpPage = &encode($::resource{help});
	my $htmlbody;
	my ($title,$headerbody,$menubarbody,$sidebarbody,$footerbody,$notesbody);

	# CSSの設定
	my $csscharset=qq( charset="$::charset");
	if($::use_blosxom eq 1) {
		&jscss_include("blosxom");
	}

	# サブページの読み込み
	my $flg= $::form{cmd}!~/^(ad|admin|adminchangepassword|compressbackup|deletecache|edit|freezeconvert|listfrozen|logs\_viewer|server)/ ? 1 : 0;

	my ($menubarbody, $headerbody, $sidebarbody);
	my ($bodyheaderbody, $bodyfooterbody);
	my ($footerbody, $titleheaderbody, $skinfooterbody);

	my %subbody=&skinsubpage(
		$::MenuBar, $::Header, $::SideBar, $::BodyHeader, $::BodyFooter,
		$::TitleHeader, $::Footer, $::SkinFooter);

	if($is_page || $::allview eq 1) {
		$menubarbody=$subbody{$::MenuBar};
		if($flg) {
			$headerbody=$subbody{$::Header};
			$sidebarbody=$subbody{$::SideBar};
			$bodyheaderbody=$subbody{$::BodyHeader};
			$bodyfooterbody=$subbody{$::BodyFooter};
			$footerbody=$subbody{$::Footer};
		}
	}
	# :TitleHeader
	if($flg) {
		$titleheaderbody=$subbody{$::TitleHeader};
	}
	$skinfooterbody=$subbody{$::SkinFooter};

	# 注釈HTMLの生成
	if (@::notes) {
		$notesbody.= << "EOD";
<div id="note">
<hr class="note_hr" />
EOD
		my $cnt = 1;
		foreach my $note (@::notes) {
			$notesbody.= << "EOD";
<a id="notefoot_$cnt" href="@{[&make_cookedurl($::form{mypage})]}#notetext_$cnt" class="note_super">*$cnt</a>
@{[$::notesview ne 0 ? qq(<span class="small">) : '']}@{[$note]}@{[$::notesview ne 0 ? qq(</span>) : '']}
<br />
EOD
			$cnt++;
		}
		$notesbody.="</div>\n";
	}

	# changed on v0.2.0 moved on v0.2.0-p2
	# <title>タグの生成
	my($title, $title_tag)=&maketitle($page, $message);

	# changed on v0.2.1 説明
	$description=qq(\n<meta name="description" content="@{[$::IN_TITLE eq '' ? "$title - $escapedpage" : $::IN_TITLE]}" />)
		if($::IN_META_ROBOTS!~/<meta name="description"/);

	# HTML <head>〜</head> から、画像リンクまで
	$htmlbody=<<"EOD";
$::dtd
<title>$title_tag</title>
@{[&skin_head($pagename)]}
</head>
<body class="$bodyclass"$::IN_BODY>
<div id="container">
<div id="head">
<div id="header">
<a href="$::modifierlink"><img id="logo" src="$::logo_url" width="$::logo_width" height="$::logo_height" alt="$::logo_alt" title="$::logo_alt" /></a>
EOD

	# ページタイトル、メッセージの表示
	if($errmessage ne '') {
		$htmlbody.=<<EOD;
<h1 class="error">$errmessage</h1>
EOD
	} elsif($page ne '') {
		$htmlbody.=<<EOD;
@{[$titleheaderbody ne '' ? '<table><tr><td class="headermain">' : '']}
<h1 class="title"><a
    title="$::resource{searchthispage}"
    href="$::script?cmd=search&amp;mymsg=$cookedpage">$escapedpage_short</a>@{[$message eq '' ? '' : "&nbsp;$message"]}</h1>
<span class="small">@{[&topicpath($page)]}</span>
@{[$titleheaderbody ne '' ? '</td><td class="headerbody">' . $titleheaderbody . '</td></tr></table>' : '']}
EOD
	} else {
		$htmlbody.=<<EOD;
@{[$titleheaderbody ne '' ? '<table><tr><td class="headermain">' : '']}
<h1 class="title">$message</h1>
@{[$titleheaderbody ne '' ? '</td><td class="headerbody">' . $titleheaderbody . '</td></tr></table>' : '']}
EOD
	}

	# ナビゲータの表示
	$htmlbody.=<<EOD;
</div>
<div id="navigator">[
EOD
	my $flg=0;
	foreach $name (@::navi) {
		if($name eq '') {
			$htmlbody.=" ] &nbsp; [ " if($flg ne 0);
			$flg=0;
		} else {
			if($::navi{"$name\_html"} ne '') {
				$htmlbody .= " | " if($flg eq 1 && $name!~/\-nobr/);
				$flg=1;
				$htmlbody.=$::navi{"$name\_html"};
			} elsif($::navi{"$name\_name"} ne '') {
				$htmlbody .= " | " if($flg eq 1 && $name!~/\-nobr/);
				$flg=1;
				$htmlbody.=<<EOD;
<a title="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" href="$::navi{"$name\_url"}">$::navi{"$name\_name"}</a>
EOD
			}
		}
	}
	$htmlbody.=<<EOD;
]
</div>
<hr class="full_hr" />
@{[ $::last_modified == 1
  ? qq(<div id="lastmodified">$::lastmod_prompt $lastmod</div>)
  : q()
]}
</div>
EOD

	# table定義
	my $colspan=1;
	$colspan++ if($menubarbody ne '');
	$colspan++ if($sidebarbody ne '');

	$htmlbody.= <<"EOD";
<div id="content">
<table class="content_table" border="0" cellpadding="0" cellspacing="0">
@{[$headerbody ne '' ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}><div id="headerbody">$headerbody</div></td></tr>) : '']}
  <tr>
EOD

	# MenuBarの表示
	if($menubarbody ne '') {
		$htmlbody.=<<"EOD";
    <td class="menubar" valign="top">
    <div id="menubar">
$menubarbody
    </div>
    </td>
EOD
	}

	# コンテンツの表示
	$htmlbody.= <<"EOD";
    <td class="body" valign="top">
      @{[$bodyheaderbody ne '' ?  qq(<div id="bodyheaderbody">$bodyheaderbody</div>\n) : ""]}<div id="body">$body</div>@{[$::notesview eq 0 ? $notesbody : '']}@{[$bodyfooterbody ne '' ? qq(\n<div id="bodyfooterbody">$bodyfooterbody</div>) : ""]}
    </td>
EOD
	# SideBarの表示
	if($sidebarbody ne '') {
		$htmlbody.=<<"EOD";
    <td class="sidebar" valign="top">
    <div id="sidebar">
$sidebarbody
    </div>
    </td>
EOD
	}

	# 下の表示
	$htmlbody.= << "EOD";
  </tr>
@{[$::notesview eq 1 ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}>$notesbody</td></tr>) : '']}
@{[$footerbody ne '' ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}><div id="footerbody">$footerbody</div></td></tr>) : '']}
</table>
EOD

	# 注釈の表示（:Footerの下）
	$htmlbody.=$::notesview eq 2 ? $notesbody : '';

	# アイコン、lastmodified表示
	$htmlbody.= <<"EOD";
</div>
<div id="foot">
<hr class="full_hr" />
EOD
	if($::toolbar ne 0) {
		$htmlbody.= <<"EOD";
<div id="toolbar">
&nbsp;@{[&navi_toolbar]}
</div>
EOD
	}
	$htmlbody.=<<EOD;
@{[ $::last_modified == 2
 ? qq(<div id="lastmodified">$::lastmod_prompt $lastmod</div>)
 : qq()
]}
<div id="footer">
@{[&skin_footer($skinfooterbody)]}
@{[&convtime]}
</div>
</div>
</div>
@{[&skin_last($pagename)]}
</body>
</html>
EOD
	$htmlbody=~s/\&copy\;/\(C\)/g if($::skin_name eq "mikachan");
	return $htmlbody;
}
1;
