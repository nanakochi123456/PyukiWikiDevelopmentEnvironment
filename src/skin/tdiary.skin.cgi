######################################################################
# @@HEADER1@@
######################################################################
# tdiary ����ơ���wrapper
#
# ����
#
# http://pukiwiki.sfjp.jp/dev/?BugTrack/769
#
# ���������
# http://sf.net/projects/tdiary/files/theme/
#
# �Ȥ���
# ����skin/theme �ʲ��ˡ����ष����300�ե�����Υ�����򥢥åץ��ɤ���
# ����$::skin_name="tdiary"; �ˤ���
# ����$::skin_tdiary_name="���򤷤��ơ���"; �ˤ���
# ����ɬ�פǤ���С�����Ĵ����skin/theme/���򤷤��ơ���.css ����¸���롣
# ����$::skin_tdiary_selector="�ơ���:��̾,�ơ���:��̾";�Ȥ��뤳�Ȥǡ�
#     setting.inc.cgi ��������Ǥ���褦�ˤʤ�
# ����$::skin_tdiary_base �ǡ�tdiary������Υ١����ξ�������Ǥ��ޤ���
# ����$::skin_tdiary_host = 1; �ǳ����ۥ��ƥ��󥰤����Ѥ��ޤ���
######################################################################
# �ʲ��ѹ��ػ�
$tdiary_skin_hostlist=<<EOM;
http://pyukiwiki.sourceforge.jp/tdiary_theme/
EOM
$tdiary_skin_version="current";
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

#	# CSS������
#	my $csscharset=qq( charset="$::charset");
#	if($::use_blosxom eq 1) {
#		&jscss_include("blosxom");
#	}

	# ���֥ڡ������ɤ߹���
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
#			$sidebarbody=$subbody{$::SideBar};
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

	# ���HTML������
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
	# <title>����������
	my($title, $title_tag)=&maketitle($page, $message);

	# changed on v0.2.1 ����
	$description=qq(\n<meta name="description" content="@{[$::IN_TITLE eq '' ? "$title - $escapedpage" : $::IN_TITLE]}" />)
		if($::IN_META_ROBOTS!~/<meta name="description"/);

	$::skin_name{tdiary}=$::skin_selector{tdiary} && $::setting_cookie{tdiarystyle} ? $::setting_cookie{tdiarystyle} : $::skin_name{tdiary} eq "" ? $::skin_tdiary_name : $::skin_name{tdiary};
	$::skin_name{tdiary}=~s/\///g;

	# tdiary�Ѹ���Ĵ��
	if($::skin_name{tdiary}=~/^asterisk/) {
		$::IN_CSSHEAD.=<<EOM;
div.sidebar {
 position:absolute;
 top:100;
 right:100;
 margin-right:80px;
 margin-top: 150px;
}
EOM
	}
	if($::skin_name{tdiary}=~/^90$/) {
		$::IN_CSSHEAD.=<<EOM;
.sidebar {
	position: absolute;
	top: 50px;
	right: 0px;
	width: 150px;
	border-top: solid 1px #606060;
}
EOM
	}
	if($::skin_name{tdiary}=~/aqua/) {
		$::IN_CSSHEAD.=<<EOM;
div.sidebar {
 margin-right:50px;
 margin-top: 130px;
 width:150px;

}
h3 {
  margin-left: 0px;
  margin-right: 0px;
}
div.main {
  margin-right: 200px;
}
EOM
	}

	if($::skin_name{tdiary}=~/^wall/) {
		$::IN_CSSHEAD.=<<EOM;
div.sidebar {
 position:absolute;
 top:100;
 right:100;
 margin-right:10px;
 margin-top: 52px;66
 width:150px;
 border-top: solid 1px #606060;

}
h3 {
  margin-left: 0px;
  margin-right: 0px;
}
div.main {
  margin-right: 200px;
}
EOM
	}

	if($::skin_tdiary_url ne "") {
		$::IN_CSSFILES.=<<EOM;
<link rel="stylesheet" href="$::skin_tdiary_url/$::skin_name{tdiary}/$::skin_name{tdiary}.css" />
<link rel="stylesheet" href="$::skin_tdiary_url/$::skin_name{tdiary}.css" />
EOM
	} else {
		$::skin_base{tdiary}="theme";# if($::skin_base{tdiary} eq "");
		#&jscss_include("$::skin_base{tdiary}/base");
		&jscss_include("$::skin_base{tdiary}/$::skin_name{tdiary}/$::skin_name{tdiary}");
	}
	&jscss_include("$::skin_base{tdiary}/$::skin_name{tdiary}");	# ����Ĵ��

	# HTML <head>���</head> ���顢������󥯤ޤ�
	$htmlbody=<<"EOD";
