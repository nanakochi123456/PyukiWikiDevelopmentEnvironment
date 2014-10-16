######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;
use Nana::Cache;

sub plugin_edit_action {
	my ($page) = &unarmor_name(&armor_name($::form{mypage}));
	my $body;
	my $under;

	if($::form{autosave} ne "") {
		my $cache=new Nana::Cache (
			ext=>"editbackup",
			files=>100,
			dir=>$::cache_dir,
			size=>100000,
			use=>1,
			expire=>86400,
		);

		my $cachefile = &dbmname($::form{autosave});
		my $buf=$::form{mymsg};
		$buf=~s/\f1/&/g;
		$buf=~s/\f2/;/g;
		$buf=~s/\f3//g;
		$buf=~s/\f4/\n/g;

		$cache->write($cachefile,$buf);
		print &http_header("Content-type: text/html");
		print $::form{mymsg};
		exit;
	}

	if($::form{under}) {
		$under=&unarmor_name($::form{under});
		$page="$under/" . &unarmor_name(&armor_name($::form{mypage}));
		$::form{mypage}=$page;
		$::form{refer}=$under;
	}
	if($page=~/\[\[\]\]/) {
		$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
	} elsif (not &is_editable($page)) {
		$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
	} elsif (&is_frozen($page)) {
		$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
	} else {
		# 2005.11.2 pochi: �����ҏW���\��						# comment
		my $pagemsg;
		if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
			my $mymsg = (&read_by_part($page))[$::form{mypart} - 1];
			$pagemsg = \$mymsg;
		} else {
			# original
			$pagemsg = \$::database{$page};
		}
		# }
		$body .= &plugin_edit_editform($$pagemsg,
			&get_info($page, $::info_ConflictChecker), admin=>0);
	}
	return ('msg'=>"$page\t$::resource{edit_plugin_title}", 'body'=>$body,'ispage'=>1);
}

my %auth;

sub plugin_edit_editform {
	my ($mymsg, $conflictchecker, %mode) = @_;
	my $frozen = &is_frozen($::form{mypage});
	my $body = '';

	# 0.2.0-p3 split to edit_extend.inc.pl					# comment
	if ($::extend_edit && -f "$::plugin_dir/edit_extend.inc.pl") {
		require "$::plugin_dir/edit_extend.inc.pl";
		&plugin_edit_extend_edit_init;
	} else {
		$::extend_edit=0;
	}

	my $edit = $mode{admin} ? 'adminedit' : 'edit';
	$edit = $mode{blog} && $::newpage_auth eq 1 ? 'adminedit' : $edit;

	if($edit eq 'adminedit' || $mode{blog} && $::newpage_auth eq 1) {
		&load_wiki_module("auth");
		%auth=&authadminpassword("input",$::resource{admin_passwd_prompt_msg},"frozen");
	}
	if($::pukilike_edit > 1 && $::form{template} ne '') {
		$::form{mymsg}=&plugin_edit_editform_loadtemplate;
	}

	my $helplink=$::resource{$::form{mymsg} eq '' ? "edit_plugin_helplink" : "edit_plugin_helplink2"};
	if ($::form{mypreview}) {
		if ($::form{mymsg}) {
			unless ($mode{conflict}) {
				$body .= qq(<h3>$::resource{edit_plugin_previewtitle}</h3>\n);
				if($::edit_afterpreview eq 0) {
					$body .= qq($::resource{edit_plugin_previewnotice}\n);
					$body .= qq(<div class="preview">\n);
					$body .= &text_to_html($::form{mymsg}, toc=>1);
					$body .= qq(<hr class="full_hr" />);
				} else {
					$body .= qq($::resource{edit_plugin_previewnotice2}\n);
				}
#				$body .= qq(</div>\n);						# comment
			}
		} else {
			$body .= qq($::resource{edit_plugin_previewempty});
		}
		$mymsg = $::form{mymsg};
	} elsif($::form{plugined} eq 1) {
		$mymsg = $::form{mymsg} . "\n";
	} elsif($mymsg eq '') {
		if($::form{mymsg} eq '' && $::new_refer ne '' && $::form{refer} ne '') {
			$mymsg =$::new_refer;
			$mymsg =~s/\$1/$::form{refer}/g;
			$mymsg = &htmlspecialchars($mymsg);
		} else {
			$mymsg = &htmlspecialchars($mymsg);
		}
	}
	my $escapedmypage = &htmlspecialchars($::form{mypage});

	$body.=$::pukilike_edit >0
		? &plugin_edit_editform_pukilike(
			$mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,
			$edit eq 'adminedit' || $::newpage_auth eq 1 ? $auth{crypt} : 0,%mode)
		: &plugin_edit_editform_pyukiwiki(
			$mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,
			$edit eq 'adminedit' || $::newpage_auth eq 1 ? $auth{crypt} : 0,%mode);

	unless ($mode{conflict}) {
		if(&is_exist_page($::resource{rulepage})) {
			if($::pukilike_edit >0 && $::form{help} ne 'true' || $::form{mypreview} ne '') {
				$body.=<<EOM;
<ul>
<li>
<a title="$helplink" href="$::script?cmd=$::form{cmd}&amp;mypage=@{[&encode($::form{mypage})]}&amp;refer=@{[&encode($::form{refer})]}&amp;help=true">$helplink</a>
</li>
</ul>
EOM
			} else {
				if($::form{mypreview} eq '') {
					$body.=qq(<hr class="full_hr" />\n);
					$body .= &text_to_html($::database{$::resource{rulepage}}, toc=>0);
				}
			}
		}
	}

	if ($::form{mypreview} && $::edit_afterpreview eq 1) {
		if ($::form{mymsg}) {
			unless ($mode{conflict}) {
				$body .= qq(<hr class="full_hr" />);
				$body .= &text_to_html($::form{mymsg}, toc=>1);
			}
		}
	}
	return $body;
}

