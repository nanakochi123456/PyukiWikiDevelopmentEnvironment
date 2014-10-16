######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_wiki.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 DESCRIPTION

PyukiWiki is yet another Wiki clone. Based on YukiWiki

PyukiWiki can treat Japanese WikiNames (enclosed with [[ and ]]).
PyukiWiki provides 'InterWiki' feature, RDF Site Summary (RSS),
and some embedded commands (such as [[# comment]] to add comments).

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_wiki.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_wiki.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_wiki.cgi>

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

=head2 do_read

=over 4

=item 入力値

title - ページ名 (変更する時のみ)

=item 出力

なし

=item オーバーライド

可

=item 概要

ページを読み込み、出力する。

=back

=cut

sub _do_read {
	my($title)=@_;
	$title=$::form{mypage} if($title eq '');
	# 固定ページからプラグインの起動				# comment
	foreach(keys %::fixedpage) {
		if($::fixedpage{$_} ne '' && $_ eq $::form{mypage}) {
			my $refer=&encode($::form{mypage});
			$::form{refer}=$refer;
			$::form{cmd}=$::fixedpage{$_};
			$ENV{QUERY_STING}="cmd=$::form{cmd}$amp;refer=$refer";
			$::form{mypage}='';
			return 0 if(&exec_plugin eq 1);
		}
	}
	# 読み込み認証									# comment
	if(!&is_readable($::form{mypage})) {
		&print_error($::resource{auth_readfobidden});
	}
	# 2005.11.2 pochi: 部分編集を可能に				# comment
	&skinex($title, &text_to_html($::database{$::form{mypage}}, mypage=>$::form{mypage}), 1, @_);
	return 0;
}

=lang ja

=head2 print_content

=over 4

=item 入力値

&print_content(wiki文章, ページ名);

=item 出力

HTML

=item オーバーライド

可

=item 概要

wiki文章をHTMLに変換する。(スキン用）

=back

=cut

sub _print_content {
	my ($rawcontent,$nowpagename) = @_;
	$::form{basepage}=$nowpagename eq '' ? $::form{mypage} : $nowpagename;
	return &text_to_html($rawcontent);
}

=lang ja

=head2 topicpath

=over 4

=item 入力値

なし

=item 出力

リンク文字列

=item オーバーライド

可

=item 概要

タイトルのURL,またはtopicpathを表示する。

プラグイン topicpath.inc.plがある場合、自動読み込みをする。

=back

=cut

sub _topicpath {
	my ($title)=@_;
	$title=$::form{mypage} if($title eq '');
	my $buf;
	if($::useTopicPath eq 1 && &exist_plugin("topicpath") ne 0) {
		$buf=&plugin_topicpath_inline("1,$title") if(&is_exist_page($title));
	}
	if($buf eq '') {
		my $cookedurl=$::basehref . '?' . &encode($title);
		return qq(<a href="$cookedurl">$cookedurl</a>);
	}
	return $buf;
}

=lang ja

=head2 get_fullname

=over 4

=item 入力値

&get_fullname(ページ名, 参照元ページ名);

=item 出力

アンカー名(１文字）

=item オーバーライド

可

=item 概要

正しいページ名を返す。

=back

=cut

sub _get_fullname {
	my ($name, $refer) = @_;
	return $refer if ($name eq '');
	if ($name eq $::separator) {
		$name = substr($name,1);
		return ($name eq '') ? $::FrontPage : $name;
	}
	return $refer if ($name eq "$::dot$::separator");
	if (substr($name,0,2) eq "$::dot$::separator") {
		return ($1) ? $refer . "$::separator" . $1 : $refer;
	}
	if (substr($name,0,3) eq "$::dot$::dot$::separator") {
		my @arrn = split($::separator, $name);
		my @arrp = split($::separator, $refer);

		while (@arrn > 0 and $arrn[0] eq "$::dot$::dot") {
			shift(@arrn);
			pop(@arrp);
		}
		$name = @arrp ? join($::separator,(@arrp,@arrn)) :
			(@arrn ? "$::FrontPage$::separator".join($::separator,@arrn) : $::FrontPage);
	}
	return $name;
}

=lang ja

=head2 get_subjectline

=over 4

=item 入力値

&get_subjectline(ページ名,行数,%オプション);

=item 出力

Plain文字列

=item オーバーライド

可

=item 概要

ページの１〜指定行を取得する。内容によっては２行目、３行目になることがある。

=back

=cut

sub _get_subjectline {
	my ($page, $lines,%option) = @_;
	$lines=1 if($lines+0 < 1);
	my $line;
	if (not &is_editable($page)) {
		return "";
	}
	# Delimiter check.								# comment
	my $delim = $subject_delimiter;
	$delim = $option{delimiter} if (defined($option{delimiter}));
	# Get the subject of the page.
	my $subject = $::database{$page};
	my $i=1;
	my $p=0;
	foreach (split(/\n/,$subject)) {
		s/\(\((.*)\)\)//gex;			# thanks to Ayase
		s/\#(.+?)$//g;
		s/\&([^<>{}]+?);//g;
		my $tmp=&text_to_html($_);
		$tmp=~s/\#(.+?)\n//g;
		$tmp=~s/\&([^<>{}]+?);//g;
		$tmp=~s/<.*?>//g;
		$tmp=&trim($tmp);
		if($tmp eq '') {
			if($p++ > 20) {
				next;
			}
		}
		$line.=$i eq 1 ? $tmp : "\n$tmp";
		last if($line ne '' && $i++ >= $lines);
	}
	$line=~s/\r?\n/\n/g;
	while($line=~/\n\n/) {
		$line=~s/\n\n/\n/g;
	}
	while($line=~/^\n/) {
		$line=~s/^\n//g;
	}
	while($line=~/\n$/) {
		$line=~s/\n$//g;
	}
	if($lines > 1) {
		return $line;
	}
	$line =~ s/\n.*//s;
	return "$delim$line";
}

=lang ja

=head2 get_info

=over 4

=item 入力値

&get_info(ページ名, キー);


=item 出力

取得した文字列

=item オーバーライド

可

=item 概要

InfoBaseから情報を取得する。

=back

=cut

sub _get_info {
	my ($page, $key) = @_;
	if ($key eq $info_IsFrozen) {
		return ($::database{$page} =~ /\n?#freeze\r?\n/) ? 1 : 0;
	}
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	&close_info_db;
	return $info{$key};
}

=lang ja

=head2 is_frozen

=over 4

=item 入力値

&is_frozen(ページ名);

=item 出力

0:凍結されていない 1:凍結されている。

=item オーバーライド

可

=item 概要

指定したページが凍結されているかチェックする。

=back

=cut

sub _is_frozen {
	my ($page) = @_;
	if($::newpage_auth eq 1) {
		return 1 if(!&is_exist_page($page));
	}
	return &get_info($page, $info_IsFrozen);
}

=lang ja

=head2 is_readable

=over 4

=item 入力値

&is_readable(ページ名);

=item 出力

ページ閲覧可・不可フラグ

=item オーバーライド

可

=item 概要

ページの閲覧可・不可フラグを返す。

=back

=cut

sub _is_readable {
	my($page)=@_;
	return 0 if($page eq $::RecentChanges);	# do not delete	# comment
	return 1;
}

=lang ja

=head2 is_editable

=over 4

=item 入力値

&is_editable(ページ名);

=item 出力

編集可・不可フラグ

=item オーバーライド

可

=item 概要

ページの新規作成・編集可・不可フラグを返す。

=back

=cut

sub _is_editable {
	my ($page) = @_;
	return 0 if($fixedpage{$page} || $fixedplugin{$::form{cmd}});
	return 0 if(
		$page=~/([\xa\xd\f\t\[\]])|(\.{1,3}\/)|^\s|\s$|^\#|^\/|\/$|^$|^$::ismail$/o);
	return 0 if (not &is_readable($page));
	return 1;
}


=lang ja

=head2 interwiki_convert

=over 4

=item 入力値

&interwiki_convert($type, $localname);


=item 出力

変換後の文字列

=item オーバーライド

可

=item 概要

InterWikiのURLへの変換をする。

=back

=cut

sub _interwiki_convert {
	my ($type, $localname) = @_;
	if ($type eq 'sjis' or $type eq 'euc' or $type eq 'utf8') {
		$localname=&code_convert(\$localname, $type, $::defaultcode)
			if($localname=~/[\xa1-\xfe]/);
		return &encode($localname);
	} elsif (($type eq 'ykwk') || ($type eq 'yw')) {
		# for YukiWiki1
		if ($localname =~ /^$wiki_name$/) {
			return $localname;
		} else {
			$localname=&code_convert(\$localname, 'sjis', $::defaultcode)
				if($localname=~/[\xa1-\xfe]/);
			return &encode("[[" . $localname . "]]");
		}
#	} elsif (($type eq 'asis') || ($type eq 'raw')) {		# comment
#		return $localname;									# comment
	} else {
		return $localname;
	}
}
1;
