######################################################################
# @@HEADER1@@
######################################################################

$::Token='';

=head1 NAME

wiki_auth.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_auth.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_auth.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_auth.cgi>

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

=head2 valid_password

=over 4

=item 入力値

&valid_password(入力されたパスワード,admin|frozen|attach,暗号化されたパスワード,トークン);

=item 出力

パスワードが一致していたら1、一致していなければ0

=item オーバーライド

可

=item 概要

管理者パスワード認証をする。

=back

=cut
	# 2005.10.27 pochi: 添付用パスワードを設置			# comment
	# 汎用管理パスワード対応							# comment
	# $::adminpass / $::adminpass{attach} ....			# comment
	# 2012.09.12 MD5 / SHA1等対応						# comment

sub _valid_password {
	my ($givenpassword,$type,$enc,$token) = @_;

	$givenpassword=&password_decode($givenpassword,$enc,$token);

	&load_module("Nana::Crypt");
	if($::adminpass{$type} eq "") {
		return Nana::Crypt::check($givenpassword, $::adminpass);
	}
	return Nana::Crypt::check($givenpassword, $::adminpass{$type});
}

=lang ja

=head2 passwordform

=over 4

=item 入力値

&passwordform(入力されるパスワード, [hidden], [フォーム名], [暗号化されたパスワード], [トークン], [サイズ], [最小文字数], [最大文字数], [スタイル], [追加文字列]);

=item 出力

HTML

=item オーバーライド

可

=item 概要

パスワードフォームを出力する。

=back

=cut

sub _passwordform {
	my($default,$mode,$formname,$enc,$token,$size,$minlength,$maxlength,$style, $add)=@_;
	$formname="mypassword" if($formname eq '');

	my $size=10 if($size+0 eq 0);
	$maxlength=32 if($maxlength+0 eq 0);

	if(&iscryptpass) {
		if($enc eq '') {
			$cryptpassform=<<EOM;
<input type="hidden" name="$formname\_enc" id="$formname\_enc" value="" /><input type="hidden" id="$formname\_token" name="$formname\_token" value="$::Token" />
EOM
		} else {
			my $newpass=&password_encode(&password_decode('',$enc,$token), $::Token);
			$cryptpassform=<<EOM;
<input type="hidden" name="$formname\_enc" id="$formname\_enc" value="$newpass" /><input type="hidden" name="$formname\_token" id="$formname\_token" value="$::Token" />
EOM
		}
	}

	if($mode eq 'hidden') {
		return qq(<input type="hidden" name="$formname" id="$formname" value="$default" />$cryptpassform);
	} elsif($default eq '') {
		return qq(<input type="password" name="$formname" id="$formname" value="" size="$size" minlength="$minlength" maxlength="$maxlength" @{[$style eq "" ? "" : qq(style="$style") ]} $add />$cryptpassform);
	} else {
		return qq(<input type="password" name="$formname" id="$formname" value="$default" size="$size" minlength="$minlength" maxlength="$maxlength" @{[$style eq "" ? "" : qq(style="$style") ]} $add />$cryptpassform);
	}
}

=lang ja

=head2 authadminpassword

=over 4

=item 入力値

&authadminpassword(form|input, タイトル, attach|frozen|admin);

=item 出力

%ret{authed}, %ret{html}, %ret{crypt}

=item オーバーライド

可

=item 概要

管理者パスワード統合認証をし、必要であればパスワードフォームのHTMLを出力をする。

=back

=cut

