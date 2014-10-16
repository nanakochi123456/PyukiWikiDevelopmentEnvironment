######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

# コメント欄の全体フォーマット
$multicomment::format = "\x08MSG\x08 -- \x08NAME\x08 \x08NOW\x08"
	if(!defined($multicomment::format));

# テキストエリアのカラム数
$multicomment::cols = 70
	if(!defined($multicomment::cols));
#
# テキストエリアの行数
$multicomment::rows = 5
	if(!defined($multicomment::rows));
#
# 名前、URL、メールアドレステキストエリアのカラム数
$multicomment::name_cols = 24
	if(!defined($multicomment::name_cols));
#
# その他題名テキストエリアのカラム数
$multicomment::text_cols = 60
	if(!defined($multicomment::text_cols));
#
# 名前の挿入フォーマット
$multicomment::name_format = "\'\'[[\$1>$::resource{profile_page}/\$1]]\'\'"
	if(!defined($multicomment::name_format));
#
# 日付の挿入フォーマット (&new で認識できること)
$multicomment::date_format= "Y-m-d(lL) H:i:s"
	if(!defined($multicomment::date_format));
#
# URLの挿入フォーマット (&new で認識できること)
$multicomment::url_format= '[[HOME>$1]]'
	if(!defined($multicomment::url_format));
#
# メールの挿入フォーマット (&new で認識できること)
$multicomment::mail_format= '[[MAIL>$1]]'
	if(!defined($multicomment::mail_format));
#
# 挿入する位置 1:欄の前 0:欄の後
$multicomment::ins = 1
	if(!defined($multicomment::ins));
#
# 書込み下に一行コメントを 1:入れる 0:入れない
$multicomment::comment = 1
	if(!defined($multicomment::comment));
#
# 改行を自動的変換 1:する 0:しない
$multicomment::auto_br = 1
	if(!defined($multicomment::auto_br));
#
# 名前なしで処理しない
$multicomment::noname = 1
	if(!defined($multicomment::noname));

#
# メールのヘッダー
$multicomment::mailheader = "$::mail_head{post}"
	if(!defined($multicomment::mailheader));

######################################################################

$multicomment::no = 0;

my $_no_name = "";