sub plugin_edit_editform_pukilike {
	my($mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,$crypt,%mode)=@_;
	my $loadlist;
	if(($::pukilike_edit eq 3 && $::form{template} eq '' && $::form{refercmd} eq 'new')
	 ||($::pukilike_edit eq 2 && $::form{template} eq '' )) {
		$loadlist=&plugin_edit_editform_loadlist($edit);
	}

	# 2005.11.2 pochi: �����ҏW���\��							# comment
	my $partfield = '';
	if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
		$partfield = qq(<input type="hidden" name="mypart" value="$::form{mypart}">);
	}

	# changed 0.2.0 Javascript crypt password					# comment
	# changed 0.2.0-p3 support blog								# comment
	my $category_array;
	if($mode{category} ne '') {
		$category_array=<<EOM;
<select name="selcategory" onchange="addcategory()">
<option value="">$::resource{blog_plugin_error_msg_selcategory}</option>
EOM
		foreach(split(/\t/,$mode{category})) {
			$category_array.=<<EOM;
<option value="$_">$_</option>
EOM
		}
		$category_array.=<<EOM;
</select>
EOM
	}
	my $blog=$mode{blog} ? "blog_" : "";
	my $captcha_form;
	eval {
		$captcha_form=&plugin_captcha_form;
	};

  $::IN_JSHEAD.=<<EOM;
	sins(gid("submitbutton"), editbutton(
"hidden", "mypreviewjs_$blog$edit",
"hidden", "mypreviewjs_@{[$blog]}write",
"hidden", "mypreviewjs_@{[$blog]}cancel",
"button", "mypreviewjs_button_$edit", "$::resource{edit_plugin_previewbutton}", 0,
"button", "mypreviewjs_button_write", "@{[$::resource{edit_plugin_pukiwikisavebutton} eq '' ? $::resource{edit_plugin_savebutton} : $::resource{edit_plugin_pukiwikisavebutton}]}", 1,
"checkbox", "mytouchjs", "on", '@{[&mytouchcheck]}', "$::resource{edit_plugin_touch}",
"button", "mypreviewjs_button_cancel", "$::resource{edit_plugin_cancelbutton}", 2
));
EOM

	my $body = <<"EOD";