$::dtd
<title>$title_tag</title>
@{[&skin_head($pagename)]}
</head>
<body class="$bodyclass"$::IN_BODY>
<div id="container">
<div id="head">
<div id="header">
EOD

	# �ʥӥ�������ɽ��
	$htmlbody.=<<EOD;
</div>
<div class="adminmenu">
<div id="navigator">
EOD
	my $flg=0;
	foreach $name (@::navi) {
		if($name eq '') {
#			$htmlbody.=" ] &nbsp; [ " if($flg ne 0);
			$flg=0;
		} else {
			if($::navi{"$name\_html"} ne '') {
#				$htmlbody .= " | " if($flg eq 1 && $name!~/\-nobr/);
				$flg=1;
				$htmlbody.=$::navi{"$name\_html"};
			} elsif($::navi{"$name\_name"} ne '') {
#				$htmlbody .= " | " if($flg eq 1 && $name!~/\-nobr/);
				$flg=1;
				$htmlbody.=<<EOD;
<span class="adminmenu"><a title="@{[$::navi{"$name\_title"} eq '' ? $::navi{"$name\_name"} : $::navi{"$name\_title"}]}" href="$::navi{"$name\_url"}">$::navi{"$name\_name"}</a></span>
EOD
			}
		}
	}
	$htmlbody.=<<EOD;
</div>
</div>
</div>
EOD

	$htmlbody.=<<"EOD" if($titleheaderbody ne "");
<span class="headerbody">$titleheaderbody</span>
EOD

	$htmlbody.=<<"EOD" if($::disable_wiki_title+0 eq 0);
<h1>$::wiki_title</h1>
EOD

	# table���
#	my $colspan=1;
#	$colspan++ if($menubarbody ne '');
#	$colspan++ if($sidebarbody ne '');

#	$htmlbody.= <<"EOD";
#<div id="content">
#<table class="content_table" border="0" cellpadding="0" cellspacing="0">
#@{[$headerbody ne '' ? qq(<tr><td@{[$colspan ne 1 ? qq( colspan="$colspan") : '']}><div id="headerbody">$headerbody</div></td></tr>) : '']}
#  <tr>
#EOD

	# MenuBar��ɽ��
	if($menubarbody ne '') {
		$htmlbody.=<<"EOD";
    <div class="sidebar">
    <div id="menubar">
$menubarbody
    </div>
    </div>
</div>
EOD
	}


	$htmlbody.=<<EOD;
<div class="pkwk_body">
<div class="main">
<hr class="sep" />
<div class="day">
EOD
	# �ڡ��������ȥ롢��å�������ɽ��
	if($errmessage ne '') {
		$htmlbody.=<<EOD;
<h2>$errmessage</h2>
EOD
	} elsif($page ne '') {
		$htmlbody.=<<EOD  if($::disable_wiki_page_title+0 eq 0);
<h2>$escapedpage_short@{[$message eq '' ? '' : "&nbsp;$message"]}</h2>
EOD
	} else {
		$htmlbody.=<<EOD  if($::disable_wiki_page_title+0 eq 0);
<h2>$message</h2>
EOD
	}

	# ����ƥ�Ĥ�ɽ��
	$htmlbody.= <<"EOD";
<div class="body">
@{[$headerbody ne '' ? qq(<div id="headerbody">$headerbody</div>) : '']}
@{[$bodyheaderbody ne '' ?  qq(<div id="bodyheaderbody">$bodyheaderbody</div>\n) : ""]}<div>$body</div>@{[$::notesview eq 0 ? $notesbody : '']}@{[$bodyfooterbody ne '' ? qq(\n<div id="bodyfooterbody">$bodyfooterbody</div>) : ""]}
@{[$footerbody ne '' ? qq(<div id="footerbody">$footerbody</div>) : '']}
</div>

</div>
EOD
	# SideBar��ɽ��
#	if($sidebarbody ne '') {
#		$htmlbody.=<<"EOD";
#    <td class="sidebar" valign="top">
#    <div id="sidebar">
#$sidebarbody
#    </div>
#    </td>
#EOD
#	}

	# ����ɽ��
	$htmlbody.= << "EOD";
@{[$::notesview eq 1 ? qq($notesbody) : '']}
EOD

	# ����ɽ����:Footer�β���
	$htmlbody.=$::notesview eq 2 ? $notesbody : '';

	# ��������lastmodifiedɽ��
	$htmlbody.= <<"EOD";
</div>
<div id="foot">
EOD
	if($::toolbar ne 0) {
		$htmlbody.= <<"EOD";
<div id="toolbar">
&nbsp;@{[&navi_toolbar]}
</div>
EOD
	}

	$htmlbody.=<<EOD;
</div>
@{[ $::last_modified == 2 || 1
 ? qq(
<div class="referer">$::lastmod_prompt $lastmod</div>)
 : qq()
]}
<div class="footer">
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
	return $htmlbody;
}
1;
