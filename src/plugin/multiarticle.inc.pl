######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

# テキストエリアのカラム数
$multiarticle::cols = 70
	if(!defined($multiarticle::cols));
#
# テキストエリアの行数
$multiarticle::rows = 5
	if(!defined($multiarticle::rows));
#
# 名前、URL、メールアドレステキストエリアのカラム数
$multiarticle::name_cols = 24
	if(!defined($multiarticle::name_cols));
#
# 題名テキストエリアのカラム数
$multiarticle::subject_cols = 60
	if(!defined($multiarticle::subject_cols));
#
# その他題名テキストエリアのカラム数
$multiarticle::text_cols = 60
	if(!defined($multiarticle::text_cols));
#
# 名前の挿入フォーマット
$multiarticle::name_format = "\'\'[[\$1>$::resource{profile_page}/\$1]]\'\'"
	if(!defined($multiarticle::name_format));
#
# 題名の挿入フォーマット
$multiarticle::subject_format = '**$subject'
	if(!defined($multiarticle::subject_format));
#
# 日付の挿入フォーマット (&new で認識できること)
$multiarticle::date_format= "Y-m-d(lL) H:i:s"
	if(!defined($multiarticle::date_format));
#
# URLの挿入フォーマット (&new で認識できること)
$multiarticle::url_format= '[[HOME>$1]]'
	if(!defined($multiarticle::url_format));
#
# メールの挿入フォーマット (&new で認識できること)
$multiarticle::mail_format= '[[MAIL>$1]]'
	if(!defined($multiarticle::mail_format));
#
# 挿入する位置 1:欄の前 0:欄の後
$multiarticle::ins = 0
	if(!defined($multiarticle::ins));
#
# 書込み下に一行コメントを 1:入れる 0:入れない
$multiarticle::comment = 1
	if(!defined($multiarticle::comment));
#
# 改行を自動的変換 1:する 0:しない
$multiarticle::auto_br = 1
	if(!defined($multiarticle::auto_br));
#
# 名前なしで処理しない
$multiarticle::noname = 1
	if(!defined($multiarticle::noname));
#
# サブジェクトなしで処理しない
$multiarticle::nosubject = 0
	if(!defined($multiarticle::nosubject));
#
# サブジェクトなしのタイトル
$multiarticle::no_subject = "no subject"
	if(!defined($multiarticle::no_subject));
#
# 拒否するURL
$multiarticle::ignoreurl=$::ignoreurl
	if(!defined($multiarticle::ignoreurl));

#
# メールのヘッダー
$multiarticle::mailheader = "$::mail_head{post}"
	if(!defined($multiarticle::mailheader));

######################################################################

$multiarticle::no = 0;

my $_no_name = "";