<div class="editform">
<form action="$::script" method="post" id="editform" name="editform">
  @{[$mode{admin} || $mode{blog} && $::newpage_auth ? "$auth{html}<br />" : ""]}
  <input type="hidden" name="myConflictChecker" value="$conflictchecker" />
  <input type="hidden" name="mypage" value="$escapedmypage" />
  <input type="hidden" name="refer" value="$::form{refer}" />
  <input type="hidden" name="refercmd" value="$edit" />
  @{[$mode{blog} ? qq($::resource{blog_plugin_input_subject} : <input class="editform" name="subject" value="" size="$blog::subjectcols" /><br />) : ""]}
  @{[$mode{blog} ? qq($::resource{blog_plugin_input_category} : <input class="editform" name="category" value="" size="$blog::categorycols" /> $category_array ) : ""]}
  @{[$mode{blog} ? qq(<input class="editform" type="hidden" name="basepage" value="$::form{basepage}" />) : ""]}
  @{[$mode{blog} ? qq(<input class="editform" type="hidden" name="catepage" value="$::form{catepage}" />) : ""]}
  @{[$::extend_edit ? &plugin_edit_extend_edit : ""]}
  $partfield
  $loadlist
  <textarea cols="$::cols" rows="$::rows" name="mymsg" id="mymsg">@{[&plugin_edit_crlfconv(&htmlspecialchars($mymsg,1))]}</textarea><br />
$captcha_form
@{[
  $mode{admin} ?
  qq(
  <input class="editformcheck" type="radio" name="myfrozen" value="1"@{[$frozen ? qq( checked="checked") : ""]} />$::resource{edit_plugin_frozenbutton}
  <input class="editformcheck" type="radio" name="myfrozen" value="0"@{[$frozen ? "" : qq( checked="checked")]} />$::resource{edit_plugin_notfrozenbutton}<br />)
  : ""
]}
@{[
  $mode{conflict} ? "" :
#  $crypt ?
  1 ?
  qq(
    <span id="submitbutton"></span>
  <noscript>
    <input class="editformbutton" type="submit" name="mypreview_$blog$edit" value="$::resource{edit_plugin_previewbutton}" />
    <input class="editformbutton" type="submit" name="mypreview_@{[$blog]}write" value="@{[$::resource{edit_plugin_pukiwikisavebutton} eq '' ? $::resource{edit_plugin_savebutton} : $::resource{edit_plugin_pukiwikisavebutton}]}" />
    <input class="editformcheck" type="checkbox" name="mytouch" id="mytouch" value="on"@{[&mytouchcheck]} />$::resource{edit_plugin_touch}
    <input class="editformbutton" type="submit" name="mypreview_@{[$blog]}cancel" value="$::resource{edit_plugin_cancelbutton}" />
  </noscript>
  ) :
  qq(
    <input class="editformbutton" type="submit" name="mypreview_$blog$edit" value="$::resource{edit_plugin_previewbutton}" />
    <input class="editformbutton" type="submit" name="mypreview_@{[$blog]}write" value="@{[$::resource{edit_plugin_pukiwikisavebutton} eq '' ? $::resource{edit_plugin_savebutton} : $::resource{edit_plugin_pukiwikisavebutton}]}" />
    <input class="editformcheck" type="checkbox" name="mytouch" id="mytouch" value="on"@{[&mytouchcheck]} />$::resource{edit_plugin_touch}
    <input class="editformbutton" type="submit" name="mypreview_@{[$blog]}cancel" value="$::resource{edit_plugin_cancelbutton}" />
  )
]}
</form>
</div>
EOD
	return $body;
}

sub mytouchcheck {
	my $ret=' checked="checked"';

	if($ENV{REQUEST_METHOD} eq "POST") {
		if(defined($::form{mytouchjs})) {
			return $ret if($::form{mytouchjs} eq "on");
		} elsif($::form{mytouch} eq "on") {
			return $ret;
		}
		return '';
	}
	return $ret;
}

sub plugin_edit_editform_loadtemplate {
	if(&is_readable($::form{template})) {
		return $::database{$::form{template}};
	}
	$::form{template}="";
	return '';
}

