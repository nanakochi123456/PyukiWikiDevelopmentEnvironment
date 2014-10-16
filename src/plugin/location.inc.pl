######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 2012/09/27 JavaScriptでの移動をできるようにした。
# v0.2.1 2012/04/25 0のとき、Locationヘッダで移動するようにした。
# v0.1.9 2011/02/23 新規作成
#
# *Usage
# #location(http:�・ or wikiページ名)
#
# 安全の為、凍結されているページでしか実行されません。
######################################################################

use strict;

$::location::move_time=3
	if(!defined($::location::move_time));

$location::301redirect=1
	if(!defined($location::301redirect));

sub plugin_location_convert {
	my ($url, $time, $jsflag, $nomsg, $fakeurl)=split(/,/,shift);

	return if(!&is_frozen($::form{mypage}));

	if(&is_exist_page($url)) {
		my $tmp=&make_cookedurl($url);
		$url="$::basehref$tmp";
	}
	$::location::move_time=$time if($time ne "");

	if($::location::move_time eq 0) {
		&location($url, $location::301redirect eq 1 ? 301 : 302, $::HTTP_HEADER);
		exit;
	}
	if($jsflag=~/js/) {
		$::IN_JSHEAD.=<<EOM;
jslocation("sec",'$url',$::location::move_time, '$fakeurl');	
EOM
		return qq(<span id="sec"></span>);
	}
	$::IN_HEAD.=<<EOM;
<meta http-equiv="Refresh" content="$::location::move_time;url=$url" />
EOM
	my $body=$::resource{location_plugin_message};
	$body=~s/\$URL/$url/g;
	return ' ' if($nomsg eq "nomsg");
	return $body;
}

1;
__END__
=head1 NAME

locatioin.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #location(url or wiki page)

=head1 DESCRIPTION

This plugin is location of page.

=head1 USAGE

 #location(url or wiki page)

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/location

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/location/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/location.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
