######################################################################
# @@HEADER2_YUKI@@
######################################################################

use strict;

package link;

sub plugin_inline {
	my ($escaped_argument) = @_;
	my ($caption, $url,$target) = split(/,/, $escaped_argument);
	if ($url =~ /^(mailto|http|https|ftp):/) {
		return &make_link_url("link",$url,$caption,@{[$::use_autoimg && $caption=~/\.$::image_extention$/o ? $caption : ""]},$target);
#		return qq(<a href="$url">$caption</a>);
	} elsif($url=~/(?:[Mm][Aa][Ii][Ll][Tt][Oo]:($::ismail))|($::ismail)/) {
		return &make_link_mail($url,@{[$::use_autoimg && $caption=~/\.$::image_extention$/o ? &make_link_image($caption,"Mail") : $caption]});
	} else {
		return qq(&link($escaped_argument));
	}
}

sub plugin_usage {
	return {
		name => 'link',
		version => '1.1',
		author => 'Hiroshi Yuki http://www.hyuki.com/',
		syntax => '&link(caption,url)',
		description => 'Create link with given caption..',
		example => "Please visit &link(Hiroshi Yuki,http://www.hyuki.com/).",
	};
}

sub make_link_url {
	my $funcp = $::functions{"make_link_url"};
	return &$funcp(@_);
}
sub make_link_mail {
	my $funcp = $::functions{"make_link_mail"};
	return &$funcp(@_);
}
sub make_link_image {
	my $funcp = $::functions{"make_link_image"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

link.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &link(Hiroshi Yuki,http://www.hyuki.com/[,_blank|_top|frame name]);
 &link(Mail,mail (at) example (dot) com);
 &link(Mail,mail (at) example (dot) com?cc=cc (at) example (dot) com&bcc=bcc (at) example (dot) com);

=head1 DESCRIPTION

This plagin is link web page or mail link.

It is not influenced by the internal purser of PyukiWiki.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/link

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/link/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/link.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_YUKI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_YUKI@@

=cut
