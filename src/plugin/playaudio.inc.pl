######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# 2012/02/18 change: WMVがなくてもMP4があれば一応動くようにした。
#                    その為、アップロード時に MP4::Infoが必要になります。
#                    IEでのポップアップを開くのが遅いのを修正した。
######################################################################
# Usage:
# &playaudio(name, [options...]);
# #playaudio(name, [options...])
#
#  name : audio file name
#    if not place filename extention, new window open.
#    if place filename extention (wmv or html)
#      inner window player
#
#  options :
#    image=filename.jpg or gif or png
#    filename.jpg or gif or png
#      movie cover image (attach file)
#    inline, inline=yes
#      inline window player
#    autoplay, autoplay=yes, autostart, autostart=yes
#      auto play when wiki page open
#    loop, loop=yes
#      movie loop (only Popup Windows Media / HTML video and HTML5 video)
#    notime, notime=yes
#      not display movie time
#    nodownload, nodownload=yes
#      not place download link
#    size=(0-100)%
#      inner player size
#    width=xxx height=xxx or 640x480
#      inner player size
#    youtube=ID
#      YouTube ID
#    niconico=ID
#      NicoVideo ID
#
########################################################################

$PLUGIN="playaudio";
$VERSION="0.1";



use Nana::Cache;
use Nana::HTTP;
#use Image::ExifTool;
require "$::plugin_dir/counter.inc.pl";

$playaudio::fedeout=2
	if(!defined($playaudio::fedeout));

$playaudio::regex=qq(mp3|ogg|wav)
	if(!defined($playaudio::regex));

######################################################################

use strict;

sub plugin_playaudio_action {
	if($::form{mode} eq "image") {
		my $mime;
		my $file  = "$::upload_dir/" . &dbmname($::form{page}) . '_' . &dbmname($::form{name});
		if($::form{name}=~/\.[Pp][Nn][Gg]$/) {
			$mime="image/png";
		} elsif($::form{name}=~/\.[Gg][Ii][Ff]$/) {
			$mime="image/gif";
		} elsif($::form{name}=~/\.[Jj][Pp][Ee]?[Gg]$/) {
			$mime="image/jpeg";
		} else {
			&content_output(&http_header("Content-type: text/html",$::HTTP_HEADER)
				, qq(<html><body>image type error:$::form{name}</body></html>));
			exit;
		}
		&load_module("Image::Magick");
		my $iq = Image::Magick->new;
		my $ik = $iq->Read($file);
		my ($width,$height,$filesize) = $iq->Get('width','height','filesize');
		my $img;
		if($::form{width} eq $width && $::form{height} eq $height) {
			open(R,$file);
			binmode(R);
			read(R,$img,$filesize);
			close(R);
		} else {
			my $cachef="$::cache_dir/" . &dbmname("$::form{attach}$::form{width}$::form{height}$ENV{REMOTE_ADDR}$ENV{PID}$ENV{PPID}") . ".refMagick";
			$ik = $iq->Scale(geometry=>"$::form{width}x$::form{height}");
			$ik = $iq->Write(filename=>"$cachef");
			open(R,$cachef);
			binmode(R);
			read(R,$img,-s $cachef);
			close(R);
			unlink($cachef);
		}
		print &http_header(
			"Content-type: $mime\n",
			"Accept-Ranges: bytes\n",
			sprintf("Content-Length: %d\n"
				,length($img)),
			sprintf("Last-Modified: %s GMT\n"
				, &date("D, j M Y G:i:S",(stat($file))[9],"gmtime")));
		print $img;
		exit;
	} elsif($::form{mode}="popup") {
		if($::form{page} ne '' && $::form{name} ne '' && $::form{height} ne '' && $::form{width} ne '') {
			my $url = "$::upload_url/" . &dbmname($::form{page}) . '_' . &dbmname($::form{name});
			my $body=<<EOM;
$::dtd
<title>$::form{name}</title>
<script type="text/javascript"><!--
function loadchk(){if(d.pi.complete){window.status="";self.resizeTo($::form{width}+10,$::form{height}+80);}else{window.status="Loading...";window.setTimeout("loadchk();",100);}}
function imgsize(v){var w=$::form{width}*v;var h=$::form{height}*v;d.pi.height=h;d.pi.width=w;self.resizeTo(w+10,h+80);}
window.setTimeout("loadchk();",100);
//--></script>
<style type="text/css"><!--
*,img{margin: 0px;padding: 0px;}
//--></style>
</head>
<body>
<div align="center" id="view" style="display:block;">
<table>
<tr><td>
<form action="#">
<select name="size" onchange="imgsize(this.value);">
<option value="0.25">25%</option>
<option value="0.5">50%</option>
<option value="1" selected="selected">100%</option>
<option value="1.5">150%</option>
<option value="2">200%</option>
</select>
</form>
</td>
<td>
<form action="#">
<input type="button" value="$::resource{closebutton}" onclick="self.close();">
</form>
</td>
</tr>
</table>
<img src="$url" name="pi" alt="$::form{page}&#13;&#10;$::form{name}\" title=\"$::form{page}&#13;&#10;$::form{name}" height="$::form{height}" width="$::form{width}" onclick="self.close();" /><br />
</div>
</body>
</html>
EOM
			&content_output(&http_header("Content-type: text/html; charset=$::charset",$::HTTP_HEADER),$body);
		} else {
			&content_output(&http_header("Content-type: text/html",$::HTTP_HEADER)
				, qq(<html><body>access deined</body></html>));
		}
		exit:
	}
}

