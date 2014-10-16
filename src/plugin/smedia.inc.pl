######################################################################
# @@HEADER2_NANAMI@@
######################################################################
#
# ソーシャルメディアへリンクするプラグイン
#
######################################################################
# 2012/03/20 0.2.0-p4 : 大幅変更
######################################################################

sub plugin_smedia_init {

# デフォルトのソーシャルメディア
$smedia::share="twitter,facebook,google,mixi,livedoor"
	if(!defined($smedia::share));
$smedia::bookmark="hatena,yahoo,googleb,bookmark"
	if(!defined($smedia::bookmark));
$smedia::subscribe="yahoorss,googlerss,livedoorrss"
	if(!defined($smedia::subscribe));

# if you not setting mixikey, not display
# this is using mobile mail auth.
# https://mixi.jp/guide_developer.pl
$smedia::mixikey=""
	if(!defined($smedia::mixikey));

%smedia::array;

$smedia::array{twitter_username}=""
	if($smedia::array{twitter_username} eq "");

$smedia::array{twitter_follow}=0
	if($smedia::array{twitter_follow} eq "");

$smedia::array{gree_type}=0
	if($smedia::array{gree_type} eq "");

$smedia::array{gree_height}=20
	if($smedia::array{gree_height} eq "");

}

######################################################################

use strict;
$::plugin_smedia_loaded=0;

sub plugin_smedia_convert {
	return &plugin_smedia_inline(@_);
}

sub plugin_smedia_inline {
	my $argv = shift;
	my @argv=split(/,/,$argv);

	&plugin_smedia_init;

	if($ENV{HTTP_USER_AGENT}=~/MSIE\s(\d+)\.(\d+)/) {
		return ' ' if($1 <= 6);
	}
	if($ENV{HTTP_USER_AGENT}=~/FireFox\/(\d+)\.(\d+)\.(\d+)/) {
		return ' ' if($1 <= 1);
	}
	return ' ' if($::htmlmode eq "xhtml11");
	return ' '
		if($::form{cmd}=~/edit|admin/);

	my $bar="";
	my $args="";

	my $url=&make_cookedurl($::pushedpage ne '' ? $::pushedpage : $::form{mypage});
	&getbasehref;
	my $base=$::basehref;
	my $rss="$base?cmd=rss&amp;ver=2.0@{[$::_exec_plugined{lang} > 1 ? '&amp;lang=$::lang' : '']}";
	$base=~s/\/$//;
	$url="$base$url";

	foreach(@argv) {
		s/"//g;
		if($_ eq "menubar" || $_ eq "sidebar") {
			$bar="menubar";
			next;
		} elsif(/facebook/ && (/comment/ || /bbs/)) {
			&init_dtd(qq(xmlns:fb="http://ogp.me/ns/fb#"));
			$::IN_BODY.=<<EOM;
>
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/ja_JP/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script
EOM
			return <<EOM;
<fb:comments href="http://nicov.jp/" num_posts="5" width="470"></fb:comments>
EOM
		} else {
			$args.="$_,";
		}
	}
	$args=~s/\,$//g;

	my $title=$::IN_TITLE ? $::IN_TITLE : $bar eq "menubar" ? $::pushedpage : $::form{mypage};
	$title.=" - $::wiki_title" if($::wiki_title ne '');

	return &plugin_smedia_html($url,$rss, $title, $args, $bar);
}

sub plugin_smedia_html {
	my($url,$rssurl,$title, $argv, $form)=@_;
	my @argv=split(/,/,$argv);
	&plugin_smedia_init;
	return ' ' if($::plugin_smedia_loaded);

	$::plugin_smedia_loaded++;

	$::IN_JSHEADVALUE.=<<EOM;
var smedia_share="$smedia::share";smedia_bookmark="$smedia::bookmark";smedia_subscribe="$smedia::subscribe";smedia_mixikey="$smedia::mixikey";
EOM
	$::IN_JSHEADVALUE.=<<EOM;
var smediaarray=new Array();
EOM
	foreach(keys %smedia::array) {
		$::IN_JSHEADVALUE.=<<EOM;
smediaarray["$_"]="$smedia::array{$_}";
EOM
	}

	my $body=<<EOM;
<div id="smediabutton"></div>
EOM
	$::IN_JSHEAD.=<<EOM;
smedia_init("$url","$rssurl","$title","$argv","$form");
EOM
	return $body;
	my $bar=0;
	foreach(@argv) {
		my($l,$r)=split(/=/,$_);
		if($l=~/^twitter\-(.+)/) {
			my $v=$1;
			if($v=~/data-via|data-text|data-related|data-hashtags|data-lang|data-url/) {
				$smedia::twitter{$v}=$r;
			}
		} elsif($l=~/^facebook\-(.+)/) {
			my $v=$1;
			if($v=~/data-href/) {
				$smedia::facebook{$v}=$r;
			}
		} elsif($l=~/^hatena\-(.+)/) {
			my $v=$1;
			if($v=~/href/) {
				$smedia::hatena{"url"}=$r;
			} elsif($v=~/title/) {
				$smedia::hatena{"title"}=$r;
			}
		}
	}

	my $out;
	my $class=$::form{form} eq "menubar" ? "smediamenubar" : "smedia";
	$out=qq(<div class="$class"><ul class="$class">);
	foreach(split(/,/,$smedia::default)) {
		if($_ eq '') {
			$out.="</tr></table><table><tr>";
		} else {
			$_=~s/\+//g;
			$out.=qq(<li class="$class\_$_">);
			$out.=&plugin_smedia_htmlout($_);
			$out.=qq(</li>);
		}
	}
	$out.="</ul></div>\n";
	return $out;
}

1;
__END__
=head1 NAME

smedia.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &smedia([options=value[,options=value]]);

=head1 DESCRIPTION

Display Social media bookmark link.

=head1 ATTENTION

Can't execute XHTML 1.1 mode

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/smedia

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/smedia/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/smedia.inc.pl>

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
