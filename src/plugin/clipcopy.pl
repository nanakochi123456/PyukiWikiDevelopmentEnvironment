######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# clipcopy プラグイン
# IE専用のプラグインで、右クリックしてショートカットをコピーするものを
# ワンクリックでできるようにするものです。
# IE以外では、何も出力しません。
#
# usage : &clipcopy(url, text);
######################################################################


$PLUGIN="clipcopy";
$VERSION="1.3";

use strict;
package clipcopy;

sub plugin_inline {
	my ($arg)=@_;
	my ($linkurl,$text,$copiedtext,$nodisplaytitle)=split(/,/,$arg);

	my $body;

	$text=&javascriptspecialchars($text);
	$linkurl=&javascriptspecialchars($linkurl);

	if(($ENV{HTTP_USER_AGENT}=~/MSIE/ || $ENV{HTTP_USER_AGENT}=~/Trident/) && $ENV{HTTP_USER_AGENT}!~/Opera/
	 || $ENV{HTTP_USER_AGENT}=~/FireFox/) {
#		return " " if($linkurl!~/$::isurl/);
		if($copiedtext eq '') {
			$copiedtext="$linkurl copied to clipboard";
		} else {
			$copiedtext=&javascriptspecialchars($copiedtext);
		}
		$body=<<EOM;
(<a href="javascript:void(0);"@{[$nodisplaytitle eq "" ? qq( title="$linkurl") : ""]} onclick="clipboardData.setData('Text', '$linkurl');alert('$copiedtext')">$text</a>)
EOM
		return $body;
	}
	return " ";
}

sub javascriptspecialchars {
	my ($s) = @_;
	$s =~ s|\r\n|\n|g;
	$s =~ s|\&|&amp;|g;
	$s =~ s|<|&lt;|g;
	$s =~ s|>|&gt;|g if($s=~/</);
	$s =~ s|"|&quot;|g;
	$s =~ s|'|&apos;|g;
	return $s;
}

sub plugin_clipcopy_pyukiver {
	my ($v,$s)=split(/\-/,$::version);
	$v=~s/\.//g;
	return 1 if($v+0>=16);
	return 0;
}

1;
__END__

=head1 NAME

clipcopy.pl - PyukiWiki / YukiWiki Plugin

=head1 SYNOPSIS

 &clipcopy(linkurl, text, [copiedtext]);
 &clipcopy(@@BASEURL@@/?rss
  ,RSS Link Copy,@@BASEURL@@/?rss Copied to clipboard);

=head1 DESCRIPTION

Specified URL is copied to a clipboard. Any character strings other than URL cannot be specified.

Only Internet Explorer.
Nothing is returned in the other browser.

This plugin is compatible with YukiWiki.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/clipcopy

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/clipcopy/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/clipcopy.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
