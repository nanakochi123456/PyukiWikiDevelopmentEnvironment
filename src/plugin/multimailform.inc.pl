######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1以降専用です。
######################################################################
#
# テキストエリアのカラム数
$multimailform::cols=70
	if(!defined($multimailform::cols));
#
# テキストエリアの行数
$multimailform::rows=10
	if(!defined($multimailform::rows));
#
# 名前テキストエリアのカラム数
$multimailform::name_cols=24
	if(!defined($multimailform::name_cols));
#
# メールアドレステキストエリアのカラム数
$multimailform::from_cols=24
	if(!defined($multimailform::from_cols));
#
# 題名テキストエリアのカラム数
$multimailform::subject_cols=24
	if(!defined($multimailform::subject_cols));
#
# 題名が未記入の場合の表記
$multimailform::no_subject_title = "no title"
	if(!defined($multimailform::no_subject_title));
#
# 名前が未記入の場合の表記
$multimailform::no_name_title = "anonymous"
	if(!defined($multimailform::no_name_title));
#
# 題名なしで処理:0、題名なしを許容する:1、題名なしを許可しない:2
$multimailform::no_subject = 2
	if(!defined($multimailform::no_subject));
#
# 名前なしで処理:0、名前なしを許容する:1、名前なしを許可しない:2
$multimailform::no_name = 1
	if(!defined($multimailform::no_name));
#
# メールアドレスなしで処理:0、メールアドレスなしを許容する:1、メールアドレスなしを許可しない:2
$multimailform::no_from = 2
	if(!defined($multimailform::no_from));
#
# 本文なしで処理しない:1
$multimailform::no_data = 1
	if(!defined($multimailform::no_data));
#
# 投稿内容のメール送信時のprefix
$multimailform::subject_prefix="$::mail_head$::mail_head{form}"
	if(!defined($multimailform::subject_prefix));
#
# 拒否するURL
$multimailform::ignoreurl=$::ignoreurl
	if(!defined($multimailform::ignoreurl));
#
#####################################################33
use strict;

# cmd=multimailform&...											# comment

