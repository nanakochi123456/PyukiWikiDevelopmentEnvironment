######################################################################
# @@HEADER2_NANAMI@@
######################################################################

@FILELIST=(
	"./ .cgi\$,$::explugin_dir wiki\.cgi,$::explugin_dir func\.cgi,$::explugin_dir file\.cgi,$::explugin_dir auth\.cgi,$::explugin_dir config\.cgi,$::explugin_dir define\.cgi,$::explugin_dir mail\.cgi,$::explugin_dir html\.cgi:basic",
	"$::explugin_dir/Nana \.pm\$,$::explugin_dir/Yuki \.pm\$\,$::explugin_dir/Algorithm \.pm\$,$::explugin_dir/Digest/Perl \.pm\$,$::explugin_dir/Time \.pm\$,$::explugin_dir/File \.pm\$,$::explugin_dir/File \.txt\$,$::explugin_dir/Jcode \.pm\$,$::explugin_dir/HTTP \.pm\$,$::explugin_dir/IDNA \.pm\$,$::explugin_dir/Jcode \.pm\$,$::explugin_dir/Jcode/Unicode \.pm\$,$::explugin_dir \.pm\$:module",
	"$::plugin_dir \.pl\$\:plugin",
	"$::explugin_dir \.inc\.pl\$,$::explugin_dir \.inc\.cgi\$\:explugin",
	"$::res_dir \.txt\$\:resource",
	"$::skin_dir \.cgi\$\:skin",
	"$::skin_dir \.css\$,$::skin_dir \.css\.org\$\:css",
	"$::skin_dir \.js\$,$::skin_dir \.js\.src\$\:js",
);

@DIRLIST=(
	"$::plugin_dir", "$::explugin_dir", "$::skin_dir", "$::image_dir",
	"$::res_dir"
);


require "$::plugin_dir/perlpod.inc.pl";

