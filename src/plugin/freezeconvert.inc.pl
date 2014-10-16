######################################################################
# @@HEADER2_NANAMI@@
######################################################################

%::infobase;

sub plugin_freezeconvert_action {
	my $body;
	my $upperlist;
	my %pageinfo;
	&load_wiki_module("auth");
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{freezeconvert_plugin_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	my $freeze_execed_file="$::info_dir/.freezeconverted";
	if($::form{submit} eq '') {
		if(-r $freeze_execed_file) {
			return('msg'=>"\t$::resource{freezeconvert_plugin_title}"
				  ,'body'=>$::resource{freezeconvert_plugin_execed});
		}
		my $body=<<EOM;
<form action="$::script" method="POST">
$auth{html}
<input type="hidden" name="cmd" value="freezeconvert" />
<input type="submit" name="submit" value="$::resource{freezeconvert_plugin_btn_submit}" />
</form>
EOM
		return('msg'=>"\t$::resource{freezeconvert_plugin_title}"
			  ,'body'=>$body);
	}

	&open_info_db;
	my @pages;
	my %freeze;
	foreach my $page (sort keys %::infobase) {
		my $freeze=(&old_get_info($page, $info_IsFrozen)) ? 1 : 0;
		&set_info($page,$info_IsFrozen,$freeze);
		&delete_isfrozen($page);
		push(@pages,$page);
		$freeze{$page}=$freeze;
	}
	&close_info_db;

	open(W, ">$freeze_execed_file") || die;
	close(W);

	my $body=<<EOM;
<h2>$::resource{freezeconvert_plugin_execmsg}</h2>
<table border="1">
EOM
	foreach(@pages) {
		$body.=<<EOM;
<tr><td>$_</td><td>@{[$freeze{$_} eq 1 ?  $::resource{freezeconvert_plugin_freeze} : $::resource{freezeconvert_plugin_nofreeze}]}</td></tr>
EOM
	}
	$body.="</table>\n";
	return('msg'=>"\t$::resource{freezeconvert_plugin_title}",'body'=>$body);}

sub old_get_info {
	my ($page, $key) = @_;
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	return $info{$key};
}

sub delete_isfrozen {
	my ($page)=@_;
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	delete $info{$info_IsFrozen};
	my $s = '';
	for (keys %info) {
		if($_ ne $info_IsFrozen) {
			$s .= "$_=$info{$_}\n";
		}
	}
	$infobase{$page} = $s;
}
1;
__END__

=head1 NAME

freezeconvert.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=freezeconvert

=head1 DESCRIPTION

Freeze wiki converter to PukiWiki Compatible.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/freezeconvert

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/freezeconvert/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/freezeconvert.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
