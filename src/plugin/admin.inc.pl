######################################################################
# @@HEADER2_NANAMI@@
######################################################################

$admin::ignore_plugin=q{^edit|^admin\.|^newpage|^attach|^diff|^backup};

sub plugin_admin_action {
	my $body;
	&load_wiki_module("auth");
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{adminbutton}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my @adminlist=();
	my @dir=();
	opendir(DIR,"$::plugin_dir");
	while(my $dir=readdir(DIR)) {
		push(@dir,$dir);
	}
	closedir(DIR);
	@dir=sort @dir;
	foreach my $dir(@dir) {
		if($dir=~/(.*?)\.inc\.pl$/ && $dir!~/($admin::ignore_plugin)/) {
			my $flag=0;
			my $res="";
			open(R, "$::plugin_dir/$dir");
			foreach my $line(<R>) {
				$flag++ if($line=~/^sub.*\_action/);
				$flag++ if($line=~/\&authadminpassword/);
				if($flag eq 2) {
					$dir=~s/\.inc\.pl$//g;
					push(@adminlist,$dir);
					last;
				}
			close(R);
			}
		}
	}

	foreach my $plugin(@adminlist) {
		open(R, "$::plugin_dir/$plugin.inc.pl");
		my $res=$plugin;
		foreach my $line(<R>) {
			if($line=~/resource:(.+)/) {
				$res=$1;
			}
		}
		close(R);
		my $path="$::res_dir/$res.$::lang.txt";
		%::resource = &read_resource($path,%::resource) if(-r $path);
		$msg="$plugin";
		$msg.=" - " . $::resource{$plugin . "_plugin_title"}
			if($::resource{$plugin . "_plugin_title"} ne '');
		$body.=<<EOM;
<div align="center">
<form action="$::script" method="POST">
<input type="hidden" name="cmd" value="$plugin" />
$auth{html}
<input type="submit" value="$msg" />
</form>
</div>
EOM
	}
	return ('msg'=>"\t$::resource{adminbutton}", 'body'=>$body);
}
1;

__DATA__

sub plugin_admin_usage {
	return {
		name => 'admin',
		version => '1.2',
		type => 'admin,command',
		author => '@@NANAMI@@',
		syntax => '?cmd=admin',
		description => 'The menu which supports execution of management plugin.
',
		description_ja => '管理プラグインの実行を支援するメニューを表示する。
',
		example => 'http://example/?cmd=admin',
	};
}

1;
__END__

=head1 NAME

admin.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=admin

=head1 DESCRIPTION

The menu which supports execution of management plugin.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/admin

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/admin/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/admin.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
