######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.0-p2 add option
# v0.2.0 First Release
#
#*Usage
# #title(title tag string)
# #title(title tag string,add)
######################################################################

sub plugin_title_convert {
	my ($arg) = shift;
	return if(!&is_frozen($::form{mypage}));
	my($title,$flg)=split(/,/,$arg);
	if($flg ne '') {
		$::IN_TITLE=&htmlspecialchars($title) . "\t";
	} else {
		$::IN_TITLE=&htmlspecialchars($title);
	}
	return ' ';
}
1;
__END__

=head1 NAME

title.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #title(title tag string)

=head1 DESCRIPTION

Setting title tag

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/title

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/title/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/title.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
