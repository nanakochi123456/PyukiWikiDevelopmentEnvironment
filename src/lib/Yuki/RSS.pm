######################################################################
# @@HEADER3_YUKI@@
######################################################################

package Yuki::RSS;
use strict;
use vars qw($VERSION);

$VERSION = '0.3';

# The constructor.
sub new {
	my ($class, %hash) = @_;
	my $self = {
		version => $hash{version},
		encoding => $hash{encoding},
		channel => { },
		items => [],
	};
	return bless $self, $class;
}

# Setting channel.
sub channel {
	my ($self, %hash) = @_;
	foreach (keys %hash) {
		$self->{channel}->{$_} = $hash{$_};
	}
	return $self->{channel};
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
	my $doc = <<"EOD";
<?xml version="1.0" encoding="$self->{encoding}" ?>

<rdf:RDF
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
 xmlns="http://purl.org/rss/1.0/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
>

<channel rdf:about="$self->{channel}->{link}">
 <title>$self->{channel}->{title}</title>
 <link>$self->{channel}->{link}</link>
 <description>$self->{channel}->{description}</description>
 <items>
  <rdf:Seq>
   @{[
    map {
     qq{<rdf:li rdf:resource="$_->{link}" />}
    } @{$self->{items}}
   ]}
  </rdf:Seq>
 </items>
</channel>
@{[
 map {
  qq{
   <item rdf:about="$_->{link}">
    <title>$_->{title}</title>
    <link>$_->{link}</link>
    <description>$_->{description}</description>
    <dc:date>$_->{dc_date}</dc:date>
   </item>
  }
 } @{$self->{items}}
]}
</rdf:RDF>
EOD
}

1;
__END__

=head1 NAME

Yuki::RSS - The smallest module to generate RSS 1.0. 
It is downward compatible to XML::RSS.

=head1 SYNOPSIS

    use strict;
    use Yuki::RSS;
 
    my $rss = new Yuki::RSS(
        version => '1.0',
        encoding => 'Shift_JIS'
    );
 
    $rss->channel(
        title => "Site Title",
        link => "http://url.of.your.site/",
        description  => "The description of your site",
    );
 
    $rss->add_item(
        title => "Item Title",
        link => "http://url.of.your/item.html",
        description => "Yoo, hoo, hoo",
        dc_date => "2003-12-06T01:23:45+09:00",
    );
 
    print $rss->as_string;

=head1 DESCRIPTION

Yuki::RSS is the smallest RSS 1.0 generator.
This module helps you to create the minimum document of RSS 1.0.
If you need more than that, use XML::RSS.

=head1 METHODS

=over 4

=item new Yuki::RSS (version => $version, encoding => $encoding)

Constructor for Yuki::RSS.
It returns a reference to a Yuki::RSS object.
B<version> must be 1.0.
B<encoding> will be inserted output document as a XML encoding.
This module does not convert to this encoding.

=item add_item (title => $title, link => $link, description => $description, dc_date => $date)

Adds an item to the Yuki::RSS object.

=item as_string

Returns the RSS string.

=item channel (title => $title, link => $link, description => $desc)

Channel information of RSS.

=head1 SEE ALSO

=over 4

=item L<XML::RSS>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Yuki/RSS.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_YUKI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_YUKI@@

=cut
