######################################################################
# @@HEADER2_YASHIGANIMODOKI@@
######################################################################
# 作者音信普通の為、承諾がとれていませんが、便宜の上で
# v0.1.6対応版を配布することとしました。
# その他、少し機能向上しています。
# PyukiWiki Developer Term
######################################################################
# 使い方
#
# #popular(10(件数),FrontPage|MenuBar,[total/today/yesterday...],[notitle])
#
# ・件数：表示する件数
# ・非対象ページ：対象外のページを正規表現で記述する
# ・total/today/yesterday：全件対象か、今日だけか、昨日だけかを選択
#   $::CountView=2であれば、以下も使用できます。
#   week - 今週の合計
#   lastweek - 先週の合計
# ・notitle：文字列を指定するとタイトルが表示されなくなる。
# なお、popurarを使用すると、自動的にpopular.inc.plがインクルード
# されます。
######################################################################

######################################################################
# 作者音信普通の為、承諾がとれていませんが、便宜の上で
# v0.1.6対応版を配布することとしました。
# その他、少し機能向上しています。
# PyukiWiki Developer Term
######################################################################
# 使い方
#
# #popular(10(件数),FrontPage|MenuBar,[total/today/yesterday...],[notitle])
#
# ・件数：表示する件数
# ・非対象ページ：対象外のページを正規表現で記述する
# ・total/today/yesterday：全件対象か、今日だけか、昨日だけかを選択
#   $::CountView=2であれば、以下も使用できます。
#   week - 今週の合計
#   lastweek - 先週の合計
# ・notitle：文字列を指定するとタイトルが表示されなくなる。
# なお、popurarを使用すると、自動的にpopular.inc.plがインクルード
# されます。
######################################################################

# キャッシュ保持時間(20分)
$popular::cache_expire=20*60
	if(!defined($popular::cache_expire));

######################################################################

use strict;
use Nana::Cache;
use Nana::MD5 qw(md5_hex);

sub plugin_popular_convert {
	my $argv = shift;
	my ($limit, $ignore_page, $flag, $notitle) = split(/,/, $argv);

	return qq(<div class="error">counter.inc.pl can't require</div>)
		if (&exist_plugin("counter") ne 1);

	if ($limit+0 < 1) {$limit = 10;}
	if ($ignore_page eq '') {$ignore_page = '^FrontPage$|MenuBar$';}
	if ($::non_list  ne '') {$ignore_page .= "|$::non_list";}

	$flag=lc $flag;
	$flag="total" if($flag eq '');

	my $exist_urlhack=-r "$::explugin_dir/urlhack.inc.cgi";
	my $cachefile=&md5_hex("$limit-$ignore_page-$flag-$::lang-$exist_urlhack");

	my $cache=new Nana::Cache (
		ext=>"popular",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>365 * 86400,
	);

#	$cache->check(
#		"$::plugin_dir/popular.inc.pl",
#		"$::res_dir/popular.$::lang.txt",
#		"$::explugin_dir/Nana/Cache.pm"
#	);

	my $out=$cache->read($cachefile);
	my $cache2=new Nana::Cache (
		ext=>"popular",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>$popular::cache_expire,
	);

	$cache2->check(
		"$::plugin_dir/popular.inc.pl",
		"$::res_dir/popular.$::lang.txt",
		"$::explugin_dir/Nana/Cache.pm"
	);

	my $tmp=$cache2->read($cachefile);

	if($out eq '') {
		$out=&plugin_popular_make($cachefile, $ignore_page, $flag, $notitle, $limit);
		$cache->write($cachefile,$out);
		return $out;
	}
	my $pid;

	if($tmp eq '') {
		$pid=fork;
		unless(defined $pid) {
			$out=&plugin_popular_make($cachefile, $ignore_page, $flag, $notitle, $limit);
			$cache->write($cachefile,$out);
			return $out;
		} else {
			if($pid) {
				$cache->write($cachefile,$out);
				local $SIG{ALRM} = sub { die "time out" };
				eval {
					alerm(1);
					wait;
					alerm(0);
				};
				if ($@ =~ /time out/) {
					return $out;
				} else {
					return $out;
				}
			} else {
				close(STDOUT);
				$out=&plugin_popular_make($cachefile, $ignore_page, $flag, $notitle, $limit);
				$cache->write($cachefile,$out);
				exit;
			}
		}
	}
	return ' ' if($out eq '');
	return $out;
}

sub plugin_popular_make {
	my($cachefile, $ignore_page, $flag, $notitle, $limit)=@_;
	my $out;
	my @populars;
	my $count = 0;

	foreach my $page (sort keys %::database) {
		next if !&is_exist_page($page);
		next if $page =~ /^($::RecentChanges)$/;
		next if $page =~ /($ignore_page)/;
		next unless(&is_readable($page));

		my $cnt=&plugin_counter_selection($flag,&plugin_counter_do($page,"r"));
#			push @populars, sprintf("%10d\t%s",$cnt,$page)
#				if($cnt > 0);
		push @populars, sprintf("%d\t%s",$cnt,$page)
			if($cnt > 0);
	}
	foreach my $key (sort { $b<=>$a } @populars) {
		last if ($count >= $limit);
		my ($cnt,$page)=split(/\t/,$key);
		$out .= "<li>" . &make_link(&armor_name($page)) . "<span class=\"popular\">($cnt)</span></li>\n";
		$count++;
	}
	if ($out) {
		$out =  '<ul class="popular_list">' . $out . '</ul>';
	}

	if($notitle ne 'notitle') {
		if ($::resource{"popular_plugin_$flag\_frame"}) {
			$out=sprintf $::resource{"popular_plugin_$flag\_frame"}, $count, $out;
		}
	}
	return $out;
}

1;
__END__

=head1 NAME

popular.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #popular(20,FrontPage|MenuBar,today)

=head1 DESCRIPTION

A popular page is displayed in a list.

It corresponds to v0.1.6 and popular.inc.pl by which Mr. YASIganiModoki was created is improved.

=head1 USAGE

 #popular(max view pages, regex of disable view page[,total|today|yesterday][,notitle])

=over 4

=item max view pages

Cases to display of number. Default is 10.

=item regex of disable view page

The list of pages which are not displayed is set up with a regular expression.

=item total|today|yesterday

The display of all accesses, today's display, and yesterday's display are set up. Default is all accesses.

=item notitle

No display popular title

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/popular

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/popular/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/popular.inc.pl>

=item PyukiWiki/Plugin/popular

for 0.1.5 or minor

L<http://hpcgi1.nifty.com/it2f/wikinger/pyukiwiki.cgi?PyukiWiki%2f%a5%d7%a5%e9%a5%b0%a5%a4%a5%f3%2fpopular>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_YASIGANIMODOKI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_YASIGANIMODOKI@@

=cut
