######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# 画像を表示する。
# :書式|
#  #img(画像のURI[,書式][,altコメント][,width,height])
# 書式：r,right(右寄せ) or l,left(左寄せ) or center (中央寄せ)
# or module(index.cgi からの呼び出し)
# or それ以外(クリア)~
# Pyukiwiki Classic v0.1.6b よりこの関数を 
# lib/wiki.cgi の img 変換でも呼び出すよう修正。(必須)
######################################################################

# 末尾、gif, png, jpg, jpeg でなくても、img タグを表示する
$img::force_img_tag=0
	if(!defined(img::force_img_tag));

sub plugin_img_inline {
	return &plugin_img_convert(@_);
}

sub plugin_img_convert {
	my ($uri, $align, $alt, $width, $height) = split(/,/, shift);
	$uri   = &trim($uri);
	$align = &trim($align);
	$alt   = &trim($alt);
	my $module = 0;
	my $res = '';

	if ($align =~ /^(r|right)/i) {
		$align = 'right';
	} elsif ($align =~ /^(l|left)/i) {
		$align = 'left';
	} elsif ($align =~ /^(center)/i) {
		$align = 'center';
	} elsif ($align =~ /^module$/i) {
		$module = 1;
	} elsif ($align ne '') {
		return '<div style="clear:both"></div>';
	}
#	if ($uri =~ /^(https?|ftp):/) {						# comment
		if ($uri =~ /\.(gif|png|jpe?g)$/i || $img::force_img_tag eq 1) {
			if ($module == 1) {
				# 必要であれば、この部分を拡張する。
				$res .= "<a href=\"$uri\"><img src=\"$uri\" /></a>\n";
			} else {
				$res .= "<div style=\"float:$align; padding:.5em 1.5em .5em 1.5em;\">"
					if($height ne 1 && $width ne 1);
				$res .= "<img src=\"$uri\"";
				$res .= " alt=\"$alt\"" if ($alt ne '');
				if($width ne '' && $height ne '') {
					$res .= " width=\"$width\" height=\"$height\"";
				}
				if($height ne 1 && $width ne 1) {
					$res .= " /></div>\n";
				} else {
					$res .= "/>\n";
				}
			}
		}
#	}													# comment
	return $res;
}
1;
__END__

=head1 NAME

img.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #img(http://example.com/image.png)
 #img(http://example.com/image.jpg,right)
 #img(http://example.com/image.gif,l,AlternateText)
 #img(,c)

=head1 DESCRIPTION

Display Image File

=head1 USAGE

 #img(image_url,[alt],[l|left],[r|right],c)

=over 4

=item image_url

URL of a picture is specified.

=item left | l

Align to Left

=item right | r

Align to Right

=item c

Disable a surroundings lump of a text

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/img

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/img/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/img.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