sub plugin_multicomment_action {
	my $name_form;
	my $textarea_form;
	my $url_form;
	my $mail_form;

	foreach(keys %::form) {
		if(/^\_ext\_(name|text|textarea)/) {
			&::spam_filter($::form{$_}, 2, $::chk_multicomment_uri_count, $::chk_multicomment_mail_count);
		}
		if(/^\_ext\_(name|textarea)/) {
			if($::form{$_}=~/^\s*$/) {
				return('msg'=>"$::form{mypage}\t\t$::resource{multicomment_plugin_err}",'body'=>&text_to_html($::database{$::form{mypage}}),'ispage'=>1);
			}
		}
		$::form{$_}=&code_convert(\$::form{$_}, $::defaultcode);
		$name_form=$_ if(/^\_ext\_name\_/);
		$textarea_form=$_ if(/^\_ext\_textarea\_/);
		$url_form=$_ if(/^\_ext\_url\_/);
		$mail_form=$_ if(/^\_ext\_mail\_/);

		if(/^\_ext\_textarea\_/) {
			$::form{$_}=~s/\x0D\x0A|\x0D|\x0A/\n/g;
			$::form{$_}=~s/^(\s|\n)//g while($::form{$_}=~/^(\s|\n)/);
			$::form{$_}=~s/(\s|\n)$//g while($::form{$_}=~/(\s|\n)$/);
			$::form{$_}=~s/\n/\~\n/g if($multicomment::auto_br);
		}
	}

	my ($url, $mail, $myurl, $mymail, $myname);
	my $name = $_no_name;
	if ($::form{$name_form} ne '') {
		$name = $multicomment::name_format;
		$name =~ s/\$1/$::form{$name_form}/g;
		$myname=$::form{$name_form};
	}

	my $msg=$::form{$textarea_form};

	if($::form{$url_form}=~/$::isurl/g && $::form{$url_form} ne "") {
		if($::form{$url_form}=~/$multicomment::ignoreurl/i) {
			return('msg'=>"$::form{mypage}\t\t$::resource{multicomment_plugin_err}",'body'=>&text_to_html($::database{$::form{mypage}}),'ispage'=>1);
		}
		$myurl=$::form{$url_form};
		$url=$multicomment::url_format;
		$url=~ s/\$1/$myurl/g;
	}
	if($::form{$mail_form}=~/$::ismail/g && $::form{$mail_form} ne "") {
		$mymail=$::form{$mail_form};
		$mail=$multicomment::mail_format;
		$mail=~ s/\$1/$mymail/g;
	}

	my $now="&new{@{[&date($multicomment::date_format)]}};";
	my $comment = $multicomment::format;
	$comment =~ s/\x08MSG\x08/$msg/;
	$comment =~ s/\x08NAME\x08/$name $url $mail/;
	$comment =~ s/\x08NOW\x08/$now/;
	$comment = "-" . $comment;

	if($::setting_cookie{savename}+0>0 && $myname ne '') {
		eval {
			&plugin_setting_savename($myname, $myurl, $mymail);
		};
	}

	my $postdata = '';
	my @postdata_old = split(/\r?\n/, $::database{$::form{'mypage'}});
	my $_multicomment_no = 0;

	foreach (@postdata_old) {
		$postdata .= $_ . "\n" if (!$multicomment::ins);
		if (/^#multicomment/ && (++$_multicomment_no == $::form{multicomment_no})) {
			$postdata .= "$comment\n";
		}
		$postdata .= $_ . "\n" if ($multicomment::ins);
	}
	$::form{mymsg} = $postdata;
	$::form{mytouch} = 'on';
	&do_write("FrozenWrite", "", $multicomment::mailheader);
	&close_db;
	exit;
}

sub plugin_multicomment_convert {
	my(@args)=split(/,/,&htmlspecialchars(shift));

	return ' '
		if($::writefrozenplugin eq 0 && &get_info($::form{mypage}, $::info_IsFrozen) eq 1);
	$multicomment::no++;
	my $conflictchecker = &get_info($::form{mypage}, $::info_ConflictChecker);

	my $captcha_form;
	eval {
		$captcha_form=&plugin_captcha_form;
	};

	my $form="<table>";
	my $formname=0;
	foreach my $arg(@args) {
		$formname++;
		my($type, $text, $opt)=split(/=/,$arg);
		if($type=~/^(comment)/) {
			$form.=<<EOM;
<input type="hidden" name="_ext\_$type\_$formname" value="$text" />
EOM
		}
		if($type=~/^(label)$/) {
			$form.=<<EOM;
<tr><td colspan="2" class="big">$text</td></tr>
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
<tr><td>$text : </td><td><input type="text" name="_ext\_$type\_$formname" size="@{[$type=~/text/ ? $multicomment::text_cols : $type=~/name|url|mail/ ? $multicomment::name_cols : $multicomment::subject_cols]}" value="$value" /></td></tr>
EOM
		}
		if($type eq "textarea") {
			$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td>
<textarea name="_ext_textarea_$formname" rows="$multicomment::rows" cols="$multicomment::cols"></textarea></td></tr>
EOM
		}
	}
	$form.=<<EOM;
<tr><td>&nbsp;</td><td>
$captcha_form
<input type="submit" value="$::resource{multicomment_plugin_btn}" />
<input type="reset" value="$::resource{multicomment_plugin_clear}" />
</td></tr>
</table>
EOM
	return <<"EOD";
<form action="$::script" method="post">
<div>
<input type="hidden" name="multicomment_no" value="$multicomment::no" />
<input type="hidden" name="cmd" value="multicomment" />
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

multicomment.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

 #multicomment(name=name,textarea=comment)
 
=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/multicomment

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/multicomment/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/multicomment.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