sub plugin_edit_editform_loadlist {
	my($edit)=@_;
	my @ALLLIST=();
	my @loadlist=();
	my $loadlist;
	# �S�y�[�W����x�X�^�b�N								# comment
	foreach my $pages (keys %::database) {
		push(@ALLLIST,$pages) if($pages!~/$::non_list/ && &is_readable($pages));
	}
	@ALLLIST=sort @ALLLIST;
	# ���̃y�[�W�̏�w��D��ɂ��邽�߂̏���				# comment
	if($::form{refer} ne '') {
		my $refpage="/$::form{refer}";	# �Ӑ}�I�ɐ擪�ɃX���b�V��������
		while($refpage=~/\//) {
			my $pushpage=$refpage;
			$pushpage=~s/^\///g;
			if(&is_exist_page($pushpage)) {
				my $exist=0;
				foreach(@loadlist) {
					$exist=1 if($pushpage eq $_);
				}
				push(@loadlist,$pushpage) if($exist eq 0 && &is_readable($pushpage));
			}
			$refpage=~s/\/[^\/]+$//g;
		}
	}
	$loadlist=<<EOM;
<select name="template">
<option value="" selected="selected">$::resource{edit_plugin_template}</option>
EOM
	# ��w���X�g�̍쐬										# comment
	foreach(@loadlist) {
		$loadlist.=qq(<option value="$_">$_</option>\n);
	}
	foreach my $all(@ALLLIST) {
		my $exist=0;
		foreach(@loadlist) {
			$exist=1 if($all eq $_);
		}
		if($exist eq 0) {
			$loadlist.=qq(<option value="$all">$all</option>\n);
		}
	}
	$loadlist.=<<EOM;
</select>
<input type="hidden" name="mytouch" value="on" />
<input class="editformbutton" type="submit" name="mypreview_$edit" value="$::resource{edit_plugin_load}" />
<br />
EOM
	return $loadlist;
}

sub plugin_edit_editform_pyukiwiki {
	my($mymsg,$conflictchecker,$escapedmypage,$frozen,$edit,$crypt,%mode)=@_;
	# 2005.11.2 pochi: �����ҏW���\��						# comment
	my $partfield = '';
	if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
		$partfield = qq(<input type="hidden" name="mypart" value="$::form{mypart}" />);
	}

	# changed 0.2.0 Javascript crypt password					# comment
	# changed 0.2.0-p3 support blog								# comment
	my $category_array;
	if($mode{category} ne '') {
		$category_array=<<EOM;
<select name="selcategory" onchange="addcategory()">
<option value="">$::resource{blog_plugin_error_msg_selcategory}</option>
EOM
		foreach(split(/\t/,$mode{category})) {
			$category_array.=<<EOM;
<option value="$_">$_</option>
EOM
		}
		$category_array.=<<EOM;
</select>
EOM
	}
	my $blog=$mode{blog} ? "blog_" : "";
	my $captcha_form;
	eval {
		$captcha_form=&plugin_captcha_form;
	};
	my $body= <<"EOD";
<div class="editform">
<form action="$::script" method="post" id="editform" name="editform">
  @{[$mode{admin} || $mode{blog} && $::newpage_auth ? "$auth{html}<br />" : ""]}
  <input type="hidden" name="myConflictChecker" value="$conflictchecker" />
  <input type="hidden" name="mypage" value="$escapedmypage" />
  <input type="hidden" name="refer" value="$::form{refer}" />
  <input type="hidden" name="refercmd" value="$edit" />
  @{[$mode{blog} ? qq($::resource{blog_plugin_input_subject} : <input class="editform" name="subject" value="" size="$blog::subjectcols" /><br />) : ""]}
  @{[$mode{blog} ? qq($::resource{blog_plugin_input_category} : <input class="editform" name="category" value="" size="$blog::categorycols" /> $category_array ) : ""]}
  @{[$mode{blog} ? qq(<input type="hidden" name="basepage" value="$::form{basepage}" />) : ""]}
  @{[$mode{blog} ? qq(<input type="hidden" name="catepage" value="$::form{catepage}" />) : ""]}
  @{[$::extend_edit ? &plugin_edit_extend_edit : ""]}
  $partfield
  <textarea cols="$::cols" rows="$::rows" name="mymsg" id="mymsg">@{[&plugin_edit_crlfconv(&htmlspecialchars($mymsg,1))]}</textarea><br />
