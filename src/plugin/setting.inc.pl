######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# cookie設定用プラグイン
# 設定はリソースファイルにします。
# ExPlugin setting.inc.cgi、$::write_location=1を有効にする必要があります
######################################################################

sub plugin_setting_action {
	my $body;
# bug ? 0.1.8 fix										# comment
#	return if($::setting_cookie eq '' || $::write_location eq 0);	# comment
# 0.1.9 fix												# comment

	return if($::useExPlugin eq 1 && $::_exec_plugined{setting} ne 2);
	if($::form{submit} ne '') {
		my $url;
		if($::form{refer} ne '') {
			$url="$::basehref?@{[&encode($::form{refer})]}";
		} elsif($::form{mypage} ne '') {
			$url="$::basehref?@{[&encode($::form{mypage})]}";
		} else {
			$url="$::basehref?cmd=setting";
		}
		foreach(keys %::form) {
			if(/^_(.*)/) {
				my $setting=$1;
				my $opt=$::resource{"plugin_setting_" . $setting . "_list"};
				if($opt=~/^sub/) {
					$opt=~s/^sub//g;
					@optlist=eval $opt;
					$::debug.=$@;
				} else {
					foreach my $list(split(/,/,$opt)) {
						push(@optlist,$list);
					}
				}
				my $flg=0;
				foreach(@optlist) {
					my($v,$n)=split(/:/,$_);
					$flg=1 if($v eq $::form{"_" . $setting});
				}
				if($flg eq 0) {
					$body.="err:$setting<br />";
				} else {
					$::setting_cookie{$setting}=$::form{"_" . $setting};
				}
			}
		}
		&setcookie($::setting_cookie, 1, %::setting_cookie);
		&location($url, 302, $::HTTP_HEADER);
		close(STDOUT);
		exit;
	}
	$body.=<<EOM;
<h3>$::resource{plugin_setting_title}</h3>
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="setting" />
<input type="hidden" name="refer" value="$::form{refer}" />
<input type="hidden" name="mypage" value="$::form{mypage}" />
<table>
EOM
	foreach my $setting(split(/,/,$::resource{plugin_setting_list})) {
		my $opts;
		my @optlist=();
		my $check=$::resource{"plugin_setting_" . $setting . "_check"};
		if($check=~/^sub/) {
			$check=~s/^sub//g;
			$check=eval $check;
			$::debug.=$@;
		} elsif($check eq '') {
			$check=1;
		}
		if($check eq 1) {
			my $opt=$::resource{"plugin_setting_" . $setting . "_list"};
			if($opt=~/^sub/) {
				$opt=~s/^sub//g;
				@optlist=eval $opt;
				$::debug.=$@;
			} else {
				foreach my $list(split(/,/,$opt)) {
					push(@optlist,$list);
				}
			}
			my $default=$::resource{"plugin_setting_" . $setting . "_default"};
			if($default=~/^sub/) {
				$default=~s/^sub//g;
				$default=eval $default;
				$::debug.=$@;
			}
			my $onclick=$::resource{"plugin_setting_" . $setting . "_onclick"};
			my $select=$::resource{"plugin_setting_" . $setting . "_select"};
			my $addhead=$::resource{"plugin_setting_" . $setting . "_addhead"};
			my $type=$::resource{"plugin_setting_" . $setting . "_type"};

			if($type eq "select") {
				$opts.=<<EOM;
<select name="_$setting"@{[$select ne "" ? " onchange='$select'" : ""]}>
EOM
			}
			foreach(@optlist) {
				my $checked;
				my $name;
				my $value;
				if(/:/) {
					($value,$name)=split(/:/,$_);
				} else {
					$name=$_;
					$value=$_;
				}
				my $js=$onclick;
				$js=~s/\$1/$value/g;
				$js=~s/\$skin/$::skin_url\/theme/g;
				my $head=$addhead;
				$head=~s/\$1/$value/g;
				$head=~s/\$skin/$::skin_url/g;
				$::IN_HEAD.=<<EOM;
$head
EOM
				if($type eq "select") {
					if($::setting_cookie{$setting} ne '') {
						$checked=qq( selected="selected") if($value eq $::setting_cookie{$setting});
					} else {
						$checked=qq( selected="selected") if($value eq $default);
					}
					$opts.=<<EOM;
<option value="$value" $selected>$name</option>
EOM
				} else {
					if($::setting_cookie{$setting} ne '') {
						$checked=qq( checked="checked") if($value eq $::setting_cookie{$setting});
					} else {
						$checked=qq( checked="checked") if($value eq $default);
					}
					$opts.=<<EOM;
<input type="radio" name="_$setting" value="$value" $checked @{[$js ne "" ? "onclick='$js';" : '']} />$name
EOM
				}
			}
			if($type eq "select") {
				$opts.=<<EOM;
</select>
EOM
			}
			$body.=<<EOM;
<tr><td>$::resource{"plugin_setting_" . $setting}</td><td>$opts</td></tr>
EOM
		}
	}
	$body.=<<EOM;
<tr><td>&nbsp;</td><td><input type="submit" name="submit" value="$::resource{plugin_setting_button}" /></td></tr>
</table>
</form>
EOM

	return('msg'=>"\t$::resource{plugin_setting_title}", 'body'=>$body);
}

1;
__END__

=head1 NAME

setting.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=setting
 rename lib/setting.inc.pl to lib/setting.inc.cgi

=head1 DESCRIPTION

A user's personal environment setup and it saves at cookie.

=head1 SETTING

=head1 設定

=head2 pyukiwiki.ini.cgi

=over 4

=item $::use_Setting

Enable menu of setting link.

=item $::cookie_expire

Setting save cookie expire.

=item $::cookie_refresh

Setting save cookie refresh time.

=item $::write_location=1

It cannot be used unless Location movement is effective.

=back

=head2 resource/setting.(lang).txt

=over 4

=item plugin_setting_(itemname)

Specify setting item name.

=item plugin_setting_(itemname)_check

It specifies whether this setup can be performed. To the beginning   When there is a character string called sub, it is after it.   perl A script is performed.

1: Enable, 0:Disabled.

When not carrying out this setup, enable setuped.

=item plugin_setting_(itemname)_list

Edit setting values list.

Exmple... "value:name,value:name" ...

To the beginning   When there is a character string called sub, it is after it. Perl script is performed and the array of the return value is specified as a list.

=item plugin_setting_(itemname)_default

Setting default value.

To the beginning   When there is a character string called sub, it is after it. Perl script is performed and the return value is specified as a default value.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/setting

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/setting/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/setting.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/setting.inc.pl>

=back

=head1 著者

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 ライセンス

@@LICENSE_NANAMI@@

=cut
