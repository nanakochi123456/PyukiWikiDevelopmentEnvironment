######################################################################
# @@HEADER2_NANAMI@@
######################################################################

sub plugin_backlink_inline {
	return plugin_backlink_convert(@_);
}

sub plugin_backlink_convert {
	my $mypage=$::form{mypage};
	my @pages=split(/$::separator/,$mypage);
	my $buf;
	my $backpage;
	foreach(@pages) {
		if($backpage eq "") {
			$backpage=$buf;
		} else {
			$backpage="$backpage$::separator$buf";
		}
		$buf=$_;
	}
	my $msg=$::resource{backlink_msg};
	$backpage=$::FrontPage if($backpage eq "");
	$msg=~s/\$1/$backpage/g;
	$body=qq(<a href="@{[&make_cookedurl(&encode($backpage))]}" title="$msg">$msg</a>);
	return $body;
}

1;
__DATA__

sub plugin_backlink_usage {
	return {
		name => 'backlink',
		version => '1.0',
		type => 'convert,inline',
		author => '@@NANAMI@@',
		syntax => '#backlink\n&backlink;',
		description => 'To create a link back to the wiki of the upper hierarchy.',
		description_ja => '上層の階層のwikiへ戻るリンクを作成する。',
		example => '#backlink',
	};
}

1;
__END__

=head1 NAME

backlink.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &backlink;

=head1 DESCRIPTION

To create a link back to the wiki of the upper hierarchy.

If there is no upper layer of the hierarchy of wiki, it does not make sense.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/backlink

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/backlink/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/backlink.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
