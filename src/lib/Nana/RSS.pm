######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package Nana::RSS;
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
		version => $hash{version},
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
	foreach(keys %hash) {
		if($hash{$_} =~ /\n/) {
			my $s=$hash{$_};
			if($self->{version} eq "atom") {
				$s=~s/\n//g;
			} else {
				$s=~s/\n/\<br \/\>\n/g;
			}
			$hash{$_}="<![CDATA[$s]]>";
		}
	}
	push(@{$self->{items}}, \%hash);
	return $self->{items};
}

#
sub as_string {
	my ($self) = @_;
	my $doc;
	if($self->{version} eq "1.0") {
		$doc = <<"EOD";
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

	} elsif($self->{version} eq "2.0") {
		$doc = <<"EOD";
<?xml version="1.0" encoding="$self->{encoding}"?>
<rss
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:content="http://purl.org/rss/1.0/modules/content/"
 version="2.0">
<channel>
<title>$self->{channel}->{title}</title>
<link>$self->{channel}->{link}</link>
<description>$self->{channel}->{description}</description>
<language>$self->{channel}->{language}</language>
<lastBuildDate>$self->{channel}->{lastbuilddate}</lastBuildDate>

@{[
 map {
  qq{
	<item>
		<title>$_->{title}</title>
		<link>$_->{link}</link>
		<description>$_->{description}</description>
		<pubDate>$_->{dc_date}</pubDate>
	</item>
  }
 } @{$self->{items}}
]}
</channel>
</rss>
EOD
	} elsif($self->{version} eq "atom") {
		$doc = <<"EOD";
<?xml version="1.0" encoding="$self->{encoding}"?>
<feed version="0.3" xml:lang="$self->{language}" xmlns="http://purl.org/atom/ns#" xmlns:dc="http://purl.org/dc/elements/1.1/">
<title>$self->{channel}->{title}</title>
<link rel="alternate" type="text/html" href="$self->{channel}->{basehref}" />
<generator uri="$self->{channel}->{basehref}">$self->{channel}->{wikititle}</generator>
<tagline>$self->{channel}->{description}</tagline>

@{[
 map {
  qq{
	<entry>
		<title>$_->{title}</title>
		<link rel="alternate" type="text/html" href="$_->{link}" />
		<modified>$_->{dc_date}</modified>
		<summary>$_->{description}</summary>
	</entry>
  }
 } @{$self->{items}}
]}
</feed>
EOD
	}
	$doc;
}

1;
__END__

=head1 NAME

Nana::RSS - The smallest module to generate RSS 1.0.
It is downward compatible to XML::RSS.

=head1 SYNOPSIS

    use strict;
    use Nana::RSS;

    my $rss = new Nana::RSS(
        version => '1.0', (or '2.0')
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

Nana::RSS is the smallest RSS 1.0 generator.
This module helps you to create the minimum document of RSS 1.0.
If you need more than that, use XML::RSS.

=head1 METHODS

=over 4

=item new Nana::RSS (version => $version, encoding => $encoding)

Constructor for Nana::RSS.
It returns a reference to a Nana::RSS object.
B<version> must be 1.0.
B<encoding> will be inserted output document as a XML encoding.
This module does not convert to this encoding.

=item add_item (title => $title, link => $link, description => $description, dc_date => $date)

Adds an item to the Nana::RSS object.

=item as_string

Returns the RSS string.

=item channel (title => $title, link => $link, description => $desc)

Channel information of RSS.

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/RSS.pm>

=item L<XML::RSS>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_YUKI@@

@@AUTHOR_PYUKI@@

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
