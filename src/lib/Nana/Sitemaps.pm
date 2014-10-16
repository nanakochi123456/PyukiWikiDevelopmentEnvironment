######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package Nana::Sitemaps;
use strict;
use integer;
use vars qw($VERSION);

$VERSION = '0.3';

# The constructor.
sub new {
	my ($class, %hash) = @_;
	my $self = {
		version => $hash{version},
		encoding => $hash{encoding},
		index => $hash{index},
	};
	return bless $self, $class;
}

# Adding item.
sub add_item {
	my ($self, %hash) = @_;
	push(@{$self->{items}}, \%hash);
	return $self->{items};
}

#
sub as_string {
	my ($self) = @_;
	my $doc;
	if($self->{index} eq 1) {
		$doc=<<EOM;
<?xml version="1.0" encoding="utf-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
@{[
	map {
		qq {
<sitemap>
<loc>$_->{link}</loc>
<lastmod>$_->{dc_date}</lastmod>
</sitemap>
		}
	} @{$self->{items}}
]}
</sitemapindex>
EOM
	} else {
		$doc = <<EOM;
<?xml version="1.0" encoding="utf-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
@{[
	map {
		qq{
<url>
<loc>$_->{link}</loc>
<lastmod>$_->{dc_date}</lastmod>
<priority>$_->{priority}</priority>
@{[$_->{changefreq} ne '' ? "<changefreq>$_->{changefreq}</changefreq>" : ""]}
</url>
		}
	} @{$self->{items}}
]}
</urlset>
EOM
	}
}
1;
__END__

=head1 NAME

Nana::Sitemaps - Generate sitemaps module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Sitemaps.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
