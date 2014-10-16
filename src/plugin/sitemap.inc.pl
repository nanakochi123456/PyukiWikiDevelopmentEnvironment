######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# �����ȥޥåץץ饰����Ǥϡ�����Ū�פ˥桼������ʥӥ��������
# ���䤹������ץ饰����Ǥ���
#
# ���Ҥˤϡ��ʲ��Τ褦�ʥ롼�뤬����ޤ���
#
# MenuBar�Ǥϰʲ��Τ褦�˵��Ҥ���
# ***����̾
# [[WikiName]]
# [[�ڡ���]]
# (WikiName�����Ǥ�ư���ޤ���)
#
# MenuBar����Ͽ���줿�ڡ����Ǥϡ��ʲ��Τ褦�˵��Ҥ���
# -[[WikiName]] (WikiName�����Ǥ�ư���ޤ���)
# -[[�ڡ���]]~
# --[[�ڡ���]]~
# ---[[�ڡ���]]~
# -[[?cmd=�ץ饰����&.....]]~
#
# p.s. [[���>http://www.yahoo.co.jp/]] ��������󥯤ϤϤ����ޤ���
#
# �Ȥ���
# ?cmd=sitemap
# @@BASE_URL@@/?cmd=sitemap
#
######################################################################

$sitemap::noprefix=1
	if(!defined($::sitemap::noprefix));

sub plugin_sitemap_convert {
	$::form{title}='no';
#	$::form{ls2}='no';
	$::form{level}=2;
	$::form{subject}=1;
	my %sitemap=&plugin_sitemap_action;
	return $sitemap{body};
}

sub plugin_sitemap_action {
	my $prev = '';
	my $char = '';
	my $idx = 1;
	my $menubar=$::MenuBar;
	my $name;
	my $menucount=0;
	my $submenu=0;
	my $basepage;
	my $nextpage;
	my $body="<h2>@{[$::wiki_title eq '' ? $::resource{sitemap_plugin_title} : $::wiki_title]}</h2>\n"
		if($::form{title} ne 'no');
	$::form{level}=5 if($::form{level}+0 eq 0);

	foreach $basepage(split(/\n/,$::database{$menubar})) {
		# MenuBar���� ***�ι��ܤ���Ф���					# comment
		if ($basepage=~/^(\*{1,5})(.+)/) {
			$name=$basepage;
			$name=~s/^(\*{1,5})//g;
			$name=&plugin_sitemap_trim($name);
			$menucount++;
			push(@sitemap,$name);
		#  MenuBar����֥饱�åȤ���Ф���					# comment
		}elsif($basepage=~/$::bracket_name/ && $basepage!~/>(http:|https:|ftp:|mailto:|\?)/
			&& $basepage!~/($::interwiki_name1|$::interwiki_name2)/) {
			$basepage=~s/$::bracket_name/$1/g;
			$basepage=~s/.*>//g if($basepage=~/>/);
			$basepage=&plugin_sitemap_trim($basepage);
			if(&is_readable($basepage)) {
				$submenu++;
				$sitemap{$name}.=sprintf("%05d\t%05d\t%05d\t%05d\t%s\n",$menucount,$submenu,0,0,$basepage);
				# MenuBar������Ф����ڡ������顢����٥�Υڡ�������Ф���	# comment
				$sitemap{$name}.=&submenu($basepage,$menucount,$submenu,0,1);
			}
		}
	}
	my $nest;
	my $nestorg;
	@viewed=();
	foreach my $menu(@sitemap) {
		if($sitemap{$menu} ne '') {
			if($menu=~/$bracket_name/) {
				if($menu!~/$::non_list/) {
					$body.="<ul><li><strong>@{[&make_link(&plugin_sitemap_cutpage($menu))]}</strong></li><ul>";
				}
			} else {
				$body.="<ul><li><strong>$menu</strong></li><ul>";
			}
			$nestorg=0;
			foreach(split(/\n/,$sitemap{$menu})) {
				chomp;
				($menucount,$submenu,$nextmenu,$nest,$page)=split(/\t/,$_);
				if($nestorg<$nest) {
					for(my $i=$nestorg; $i<$nest; $i++) {
						$body.="<ul>";
					}
				}
				if($nestorg>$nest) {
					for(my $i=$nest; $i<$nestorg; $i++) {
						$body.="</ul>";
					}
				}
				my $view=0;
				foreach(@viewed) {
					$view=1 if($page eq $_);
				}
				if($view eq 0) {
					if(&is_readable($page) && &is_exist_page($page) && $page!~/$::non_list/) {
						push(@viewed,$page);
						$body.="<li>" . &make_link_wikipage($page,&plugin_sitemap_cutpage($page));
						if($::form{subject}+0 eq 1) {
							$body.="<br>";
							$body.=&plugin_sitemap_trim(&get_subjectline($page),60);
						}
						$body.="</li>";
					}
				}
				$nestorg=$nest;
			}
			$body.="</ul>";
		}
		for(my $i=$nestorg; $i>=0; $i--) {
			$body.="</ul>";
		}
	}
	return ('msg' => "\t$::resource{sitemap_plugin_title}", 'body' => $body);
}

