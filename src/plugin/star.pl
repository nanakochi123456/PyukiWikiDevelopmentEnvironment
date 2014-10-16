######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

$STAR::STRING1=qq(<span class="star1">&#9733;</span>)
	if(!defined($STAR::STRING1));
$STAR::STRING2=qq(<span class="star2">&#9734;</span>)
	if(!defined($STAR::STRING2));

package star;

sub plugin_inline {
	my @args = split(/,/, shift);
	my $max=5;
	my $now=0;

	if(@args >= 2) {
		if($args[1]+0 > 0) {
			$max=$args[1];
		}
	}
	if($args[0]+0 > 0) {
		$now=$args[0];
	}

	my $out;
	for (my $i=1; $i <= $max; $i++) {
		if($i <= $now) {
			$out.=$STAR::STRING1;
		} else {
			$out.=$STAR::STRING2;
		}
	}
	return $out;
}

1;
__END__

=head1 NAME

star.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &star(4);
 &star(3,10);

=head1 DESCRIPTION

Display rank of star.

This plugin is compatible with YukiWiki.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/star

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/star/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/star.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
