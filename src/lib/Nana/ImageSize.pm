######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::ImageSize;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);

@EXPORT_OK = qw(imgsize);

@ISA = 'Exporter';
$VERSION = '0.1';

sub imgsize {
	my ($file, $type) = @_;
	my $width  = 0;
	my $height = 0;
	my ($data, $m, $c, $l);
	my $fp;
	if ($file =~ /\.[Jj][Pp][Ee]?[Gg]$/i || $type eq lc "jpg") {
		open($fp, "$file") || return (0, 0);
		binmode $fp;
		read($fp, $data, 2);
		while (1) {
			read($fp, $data, 4);
			($m, $c, $l) = unpack("a a n", $data);
			if ($m ne "\xFF") {
				$width = $height = 0;
				last;
			} elsif ((ord($c) >= 0xC0) && (ord($c) <= 0xC3)) {
				read($fp, $data, 5);
				($height, $width) = unpack("xnn", $data);
				last;
			} else {
				read($fp, $data, ($l - 2));
			}
		}
		close($fp);
	} elsif ($file =~ /\.[Gg][Ii][Ff]$/i || $type eq lc "gif") {
		open($fp, "$file") || return (0,0);
		binmode($fp);
		sysread($fp, $data, 10);
		close($fp);
		$data = substr($data, -4) if ($data =~ /^GIF/);

		$width  = unpack("v", substr($data, 0, 2));
		$height = unpack("v", substr($data, 2, 2));
	} elsif ($file =~ /\.[Pp][Nn][Gg]$/i || $type eq lc "png") {
		open($fp, "$file") || return (0,0);
		binmode($fp);
		read($fp, $data, 24);
		close($fp);

		$width  = unpack("N", substr($data, 16, 20));
		$height = unpack("N", substr($data, 20, 24));
	}
	return ($width, $height);
}
1;
__END__

=head1 NAME

Nana::ImageSize - get image size module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/ImageSize.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