sub _authadminpassword {
	my($mode,$title,$type)=@_;
	my $body;

	$type=($type eq "attach" ? "attach" : $type eq "frozen" ? "frozen" : "admin");
	if($mode=~/submit|page|form/) {
		$title=$::resource{admin_passwd_prompt_title} if($title eq '');
		if(!&valid_password($::form{"mypassword_$type"},$type,$::form{"mypassword_$type\_enc"},$::form{"mypassword_$type\_token"})) {
			$body=<<EOM;
<h2>$title</h2>
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>\n)]}
<form action="$::script" method="post" id="adminpasswordform" name="adminpasswordform">
$::resource{admin_passwd_prompt_msg}@{[&passwordform('','',"mypassword_$type")]}
EOM
			if(&iscryptpass) {
				$body.=<<EOM;
<span id="submitbutton"></span>
<noscript><input type="submit" value="$::resource{admin_passwd_button}" /></noscript>
EOM
				$::IN_JSHEAD.=<<EOM;
	gid("submitbutton").innerHTML='<input type="button" value="$::resource{admin_passwd_button}" onclick="fsubmit(\\'adminpasswordform\\',\\'$type\\');" onkeypress="fsubmit(\\'adminpasswordform\\',\\'$type\\',event);" />';
EOM
			} else {
				$body.=<<EOM;
<input type="submit" value="$::resource{admin_passwd_button}" />
EOM
			}
			foreach my $forms(keys %::form) {
				$body.=qq(<input type="hidden" name="$forms" value="$::form{$forms}" />\n)
					if($forms!~/^mypassword/);
			}
			$body.="</form>\n";
			return('authed'=>0,'html'=>$body, 'crypt'=>&iscryptpass);
		} else {
			$body.=qq(@{[&passwordform($::form{"mypassword\_$type"},"hidden","mypassword\_$type",$::form{"mypassword\_$type\_enc"},$::form{"mypassword\_$type\_token"})]}\n);
			return('authed'=>1,'html'=>$body, 'crypt'=>&iscryptpass);
		}
	} else {
		if(!&valid_password($::form{"mypassword_$type"},$type,$::form{"mypassword_$type\_enc"},$::form{"mypassword_$type\_token"})) {
			$body.=<<EOM;
@{[$ENV{REQUEST_METHOD} eq 'GET' && $::form{mypassword} eq '' ? '' : qq(<div class="error">$::resource{admin_passwd_prompt_error}</div>)]}
EOM
			$body.=qq(@{[$title ne '' ? $title : $::resource{admin_passwd_prompt_msg}]}@{[&passwordform('','',"mypassword_$type")]}\n);
			return('authed'=>0,'html'=>$body, 'crypt'=>&iscryptpass);
		} else {
			$body.=qq(@{[&passwordform($::form{"mypassword\_$type"},"hidden","mypassword\_$type",$::form{"mypassword\_$type\_enc"},$::form{"mypassword\_$type\_token"})]}\n);
			return('authed'=>1,'html'=>$body, 'crypt'=>&iscryptpass);
		}
	}
}

=head2 password_decode

=over 4

=item 入力値

&password_decode([生パスワード], エンコードされたパスワード, トークン);

=item 出力

生のパスワード

=item オーバーライド

可

=item 概要

パスワードをデコードする。

=back

=cut

sub _password_decode {
	&load_module("Nana::Enc");
	return Nana::Enc::decode(@_);
}

=lang ja

=head2 password_encode

=over 4

=item 入力値

&password_encode(エンコードされたパスワード, トークン);

=item 出力

生のパスワード

=item オーバーライド

可

=item 概要

パスワードを暗号化する。

=back

=cut

sub _password_encode {
	&load_module("Nana::Enc");
	return Nana::Enc::encode(@_);
}

=lang ja

=head2 iscryptpass

=over 4

=item 入力値

なし

=item 出力

可能であれば、1 を返す。

また、$::Token にトークンを返す。

=item オーバーライド

可

=item 概要

簡易暗号化が可能であれば１を返す。

=back

=cut

sub _iscryptpass {
	&load_module("Nana::Enc");
	return Nana::Enc::iscryptpass(@_);
}

=lang ja

=head2 maketoken

=over 4

=item 入力値

なし

=item 出力

トークン

=item オーバーライド

可

=item 概要

簡易暗号化及びアンチスパムメール用のトークンを出力する。

=back

=cut

sub _maketoken {
	&load_module("Nana::Enc");
	return Nana::Enc::maketoken(@_);

}
1;
