######################################################################
# @@HEADER2_NANAMI@@
######################################################################

$back::allowpagelink=0
	if(!defined($back::allowpagelink));
$back::allowjavascript=1
	if(!defined($back::allowjavascript));
$back::blacket=1
	if(!defined($back::blacket));
######################################################################

use strict;

$::back::count;

sub plugin_back_convert {
	my($str,$align,$hr,$link)=split(/,/,shift);
	my $body;
	$str=$::resource{backbutton} if($str eq '');
	$align="center" if($align eq '');
	if($hr+0 eq 0) {
		$hr="";
	} else {
		$hr=qq(<hr class="full_hr" />\n);
	}
	if($back::allowpagelink eq 0) {
		$link="";
	} elsif($link!~/$::isurl/) {
		$link = &make_cookedurl(&encode($link));
	}
	if($link eq "") {
		if($back::allowjavascript eq 1) {
			$::back::count+=0;
			$::back::count++;
			$body=<<EOM;
<span id="back_$::back::count"></span>
<script type="text/javascript"><!--
//--></script>
<noscript>
$hr
<div align="$align">
@{[$back::blacket eq 1 ? '[' : '']}<a href="$ENV{HTTP_REFERER}" title="$str">$str</a>@{[$back::blacket eq 1 ? ']' : '']}
</div>
</noscript>
EOM
			$::IN_JSHEAD.=<<EOM;
if(history.length!=0){sinss("back_$::back::count",'$hr<div align="$align">@{[$back::blacket eq 1 ? '[' : '']}<a href="javascript:history.go(-1)" title="$str">$str</a>@{[$back::blacket eq 1 ? ']' : '']}</div>';}
EOM
		} elsif($ENV{HTTP_REFERER} ne '') {
			$body=<<EOM;
$hr
<div align="$align">
@{[$back::blacket eq 1 ? '[' : '']}<a href="$ENV{HTTP_REFERER}" title="$str">$str</a>@{[$back::blacket eq 1 ? ']' : '']}
</div>
EOM
		} else {
			$body=" ";
		}
	} else {
		$body=<<EOM;
$hr
<div align="$align">
<a href="$link" title="$str">$str</a>
</div>
EOM
	}
	return $body;
}

1;
__DATA__

sub plugin_back_usage {
	return {
		name => 'back',
		version => '2.0',
		type => 'convert',
		author => '@@NANAMI@@',
		syntax => '#back(Display String [,left|center|right] [,0|1],[Back to link])',
		description => 'The link to a return place is installed in the specified position.',
		description_ja => '指定した位置に戻り先へのリンクを設置します。',
		example => '#back\n?#back(BACK,left)',
	};
}

1;
__END__

=head1 NAME

back.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #back( [[Display string] [,[left| center| right] [,[0| 1] [,[Back to link] ]]]] ) 

=head1 DESCRIPTION

The link to a return place is installed in the specified position.

=head1 USAGE

=over 4

=item Display string

If a printable character sequence omits, it will become "Back"

=item left, center, right

A display position is specified of left, center, or right. Default is center.

 left - Displayed by flush left.
 center - Displayed by central.
 right - Displayed by flush right.

=item 0, 1

The existence of the horizon is specified. Default is 1

 0 - No display.
 1 - Display horizon line.

=item Back to link

A return place specifies a link by either of URL and the page names used as the movement place at the time of selection.

=back

=head1 SETTING

=head2 back.inc.pl

=over 4

=item $back::allowpagelink

It sets up whether return place specification by the page name (+ anchor name) is enabled.

=item $back::allowjavascript

It specifies whether JavaScript(history.go (-1)) is used for specification of a return place.

It does not display, when the history of JavaScript does not exist.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/back

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/back/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/back.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