sub plugin_multiarticle_action {
	my $name_form;
	my $subject_form;
	foreach(keys %::form) {
		if(/^\_ext\_(name|subject|textarea)/) {
			&::spam_filter($::form{$_}, 2, $::chk_multiarticle_uri_count, $::chk_multiarticle_mail_count);
		}
		if(/^\_ext\_(name|subject|textarea)/) {
			if($::form{$_}=~/^\s*$/) {
				return('msg'=>"$::form{mypage}\t\t$::resource{multiarticle_plugin_err}",'body'=>&text_to_html($::database{$::form{mypage}}),'ispage'=>1);
			}
		}
		$::form{$_}=&code_convert(\$::form{$_}, $::defaultcode);
		$name_form=$_ if(/^\_ext\_name\_/);
		$subject_form=$_ if(/^\_ext\_subject\_/);

		if(/^\_ext\_textarea\_/) {
			$::form{$_}=~s/\x0D\x0A|\x0D|\x0A/\n/g;
			$::form{$_}=~s/^(\s|\n)//g while($::form{$_}=~/^(\s|\n)/);
			$::form{$_}=~s/(\s|\n)$//g while($::form{$_}=~/(\s|\n)$/);
			$::form{$_}=~s/\n/\~\n/g if($multiarticle::auto_br);
		}
	}

	my ($url, $mail, $myurl, $mymail, $myname);
	my $name = $_no_name;
	if ($::form{$name_form} ne '') {
		$name = $multiarticle::name_format;
		$name =~ s/\$1/$::form{$name_form}/g;
		$myname=$::form{$name_form};
	}
	my $subject = $multiarticle::subject_format;
	if ($::form{$subject_form} ne '') {
		$subject =~ s/\$subject/$::form{$subject_form}/g;
	} else {
		$subject =~ s/\$subject/$multiarticle::no_subject/g;
	}

	my $artic;


	for(my $i=1; $::form{"_ext_hidden\_$i"} ne ""; $i++) {
		foreach my $ffname("text","url","mail","star","select","checkbox","textarea") {
			if($::form{"_ext\_$ffname\_$i"} ne "") {
				if($ffname eq "url") {
					if($::form{"_ext\_$ffname\_$i"}=~/$::isurl/g) {
						if($::form{"_ext\_$ffname\_$i"}=~/$multiarticle::ignoreurl/i) {
							return('msg'=>"$::form{mypage}\t\t$::resource{multiarticle_plugin_err}",'body'=>&text_to_html($::database{$::form{mypage}}),'ispage'=>1);
						}
						$myurl=$::form{"_ext\_$ffname\_$i"};
						$url=$multiarticle::url_format;
						$url=~ s/\$1/$myurl/g;
					}
				} elsif($ffname eq "mail") {
					if($::form{"_ext\_$ffname\_$i"}=~/$::ismail/g) {
						$mymail=$::form{"_ext\_$ffname\_$i"};
						$mail=$multiarticle::mail_format;
						$mail=~ s/\$1/$mymail/g;
					}
				} elsif($ffname eq "star") {
					if($::form{"_ext\_$ffname\_$i"}+0 eq 0) {
						$artic.=<<EOM;
$::form{"_ext_hidden_$i"} : $::resource{multiarticle_plugin_star0}~
EOM
					} else {
						$artic.=<<EOM;
$::form{"_ext_hidden_$i"} : &star($::form{"_ext\_$ffname\_$i"});~
EOM
					}
				} else {
					$artic.=<<EOM;
$::form{"_ext_hidden_$i"} : $::form{"_ext\_$ffname\_$i"}~
EOM
				}
			}
		}
	}
	$artic = <<EOM;
$subject\n>$name $url $mail &new{@{[&date($multiarticle::date_format)]}};~
~
$artic
EOM

	if($::setting_cookie{savename}+0>0 && $myname ne '') {
		eval {
			&plugin_setting_savename($myname, $myurl, $mymail);
		};
	}

	my $commentarg;
	for(my $i=1; $::form{"_ext_hidden\_$i"} ne ""; $i++) {
		foreach("name", "text", "url", "mail", "textarea", "label") {
			if(defined($::form{"_ext_comment$_\_$i"})) {
				$commentarg.=qq($_=$::form{"_ext_hidden\_$i"}=$::form{"_ext_comment$_\_$i"},);
			}
		}
	}
	$commentarg=~s/,$//;
	$commentarg="($commentarg)" if($commentarg ne "");
	$artic .= "\n#multicomment$commentarg\n" if ($multiarticle::comment);
	my $postdata = '';
	my @postdata_old = split(/\r?\n/, $::database{$::form{'mypage'}});
	my $_multiarticle_no = 0;

	foreach (@postdata_old) {
		$postdata .= $_ . "\n" if (!$multiarticle::ins);
		if (/^#multiarticle/ && (++$_multiarticle_no == $::form{multiarticle_no})) {
			$postdata .= "$artic\n";
		}
		$postdata .= $_ . "\n" if ($multiarticle::ins);
	}
	$::form{mymsg} = $postdata;
	$::form{mytouch} = 'on';
	&do_write("FrozenWrite", "", $multiarticle::mailheader);
	&close_db;
	exit;
}


