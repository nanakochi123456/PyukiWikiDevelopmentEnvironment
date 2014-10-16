######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;

sub plugin_adminedit_action {
	if (1 == &exist_plugin('edit')) {
		my ($page) = &unarmor_name(&armor_name($::form{mypage}));
		my $body;
		if (not &is_editable($page)) {
			$body .= qq(<p><strong>$::resource{edit_plugin_cantchange}</strong></p>);
		} else {
			$body .= qq(<p><strong>$::resource{adminedit_plugin_passwordneeded}</strong></p>);
			# 2005.11.2 pochi: 部分編集を可能に (thanks Walrus)	# comment
			my $pagemsg;
			if ($::form{mypart} =~ /^\d+$/ and $::form{mypart}) {
				my $mymsg = (&read_by_part($page))[$::form{mypart} - 1];
				$pagemsg = \$mymsg;

			} else {
				# original
				$pagemsg = \$::database{$page};
			}
			$body .= &plugin_edit_editform($$pagemsg,
				&get_info($page, $::info_ConflictChecker), admin=>1);
		}
		return ('msg'=>"$page\t$::resource{adminedit_plugin_title}", 'body'=>$body, 'ispage'=>1);
	}
	return "";
}

1;
__DATA__

sub plugin_adminedit_usage {
	return {
		name => 'adminedit',
		version => '3.0',
		type => 'admin,command',
		author => '@@NANAMI@@',
		syntax => '?cmd=adminedit&mypage=pagename',
		description => 'Edit page and frozen/unfrozen page.',
		description_ja => '指定したページを編集・凍結する',
		example => 'http://example/?cmd=adminedit&mypage=pagename',
	};
}

1;
__END__

=head1 NAME

adminedit.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=adminedit&mypage=pagename

=head1 DESCRIPTION

Edit page and frozen/unfrozen page.

Frozen password is required in order to edit and freeze.

The page name must be encoded.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/adminedit

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/adminedit/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/adminedit.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
