######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################

$PLUGIN="bookmark";
$VERSION="2.0";

use strict;
my $body;

$bookmark::js=0;

#my $js_bookmark=<<EOM;
#<script type="text/javascript"><!--
#\@\@yuicompressor_js="./plugin/bookmark.inc.js"\@\@
#//--></script>
#EOM


sub plugin_bookmark_convert {
	return &plugin_bookmark_inline(@_);
}

sub plugin_bookmark_inline {
	my ($arg)=@_;
	my ($title,$url,$pagename,$mode,$title2)=split(/,/,$arg);
#	my $body;

	my $agent=$ENV{HTTP_USER_AGENT};
	return ' 'unless($agent=~/MSIE/ || $agent=~/Trident/|| $agent=~/Opera/ || $agent=~/Fire[Ff]ox/);

	my $iever;
	if($agent=~/Trident\/\d+.\d+; rv:(\d+).(\d+)/) {
		$iever=$1 + 0;
	}
	if($agent=~/MSIE\s(.*?);/) {
		$iever=$1 + 0;
	}
	return if($url ne &javascriptspecialchars($url));
	$pagename=&javascriptspecialchars($pagename);

	if(&plugin_bookmark_pyukiver) {
		$url=$::basehref if($url eq '');
	} else {
		$url=&getbasehref if($url eq '');
	}
	if($pagename eq '') {
		if($::wiki_title ne '') {
			$pagename=$::wiki_title;
		} else {
			$pagename=$::form{mypage};
		}
	}
	if($url!~/^http/ && $title eq '') {
		$body=<<EOM;
<br>
<strong>bookmark plugin</strong><br>
Usage: #bookmark(text,[url],[pagename],[start]);<br>
EOM
	} else {
		if($mode=~/([Hh][Oo][Mm][Ee])|([Ss][Tt][Aa][Rr][Tt])/
			&& $agent=~/Windows/ && $iever>=5) {
			my $urltmp=&encode(&escape(&code_convert(\$url,'utf8',$::defaultcode)));
			my $pagetmp=&encode(&escape(&code_convert(\$pagename,'utf8',$::defaultcode)));
			my $id="bookmark" . $bookmark::js;

			if($::versionnumber >= 0 * 10000 + 21 * 100 + 0) {
				$body=<<EOM;
<span id="$id"></span>
EOM
				$::IN_JSHEAD.=<<EOM;
sethomepage("$id","$urltmp","$pagetmp","$title",0);
EOM
			} else {
				$body=<<EOM;
<span id="$id"></span>
<script type="text/javascript"><!--
sethomepage("$id","$urltmp","$pagetmp","$title",0);
//--></script>
EOM
			}
			$bookmark::js++;
#			$::IN_HEAD.=$js_bookmark if($bookmark::js++);
		} else {
			$title=$title2 if($title2 ne '');
			my $urltmp=&encode(&escape(&code_convert(\$url,'utf8',$::defaultcode)));
			my $pagetmp=&encode(&escape(&code_convert(\$pagename,'utf8',$::defaultcode)));
			my $id="bookmark" . $bookmark::js;

			if($::versionnumber >= 0 * 10000 + 21 * 100 + 0) {
				$::IN_JSHEAD.=<<EOM;
setbookmark("$id","$urltmp","$pagetmp","$title");
EOM
			} else {
				$body=<<EOM;
<span id="$id"></span>
<script type="text/javascript"><!--
setbookmark("$id","$urltmp","$pagetmp","$title");
//--></script>
EOM
			}
			$bookmark::js++;
#			$::IN_HEAD.=$js_bookmark if($bookmark::js++);
		}
	}
#	return $body if(&plugin_bookmark_pyukiver);
#	if($::IN_HEAD=~/function\ set(homepage|bookmark)/) {
#		$body=$::IN_HEAD . $body;
#		$::IN_HEAD.="<!-- function sethomepage, function setbookmark -->";
#	}
	return $body;
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

sub plugin_bookmark_pyukiver {
	my ($v,$s)=split(/\-/,$::version);
	$v=~s/\.//g;
	return 1 if($v+0>=16);
	return 0;
}

sub getbasehref {
	# Thanks moriyoshi koizumi.
	my $basehref = "$ENV{'HTTP_HOST'}";
	if (($ENV{'https'} =~ /on/i) || ($ENV{'SERVER_PORT'} eq '443')) {
		$basehref = 'https://' . $basehref;
	} else {
		$basehref = 'http://' . $basehref;
		$basehref .= ":$ENV{'SERVER_PORT'}" if ($ENV{'SERVER_PORT'} ne '80');
	}
	$basehref .= $ENV{'SCRIPT_NAME'};
}

1;
__END__

=head1 NAME

bookmark.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &bookmark(Bookmark This Page);
 &bookmark(Regist Start Page,@@PYUKI_URL@@,start,Bookmark This Page);

=head1 DESCRIPTION

Make Bookmark link for Windows Internet Explorer

=head1 USAGE

 &bookmark(text, [url], [page name], [start], [substitution text]);

=over 4

=item text (Indispensable)

It writes hear, link text.

=item url

Link to url

When omits, $::basehref url is displayed.

=item page name

Bookmark to page title.

When omits, $::wiki_title value or FrontPage title is displayed.

=item start

Create link for registering start page.

The link automatically registered into a bookmark is created to the browser which cannot be registered into a start page.

=item substitution text

It is an alternative text for registering with the bookmark to the browser which cannot be registered into a start page.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/bookmark

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/bookmark/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/bookmark.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
