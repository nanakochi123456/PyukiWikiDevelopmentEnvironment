######################################################################
# @@HEADER2_NANAMI@@
######################################################################

sub plugin_convertutf8_action {
	my @convertdirs=(
		"$::upload_dir",
		"$::backup_dir",
		"$::diff_dir",
		"$::counter_dir",
		"$::info_dir",
		"$::data_dir",
		"$::user_dir",
	);

	my @convertfiles=(
		"$::backup_dir",
		"$::diff_dir",
		"$::data_dir",
		"$::user_dir",
	);

	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{convertutf8_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	if($::defaultcode eq 'utf8') {
		return('msg'=>"\t$::resource{convertutf8_plugin_title}"
			  ,'body'=>"$::resource{convertutf8_pluin_noutf8}");
	}

	if($::lang ne 'ja') {
		return('msg'=>"\t$::resource{convertutf8_plugin_title}"
			  ,'body'=>"$::resource{convertutf8_pluin_nojapanese}");
	}

	if($::utf8convertexeced eq 1) {
		return('msg'=>"\t$::resource{convertutf8_plugin_title}"
			  ,'body'=>"$::resource{convertutf8_pluin_converted_always}");
	}
	if($::form{confirm} eq '') {
		$body=<<EOM;
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="convertutf8" />
$::resource{convertutf8_pluin_convert}<br />
<input type="submit" name="confirm" value="$::resource{convertutf8_pluin_convert_yes}" />
</form>
EOM
		return('msg'=>"\t$::resource{convertutf8_plugin_title}"
			  ,'body'=>"$body");
	}

	# convert filname
	foreach(@convertdirs) {
		next if($_ eq '');
		opendir(DIR,$_);
		while($file=readdir(DIR)) {
			next if($file eq '.' || $file eq '..');
			next if($file=~/\.html$/ || $file=~/^\.ht/ || $file=~/\.pl$/ || $file=~/\.cgi$/);

			$ext="";
			if($file=~/\.txt$/) {
				$ext=".txt";
				$file=~s/\.txt$//;
			} elsif($file=~/$::counter_ext$/) {
				$ext="$::counter_ext";
				$file=~s/$::counter_ext$//;
			} elsif($file=~/\.gz$/) {
				$ext=".gz";
				$file=~s/\.gz$//;
			}
			if($file=~/^(.+)?\_(.+)?/) {
				$dbm1=&undbmname($1);
				$dbm2=&undbmname($2);
				$dbm1=&code_convert(\$dbm1, "utf8");
				$dbm1=&dbmname($dbm1);
				$dbm2=&code_convert(\$dbm2, "utf8");
				$dbm2=&dbmname($dbm2);
				$old="$_/$file$ext";
				$new="$_/$dbm1\_$dbm2$ext";
			} else {
				$dbm=&undbmname($file);
				$dbm=&code_convert(\$dbm, "utf8");
				$dbm=&dbmname($dbm);
				$old="$_/$file$ext";
				$new="$_/$dbm$ext";
			}
			$body.="rename<br />$old<br />$new<br /><br />";
			rename($old,$new);
		}
	}

	# convert data
	foreach(@convertfiles) {
		next if($_ eq '');
		opendir(DIR,$_);
		while($file=readdir(DIR)) {
			next if($file eq '.' || $file eq '..');
			next if($file=~/\.html$/ || $file=~/^\.ht/ || $file=~/\.pl$/ || $file=~/\.cgi$/);
			if($file=~/\.txt$/) {
				$ext=".txt";
				$file=~s/\.txt$//;
			} elsif($file=~/\.gz$/) {
				$ext=".gz";
				$file=~s/\.gz$//;
			}

			$buf="";
			open(R,"$_/$file$ext");
			foreach $data(<R>) {
				$buf.=$data;
			}
			close(R);
			$buf=&code_convert(\$buf, "utf8");
			open(W,">$_/$file$ext");
			print W $buf;
			close(W);
			$body.="convert<br />$_/$file$ext<br /><br />";
		}
	}
	if(-w $::setup_file) {
		$buf="";
		open(R,"$::setup_file");
		foreach $data(<R>) {
			$buf.=$data;
		}
		close(R);
		$buf=&code_convert(\$buf, "utf8");
		open(W,">$::setup_file");
		print W $buf;
		close(W);

		open(W, ">>$::setup_file");
		print W <<EOM;
\$::kanjicode = "utf8";			# converted utf8
\$::charset = "utf-8";			# converted utf8
\$::utf8convertexeced=1;		# converted utf8
1;
EOM
	}
	$::allview=0;
	return('msg'=>"\t$::resource{convertutf8_plugin_title}"
		  ,'body'=>"$::resource{convertutf8_pluin_converted}<hr />$body");
}

1;
__END__

=head1 NAME

convertutf8.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=convertutf8

=head1 DESCRIPTION

Convert EUC Code wiki to UTF-8 wiki for UTF-8 version.

Warning Can't convert UTF-8 to EUC

and can't exec UTF-8 version

Please Backup wiki all pages.

and deletecache plugin.

support database type of Yuki/YukiWikiDB.pm of Nana/YukiWikiDB.pm

not supportted with explugin lang.inc.cgi

if old type counter use, before execute counter_viewer plugin

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/convertutf8

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/convertutf8/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/convertutf8.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