sub submenu {
	my($pagename,$menucount,$submenu,$nextmenu,$nest)=@_;
	my $ret="";
	my $nextpage;
	return if($nest>=$::form{level}+0);
	foreach my $line(split(/\n/,$::database{$pagename})) {
		if($line=~/-{1,3}$::bracket_name/ && $line!~/>(http:|https:|ftp:|mailto:|\?)/
			&& $line!~/($::interwiki_name1|$::interwiki_name2)/
			|| $line=~/>\?cmd=.*/ && $line =~ /^-\[\[(.*?)\]\]/) {
			$nextpage=$line;
			$nextpage=~s/-{1,3}$::bracket_name/$1/g;
			$nextpage=&plugin_sitemap_trim($nextpage);
			$nextpage=~s/.*>//g if($nextpage=~/>/ && $nextpage !~/\?cmd=/);
			$nextmenu++;
			$ret.=sprintf("%05d\t%05d\t%05d\t%05d\t%s\n",$menucount,$submenu,$nextmenu,$nest,$nextpage);
			$ret.=&submenu($nextpage,$menucount,$submenu,$nextmenu+1,$nest+1);
		# include											# comment
		} elsif($line=~/^#include\((.*?)\)/ && $::form{include} eq '') {
			$ret.=&submenu((split(/,/,$1))[0],$menucount+1,$submenu,$nextmenu+1,$nest)
		# ls2												# comment
		}elsif(($line=~/^#ls2\((.*?)\)/ || $line=~/^#ls2/) && $::form{ls2} eq '') {
			my @ls2args = split(/,/, $1);
			my $ls2prefix;
			my $ls2reverse=0;
			if (@ls2args > 0) {
				$ls2prefix = shift(@ls2args);
				foreach my $ls2arg (@ls2args) {
					if (lc $ls2arg eq "reverse") {
						$ls2reverse = 1;
					}
				}
			}
			$ls2prefix = $pagename . "/" if ($ls2prefix eq '');
			@ls2pages=();
			foreach my $ls2page (sort keys %::database) {
				push(@ls2pages, $ls2page) if ($ls2page =~ /^$ls2prefix/ && &is_readable($ls2page));
			}
			@ls2pages = reverse(@ls2pages) if ($ls2reverse);
			foreach(@ls2pages) {
				$nextpage=$_;
				$nextmenu++;
				$ret.=sprintf("%05d\t%05d\t%05d\t%05d\t%s\n",$menucount,$submenu,$nextmenu,$nest,$nextpage);
				$ret.=&submenu($nextpage,$menucount+1,$submenu,$nextmenu+1,$nest+1)
			}
		}
	}
	return $ret;
}

sub plugin_sitemap_trim {
	my($str,$strlen)=@_;

	$Zspace = '(?:\xA1\xA1)'; # ���ѥ��ڡ���		# comment
	$eucpre = qr{(?<!\x8F)};

	if($strlen+0 > 0) {
		my $len=length($str);
		$str=substr($str,0,$strlen);
		if ($str =~ /\x8F$/ or $str =~ tr/\x8E\xA1-\xFE// % 2) {
			$str=substr($str,0,length($str)-1);
		}
		$str.="..." if($len ne length($str));
	}

	# $str ����Ƭ�����ζ���ʸ��(���ѥ��ڡ�����)��������	# comment
	$str =~ s/^(?:\s|$Zspace)+//o; # $str �� EUC-JP �ξ��	# comment
	$str =~ s/$eucpre(?:\s|$Zspace)+$//o; # $str �� EUC-JP �ξ��(perl5.005�ʹ�	# comment)
	$str=~s/\~//g;
	$str=~s/[\r|\n]//g;
	$str=~s/\ \/\/\ \#.*//g;	# debug
	return $str;
}

sub plugin_sitemap_cutpage {
	my $str=shift;

	if($pathmenu::loaded eq 1) {
		my $cutedpage=$str;
		$cutedpage=~s/.*$::separator//g;
		if($str eq $cutedpage) {
			return $str;
		}
		return $cutedpage;
	}
	return $str;
}

1;
__END__
=head1 NAME

sitemap.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=sitemap

=head1 DESCRIPTION

Make navigation of the "explicit" caller easy to carry out.

=head1 USAGE

=head2 MenuBar

=item MenuBar

Written for MenuBar

 ***Item Name
 [[WikiName]]
 [[pagename]]

It does not move only by WikiName.

=item Each page

The page registered into MenuBar describes as follows.

 -[[WikiName]] (It does not move only by WikiName.)
 -[[pagename]]~
 --[[pagename]]~
 ---[[pagename]]~
 -[[?cmd=plugin&.....]]~

=back

=head1 SETTING

=head2 pyukiwiki.ini.cgi

=over 4

=item $::use_SiteMap

0:List only, 1:List and usually, sitemap.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/sitemap

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/sitemap/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/sitemap.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
