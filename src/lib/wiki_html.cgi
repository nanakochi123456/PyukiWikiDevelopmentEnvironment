######################################################################
# @@HEADER1@@
######################################################################

	# 顔文字のテーブル											# comment

%::_facemark = (
	' :)'		=> 'smile',
	' (^^)'		=> 'smile',
	' :D'		=> 'bigsmile',
	' (^-^)'	=> 'bigsmile',
	' :p'		=> 'huh',
	' :d'		=> 'huh',
	' XD'		=> 'oh',
	' X('		=> 'oh',
	' ;)'		=> 'oh',
	' (;'		=> 'wink',
	' (^_-)'	=> 'wink',
	' ;('		=> 'sad',
	' :('		=> 'sad',
	' (--;)'	=> 'sad',
	' (^^;)'	=> 'worried',
	'&heart;'	=> 'heart',

# pukiwiki_style					# comment
	'&bigsmile;'=> 'bigsmile',
	'&huh;'		=> 'huh',
	'&oh;'		=> 'oh',
	'&sad;'		=> 'sad',
	'&smile;'	=> 'smile',
	'&wink;'	=> 'wink',
	'&worried;' => 'worried',

# 以下 PukiWiki Plusより			# comment
	'&big;'			=> 'extend_bigsmile',
	'&big_plus;'	=> 'extend_bigsmile',
	'&heart2;'		=> 'extend_heart',
	'&heartplus;'	=> 'extend_heart',
	'&oh2;'			=> 'extend_oh',
	'&ohplus;'		=> 'extend_oh',
	'&sad2;'		=> 'extend_sad',
	'&sadplus;'		=> 'extend_sad',
	'&smile2;'		=> 'extend_smile',
	'&smileplus;'	=> 'extend_smile',
	'&wink2;'		=> 'extend_wink',
	'&winkplus;'	=> 'extend_wink',
	'&worried2;'	=> 'extend_worried',
	'&worriedplus;'	=> 'extend_worried',
	'&ummr;'		=> 'umm',
	'&star;'		=> 'star',
	'&tear;'		=> 'tear',
);

	# 顔文字の正規表現											# comment
$::_facemark=q{@@exec="./build/facemark.regex"@@};
$::_facemark.=q{@@exec="./build/facemark_puki.regex"@@} if($::usePukiWikiStyle eq 1);

=head1 NAME

wiki_html.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_html.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_html.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_html.cgi>

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

=head2 init_dtd

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

DTDの初期化をする。

=back

=cut

sub _init_dtd {
	my ($xmlns)=@_;

	$xmlns=" $xmlns" if($xmlns ne "");

	# DTDの初期化										# comment
	%::dtd = (
		"html4"=>qq(<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n<html lang="$::lang"$xmlns>\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="text/html; charset=$::charset" />\n<meta http-equiv="Content-Style-Type" content="text/css" />\n<meta http-equiv="Content-Script-Type" content="text/javascript" />),
		"xhtml11"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang"$xmlns>\n<head>),
		"xhtml10"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" lang="$::lang" xml:lang="$::lang"$xmlns>\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"xhtml10t"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" lang="$::lang" xml:lang="$::lang"$xmlns>\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"xhtmlbasic10"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang"$xmlns>\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"html5_plugin"=>qq(<!doctype html>\n<html lang="$::lang"$xmlns>\n<head>\n<meta http-equiv="content-type" content="text/html; charset=$::charset" /><meta http-equiv="Content-Style-Type" content="text/css" />\n<meta http-equiv="Content-Script-Type" content="text/javascript" />),
	);

	$::dtd=$::dtd{$::htmlmode};
	$::dtd=$::dtd{html4} if($::dtd eq '') || &is_no_xhtml(0);
	$::dtd.=qq(\n<meta name="generator" content="PyukiWiki $::version" />\n);

	# XHTMLであるかのフラグを設定							# comment
	$::is_xhtml=$::dtd=~/xhtml/;
}

=lang ja

=head2 is_no_xhtml

=over 4

=item 入力値

HTTPヘッダであれば１、DTDであれば0

=item 出力

XHTML非対応ブラウザでは１を返す