sub plugin_multiarticle_convert {
	my(@args)=split(/,/,&htmlspecialchars(shift));

	return ' '
		if($::writefrozenplugin eq 0 && &get_info($::form{mypage}, $::info_IsFrozen) eq 1);
	$multiarticle::no++;
	my $conflictchecker = &get_info($::form{mypage}, $::info_ConflictChecker);

	my $captcha_form;
	eval {
		$captcha_form=&plugin_captcha_form;
	};

	my $form="<table>";
	my $formname=0;
	foreach my $arg(@args) {
		$formname++;
		my($type, $text, $opt, $chk)=split(/=/,$arg);
		if($type=~/^(commentname|commenttext|commenturl|commentmail|commenttextarea|commentlabel)/) {
			$form.=<<EOM;
<input type="hidden" name="_ext\_hidden\_$formname" value="$text" />
<input type="hidden" name="_ext\_$type\_$formname" value="$opt" />
EOM
		}
		if($type=~/^(text|name|url|mail|subject)$/) {
			my $value=$opt;
			$value=$::name_cookie{myname}
				if($type eq "name" && $::name_cookie{myname} ne "");
			$value=$::name_cookie{myurl}
				if($type eq "url" && $::name_cookie{myurl} ne "");
			$value=$::name_cookie{mymail}
				if($type eq "mail" && $::name_cookie{mymail} ne "");
			$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td><input type="text" name="_ext\_$type\_$formname" size="@{[$type=~/text/ ? $multiarticle::text_cols : $type=~/name|url|mail/ ? $multiarticle::name_cols : $multiarticle::subject_cols]}" value="$value" /></td></tr>
EOM
		}
		if($type eq "star") {
			$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td><select name="_ext_star_$formname">
<option value="0">$::resource{multiarticle_plugin_star0}</option>
<option value="1">$::resource{multiarticle_plugin_star1}</option>
<option value="2">$::resource{multiarticle_plugin_star2}</option>
<option value="3">$::resource{multiarticle_plugin_star3}</option>
<option value="4">$::resource{multiarticle_plugin_star4}</option>
<option value="5">$::resource{multiarticle_plugin_star5}</option>
</select></td></tr>
EOM
		}
		if($type eq "select") {
			$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td><select name="_ext_select_$formname">
EOM
			foreach(split(/\|/,$opt)) {
				$form.=<<EOM;
<option value="$_">$_</option>
EOM
			}
			$form.=<<EOM;
</select>
</td></tr>
EOM
		}
		if($type eq "checkbox") {
			my $title;
			if($::save_multiarticle_checkbox_title ne $text) {
				$title="$text : ";
				$::save_multiarticle_checkbox_title=$text;
			}
			$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$title</td><td>
<input type="checkbox" name="_ext_checkbox_$formname" value="$opt"@{[$chk eq "checked" ? ' checked="checked"' : ""]} />$opt</td></tr>
EOM
		}
		if($type eq "textarea") {
			$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td>
<textarea name="_ext_textarea_$formname" rows="$multiarticle::rows" cols="$multiarticle::cols"></textarea></td></tr>
EOM
		}
	}
	$form.=<<EOM;
<tr><td>&nbsp;</td><td>
$captcha_form
<input type="submit" value="$::resource{multiarticle_plugin_btn}" />
<input type="reset" value="$::resource{multiarticle_plugin_clear}" />
</td></tr>
</table>
EOM
	return <<"EOD";
<form action="$::script" method="post">
<div>
<input type="hidden" name="multiarticle_no" value="$multiarticle::no" />
<input type="hidden" name="cmd" value="multiarticle" />
<input type="hidden" name="mypage" value="$::form{'mypage'}" />
<input type="hidden" name="myConflictChecker" value="$conflictchecker" />
<input type="hidden" name="mytouch" value="on" />
$form
</div>
</form>
EOD
}

1;
__END__

=head1 NAME

multiarticle.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

 #multiarticle(name=name,subject=subject,textarea=comment,commentname=name,commenttextarea=comment)
 
=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/multiarticle

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/multiarticle/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/multiarticle.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
