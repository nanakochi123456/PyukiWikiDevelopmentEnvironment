######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# sitemaps
# based on PukiWiki Google Sitemaps by Terai Atsuhiro
# http://terai.xrea.jp/PukiWiki/Google.html
# http://www.google.com/webmasters/sitemaps/login
# http://www.sitemaps.org/
######################################################################

use Nana::Sitemaps;

# always, hourly, daily, weekly, monthly, yearly, never
$sitemaps::freq="always"
	if(!defined($sitemaps::freq));

$sitemaps::defaultpriority="0.5"
	if(!defined($sitemaps::defaultpriority));

$sitemaps::defaultpriority_FrontPage="0.8"
	if(!defined($sitemaps::defaultpriority_FrontPage));

$sitemaps::defaultpriority_MenuPage="0.0"
	if(!defined($sitemaps::defaultpriority_MenuPage));

$sitemaps::defaultpriority_SysPage="0.0"
	if(!defined($sitemaps::defaultpriority_SysPage));

$sitemaps::indexfirst=2000
	if(!defined($sitemaps::indexfirst));

sub plugin_sitemaps_action {
	my $sitemaps;
	&getbasehref;
	my $base=$::basehref;
	$base=~s/\/$//;

	my @pages=keys %::database;
	my $pages=$#pages + 1;

	if($pages < $sitemaps::indexfirst || $::form{page}+0 ne 0) {
		$sitemaps = new Nana::Sitemaps(
			version => '1.0',
			encoding => "UTF-8",
		);
		for(my $i=0; $i < $sitemaps::indexfirst; $i++) {
			my $list=$pages[
				$i +
				($::form{page}+0 ne 0
					? $::form{page} - 1
					: 0)
			];
			next if($list eq "");

			my $title = &unarmor_name($list);
			my $escaped_title = &escape($title);
			my $link = $modifier_rss_link . &make_cookedurl($title);
			my $description = $escaped_title . &escape(&get_subjectline($title));
			my $t=$::database{"__update__" . $list};
#			my $date=&date("Y-m-dTH:i:s", $t, "gmtime") . "Z";
			my $date=&date("Y-m-d", $t, "gmtime");
#			$link="";
#			$link=~s!://!\t!g;
#			$link=~s!//!/!g;
#			$link=~s!\t!://!g;

			if(&is_readable($title) && $title!~/$::non_list/) {
				my $priority=$sitemaps::defaultpriority;
				if($title eq $::FrontPage) {
					$priority=$sitemaps::defaultpriority_FrontPage;
				} elsif($title=~/$::MenuBar|$::SideBar|$::TitleHeader|$::Header|$::Footer|$::BodyHeader|$::BodyFooter|$::SkinFooter/) {
					$priority=$sitemaps::defaultpriority_MenuPage;
				} elsif($title=~/$::SandBox|$::InterWikiName|$::InterWikiSandBox|$::ErrorPage|$::AdminPage|$::IndexPage|$::SearchPage|$::CreatePage|$::resource{help}/) {
					$priority=$sitemaps::defaultpriority_SysPage;
				}
				my $body=$::database{$list};
				if($body=~/#sitemaps\((\d\.\d)\)/) {
					$priority=$1;
				}
				$sitemaps->add_item(
					title => $escaped_title,
					link  => "$base$link",
					dc_date => $date,
					priority=> $priority,
					changefreq=> $sitemaps::freq,
				);
			}
		}
	} else {
		$sitemaps = new Nana::Sitemaps(
			version => '1.0',
			encoding => "UTF-8",
			index => 1,
		);
		my $c=0;
		my $p=1;
		my $dc_date=0;
		foreach my $list(@pages) {
			my $title = &unarmor_name($list);
			my $escaped_title = &escape($title);
#			my $date=&date("Y-m-dTH:i:s", $t, "gmtime") . "Z";
			my $date=&date("Y-m-d", $t, "gmtime");

			if(&is_readable($title) && $title!~/$::non_list/) {
				my $t=$::database{"__update__" . $list};
				$dc_date=$dc_date < $ t ? $t : $dc_date;
				$c++;
				if($c >= $sitemaps::indexfirst) {
					$sitemaps->add_item(
						link  => "$base?cmd=sitemaps&amp;page=$p",
						dc_date => &date("Y-m-d", $dc_date, "gmtime"),
					);
					$p++;
					$c=0;
					$dc_date=0;
				}
			}
		}
		if($c > 0) {
			$sitemaps->add_item(
				link  => "$base?cmd=sitemaps&amp;page=$p",
				dc_date => &date("Y-m-d", $dc_date, "gmtime"),
			);
		}
	}
	# print RSS information (as XML).
	my $body=$sitemaps->as_string;
	if($::lang eq 'ja') {
		$body=&code_convert(\$body, 'utf8');
	}
	print &http_header("Content-type: text/xml");
	print $body;
	&close_db;
	exit;
}

sub plugin_sitemaps_inline {
	return ' ';
}

sub plugin_sitemaps_convert {
	return ' ';
}

1;
__END__