全く見れないと思われるブラウザーでは２を返す。

=item オーバーライド

可

=item 概要

XHTML非対応ブラウザを判定する。

=back

=cut

sub _is_no_xhtml {
	my ($mode)=shift;

	# HTTPヘッダーを認識するか							# comment
	if($mode eq 1) {
		if($ENV{HTTP_USER_AGENT}=~/Opera\/(\d+)\.(\d+)/) {
			return 0 if($1 > 8);
		}
		if($ENV{HTTP_USER_AGENT}=~/Trident/) {
			return 0;
		}
		if($ENV{HTTP_USER_AGENT}=~/MSIE (\d+).(\d+)/) {
			return 0 if($1 >= 9);
		}
		if($ENV{HTTP_USER_AGENT}=~/Fire[Ff]ox\/(\d+)\./) {
			return 0 if($1 >= 3);
		}
		if($ENV{HTTP_USER_AGENT}=~/Chrome\/(\d+)\./) {
			return 0 if($1 >= 10);
		}
		if($ENV{HTTP_USER_AGENT}=~/Android/) {
			return 0;
		}
		if($ENV{HTTP_USER_AGENT}=~/Version\/(\d+).+Safari/) {
			return 0 if($1 > 4);
		}
		# Netscape and 該当ブラウザ						# comment
		if($ENV{HTTP_USER_AGENT}=~/Mozilla\/(\d+)\./ || $ENV{HTTP_USER_AGENT}=~/Netscape/) {
			return 1;
		}
		# robots (簡易)									# comment
		if($ENV{HTTP_USER_AGENT}=~/[Bb]ot|Slurp|Yeti|ScSpider|ask/) {
			return 1; # あえて、text/htmlヘッダーを出力	# comment
		}
		return 1;
	}

	# XHTMLを正確に認識するか							# comment
	if($ENV{HTTP_USER_AGENT}=~/Opera\/(\d+)\.(\d+)/) {
		return 0 if($1 > 6);
	}
	if($ENV{HTTP_USER_AGENT}=~/Trident/) {
		return 0;
	}
	if($ENV{HTTP_USER_AGENT}=~/MSIE (\d+.\d+)/) {
		return 0 if($1 >= 4);
	}
	if($ENV{HTTP_USER_AGENT}=~/Fire[Ff]ox\/(\d+)\./) {
		return 0 if($1 >= 3);
	}
	if($ENV{HTTP_USER_AGENT}=~/Chrome\/(\d+)\./) {
		return 0 if($1 >= 1);
	}
	if($ENV{HTTP_USER_AGENT}=~/Android/) {
		return 0;
	}
	if($ENV{HTTP_USER_AGENT}=~/Version\/(\d+).+Safari/) {
		return 0 if($1 > 3);
	}
	# Netscape and 該当ブラウザ
	if($ENV{HTTP_USER_AGENT}=~/Mozilla\/(\d+)\./ || $ENV{HTTP_USER_AGENT}=~/Netscape/) {
		return 1;
	}
	# robots (簡易)										# comment
	if($ENV{HTTP_USER_AGENT}=~/[Bb]ot|Slurp|Yeti|ScSpider|ask/) {
		return 0;
	}
	return 1;
}

=lang ja

=head2 meta_robots

=over 4

=item 入力値

&meta_robots(cmdname,ページ名,ページのHTML);

=item 出力

METAタグのHTML

=item オーバーライド

可

=item 概要

ロボット型検索エンジンへの最適化をする。

=back

=cut

sub _meta_robots {
	my($cmd,$pagename,$body)=@_;
	my $robots;
	my $keyword;
	if($cmd=~/edit|admin|diff|attach|backup|setting/
		|| $::form{mypage} eq '' && $cmd!~/list|sitemap|recent/
		|| $::form{mypage}=~/$::resource{help}|$::resource{rulepage}|$::RecentChanges|$::MenuBar|$::SideBar|$::TitleHeader|$::Header|$::Footer$::BodyHeader$::BodyFooter|$::SkinFooter|$::SandBox|$::InterWikiName|$::InterWikiSandBox|$::non_list/
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
<meta name="keywords" content="$::meta_keyword" />
EOD
	}
	return $robots;
}

