######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

sub plugin_skin_convert {
	my($mainskin, $subskin)=split(/,/,shift);

	if(&skin_check("$::skin_dir/$mainskin.skin%s.cgi",".$::lang","")) {
		return <<EOM;
<span class="error">Skin $mainskin not found</span>
EOM
	}

	$::skin_name=$mainskin;
	$::skin_name{$mainskin}=$subskin;
	&skin_init;
	return ' ';
}


1;
__END__

=head1 NAME

skin.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #skin(main skin name,[sub sukin name])

=head1 DESCRIPTION

Change pyukiwiki skin.

=head1 USAGE

 #skin(main skin name,[sub sukin name])

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/skin

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/skin/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/skin.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