sub plugin_playaudio_inline {
	my ($args) = @_;
	my @args = split(/,/, $args);
	return 'no argument(s).' if (@args < 1);	#エラーチェック	# comment
	my %params = &plugin_playaudio_body($args, $::form{mypage});
	return ($params{_error}) ? $params{_error} : $params{_body};
}

sub plugin_playaudio_convert {
	my ($args) = @_;
	my @args = split(/,/, $args);
	return '<p>no argument(s).</p>' if (@args < 1);	#エラーチェック	# comment
	my %params = &plugin_playaudio_body($args, $::form{mypage});

	# divで包む														# comment
	my $style;
	if ($params{around}) {
		$style = ($params{_align} eq 'right') ? 'float:right' : 'float:left';
	} else {
		$style = "text-align:$params{_align}";
	}
	return "<div class=\"img_margin\" style=\"$style\">$params{_body}</div>\n";
}

sub plugin_playaudio_body {
	my ($args) = @_;
	my @args = split(/,/, $args);
	my @names;
#	my $name = &trim(shift(@args));
	my $page;

	my (%params);
	foreach (@args) {
		$_ = &trim($_);
		my ($l, $r)=split(/=/,$_);
		$l=lc &trim($l);
		$r=&trim($r);
		if($l=~/loop|autoplay/) {
			$params{lc $l} = 1;
		} elsif($l=~/vol|volume/) {
			$l="volume" if($l eq "vol");
			$params{lc $_} = $r;
		} else {
			push(@names, &trim($_));
		}
	}

	my ($url, $url2, $urlr, $title, $is_image, $info);
	my @url;
	my %playaudio_counter;
	foreach my $name(@names) {
		if ($name =~ /^$::isurl/o) {	#URL				# comment
			$url = $url2 = &htmlspecialchars($name);
			$title = &htmlspecialchars(($name =~ '/([^\/]+)$/') ? $1 : $url);
			push(@url, $url) if($url ne "");
		} else {	# 添付ファイル							# comment
			if (!-d "$::upload_dir/") {
				$params{_error} = 'no $::upload_dir.';
				return %params;
			}
			# ページ指定のチェック							# comment
			$page = $::form{mypage} if (!$page);
			if ($name =~ /^(.+)\/([^\/]+)$/) {
				$1 .= '/' if ($1 eq '.' or $1 eq '..');
				$page = get_fullname($1, $page);
				$name = $2;
			}
			$title = &htmlspecialchars($name);
			my $file  = "$::upload_dir/" . &dbmname($page) . '_' . &dbmname($name);
			my $file2 = "$::upload_url/" . &dbmname($page) . '_' . &dbmname($name);
			if (!-e $file) {
				next;
#				$params{_error} = 'file not found.' . $file;
#				return %params;
			}

			my $ext=$name;
			$ext=~s/.*\.//g;
			$url = "$::script?cmd=attach&amp;pcmd=open"
				. "&amp;file=@{[&encode($name)]}&amp;mypage=@{[&encode($page)]}&amp;refer=@{[&encode($page)]}&_ext=.$ext";
			push(@url, $url) if($url ne "");

			if($::AttachCounter eq 2) {
				require "$::plugin_dir/counter.inc.pl";
				my %attach_counter=&plugin_counter_do("attach\_$page\_$name","r");
				$playaudio_counter{total}+=$attach_counter{total}+0;
				$playaudio_counter{today}+=$attach_counter{today}+0;
				$playaudio_counter{yesterday}+=$attach_counter{yesterday}+0;
			}
		}
	}
	my $icon = $params{noicon} ? '' : $playaudio::file_icon;
	&jscss_include("audio");

	my $jsparm;
	foreach(@url) {
		$jsparm.="'" . $_ . "',"
	}
	$jsparm=~s/,$//g;
	if($jsparm eq "") {
		$params{_body}=<<EOM;
$::resource{playaudio_notfound}
EOM
	} else {
		$params{_body}=<<EOM;
<a href="javascript:playaudio.play($jsparm);">$::resource{playaudio_play}</a> &nbsp; 
<a href="javascript:playaudio.stop();">$::resource{playaudio_stop}</a> &nbsp; 
EOM
		$params{_body} .= &make_link_target($url,"audio","_self",$info,"_self")
			. "$icon$::resource{playaudio_download}</a>\n";
		# add 0.2.0-p2
		$params{_body} .= <<EOM if($playaudio::displayinfo eq 1);
<span class="ref_info">$info</span>
EOM
		# add 0.1.8										# comment
		if($::AttachCounter eq 2) {
			$params{_body} .= <<EOM;
<br />
<span style="font-size: 10px;">
TOTAL: $playaudio_counter{total} TODAY: $playaudio_counter{today} YESTERDAY: $playaudio_counter{yesterday}
</span>
EOM
	}
	}

	$::IN_JSHEAD.=<<EOM;
playaudio.init("$::skin_url", $playaudio::fedeout);
EOM
	return %params;
}

sub plugin_playaudio_bytes {
	my ($size)=@_;
	my $kb = $size . " bytes";
	if($size>1024) {
		$kb = sprintf("%.1f KB", $size / 1024);
	}
	if($size>1024 * 1024) {
		$kb = sprintf("%.1f MB", $size / 1024 / 1024);
	}
	if($size>1024 * 1024 * 1024) {
		$kb = sprintf("%.1f GB", $size / 1024 / 1024 / 1024);
	}
	if($size>1024 * 1024 * 1024 * 1024) {
		$kb = sprintf("%.1f TB", $size / 1024 / 1024 / 1024 / 1024);
	}
	return $kb;
}

1;
__END__
=head1 NAME

playaudio.inc.pl - PyukiWiki External Plugin

=head1 SYNOPSIS

Playaudio Plugin

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/playaudio/

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/playaudio/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/playaudio.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