=lang ja

=head2 text_to_html

=over 4

=item 入力値

&text_to_html(wiki文章,%オプション);

=item 出力

HTML

=item オーバーライド

可

=item 概要

wiki文章をHTMLに変換する。

=back

=cut

sub _text_to_html {
	# 2005.10.31 pochi: オプションを指定可能に				# comment
	my ($txt, %option) = @_;
	my (@txt) = split(/\r?\n/, $txt);
	my $verbatim;
	my $tocnum = 0;
	my (@saved, @result);
	my $prevline;
	my @col_style;
	unshift(@saved, "</p>");
	push(@result, "<p>");

	# add 0.2.0-p2
	return if($txt eq '');

	# 2006.1.30 pochi: 改行モードを設置						# comment
	$::lfmode=$::line_break;

	# 2005.10.31 pochi: 部分編集を可能に					# comment
	my $editpart = "";
	if($::partedit > 0) {
		if ($option{mypage}) {
			my ($title, $edit, $button);
			if (&is_frozen($option{mypage})) {
				$title = "admineditthispart";
				$edit = "adminedit";
				$button = "admineditbutton";
			} else {
				$title = "editthispart";
				$edit = "edit";
				$button = "editbutton";
			}
			my $enc_mypage = &encode($option{mypage});
			$enc_mypage =~ s/%/%%/og;
			if($::partedit eq 2 || $edit eq 'edit') {
				$editpart = qq(<div class="partinfo"><a class="icnpart" id="icn_partedit" title="$::resource{$title}" href="$::script?cmd=$edit&amp;mypage=$enc_mypage&amp;mypart=%d">@{[$::toolbar eq 2 ? qq(<span>$::resource{$button}</span>) : $::resource{$button}]}</a></div>);
			}
		}
	}

#	my $saved_ul_level=0;									# comment
#	my $saved_ol_level=0;									# comment

	my $backline;	# 複数行対応用							# comment
	my $backcmd;
	my $nest;
	my $lines=$#txt;
	foreach (@txt) {
		$lines--;
		next if($_ eq '#freeze');
		@col_style=() if(!/^(\,|\|)/);
#		chomp;
		# add 0.2.0-p2
		if($::linesave ne 0) {
			if($_ eq $::eom_string) {
				$::linesave=0;
				$::eom_string="";
				$::linedata=~s/\n$//g;
				push(@result, &$::exec_inlinefunc($::linedata));
				$::linedata="";
				next;
			}
			$::linedata.="$_\n";
			next;
		}

		# backline
		if($backline ne '') {
			$_=$backline . $_;
			$backline="";
		}
		# verbatim.
		if ($verbatim->{func}) {
			if (/^\Q$verbatim->{done}\E$/) {
				undef $verbatim;
				push(@result, splice(@saved));
			} else {
				push(@result, $verbatim->{func}->($_));
			}
			next;
		}
		# non-verbatim follows.
		push(@result, shift(@saved)) if (@saved and $saved[0] eq '</pre>' and /^[^ \t]/);
		my $escapedscheme=$_;
		# v0.1.6 url or mail scheme escape to [BS] or [TAB]	# comment
		if($escapedscheme=~/($::isurl|mailto:$ismail)/) {
			my $url1=$1;
			my $url2=$url1;
			$url2=~s!:!\x08!g;
			$url2=~s!/!\x07!g;
			$escapedscheme=~s!\Q$url1!$url2!g;
		}

		# 複数行対応処理									# comment
		if($::usePukiWikiStyle eq 1) {
			if(/^:(.*)[|:]+$/) {
				if($lines>0) {
					$backline=$_;
					next;
				}
			} elsif(/^(:|>{1,3}|-{1,3}|\+{1,3})(.+)~$/) {
				if($lines>0) {
					$backline="$1$2\x06";
					next;
				}
			}
		}

		# * ** *** **** *****								# comment
		if (/^(\*{1,5})(.+)/) {
			my $hn = "h" . (length($1) + 1);	# $hn = 'h2'-'h6'
			my $hedding = ($tocnum != 0)
				? qq(<div class="jumpmenu"><a href="@{[&htmlspecialchars($::form{cmd} ne 'read' ? "?$ENV{QUERY_STRING}" : &make_cookedurl($::pushedpage eq '' ? $::form{mypage} : $::pushedpage))]}#navigator">&uarr;</a></div>\n)
				: '';
			push(@result, splice(@saved),
#				$hedding . qq(<$hn id="@{[&pageanchorname($::form{mypage})]}$tocnum">) . &inline($2) . qq(</$hn>)
				$hedding . qq(<$hn id="@{[&makeanchor($::form{mypage}, $tocnum, $2)]}">) . &inline($2) . qq(</$hn>)
			);
			# 2005.10.31 pochi: 部分編集を可能に			# comment
			push(@result, sprintf($editpart, $tocnum + 2)) if($editpart);
			$tocnum++;
		# verbatim											# comment
		} elsif (/^{{{/) {	# OpenWiki like. Thanks wadldw.
			$verbatim = { func => \&inline, done => '}}}', class => 'verbatim-soft' };
			&back_push('pre', 1, \@saved, \@result, " class='$verbatim->{class}'");
		} elsif (/^(-{2,3})\($/) {
			if ($& eq '--(') {
				$verbatim = { func => \&inline, done => '--)', class => 'verbatim-soft' };
			} else {
				$verbatim = { func => \&escape, done => '---)', class => 'verbatim-hard' };
			}
			&back_push('pre', 1, \@saved, \@result, " class='$verbatim->{class}'");
		# hr												# comment
		} elsif (/^----/) {
			push(@result, splice(@saved), '<hr />');
		# - -- ---											# comment
		} elsif (/^(-{1,3})(.+)/) {
			my $class = "";
			my $level = length($1);
			if ($::form{mypage} ne $::MenuBar) {
				$class = " class=\"list" . length($1) . "\"";
#				$class = " class=\"list" . length($1) . "\" style=\"padding-left:16px;margin-left:16px;\"
			}
			&back_push('ul', length($1), \@saved, \@result, $class);
			push(@result, '<li>' . &inline($2) . '</li>');
		# + ++ +++											# comment
		} elsif (/^(\+{1,3})(.+)/) {
			my $class = "";
			if ($::form{mypage} ne $::MenuBar) {
#				$class = " class=\"list" . length($1) . "\" style=\"padding-left:16px;margin-left:16px;\"";
				$class = " class=\"plist" . length($1) . "\"";
			}
			&back_push('ol', length($1), \@saved, \@result, $class);
			push(@result, '<li>' . &inline($2) . '</li>');
		# : ... : ... / : ... | ...						# comment
		} elsif (/^:/) {
			$escapedscheme=~/^(:{1,3})(.+)/;
			my $chunk=$2;
			my $class = "";
			if ($::form{mypage} ne $::MenuBar) {
				$class=qq( class="list) . length($1) . qq(");
			}
			# thanks making testdata tenk*
			$chunk=~s/\[\[([^:\]]+?):((?!\[)[^\]]+?)\]\]/[[$1\x08$2]]/g
				while($chunk=~/\[\[([^:\]]+?):((?!\[)[^\]]+?)\]\]/);
			if ($chunk=~/^([^\|]+):(.+)\|(.*)/) {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($1) . '</dt>', '<dd>' . &inline("$2|$3") . '</dd>');
			} elsif ($chunk=~/^([^\|]+)\|(.*)/) {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($1) . '</dt>', '<dd>' . &inline($2) . '</dd>');
			} elsif ($chunk=~/^([^:]+):(.+)/) {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($1) . '</dt>', '<dd>' . &inline($2) . '</dd>');
			} else {
				&back_push('dl', 1, \@saved, \@result, $class);
				push(@result, '<dt>' . &inline($chunk) . '</dt>', '<dd></dd>');
			}
		# > >> >>> >>>> >>>>>							# comment
		} elsif (/^(>{1,5})(.+)/) {
			&back_push('blockquote', length($1), \@saved, \@result);
			push(@result, qq(<p class="quotation">))
				if($::usePukiWikiStyle eq 1);
			push(@result, &inline($2));
			push(@result, qq(</p>\n))
				if($::usePukiWikiStyle eq 1);
		# null											# comment
		} elsif (/^$/) {								# comment
			push(@result, splice(@saved));
			unshift(@saved, "</p>");
			push(@result, "<p>");
		# pre											# comment
		# 2005.11.16 pochi: 整形済み領域の行頭空白を削除	# comment
		} elsif (/^\s(.*)$/o) {
			&back_push('pre', 1, \@saved, \@result);
			push(@result, &htmlspecialchars($1,1)); # Not &inline, but &escape # comment
		# table											# comment
		} elsif (/^([\,|\|])(.*?)[\x0D\x0A]*$/) {
			&back_push('table', 1, \@saved, \@result,
				' class="style_table" cellspacing="1" border="0"',
				'<div class="ie5">', '</div>');
#######										# comment
# This part is taken from Mr. Ohzaki's Perl Memo and Makio Tsukamoto's WalWiki.	# comment
			my $delm = "\\$1";
			my $tmp = ($1 eq ',') ? "$2$1" : "$2";
			my @value = map {/^"(.*)"$/ ? scalar($_ = $2, s/""/"/g, $_) : $_}
				($tmp =~ /("[^"]*(?:""[^"]*)*"|[^$delm]*)$delm/g);
			my @align = map {(s/^\s+//) ? ((s/\s+$//) ? ' align="center"' : ' align="right"') : ''} @value;
			my @colspan = map {$_ eq '==' ? 0 : 1} @value;
			my $pukicolspan=1;
			my $thflag='td';

			for (my $i = 0; $i < @value; $i++) {
				if ($colspan[$i]) {
					if($::usePukiWikiStyle eq 1) {
						# <th>
						if($value[$i]=~/^\~/) {
							$value[$i]=~s/^\~//g;
							$thflag='th';
						} elsif($value[$i] eq '~') {
							$value[$i]="";
							# reserved rowspan
						}
						# right colspan
						if($value[$i] eq '>') {
							$value[$i]='';
							$pukicolspan++;
							next;
						}
					}
					while ($i + $colspan[$i] < @value and  $value[$i + $colspan[$i]] eq '==') {
						$colspan[$i]++;
					}
					$colspan[$i] = ($colspan[$i] > 1) ? sprintf(' colspan="%d"', $colspan[$i]) : '';
					if($pukicolspan > 1 && $::usePukiWikiStyle eq 1) {
						$colspan[$i] = sprintf(' colspan="%d"', $pukicolspan);
						$pukicolspan=1;
					}
					if($::usePukiWikiStyle eq 1) {
						$value[$i]=~ s!(LEFT|CENTER|RIGHT)\:!\ftext-align:$1;\t!g;
						$value[$i]=~ s!BGCOLOR\((.*?)\)\:(.*)!\fbackground-color:$1;\t$2!g;
						$value[$i]=~ s!COLOR\((.*?)\)\:(.*)!\fcolor:$1;\t$2!g;
						$value[$i]=~ s!SIZE\((.*?)\)\:(.*)!\ffont-size:$1px;\t$2!g;
						if($value[$i]=~/\f/) {
							$value_style[$i]=$value[$i];
							$value_style[$i]=~s!\t\f!!g;
							$value_style[$i]=~s!\t(.*)$!!g;
							$value_style[$i]=~s!\f!!g;
							$value[$i]=~s/\f(.*?)\t//g;
						}
						if($tmp=~/(\,|\|)c$/) {
							$col_style[$i]=$value_style[$i];
						} else {
							$value[$i] = sprintf('<%s%s%s class="style_%s" style="%s%s">%s</%s>', $thflag,$align[$i], $colspan[$i], $thflag,$col_style[$i],$value_style[$i],&inline($value[$i]),$thflag);
							$value_style[$i]="";
						}
					} else {
						$value[$i] = sprintf('<td%s%s class="style_td">%s</td>', $align[$i], $colspan[$i], &inline($value[$i]));
					}
				} else {
					$value[$i] = '';
				}
			}
			if($::usePukiWikiStyle eq 0) {
				push(@result, join('', '<tr>', @value, '</tr>'));
			} elsif($tmp=~/(\,|\|)h$/) {
				push(@result, join('', '<thead><tr>',@value,'</tr></thead>'));
			} elsif($tmp=~/(\,|\|)f$/) {
				push(@result, join('', '<tfoot><tr>',@value,'</tr></tfoot>'));
			} elsif($tmp!~/(\,|\|)c$/) {
				push(@result, join('', '<tr>', @value, '</tr>'));
			}
		# ====											# comment
		} elsif (/^====/) {
			if ($::form{show} ne 'all') {
				push(@result, splice(@saved), "<a href=\"$::script?cmd=read&amp;mypage="
					. &encode($::form{mypage}) . "&show=all\">$::resource{continue_msg}</a>");
				last;
			}
		# 2006.1.30 pochi: 改行モードを設置				# comment
		} elsif (/^\&\*lfmode\((\d+)\);$/o) {
			$::lfmode = $1;
			$_="";
			next;
		# ブロックプラグイン							# comment
		} elsif (/^$::embedded_name$/o) {
			s/^$::embedded_name$/&embedded_to_html($1)/gexo;
			&back_push('div', 1, \@saved, \@result);
			push(@result,$_);
		} else {
			# 2006.1.30 pochi: 改行モードを設置			# comment
#			&back_push('p', 1, \@saved, \@result);		# comment
			push(@result, &inline($_, ("lfmode" => $::lfmode)));
		}
	}
	push(@result, splice(@saved));
	# 2005.10.31 pochi: 部分編集を可能に				# comment
	if ($editpart && $::partfirstblock eq 1) {
		unshift(@result, sprintf($editpart, 1));
	}
	my $body=join("\n",@result);
	# v0.2.1
	if($::replace{$::lang} ne '') {
		foreach my $rep(/\s/, $::replace{$::lang}) {
			my ($bef, $aft)=split(/\//, $rep);
			$body=~s/$bef/$aft/g;
		}
	}
	$body=~s/edit\&mypage/edit\&amp;mypage/g;

	# add 0.2.0-p2
	if($::use_Highlight eq 1) {#nocompact
		$body=&highlight($body, $::form{word}) if($::form{word} ne '');#nocompact
	}#nocompact
	return $body if($::usePukiWikiStyle eq 0);
	my $tmp=$body;
	$tmp=~s/(<p>|<\/p>|\n)//g;
	return $body if($tmp ne '');
	return '';
}

=lang ja

=head2 highlight

=over 4

=item 入力値

HTML

=item 出力

HTML

=item オーバーライド

可

=item 概要

検索結果に対して、ハイライトを付加する。

=item 参考

compact版には、この関数はありません。

=back

=cut

sub _highlight {#nocompact
	my ($text, $wd)=@_;#nocompact
	my $spc="";#nocompact
	if($::highlight_exec eq 0 && $::pushedpage eq '') {#nocompact
		$::highlight_exec=1;#nocompact
		my $msg=$::resource{msg_word};#nocompact
		my $cwd=&highlight($wd, $wd);	# 検索ワードを再帰	#nocompact
		$::bodyheaderbody="<div><strong>$msg</strong>&nbsp;$cwd</div>";#nocompact
	}#nocompact
	my $spc;#nocompact
	if ($wd) {#nocompact
		if($::lang eq "ja") {#nocompact
			if($::defaultcode eq 'utf8') {#nocompact
				$spc="\xe3\x80\x80";#nocompact
			} else {#nocompact
				$spc="\xa1\xa1";#nocompact
			}#nocompact
		}#nocompact
	}#nocompact
	if($spc ne "") {#nocompact
		foreach(" ", $spc) {#nocompact
			$wd=~s/$_/\t/g;#nocompact
		}#nocompact
	}#nocompact
	$wd=~s/(\t+)/\t/g;#nocompact
	my @wd=split(/\t/,$wd);#nocompact
	my $searchcount=0;#nocompact
	if(&load_module("Nana::Search")) {#nocompact
		foreach(@wd) {#nocompact
			next if($_ eq '');
			$_=~s/[\x21-\x2f\x3a-\x40\x5b-\x60\x7b-\x7f]//g;
			$text=Nana::Search::SearchRe(#nocompact
				$text, $_	#nocompact
			, '<strong class="word' . $searchcount . '">'	#nocompact
			, '</strong>');#nocompact
			$searchcount=($searchcount + 1) % 10;#nocompact
		}#nocompact
	} else {#nocompact
		foreach(@wd) {#nocompact
			next if($_ eq '');
			my $strong='<strong class="word' . $searchcount . '">';#nocompact
			$text=~s/(?^:((?:\G|>)[^<]*?))($_)/$1$strong$2<\/strong>/g;#nocompact
			$searchcount=($searchcount + 1) % 10;#nocompact
		}#nocompact
	}#nocompact
	return $text;#nocompact;
}#nocompact

=lang ja

=head2 pageanchorname

=over 4

=item 入力値

ページ名

=item 出力

アンカー名(１文字）

=item オーバーライド

可

=item 概要

ページ名に対するアンカー名を出力する。

=back

=cut

sub _pageanchorname {
	my ($page)=@_;
	return 'm' if($page eq $::MenuBar && $::MenuBar ne '');
	return 'r' if($page eq $::RightBar && $::RightBar ne '');
	return 'h' if($page eq $::Header && $::Header ne '');
	return 'f' if($page eq $::Footer && $::Footer ne '');
	return 's' if($page eq $::SkinFooter && $::SkinFooter ne '');
	return 'i';
}

=lang ja

=head2 makeanchor

=over 4

=item 入力値

ページ名、通し番号、アンカー候補文字列

=item 出力

アンカー名

=item オーバーライド

可

=item 概要

アンカー名を出力する。

=back

=cut

sub _makeanchor {
	my($page, $tocnum, $title)=@_;
	$title=&inlinetext($title);
	my $s="$page$title";
	return &pageanchorname($page) . &dbmname($s) . $tocnum;
}

=lang ja

=head2 inlinetext

=over 4

=item 入力値

wiki文

=item 出力

テキスト

=item オーバーライド

可

=item 概要

テキストのみを出力する。

=back

=cut

sub _inlinetext {
	my($s)=@_;
	$s=&inline($s);
	$s =~ s/<[^>]+>//g;
	$s;
}

=lang ja

=head2 back_push

=over 4

=item 入力値

&backpush($tag, $level, $savedref, $resultref, $attr, $with_open, $with_close);

=item 出力

なし

=item オーバーライド

可

=item 概要

HTMLをpushする。

=back

=cut

sub _back_push {
	my ($tag, $level, $savedref, $resultref, $attr, $before_open, $after_close,$after_open,$before_close) = @_;
	while (@$savedref > $level) {
		push(@$resultref, shift(@$savedref));
	}
	if ($savedref->[0] ne "$before_close</$tag>$after_close") {
		push(@$resultref, splice(@$savedref));
	}
	while (@$savedref < $level) {
		unshift(@$savedref, "$before_close</$tag>$after_close");
		push(@$resultref, "$before_open<$tag$attr>$after_open");
	}
}

=lang ja

=head2 inline

=over 4

=item 入力値

&inline(インラインのwiki文章,%option);

=item 出力

HTML

=item オーバーライド

可

=item 概要

インラインのwiki文章をHTMLに変換する。

=back

=cut

$::_inline_attr="";

sub _inline {
	#2006.1.30 pochi: オプションを指定可能に
	my ($line, %option) = @_;
	$line =~ tr|\x08|:|;				# escaped scheme v0.1.6	# comment
	$line =~ tr|\x07|/|;				# escaped scheme v0.1.6	# comment
	$line =~ s|^//.*||g;				# Comment				# comment
										# Comment # debug		# comment
	$line =~ s|\s//\s\#.*$||g;
	$line = &htmlspecialchars($line);

#	$line=~s!$::_inline!<$::_inline{$1}>$2</$::_inline{$1}>!go;	# comment

	$line =~ s|'''(.+?)'''|<em>$1</em>|g;			# Italic		# comment
	$line =~ s|''(.+?)''|<strong>$1</strong>|g;		# Bold			# comment
	$line =~ s|%%%(.+?)%%%|<ins>$1</ins>|g;			# Insert Line	# comment
	$line =~ s|%%(.+?)%%|<del>$1</del>|g;			# Delete Line	# comment
	$line =~ s|\^\^(.+?)\^\^|<sup>$1</sup>|g;		# sup			# comment
	$line =~ s|__(.+?)__|<sub>$1</sub>|g;			# sub			# comment

	$line =~ s|(\d\d\d\d-\d\d-\d\d \(\w\w\w\) \d\d:\d\d:\d\d)|<span class="date">$1</span>|g;	# Date	# comment

	if($::usePukiWikiStyle eq 1) {
		if($line=~/~$/) {
			if($line=~/^(LEFT|CENTER|RIGHT|RED|BLUE|GREEN):/) {
				$::_inline_attr=$1;
				$line=~s/^$::_inline_attr://g;
			}
		} else {
			$::_inline_attr="";
		}
		if($::_inline_attr ne '') {
			$line="$::_inline_attr:$line";
		}
	}
	#2006.1.30 pochi: 改行モードを設置				# comment
	if ($option{"lfmode"}) {
		if ($line !~ /^$::embedded_name$/o) {
			if (!($line =~ s/\\$//o)) {
				$line .= "<br />";
			}
		}
	} else {
		$line =~ s|~$|<br />|g;
		$line =~ s|\x06|<br />|g;			# escaped scheme v0.1.6	# comment
	}

	$line =~ s!^(LEFT|CENTER|RIGHT):(.*)$!<div style="text-align:$1">$2</div>!g;
	$line =~ s!^(RED|BLUE|GREEN):(.*)$!<font color="$1">$2</font>!g;# Tnx hash. # comment

	if($::usePukiWikiStyle eq 1) {
		$line =~ s!BGCOLOR\((.*?)\)\s*\{\s*(.*)\s*\}!<span style="background-color:$1">$2</span>!g;
		$line =~ s!COLOR\((.*?)\)\s*\{\s*(.*)\}!<span style="color:$1">$2</span>!g;
		$line =~ s!SIZE\((.*?)\)\s*\{\s*(.*)\s*\}!<span style="font-size:$1px">$2</span>!g;
	}

#	$line =~ s!&amp;version;!$::version!g;
	$line =~ s!&version;!$::version!g;
	$line =~ s!($::inline_regex)!&make_link($1)!geo;
	$line =~ s!($embedded_inline)!&embedded_inline($1)!geo
		if($::usePukiWikiStyle eq 1);	# 2ネストまで許す			# comment

	$line =~ s|\(\((.*)\)\)|&note($1)|gex;
	$line =~ s|\(\((.*)\)\)||gex;

	$line =~ s|\[\#(.*)\]|<a class="anchor_super" id="$1" href="#$1" title="$1">$::_symbol_anchor</a>|g;

	# 顔文字													# comment
	if ($::usefacemark == 1) {
#		$line=~s!($::_facemark)!<img src="$::image_url/face/$::_facemark{$1}" alt="@{[htmlspecialchars($1,1)]}" />!go;
		$line=~s!($::_facemark)!<span class="icnface" id="icn_$::_facemark{$1}">&nbsp;&nbsp;</span>!go;
	}
	return $line;
}

=lang ja

=head2 note

=over 4

=item 入力値

&note(注釈のインラインwiki文章);

=item 出力

注釈へのリンクHTML

=item オーバーライド

可

=item 概要

注釈を一時保存し、注釈へのアンカーリンクを生成する。

=back

=cut

sub _note {
	my ($msg) = @_;
	$msg=&highlight($msg, $::form{word}) if($::form{word} ne '');#nocompact
	push(@::notes, $msg);
	# thanks to Ayase
	return "<a @{[$::is_xhtml ? 'id' : 'name']}=\"notetext_" . @::notes . "\" "
		. "href=\"" . &make_cookedurl(&encode($::form{mypage})) . "#notefoot_" . @::notes . "\" class=\"note_super\">*"
		. @::notes . "</a>";
}
1;
