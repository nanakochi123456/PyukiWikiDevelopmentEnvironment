######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'pathmenu.inc.cgi'
######################################################################

use strict;

$pathmenu::loaded=1;

sub plugin_pathmenu_init {
	if(&exist_plugin("topicpath") ne 0) {
		my $mypage=$::form{mypage};
		my @path_array = split($topicpath::SEPARATOR,$mypage);
		my $c=0;
		my @paths=();
		my $pathtop;
		foreach my $pagename(@path_array) {
			if($c eq 0) {
				$pathtop=$pagename;
			} else {
				$pathtop .= $topicpath::SEPARATOR . $pagename;
			}
			push(@paths, $pathtop);
			$c++;
		}

		foreach my $pagename(@paths) {
			$::MenuBar		=&chkbars($pagename, $::MenuBar);
			$::SideBar		=&chkbars($pagename, $::SideBar);
			$::TitleHeader	=&chkbars($pagename, $::TitleHeader);
			$::Header		=&chkbars($pagename, $::Header);
			$::Footer		=&chkbars($pagename, $::Footer);
			$::BodyHeader	=&chkbars($pagename, $::BodyHeader);
			$::BodyFooter	=&chkbars($pagename, $::BodyFooter);
			$::SkinFooter	=&chkbars($pagename, $::SkinFooter);
		}
		return('init'=>1);
	}
	return('init'=>0);
}

sub chkbars {
	my($pg,$menu)=@_;
	if($::database{"$pg$topicpath::SEPARATOR$menu"} ne '') {
		return "$pg$topicpath::SEPARATOR$menu";
	}
	return $menu;
}

1;
__DATA__
sub plugin_pathmenu_setup {
	return(
		ja=>'階層下にMenuBar等を作る',
		en=>'Create a hierarchy under MenuBar etc. system page.',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/pathmenu/'
	);
__END__

=head1 NAME

pathmenu.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Create a hierarchy under MenuBar etc. system page.

=head1 DESCRIPTION

Create a hierarchy under MenuBar etc. system page.

 PyukiWiki/MenuBar
 PyukiWiki/Sample/:SideBar

=head1 USAGE

rename to pathmenu.inc.cgi

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/pathmenu

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/pathmenu/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/pathmenu.inc.pl>

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
