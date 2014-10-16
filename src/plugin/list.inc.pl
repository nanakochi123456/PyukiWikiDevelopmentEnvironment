######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# v0.2.1 maxpage / kana index with mecab
# v0.2 non_list
# v0.1
######################################################################

$list::usemecab=0
	if(!defined($list::usemecab));

$list::mecab_code="euc"
	if(!defined($list::mecab_code));

$list::maxlist=100
	if(!defined($list::maxlist));

$list::pgcounts=5
	if(!defined($list::pgcounts));

sub plugin_list_action {
	my $navi = qq(\n<div id="body"><div id="top" style="text-align:center">);
	my @body;
	my $prev = '';
	my $char = '';
	my $idx = 1;
	my $cnt = 0;
	my $pg=1;
	my $page;

	my $k;
	my $c;
	if($list::usemecab eq 1) {
		&load_module("Nana::Cache");
		&load_module("Nana::Kana");
		$k=new Nana::Kana(code=>$list::mecab_code);

		$c=new Nana::Cache (
			ext=>"list",
			files=>1000000,
			dir=>$::cache_dir,
			size=>10000000,
			use=>1,
			expire=>86400,
		);
	}

	my $displaypage=$::form{page}+0;
	$displaypage=1 if($displaypage < 1);

	my @list=();
	foreach my $page (sort keys %::database) {
		next if ($page =~ $::non_list);
		next unless(&is_readable($page));

		if($list::usemecab eq 1) {
			my $dbm=&dbmname($page);
			if(!($char=$c->read($dbm,1))) {
				$char=$k->yomi1($page);
				$char=$k->idx($char);
				$c->write($dbm, $char)
					if($char ne "");
			}
			push(@list, "$char\t$page")
				if($char ne "");
		}
		if($list::usemecab eq 0 || $char eq "") {
			$char = substr($page, 0, 1);
			if (!($char =~ /[a-zA-Z0-9]/)) {
				$char = $::resource{list_plugin_otherchara};
			}
			push(@list, "$char\t$page");
		}
	}
	foreach my $p (sort @list) {
		$cnt++;
		if($cnt > $list::maxlist) {
			$cnt=0;
			$pg++;
		}
		($char, $page)=split(/\t/, $p);
		if ($prev ne $char) {
			if ($prev ne '') {
				$navi .= " |\n";
				$body[$pg] .= "  </ul>\n </li>\n</ul>\n";
			}
#			$prev = $char;
			$navi .= qq(<a id="top_$idx" href="?cmd=list&amp;page=$pg#head_$idx"><strong>$char</strong></a>);
		}
		if ($prev ne $char || $body[$pg] eq "") {
			$body[$pg] .= <<"EOD";
<ul>
 <li><a id="head_$idx" href="?cmd=list&amp;page=$cnt#top_$idx"><strong>$char</strong></a>
  <ul>
EOD
			$prev = $char;
			$idx++;
		}
		$body[$pg] .= qq(<li><a href="@{[&make_cookedurl(&encode($page))]}">@{[&escape($page)]}</a>@{[&escape(&get_subjectline($page))]}</li>\n);
	}
	$navi.=qq(</div>);
	my $lastpage;
	for(my $i=1; $body[$i] ne ""; $i++) {
		$body[$i] .= qq(</ul></li></ul></li></ul></div>);
		$lastpage=$i;
	}
	my $pgcounts=$list::pgcounts;
	my $pagenavi;
	if($lastpage > 1 || 1) {
		my $minpage=$displaypage - $pgcounts < 1 ? 1 : $displaypage - $pgcounts;
		my $prevpage=$displaypage - 1 < 1 ? 1 : $displaypage - 1;
		my $maxpage=$minpage eq 1 ? $pgcounts * 2 : $lastpage < $displaypage + $pgcounts - 1 ? $lastpage : $displaypage + $pgcounts;
		my $nextpage=$lastpage < $displaypage + 1 ? $lastpage : $displaypage + 1;
		$maxpage=$maxpage > $lastpage ? $lastpage : $maxpage;
		$minpage=$maxpage eq $lastpage ? ($maxpage - $pgcounts * 2 < 1 ? 1 : $maxpage - $pgcounts * 2) : $minpage;

		$pagenavi=qq([<a id="pg_first" href="?cmd=list&amp;page=1">$::resource{list_firstpage}</a>]);
		$pagenavi.=qq([<a id="pg_prev" href="?cmd=list&amp;page=$prevpage">$::resource{list_prevpage}</a>]);
		for(my $i=$minpage; $i<=$maxpage; $i++) {
			if($displaypage eq $i) {
				$pagenavi.=qq([<strong id="pg_$i">$i</strong>]&nbsp;);
			} else {
				$pagenavi.=qq([<a id="pg_$i" href="?cmd=list&amp;page=$i">$i</a>]&nbsp;);
			}
		}
		$pagenavi.=qq([<a id="pg_next" href="?cmd=list&amp;page=$nextpage">$::resource{list_nextpage}</a>]);
		$pagenavi.=qq([<a id="pg_last" href="?cmd=list&amp;page=$lastpage">$::resource{list_lastpage}</a>]);
		$pagenavi=qq(<div align="center">$pagenavi</div>);
		$body[$displaypage]=$pagenavi . "<hr />" . $body[$displaypage] . "<hr />" . $pagenavi;
	}

	return ('msg' => "\t$::resource{list_plugin_title}", 'body' => $navi . $body[$displaypage]);
}
1;
__END__

=head1 NAME

list.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=list

=head1 DESCRIPTION

Display all page list.

=head1 TIPS

If install perl module MeCab or Text::MeCab, making index with hiragana

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/list

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/list/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/list.inc.pl>

=item mecab

L<http://mecab.googlecode.com/>

=item Text-MeCab

L<http://search.cpan.org/~dmaki/Text-MeCab-0.20013/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
