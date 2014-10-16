######################################################################
# @@HEADER2_NANAMI@@
######################################################################

sub plugin_compressbackup_action {
	my @convertdirs=(
		"$::backup_dir",
	);

	&load_wiki_module("auth");
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{compressbackup_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	if($::form{confirm} eq '') {
		$body=<<EOM;
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="compressbackup" />
$::resource{compressbackup_pluin_convert}<br />
<input type="submit" name="confirm" value="$::resource{compressbackup_pluin_convert_yes}" />
</form>
EOM
		return('msg'=>"\t$::resource{compressbackup_plugin_title}"
			  ,'body'=>"$body");
	}

	# compress backup
	&open_backup;
	foreach my $page (sort keys %::database) {
		my $backuptext=$::backupbase{$page};
		if($backuptext ne '') {
			$::backupbase{$page}=$backuptext;
		}
	}
	&close_backup;
	return('msg'=>"\t$::resource{compressbackup_plugin_title}"
		  ,'body'=>"$::resource{compressbackup_pluin_converted}<hr />$body");
}

1;
__END__

=head1 NAME

compressbackup.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=compressbackup

=head1 DESCRIPTION

Compress Backup Directory

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/compressbackup

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/compressbackup/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/compressbackup.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