$captcha_form
@{[
  $mode{admin} ?
  qq(
  <input class="editformcheck" type="radio" name="myfrozen" value="1"@{[$frozen ? qq( checked="checked") : ""]} />$::resource{edit_plugin_frozenbutton}
  <input class="editformcheck" type="radio" name="myfrozen" value="0"@{[$frozen ? "" : qq( checked="checked")]} />$::resource{edit_plugin_notfrozenbutton}<br />)
  : ""
]}
@{[
  $mode{conflict} ? "" :
#  $crypt ?
  1 ?
  qq(
    <span id="submitbutton"></span>
    <script type="text/javascript"><!--
	d.getElementById("submitbutton").innerHTML='<input type="hidden" name="mypreviewjs_@{[$blog]}$edit" value="" /><input type="hidden" name="mypreviewjs_@{[$blog]}write" value="" /><input class="editformcheck" type="checkbox" name="mytouchjs" id="mytouchjs" value="on"@{[&mytouchcheck]} />$::resource{edit_plugin_touch}<br /><input class="editformbutton" type="button" name="mypreviewjs_button_$edit" value="$::resource{edit_plugin_previewbutton}" onclick="editpost(0);" onkeypress="editpost(0,event);" /><input class="editformbutton" type="button" name="mypreviewjs_button_write" value="@{[$::resource{edit_plugin_pukiwikisavebutton} eq '' ? $::resource{edit_plugin_savebutton} : $::resource{edit_plugin_pukiwikisavebutton}]}" onclick="editpost(1);" onkeypress="editpost(1,event);" />';
//--></script>
  <noscript>
    <input class="editformcheck" type="checkbox" name="mytouch" id="mytouch" value="on"@{[&mytouchcheck]} />$::resource{edit_plugin_touch}<br />
    <input class="editformbutton" type="submit" name="mypreview_$blog$edit" value="$::resource{edit_plugin_previewbutton}" />
    <input class="editformbutton" type="submit" name="mypreview_@{[$blog]}write" value="@{[$::resource{edit_plugin_pukiwikisavebutton} eq '' ? $::resource{edit_plugin_savebutton} : $::resource{edit_plugin_pukiwikisavebutton}]}" />
  </noscript>
  ) :
  qq(
    <input class="editformcheck" type="checkbox" name="mytouch" id="mytouch" value="on"@{[&mytouchcheck]} />$::resource{edit_plugin_touch}<br />
    <input class="editformbutton" type="submit" name="mypreview_$blog$edit" value="$::resource{edit_plugin_previewbutton}" />
    <input class="editformbutton" type="submit" name="mypreview_@{[$blog]}write" value="$::resource{edit_plugin_savebutton}" /><br />
  )
]}
</form>
</div>
EOD
	return $body;
}

sub plugin_edit_crlfconv {
	my ($msg)=shift;
#	$msg=~s/\x0D\x0A|\x0D|\x0A/\&\#13;\&\#10;/g;
	$msg;
}
1;
__END__

=head1 NAME

edit.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=edit&mypage=pagename&refer=referpage&under=upper-layer-page

=head1 DESCRIPTION

Edit page.

The page name must be encoded.

=head1 SETTING

=head 2 pyukiwiki.ini.cgi

=over 4

=item $::cols

Columns of text area

=item $::rows

Lines of text area

=item $::extend_edit

Extended Edit (JavaScript) 1:use / 0:not use

=item $::pukilike_edit

PukiWiki like edit screen

0: PyukiWiki Original

1: PukiWiki Like

2: PukiWiki Like with load template

3: PukiWiki Like with load template on create page

=item $::edit_afterpreview

Position of preview screen 0:On an edit screen / 1:Under an edit screen

=item $::new_refer

For newpage plugin, 

In create page, it's displayed a related page on initial value

It's not displayed that setting of null string.

=item $::new_dirnavi

For newpage plugin, 

Display of selection Upper layer page 1:use / 0:not use

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/edit

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/edit/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/edit.inc.pl>

=item YukiWiki

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