sub plugin_multimailform_action {
	return <<EOM if($::modifier_mail eq '');
<div class="error">
$::resource{multimailform_plugin_err_to}
</div>
EOM

	my $argv=$::form{argv};
#	my %option=&plugin_multimailform_optionparse($argv);

	my $errstr="";

	# Locationからきた送信したメッセージ					# comment
	if($::write_location eq 1) {
		if($::form{sent} ne '') {
			return('msg'=>$::form{refer} . "\t" . $::resource{multimailform_plugin_mailsend}
				 , 'body'=>&text_to_html($::database{$::form{refer}}, mypage=>$::form{refer})
				 , 'ispage'=>1);
		}
	}

	my $name_form;
	my $subject_form;
 	my $mail_form;

	foreach(keys %::form) {
		$::form{$_}=&code_convert(\$::form{$_}, $::defaultcode);
		$name_form=$_ if(/^\_ext\_name\_/);
		$subject_form=$_ if(/^\_ext\_subject\_/);

		if(/^\_ext\_textarea\_/) {
			$::form{$_}=~s/\x0D\x0A|\x0D|\x0A/\n/g;
			$::form{$_}=~s/^(\s|\n)//g while($::form{$_}=~/^(\s|\n)/);
			$::form{$_}=~s/(\s|\n)$//g while($::form{$_}=~/(\s|\n)$/);
			$::form{$_}=~s/\n/\~\n/g if($multimailform::auto_br);
		}
	}

	my ($myurl, $mymail, $myname, $subject, $textareas);

	my $artic;

	for(my $i=1; $::form{"_ext_hidden\_$i"} ne ""; $i++) {
		foreach my $ffname("name", "subject", "text","url","mail","select","checkbox","textarea") {
			if($::form{"_ext\_$ffname\_$i"} ne "") {
				if($ffname eq "url") {
					if($::form{"_ext\_$ffname\_$i"} ne "") {
						if($::form{"_ext\_$ffname\_$i"}=~/$::isurl/g) {
							if($::form{"_ext\_$ffname\_$i"}=~/$multimailform::ignoreurl/i) {
								return('msg'=>"$::form{refer}\t\t$::resource{multimailform_plugin_err}",'body'=>&text_to_html($::database{$::form{refer}}),'ispage'=>1);
							}
							$myurl=$::form{"_ext\_$ffname\_$i"};
						} else {
							$errstr.="$::resource{multimailform_plugin_err_url_err}\n";
						}
					}
				} elsif($ffname eq "mail") {
					if($::form{"_ext\_$ffname\_$i"}=~/^$::ismail$/g) {
						$mail_form="_ext\_$ffname\_$i";
						$mymail=$::form{$mail_form};
					}
				} elsif($ffname eq "name") {
					$name_form="_ext\_$ffname\_$i";
					$myname=$::form{$name_form};
				} elsif($ffname eq "subject") {
					$subject_form="_ext\_$ffname\_$i";
					$subject=$::form{$subject_form};
				} elsif($ffname eq "textarea") {
					$textareas.=$::form{"_ext\_$ffname\_$i"};
				}
				$artic.=<<EOM;
$::form{"_ext_hidden_$i"} : $::form{"_ext\_$ffname\_$i"}
EOM
			}
		}
	}

	# メールアドレス記載のチェック							# comment
	$mymail=&trim($mymail);
	if($multimailform::no_from ne 2) {
		if($::form{multimailform_from} eq '') {
			$::form{multimailform_from}=$::modifier_mail;
		}
	}
	if($mymail eq '') {
		$errstr.="$::resource{multimailform_plugin_err_from_nostr}\n";
	} elsif($mymail!~/$::ismail/) {
		$errstr.="$::resource{multimailform_plugin_err_from_err}\n";
		$::form{$mail_form}='';
	}

	# 名前記載のチェック									# comment
	$::form{multimailform_name}=&trim($::form{multimailform_name});
	if($multimailform::no_name ne 2) {
		if($myname eq '') {
			$myname=$mymail;
			if($myname eq $::modifier_mail) {
				$myname=$multimailform::no_name_title;
			}
		}
	}
	if($multimailform::no_name ne 0) {
		if($myname eq '') {
			$errstr.="$::resource{multimailform_plugin_err_noname}\n";
		}
	}

	# 表題記載のチェック									# comment
	$subject=&trim($subject);
	if($multimailform::no_subject ne 2) {
		if($subject eq '') {
			$subject=$multimailform::no_subject_title;
		}
	}
	if($multimailform::no_subject ne 0) {
		if($subject eq '') {
			$errstr.="$::resource{multimailform_plugin_err_nosubject}\n";
		}
	}

	# 本文記載のチェック									# comment
	if($multimailform::no_data = 1 eq 1) {
		my $dmy=$textareas;
		$dmy=~s/[\r|\n]//g;
		$dmy=~s/\s//g;
		$dmy=~s/　//g;
		$errstr.="$::resource{multimailform_plugin_err_nodata}\n" if($dmy eq '');
	}

	if($errstr eq '' && $::form{edit} eq '') {
		if($::form{confirm} ne '') {
			my $body="<h2>$::resource{multimailform_plugin_msg_title}</h2>\n";
			$body.=&plugin_multimailform_makeform($::form{argv},"confirm");
			return('msg'=>$::form{refer} . "\t" . $::resource{multimailform_plugin_mailconfirm}
				 , 'body'=>$body);
		} else {
			&plugin_multimailform_send($mymail, $myname, $subject, $artic);
			if($::write_location eq 0) {
				foreach(keys %::form) {
					if(/^\_ext\_/) {
						$::form{$_}="";
					}
				}

				return('msg'=>$::form{refer} . "\t" . $::resource{multimailform_plugin_mailsend}
					 , 'body'=>&text_to_html($::database{$::form{refer}}, mypage=>$::form{refer})
					 , 'ispage'=>1);
			} else {
				if($::write_location eq 1) {
					&location("$::basehref?cmd=multimailform&sent=true&refer=@{[&encode($::form{refer})]}", 302, $::HTTP_HEADER);
					close(STDOUT);
					exit;
				}
			}
		}
	} else {
		my $body="<h2>$::resource{$::form{edit} ne '' ? 'multimailform_plugin_msg_edit' : 'multimailform_plugin_err_title'}</h2>\n";
		foreach(split(/\n/,$errstr)) {
			$body.=qq(<div class="error">$_</div>\n) if($_ ne '');
		}
		$body.=&plugin_multimailform_makeform($::form{argv});

		return('msg'=>$::form{refer} . "\t" . $::resource{multimailform_plugin_mailconfirm}
			 , 'body'=>$body);
	}
}

# メール送信本体											# comment
sub plugin_multimailform_send {
	my($from, $from_name, $subject, $data)=@_;
	&load_module("Nana::Mail");
	Nana::Mail::send(
		to=>$::modifier_mail,
		from=>$from,
		from_name=>$from_name,
		subject=>"$multimailform::subject_prefix$subject",
		data=>$data);
}

# #multimailform(...)											# comment

sub plugin_multimailform_convert {
	my $argv=shift;

	return <<EOM if($::modifier_mail eq '');
<div class="error">
$::resource{multimailform_plugin_err_to}
</div>
EOM

	return &plugin_multimailform_makeform($argv);
}

# フォームのHTML生成										# comment

