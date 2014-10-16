######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# Usage:
#
# #popup(, NG Page or URL, OK Button, NG Button, width, height)
# string...
# #popup
#
# #popup(OK Page, NG Page or URL, OK Button, NG Button, width, height)
# string...
# #popup
######################################################################

use strict;

$popup::okbutton;
$popup::ngbutton;
$popup::okmove;
$popup::ngmove;
$popup::w;
$popup::h;

sub plugin_popup_convert {
	my($okmove, $ngmove, $okbutton, $ngbutton, $w, $h)=split(/,/,shift);

	if($html::nofreezeexec eq 0) {
		return ' ' if(!&is_frozen($::form{mypage}));
	}
	$popup::okmove=$okmove;
	$popup::ngmove=$ngmove;
	$popup::okbutton=$okbutton;
	$popup::ngbutton=$ngbutton;
	$popup::w=$w;
	$popup::h=$h;

	$::linedata="";
	$::linesave=1;
	$::eom_string="#popup";
	$::exec_inlinefunc=\&plugin_popup_display;
	return ' '
}

sub plugin_popup_display {
	my($text)=@_;
	my $html=<<EOM;
@{[&text_to_html($text)]}
<form>
@{[&plugin_popup_link($popup::okmove, $popup::okbutton)]}
@{[&plugin_popup_link($popup::ngmove, $popup::ngbutton)]}
</form>
EOM

	$html=~s/[\r\n]//g;
$::IN_JSHEAD.=<<EOM;
PopupOpen('$html', '$::basehost', $popup::w, $popup::h);
EOM
	return ' ';
}

sub plugin_popup_link {
	my($link, $button)=@_;
	my $url=$link eq "" ? "" : $link=~/$::isurl/ ? $link : "$::basehref" . &make_cookedurl($link);
	return <<EOM;
<input type="button" value="$button" onclick="PopupClose(\\'$url\\');" onkeypress="PopupClose(\\'$url\\');" />
EOM
}

1;

__DATA__

sub plugin_popup_usage {
	return {
		name => 'popup',
		version => '1.0',
		type => 'convert',
		author => '@@NANAMI@@',
		syntax => '#popup(, NG Page or URL, OK Button, NG Button, width, height) to eom of #popup',
		description => 'popup with saved browser cookie',
		description_ja => 'cookieに保存して初回だけポップアップをする',
		example => '#popup(, NG Page or URL, OK Button, NG Button, width, height)',
	};
}

1;
__END__

=head1 NAME

popup.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #popup(, NG Page or URL, OK Button, NG Button, width, height)
 wiki string
 wiki string
 ...
 #popup

=head1 DESCRIPTION

Display popup message with saving cookie control.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/popup

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/popup/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/popup.inc.pl>

=back

=head1 AUTHOR

=over 4

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
