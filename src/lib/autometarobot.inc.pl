######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'autometarobot.inc.cgi'
######################################################################
#
# ページからロボット型検索エンジンへのキーワードを自動生成する
#
# 注意点：
# ・検索キーワードがあまりにも好みでないのであれば、
# 　適当にwiki自体の強調文字等を設定してみたり、解除してみたり
# 　してみて下さい。
#
######################################################################

$::auto_meta_maxkeyword=100								# 自動キーワードの抽出単語数
	if(!defined($::auto_meta_maxkeyword));				# 0なら抽出しない
$::auto_meta_minlength=5								# 自動キーワードの最小文字数
	if(!defined($::auto_meta_minlength));

#############################

# Initlize												# comment

sub plugin_autometarobot_init {
	return ('init'=>1, 'func'=>'meta_robots', 'meta_robots'=>\&meta_robots);
}

# hack wiki.cgi of meta_robots

sub meta_robots {
	my($cmd,$pagename,$body)=@_;
	my $robots;
	my $keyword;
	if($cmd=~/edit|admin|diff|attach|backup|setting/
		|| $::form{mypage} eq '' && $cmd!~/list|sitemap|recent/
		|| $::form{mypage}=~/$::resource{help}|$::resource{rulepage}|$::RecentChanges|$::MenuBar|$::SideBar|$::TitleHeader|$::Header|$::Footer|$::BodyHeader|$::BodyFooter|$::SkinFooter|$::SandBox|$::InterWikiName|$::InterWikiSandBox|$::non_list/
		|| $::meta_keyword eq "" || lc $::meta_keyword eq "disable"
		|| &is_readable($::form{mypage}) eq 0) {
		$robots.=<<EOD;
<meta name="robots" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
<meta name="googlebot" content="NOINDEX,NOFOLLOW,NOARCHIVE" />
EOD
	} else {
		$robots.=<<EOD;
<meta name="robots" content="INDEX,FOLLOW" />
<meta name="googlebot" content="INDEX,FOLLOW,ARCHIVE" /> 
EOD
		$keyword=$::meta_keyword;
		if($::auto_meta_maxkeyword>0) {
			# 以下キーワード自動生成						# comment
			my @keyword;
			$keyword="$::wiki_title,$::meta_keyword," . &htmlspecialchars($pagename) . ",";
			# <h?>〜</h?>、強調、WikiName						# comment
			foreach($body=~/(<h\d>(.+?)<\/h\d>|<strong>(.+?)<\/strong>|$::wiki_name)/g) {
				s/[\x0d\x0a]//g;
				s/<.*?>//g;
				$keyword.="$_,";
			}
			# img alt="〜", a title="〜"						# comment
			foreach($body=~/<(?:a|img)(?:.+?)(?:alt|title)="(.+?)"(?:.+)>/g) {
				next if(/^$::non_list|$::isurl/);
				s/[\x0d\x0a]//g;
				s/<.*?>//g;
				next if(/$::resource{editthispage}|$::resource{admineditthispage}/);
				$keyword.="$_,";
			}
			$keyword=~s/$::_symbol_anchor//g;

			# UTF-8版でEUCにコンバートする。						# comment
			$keyword=&code_convert(\$keyword,'euc',$::defaultcode);#utf8
			$keyword=~s/([\x0-\x2f|\x3a-\x40|\x5b-\x60|\x7b-\x7f]|(?:\xA1\xA1))/,/g;

			my $ascii = '[\x00-\x7F]'; # 1バイト EUC-JP文字
			my $twoBytes = '(?:[\x8E\xA1-\xFE][\xA1-\xFE])'; # 2バイト EUC-JP文字	# comment
			my $threeBytes = '(?:\x8F[\xA1-\xFE][\xA1-\xFE])'; # 3バイト EUC-JP文字	# comment
			$keyword=~s/($ascii)($twoBytes|threeBytes)/$1,$2/g;
			$keyword=~s/($twoBytes|threeBytes)($ascii)/$1,$2/g;
			my @keyword;
			foreach(split(/,/,$keyword)) {
				push(@keyword,$_)
					unless(length($_) < $::auto_meta_minlength);
			}
			$keyword="";
			my $i=0;
			foreach(@keyword) {
				unless($keyword=~/\,$_/) {
					$keyword.="$_,";
					last if(++$i >= $::auto_meta_maxkeyword);
				}
			}
			$keyword=~s/,$//g;
			# UTF-8版でEUCからUTF-8に戻す						# comment
			$keyword=&code_convert(\$keyword,$::defaultcode,'euc');#utf8
		}
		$robots.=<<EOD;
<meta name="keywords" content="$keyword" />
EOD
	}
	return $robots;
}

1;
__DATA__
sub plugin_autometarobot_setup {
	return(
		ja=>'検索エンジン向け自動キーワード生成',
		en=>'Auto generation keyword for robot of search engine',
		require=>'',
		override=>'meta_robots',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/autometarobot/'
	);
}
__END__
=head1 NAME

autometarobot.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

The keyword for robot type search engines is generated automatically.

=head1 USAGE

rename to autometarobot.inc.cgi

=head1 OVERRIDE

meta_robots function was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/autometarobot

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/autometarobot/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/autometarobot.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