sub plugin_versionlist_action {
	my $body;

	$::nowikiname = 1;
	&_init_inline_regex;

	%::resource = &read_resource("$::res_dir/filelist.txt",%::resource);
#	%::resource = &read_resource("$::res_dir/sums.txt");

	$::usePukiWikiStyle=1;

	&load_wiki_module("auth");
	my %auth=&authadminpassword(submit,"","admin");
	return('msg'=>"\t$::resource{versionlist_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	if($::form{pod}) {
		return('msg'=>"\t$::resource{versionlist_plugin_title}",'body'=>&perlpod($::form{pod}));
	}
	foreach(@FILELIST) {
		($files,$res_title)=split(/:/,$_);
		push(@title,$res_title);
		foreach(split(/,/,$files)) {
			($dir,$file_regex)=split(/ /,$_);
			if(opendir(DIR,$dir)) {
				while($file=readdir(DIR)) {
					next if($file=~/^\./);
					if($file=~/$file_regex/) {
						if(open(R,"$dir/$file")) {
							$f="$dir/$file";
							$f=~s/\/\//\//g;
							$f=~s/^\///g;
							$files{$res_title}.="$f,";
							foreach(<R>) {
								if(/\$Id: (.+),v (\d+\.\d+) (\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2})/) {
									$file{$f}{file}=$1;
									$file{$f}{rev}=$2;
									$file{$f}{date}=$3;
								}
								if(/\"(.+)\"\s+([Vv][Ee][Rr][Ss][Ii][Oo][Nn]|[Vv][Ee][Rr])\s+(.+)\s+\$\$/) {
									$file{$f}{pkgname}=$1;
									$file{$f}{version}=$2;
								}
								if(/^=cut/) {
									$file{$f}{podfile}="$dir/$file";
									$file{$f}{podfile}=~s/\/\//\//g;
								}
							}
							if(-r "$file{$f}{podfile}.$::lang.pod") {
								$file{$f}{"podfile_$::lang"}="$file{$f}{podfile}.$::lang.pod";
							} else {
								$tmp="$file{$f}{podfile}.$::lang.pod";
								$tmp=~s/\.inc\.cgi/\.inc\.pl/g;
								if(-r $tmp) {
									$file{$f}{"podfile_$::lang"}="$tmp";
								}
							}
							foreach("file","rev","date","pkgname","version") {
								$file{$f}{$_}=$::resource{versionlist_plugin_unknown} if($file{$f}{$_} eq '');
							}
							close(R);
							if($res_title=~/plugin/) {
								$file{$f}{arg1_title}=$::resource{versionlist_plugin_plugintype};
								$file{$f}{arg2_title}=$::resource{versionlist_plugin_pluginmethod};
								if($f=~/\.inc\.cgi$/) {
									$file{$f}{arg1_value}=$::resource{versionlist_plugin_plugintype_PyukiWikiEx_OK};
								} elsif($f=~/\.inc\.pl$/) {
									if($res_title eq 'plugin') {
										$file{$f}{arg1_value}=$::resource{versionlist_plugin_plugintype_PyukiWiki};
									} else {
										$file{$f}{arg1_value}=$::resource{versionlist_plugin_plugintype_PyukiWikiEx_NG};
									}
								} else {
									$file{$f}{arg1_value}=$::resource{versionlist_plugin_plugintype_YukiWiki};
								}
								open(R,"$f");
								foreach(<R>) {
									$pname=$file;
									$pname=~s/\..*//g;
									$file{$f}{arg2_value}.="action,"
										if(/sub\s+plugin\_$pname\_action/);
									$file{$f}{arg2_value}.="convert,"
										if(/sub\s+plugin\_$pname\_convert/);
									$file{$f}{arg2_value}.="inline,"
										if(/sub\s+plugin\_$pname\_inline/);
									$file{$f}{arg2_value}="init,"
										if(/sub\s+plugin\_$pname\_init/);
									$file{$f}{arg2_value}="version,"
										if(/sub\s+plugin\_$pname\_version/);
									$file{$f}{arg2_value}="usage,"
										if(/sub\s+plugin\_$pname\_usage/);
									$file{$f}{arg2_value}.="block,"
										if(/sub\s+plugin_block/);
									$file{$f}{arg2_value}.="inline,"
										if(/sub\s+plugin_inline/);
									$file{$f}{arg2_value}.="usage,"
										if(/sub\s+plugin_usage/);
									$file{$f}{arg2_value}.="version,"
										if(/sub\s+plugin_version/);
								}
								$file{$f}{arg2_value}=~s/, $//g;
								close(R);
							}
						}
					}
				}
				closedir(DIR);
			}
		}
	}

	$body="*$::resource{versionlist_plugin_title}\n";
	foreach $title(@title) {
		$body.=qq(**$::resource{"versionlist_plugin_$title"}\n);
		@files=();
		foreach(split(/,/,$files{$title})) {
			next if($_ eq '');
			push(@files,$_);
		}
		@files=sort @files;
		$titlestyle="COLOR(#004400):BGCOLOR(#ffeeff):";
		$valuestyle="COLOR(BLUE):BGCOLOR(#feffff):";


		foreach $f(@files) {
			if($file{$f}{podfile} ne '') {
				my $tmp=$file{$f}{podfile};
				$tmp=~s/.*\///g;
				$podlink="[[[pod>$::basehref?cmd=perlpod&file=" . &encode($tmp) . "]]]";
				if($file{$f}{"podfile_$::lang"} ne '') {
					my $tmp=$file{$f}{"podfile_$::lang"};
					$tmp=~s/.*\///g;
					$podlink.=" [[[$::lang>$::basehref?cmd=perlpod&file=" . &encode($tmp) . "]]]";
				}
			} else {
				$podlink="";
			}
			$body.="|>|>|>|>|>|>|BGCOLOR(#ffffee):&size(15){''$f''}; $podlink|\n";
			$body.=<<EOM;
|$titlestyle$::resource{versionlist_plugin_pkgname}|>|$valuestyle''$file{$f}{pkgname}''|$titlestyle$::resource{versionlist_plugin_version}|>|$valuestyle''$file{$f}{version}''|
|$titlestyle&br(nobr);$::resource{versionlist_plugin_filename}&br(/nobr);|$valuestyle$file{$f}{file}|$titlestyle$::resource{versionlist_plugin_rev}|$valuestyle$file{$f}{rev}|$titlestyle$::resource{versionlist_plugin_date}|$valuestyle$file{$f}{date}|
EOM
			if($file{$f}{"arg1"."_title"} ne '') {
				@tmp=();
				my $tmp="";
				foreach(split(/,/,$file{$f}{"arg2"."_value"})) {
					push(@tmp,$_);
				}
				@tmp=sort @tmp;
				foreach(@tmp) {
					$tmp.="$_,";
				}
				$tmp=~s/\,$//g;
				$body.=<<EOM;
|$titlestyle$file{$f}{"arg1"."_title"}|>|$valuestyle$file{$f}{"arg1"."_value"}|$titlestyle$file{$f}{"arg2"."_title"}|>|$valuestyle$tmp|
EOM
			}
			$relfiles=&getfiles($f);
			$body.=<<EOM;
|$titlestyle$::resource{versionlist_plugin_file}|>|>|>|>|$valuestyle$relfiles|
EOM

		}
	}
	return('msg'=>"\t$::resource{versionlist_plugin_title}",'body'=>&text_to_html($body));
}

sub getfiles {
	my ($orgfile)=@_;
	$orgfile=~s/^\.\///g;
	my @extlist=("",
				 "inc.pl","inc.cgi","pl","cgi",
				 ".js",".js.gz",".js.org",".js.src",
				 ".css",".css.gz",".css.org",".css.src",
				 ".en.txt",".$::lang.txt",".txt");

	my $filelist="";
	foreach my $line(split(/\n/, $::resource{filelist})) {
		next if(/^\#/ || /^\s/ || $line eq "");

		my($file, $mod, $list, $doc)=split(/\t/, $line);
		next if($orgfile!~/$file\./);

		my %list=();
		my $all="$file,$list";
		foreach my $flist(split(/,/,$all)) {
			foreach my $ext(@extlist) {
				if(-r "$flist$ext") {
					$list{"$flist$ext"}=1;
				}
				$flist=~s/.*\///g;
				foreach my $dirs(@DIRLIST) {
					if(-r "$dirs/$flist$ext") {
						$list{"$dirs/$flist$ext"}=1;
					}
				}
			}
		}
		foreach my $flist(sort keys %list) {
			$filelist.="$flist, ";
		}
	}
	$filelist;
}

1;
__END__

=head1 NAME

versionlist.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=versionlist

=head1 DESCRIPTION

The list of PyukiWiki-related files is displayed and it indicates by the version.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/versionlist

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/versionlist/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/versionlist.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