sub plugin_multimailform_makeform {
	my ($argv, $mode)=@_;
	my(@args)=split(/,/,&htmlspecialchars($argv));

	my $form="<table>";
	my $formname=0;
	foreach my $arg(@args) {
		$formname++;
		my($type, $text, $opt, $chk)=split(/=/,$arg);

		if($type=~/^(text|name|url|mail|subject)$/) {
			my $value=$::form{"_ext\_$type\_$formname"} 
				? $::form{"_ext\_$type\_$formname"} : $opt;
			if($mode eq "confirm") {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<input type="hidden" name="_ext\_$type\_$formname"  value="$value" />
<tr><td>$text : </td><td>$value</td></tr>
EOM
			} else {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td><input type="text" name="_ext\_$type\_$formname" size="@{[$type=~/text/ ? $multimailform::text_cols : $type=~/name|url|mail/ ? $multimailform::name_cols : $multimailform::subject_cols]}" value="$value" /></td></tr>
EOM
			}
		}
		if($type eq "select") {
			if($mode eq "confirm") {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<input type="hidden" name="_ext\_$type\_$formname"  value="$::form{"_ext\_$type\_$formname"}" />
<tr><td>$text : </td><td>$::form{"_ext\_$type\_$formname"}</td></tr>
EOM
			} else {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td><select name="_ext_select_$formname">
EOM
				foreach(split(/\|/,$opt)) {
					$form.=<<EOM;
<option value="$_"@{[$::form{"_ext\_$type\_$formname"} eq $_ ? ' selected="selected"' : '']}>$_</option>
EOM
				}
				$form.=<<EOM;
</select>
</td></tr>
EOM
			}
		}
		if($type eq "checkbox") {
			my $title;
			if($::save_multimailform_checkbox_title ne $text) {
				$title="$text : ";
				$::save_multimailform_checkbox_title=$text;
			}
			if(defined($::form{"_ext\_hidden\_$formname"})) {
				$chk="";
				$chk="checked" if($::form{"_ext\_$type\_$formname"} ne "");
			}
			if($mode eq "confirm") {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<input type="hidden" name="_ext\_$type\_$formname"  value="$::form{"_ext\_$type\_$formname"}" />
<tr><td>$text : </td><td>$::form{"_ext\_$type\_$formname"}</td></tr>
EOM
			} else {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$title</td><td>
<input type="checkbox" name="_ext_checkbox_$formname" value="$opt"@{[$chk eq "checked" ? ' checked="checked"' : ""]} />$opt</td></tr>
EOM
			}
		}
		if($type eq "textarea") {
			if($mode eq "confirm") {
				my $value=$::form{"_ext\_$type\_$formname"};
				$value=~s/\x0D\x0A|\x0D|\x0A/\<br \/\>/g;
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<input type="hidden" name="_ext_textarea_$formname" value="$::form{qq(_ext\_$type\_$formname)}" />
<tr><td>$text : </td><td>$value</td></tr>
EOM
			} else {
				$form.=<<EOM;
<input type="hidden" name="_ext_hidden_$formname" value="$text" />
<tr><td>$text : </td><td>
<textarea name="_ext_textarea_$formname" rows="$multimailform::rows" cols="$multimailform::cols">$::form{"_ext\_$type\_$formname"}</textarea></td></tr>
EOM
			}
		}
	}
	my $confirm=qq(<input type="hidden" name="confirm" value="true" />);
	if($mode eq "confirm") {
		$form.=<<EOM;
<tr><td>&nbsp;</td><td>
<input type="submit" name="edit" value="$::resource{multimailform_plugin_btn_back}" />
<input type="submit" name="post" value="$::resource{multimailform_plugin_btn_mailsend}" />
</td></tr>
</table>
EOM
		$confirm="";
	} else {
		$form.=<<EOM;
<tr><td>&nbsp;</td><td>
<input type="submit" value="$::resource{multimailform_plugin_btn_mailconfirm}" />
<input type="reset" value="$::resource{multimailform_plugin_btnclear}" />
</td></tr>
</table>
EOM
	}
	return <<EOM;
<div>
<form action="$::script" method="post">
<input type="hidden" name="cmd" value="multimailform" />
$confirm
<input type="hidden" name="argv" value="$argv" />
<input type="hidden" name="refer" value="@{[$::form{mypage} eq '' ? $::form{refer} : $::form{mypage}]}" />
$form
</div>
</form>
EOM
}

1;
__END__

=head1 NAME

multimailform.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #multimailform(mail=Mail address,subject=Mail title,textarea=Body)

=head1 DESCRIPTION

Display Mail form and send to admin mail message.

=head1 USAGE

 #multimailform(mail=Mail address,subject=Mail title,textarea=Body)

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/multimailform

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/multimailform/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/multimailform.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
