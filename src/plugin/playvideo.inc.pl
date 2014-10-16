######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# 2012/02/18 change: WMVがなくてもMP4があれば一応動くようにした。
#                    その為、アップロード時に MP4::Infoが必要になります。
#                    IEでのポップアップを開くのが遅いのを修正した。
# 2012/02/14 change: 別ウィンドウを開かなくても出るモードを設置した。（β版）
# 2012/02/13 change: JavaScriptポップアップでウィンドウサイズを変更するように
#                    した。
#                    video.jsを2.0.2から3.0.7にバージョンアップした。
# 2011/10/07 change: 複数のサイトに動画が分散していても対応できるようにした。
#                    ただし、wmvだけはPyukiWikiと同じサイトに設置しなければ
#                    いけませんが、mp4やflvも別サイトに設置することが
#                    できるようになった。
#                    このバージョンにするには、deletecache をする必要があり、
#                    かつ、FLV、MP4ファイルを消去した場合、もう一度 deletecache
#                    をする必要があります。
#                    無圧縮zip以外にも、生のWMVファイルをダウンロードできる
#                    ようにした。（デフォルトは無圧縮zip）
# 2011/10/05 change: HEADリクエストを用いて、WMV以外の拡張子の動画を
#                    PyukiWikiが設置してあるサーバー以外に設定できるように
#                    した。また、IE 9 において、video.jsを無効化した。
# 2011/10/02 change: HTML5プレイヤーに対応、その為、HTML5ブラウザーでなく
#                    Flashで再生する場合に、別途MP4ファイルが必要になる。
#                    その時の変換フォーマットは、FlowPlayerが認識するように
#                    MPEG4 AVC/H.264形式で変換しなければならない。
#                    旧来のFlashでの再生もサポートしていますが、IE10の
#                    デスクトップ版以外でサポートされなくなるため、互換性の為に
#                    準備だけはしてあります。
#                    IE9の不具合で、IE9においては、HTML5プレイヤーは使用
#                    できないようになっています。
# 2011/09/11 change: デフォルトのスキンを読み込めるようにした。
#                    FireFoxでキー操作により動画のリロードするのを阻止した。
#                    設定してある漢字コードで出力できるようにした。
# 2011/06/12 change: flv動画にも対応した。ただし、wmvも必要です。
# 2011/05/26 change: wmvにタグが付けられている場合、zipファイルのダウンロード
#                    ファイル名をその名前に指定できるようにした。
# 2011/05/26 change: info/setup.cgiに対応した
# 2011/03/14 change: Content-disposition: attachment; filename="$file.wvx"
#                    を出力すると問題がある可能性があるため、出力を
#                    抑制した。
# 2011/03/01 change: 拡張子をwvxに変更した。
#                    Content-Type: video/x-ms-wvx を出力した。
#                    Content-disposition: attachment; filename="$file.wvx"
#                    を出力した。
# 2010/12/10 change: ニコニコ動画に対応した
# 2010/11/13 change: 無圧縮zipでダウンロードできるようにした。
#                    大量の動画があるときキャッシュから取得するように
#                    した。ただし、有効期限は１時間です。
# 2010/10/27 change: MSIE とOpera以外はWindwos Mediaプレイヤー
#                    再生時に_blank(実質別タブ）になるようにした。
#                    Safariでは本当に別窓になります。
# 2010/10/24 change: use sub make_link_target
######################################################################
# Usage:
# &playvideo(name, [options...]);
# #playvideo(name, [options...])
#
#  name : video file name
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

$PLUGIN="playvideo";
$VERSION="2.2b";

use Nana::Cache;
use Nana::HTTP;
use Image::ExifTool;
require "$::plugin_dir/counter.inc.pl";

$::playvideo_plugin_usedownload=1		# 使わない時は0にする。
	if(!defined($::playvideo_plugin_usedownload));
$::playvideo_plugin_plain_download=0	# 生のwmvをダウンロードできるようにする
	if(!defined($::playvideo_plugin_plain_download));
$::playvideo_plugin_zipflags="-0";		# zipのオプション
$::playvideo_plugin_ziptmp="/tmp"		# zipファイルのテンポラリの位置
	if(!defined($::playvideo_plugin_ziptmp));
$::playvideo_plugin_videopath="video"
	if(!defined($::playvideo_plugin_videopath));
$::playvideo_plugin_playsite="http://$ENV{HTTP_HOST}/v.cgi"
	if(!defined($::playvideo_plugin_playsite));
$::playvideo_plugin_videourl="http://$ENV{HTTP_HOST}/$::playvideo_plugin_videopath"
	if(!defined($::playvideo_plugin_videourl));
# wmv 以外の再生サイトを設定する。
# サンプル
#	$::playvideo_plugin_videourl{flv}=<<EOM;
#	http://v2.nanakochi.daiba.cx/videonanakochi
#	http://v3.nanakochi.daiba.cx/videonanakochi
#	http://v-flv.nanakochi.daiba.cx
#	EOM
#	$::playvideo_plugin_videourl{mp4}=<<EOM;
#	http://v2.nanakochi.daiba.cx/videonanakochi
#	http://v3.nanakochi.daiba.cx/videonanakochi
#	http://v-mp4.nanakochi.daiba.cx
#	http://v-mp4-2.nanakochi.daiba.cx
#	EOM
#	$::playvideo_plugin_videourl{ogv}=<<EOM;
#	http://v2.nanakochi.daiba.cx/videonanakochi
#	http://v3.nanakochi.daiba.cx/videonanakochi
#	http://v-ogv.nanakochi.daiba.cx
#	EOM
#	$::playvideo_plugin_videourl{webm}=<<EOM;
#	http://v2.nanakochi.daiba.cx/videonanakochi
#	http://v3.nanakochi.daiba.cx/videonanakochi
#	http://v-webm.nanakochi.daiba.cx
#	EOM

$::playvideo_plugin_videourl{flv}=$::playvideo_plugin_videourl
	if(!defined($::playvideo_plugin_videourl{flv}));
$::playvideo_plugin_videourl{mp4}=$::playvideo_plugin_videourl
	if(!defined($::playvideo_plugin_videourl{mp4}));
$::playvideo_plugin_videourl{ogv}=$::playvideo_plugin_videourl
	if(!defined($::playvideo_plugin_videourl{ogv}));
$::playvideo_plugin_videourl{webm}=$::playvideo_plugin_videourl
	if(!defined($::playvideo_plugin_videourl{webm}));

# wmvのタイトルをzipに埋め込む
$::playvideo_plugin_downloadfilename_inwmv=0
	if(!defined($::playvideo_plugin_downloadfilename_inwmv));
# wmvの作者をzipに埋め込む
$::playvideo_plugin_downloadfilename_inwmv_withauthor=0
	if(!defined($::playvideo_plugin_downloadfilename_inwmv_withauthor));

# Youtubeの偽物（ニコニコ動画）を使用する
$playvideo::usefakeyoutubeurl=0
	if(!defined($playvideo::usefakeyoutubeurl));

$::playvideo_plugin_zipcmds=<<EOM;
/usr/bin/zip
/usr/local/bin/zip
EOM

# wmv9
$playvideo::wmvid="CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6"
# wmv6
#$playvideo::wmvid="CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95"
	if(!defined($playvideo::wmvid));

# スキン
$::playvideo_plugin_addcss=""
#$::playvideo_plugin_addcss="tube.css"
	if(!defined($::playvideo_plugin_addcss));
$::playvideo_plugin_vjs_skin="vjs-default-skin"
#$::playvideo_plugin_vjs_skin="tubecss"
	if(!defined($::playvideo_plugin_vjs_skin));


@HTML5_VIDEO_TARGETS_MP4=(
	"Safari 522",
	"MSIE 9",
	"iPod",
	"iPad",
	"iPhone",
	"Android",
);

@HTML5_VIDEO_TARGETS_OGV=(
	"Fire[Ff]ox 4",
	"Fire[Ff]ox 3.6",
	"Fire[Ff]ox 3.5",
	"Opera Version 11",
	"Opera Version 10.9",
	"Opera Version 10.8",
	"Opera Version 10.7",
	"Opera Version 10.6",
	"Opera Version 10.5",
	"Chrome 3",
	"iPod",
	"iPad",
	"iPhone",
	"Android",
);

@HTML5_VIDEO_TARGETS_WEBM=(
	"Chrome 6",
	"Safari 522",
	"MSIE 9",	# 以下、googleによるサポート
	"Fire[Ff]ox 4",
	"Fire[Ff]ox 3.6",
	"Fire[Ff]ox 3.5",
	"Opera Version 11",
	"Opera Version 10.9",
	"Opera Version 10.8",
	"Opera Version 10.7",
	"Opera Version 10.6",
	"Opera Version 10.5",
	"iPod",
	"iPad",
	"iPhone",
	"Android",
);

$wmv="wmv";
$ext="wvx";
$ext="asx"
	if($playvideo::wmvid eq "CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95");
$zip="zip";
$dl="dl";
$flv="flv";
$mp4="mp4";
$ogv="ogv";
$webm="webm";
$vhtml="html";

$playvideo::playercount=0;
$playvideo::htmlplayer=0;
$playvideo::flvplayer=0;

sub plugin_playvideo_convert {
	return "<div>". &plugin_playvideo_inline(@_) . "</div>\n";
}

sub plugin_playvideo_inline {
	my ($args)=@_;
	my @args = split(/,/, $args);
	return 'no argument(s).' if (@args < 1);

	my %params;
	my $fname=shift @args;
	foreach(@args) {
		if(/=/) {
			my($l,$r)=split(/=/,$_);
			$l=~s/^(\-|\-\-)//g;
			$l=lc $l;
			$l="niconico" if($l=~/nico/);
			$params{$l}=$r;
		} else {
			if(/\.$::image_extention$/oi) {
				$params{image}=$_;
			} elsif(/^sm(\d+)/) {
				$params{niconico}=$_;
			} elsif(/^([0-9.]+)%$/i) {
				$params{size}=$1;
			} elsif(/^([0-9]+)x([0-9]+)$/i) {
				$params{width}=$1;
				$params{height}=$2;
			} elsif(/^(nodl|nodownload)$/) {
				$params{nodownload}="true";
			} elsif(/^(autoplay)$/) {
				$params{autostart}=1;
			} elsif(/^(notime|inline|autostart|loop)$/) {
				$params{$_}=1;
			} else {
				$params{youtube}=$_;
			}
		}
	}
	$youtube=$params{youtube};
	$nicovideo=$params{niconico};

	my $body;
	$videopath=$::playvideo_plugin_videopath;
	$playsite=$::playvideo_plugin_playsite;
	$videourl=$::playvideo_plugin_videourl;
	my $ffull=$fname;
	my $fext=$fname;
	$fext=~s/^.*\.//g;
	$fname=~s/\..*//g;

	my $browser=$ENV{HTTP_USER_AGENT};
	my $wmvtarget = "";
	if ($browser=~/MSIE/ || $browser=~/Trident/ || $browser=~/Opera/ ) {
	} else {
		$wmvtarget = "_blank";
	}

	$playvideo::nicovideourl=$::resouyrce{playvideo_niconico_url};
	$playvideo::youtubeurl=$::resource{playvideo_youtube_url};
	$playvideo::youtube_fakeniconico_url=$::resource{playvideo_youtube_fakeniconico_url};
	$playvideo::youtubeobject=$::resource{playvideo_youtube_object};
	$playvideo::nicovideoobject=$::resource{playvideo_niconico_object};

	my $cache=new Nana::Cache (
		ext=>"playvideo",
		files=>500,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>1000000000000000
	);
	my $cachefile="playvideo_$fname";
	my $buf=$cache->read($cachefile,1);
	if(-r "$videopath/$fname.$wmv" || -r "$videopath/$fname.$mp4") {
		my $info;
		my $mp4info;
		my $mp4tag;
		my $title;
		my $author;
		my $copyright;
		my $time;
		if($buf eq '') {
			my $exifTool = new Image::ExifTool;
			if(-r "$videopath/$fname.$wmv") {
				$info = $exifTool->ImageInfo("$videopath/$fname.$wmv");
				$title=&Jcode::convert($$info{Title}, 'sjis');
				$author=&Jcode::convert($$info{Author}, 'sjis');
				$copyright=&Jcode::convert($$info{Copyright}, 'sjis');
				$time=$$info{PlayDuration};
			} elsif(&load_module("MP4::Info") && -r "$videopath/$fname.$mp4") {
				$info = $exifTool->ImageInfo("$videopath/$fname.$mp4");
				$mp4tag = MP4::Info::get_mp4tag("$videopath/$fname.$mp4");
				$title=&Jcode::convert($mp4tag->{NAM}, 'sjis');
				$author=&Jcode::convert($mp4tag->{ART} ne '' ? $mp4tag->{ART} : $mp4tag->{WRT}, 'sjis');
				$copyright=&Jcode::convert($author, 'sjis');
				$mp4info = MP4::Info::get_mp4info("$videopath/$fname.$mp4");
				$time = $mp4info->{TIME};
			} elsif(-r "$videopath/$fname.$mp4") {
				$info = $exifTool->ImageInfo("$videopath/$fname.$wmv");
				$title=&Jcode::convert($$info{Title}, 'sjis');
				$author="";
				$copyright="";
				$time="";
			}
			my $browserflg=&checkurl($fname,$mp4,$videopath,$videourl,%::playvideo_plugin_videourl) ne '' ? 1 : &checkurl($fname,$flv,$videopath,$videourl,%::playvideo_plugin_videourl) ne '' ? 2 : 0;
			$buf=<<EOM;
$time\t$title\t$author\t$copyright\t$$info{ImageWidth}\t$$info{ImageHeight}\t$browserflg
EOM
			$cache->write($cachefile,$buf);
		}
	} else {
		return &playvideo_err($fname, $::resource{playvideo_ext_wmv});
	}
	my ($time,$title,$author,$copyright,$width,$height,$browserflg)=split(/\t/,$buf);

	if($params{width} ne '' && $params{height} ne '') {
		$width=$params{width};
		$height=$params{height};
	} elsif($params{width} ne '') {
		my $_w=$width;
		$width=$params{width};
		my $tmp=$width / $_w;
		$height=$height * $tmp;
	} elsif($params{height} ne '') {
		my $_h=$height;
		$height=$params{height};
		my $tmp=$height / $_h;
		$width=$width * $tmp;
	}
	if($params{size} ne '') {
		$width=($width * $params{size} / 100);
		$height=($height * $params{size} / 100);
	}

	if($params{inline} ne "" || $fext=~/auto|inline|popup/) {
		if($browser=~/Fire[Ff]ox|Chrome|Safari|Opera|iPad|iPhone|Andoroid|Konqueror|Lunascape|Sleipnir/
			|| $browser=~/Trident.*rv:[789]\./
			|| $browser=~/Trident.*rv:[1-9][0-9]\./
			|| $browser=~/MSIE 9\./
			|| $browser=~/MSIE [1-9][0-9]\./) {
			$fext=$vhtml;
		}
		if($fext ne $vhtml && ($browser=~/MSIE/ || $browser=~/Trident/) && $browser=~/Windows/) {
			$fext=$wmv;
		}
		if($fext!~/$wmv|$vhtml/) {
			$body.=qq(<span class="error">$::resource{playvideo_err_notsupport}</span>);
		}
	}
	if($fext eq $wmv) {
		if(-r "$videopath/$fname.$fext" ) {
			$playvideo::playercount++;
			&getbasehref;
			$body.=<<EOM;
<object id="Player$playvideo::playercount" width="$width" height="$height" classid="$playvideo::wmvid">
<param name="autoStart" value="@{[$params{autostart}+0 eq 0 ? 'false' : 'true']}" />
<param name="URL" value="$playsite/$fname.$ext" />
<embed src="$playsite/$fname.$ext" autostart="0" width="$width" height="$height"@{[$params{autostart}+0 eq 0 ? '' : ' autostart="autostart"']}></embed>
</object>
<!-- saved from url=(0022)$::basehost -->
EOM
			if($browser=~/Chrome/) {
				$body.="<br />" . $::resource{playvideo_wmv_chrome} . "<br />";
			}
		} else {
			return &playvideo_err($fname, $::resource{playvideo_ext_wmv});
		}
	} elsif($fext eq $vhtml) {
		if($browserflg+0 eq 1) {
			$playvideo::playercount++;
			$html5video=&html5video($fname,$::playvideo_plugin_videopath,$::playvideo_plugin_videourl,%::playvideo_plugin_videourl);
			if($html5video ne '' && &checkhtml5videosupport eq 1) {
				if($playvideo::htmlplayer eq 0) {
					$::htmlmode="html5_plugin";
					&init_dtd;
					$::IN_HEAD.=<<EOM;
<link rel="stylesheet" href="$::skin_url/video-js.css" type="text/css" media="screen" />@{[$::playvideo_plugin_addcss ne '' ? qq(\n<link rel="stylesheet" href="$::skin_url/$::playvideo_plugin_addcss" type="text/css" media="screen" />) : '']}
<script type="text/javascript"><!--
var swf="$::skin_url/video-js.swf";
//--></script>
<script src="$::skin_url/video.js" type="text/javascript"></sc9ript>
EOM
				}
				$playvideo::htmlplayer++;
				if($ENV{HTTP_USER_AGENT}=~/iPod|iPhone|iPad|Android/) {
					$body.=<<EOM;
<video id="playvideo$playvideo::playercount" class="video-js vjs-default-skin" width="$width" height="$height" controls="controls" preload="none" onclick="this.play();" data-setup="{}"}@{[$params{loop}+0 ne 0 ? ' loop="loop"' : '']}@{[$params{image} ne '' ? qq( poster="$params{image}") : '']}>
$html5video
</video>
EOM
				} else {
					$body.=<<EOM;
<video id="playvideo$playvideo::playercount" class="video-js vjs-default-skin" width="$width" height="$height" controls="controls" preload="auto" data-setup="{}"@{[$params{autostart}+0 ne 0 ? ' autoplay="autoplay"' : '']}@{[$params{loop}+0 ne 0 ? ' loop="loop"' : '']}@{[$params{image} ne '' ? qq( poster="$params{image}") : '']}>
$html5video
</video>
EOM
				}
			} else {
				if($playvideo::flvplayer eq 0) {
					$::IN_HEAD.=<<EOM;
<script type="text/javascript" src="$::skin_url/flowplayer-3.2.6.min.js"></script>
<script src="$::skin_url/videoresize.js" type="text/javascript"$csscharset></script>
EOM
				}
				$videopath=$::playvideo_plugin_videopath;
				$videourl=$::playvideo_plugin_videourl;
				$flvpath=&checkurl($fname,$flv,$videopath,$videourl,%::playvideo_plugin_videourl);
				$flvpath=&checkurl($fname,$mp4,$videopath,$videourl,%::playvideo_plugin_videourl)
					if($flvpath eq '');
				$playvideo::flvplayer++;
				my $js_flv_noauto=qq(__yuicompressor_js="./plugin/v_js_flashvideo_noautoplay.js"__');
				my $js_flv_noauto_loop=qq(__yuicompressor_js="./plugin/v_js_flashvideo_noautoplay_loop.js"__');
				my $js_flv=qq(__yuicompressor_js="./plugin/v_js_flashvideo.js"__');
				my $js_flv_loop=qq(__yuicompressor_js="./plugin/v_js_flashvideo_loop.js"__');
				$body.=<<EOM;
<div id="page">
<div style="width:@{[$width]};height:@{[$height]}px" id="player"></div>
<script type="text/javascript"><!--
var swf="$::skin_url/flowplayer-3.2.7.swf";
var flv="$flvpath";
window.focus();
@{[$params{autostart}+0 eq 0
	? @{[$params{loop}+0 eq 0
		? "startflowplayer_noauto(swf, flv);"
		: "startflowplayer_noauto_loop(swf, flv);"
	  ]}
	: @{[$params{loop}+0 eq 0
		? "startflowplayer_auto(swf, flv);"
		: "startflowplayer_auto_loop(swf, flv);"
	  ]}
#		? $js_flv_noauto : $js_flv_noauto_loop
#	  ]}
#	: @{[$params{loop}+0 eq 0
#		? $js_flv : $js_flv_loop
#	  ]}
]}
//--></script>
</div>
EOM
			}
		}
	}
 elsif($fext=~/^sm(\d+)/) {
		my $id=$1;
		my $tmp=$playvideo::nicovideoobject;
		$tmp=~s/##ID##/sm$id/g;
		$body.=$tmp;
	} elsif($fext ne '' && $ffull=~/\./) {
		my $id=$fext;
		my $tmp=$playvideo::youtubeobject;
		$tmp=~s/##ID##/$id/g;
		$body.=$tmp;
	} else {
		my $wmvload=0;
		my $loopext=".loop" if($params{loop}+0 ne 0);
		if(-r "$videopath/$fname.$wmv") {
			$wmvload=1;
			$body.=<<EOM;
<strong>@{[&make_link_target("$playsite/$fname$loopext.$ext","",$wmvtarget,"$::resource{playvideo_wmp_play}")]}
[$::resource{playvideo_wmp_play}]</a></strong>
EOM
		}
		if($browserflg+0 eq 1) {
#	if(-r "$videopath/$fname.$mp4" || -r "$videopath/$fname.$ogv" || -r "$videopath/$fname.$webm") {
			$body.=<<EOM;
@{[$wmvload eq 0 ? '<strong>' : '']}<a href="$playsite/$fname$loopext.$vhtml" title="[$::resource{playvideo_html5video_play}]" onclick="window.open('$playsite/$fname$loopext.$vhtml','_player','location=no,status=no,toolbar=no,hotkeys=no,directories=no,scrollbars=no,resizable=yes,menubar=no,width=1,height=1');return false;">
[$::resource{playvideo_html5video_play}]</a>@{[$wmvload eq 0 ? '</strong>' : '']}
EOM
#		} elsif(-r "$videopath/$fname.$flv") {
		} elsif($browserflg+0 eq 2) {
			$body.=<<EOM;
<a href="$playsite/$fname$loopext.$flv" title="[$::resource{playvideo_flashvideo_play}]" onclick="window.open('$playsite/$fname$loopext.$flv','_player','location=no,status=no,toolbar=no,hotkeys=no,directories=no,scrollbars=no,resizable=yes,menubar=no,width=1,height=1');return false;">
[$::resource{playvideo_flashvideo_play}]</a>
EOM
		}
		if($youtube ne '') {
			$body.=<<EOM;
@{[&make_link_target("$playsite/$fname.$youtube","","_blank","$::resource{playvideo_youtube_play}")]}
[$::resource{playvideo_youtube_play}]</a>
EOM
		}
		if($nicovideo ne '') {
			$body.=<<EOM;
@{[&make_link_target("$playsite/$fname.$nicovideo","","_blank","$::resource{playvideo_nicovideio_play}")]}
[$::resource{playvideo_nicovideio_play}]</a>
EOM
		}
		if($::playvideo_plugin_usedownload eq 1 && $params{nodownload} eq "") {
			if($::playvideo_plugin_plain_download eq 1) {
				$body.=<<EOM;
@{[&make_link_target("$playsite/$fname.$dl","","","$::resource{playvideo_download}")]}
[$::resource{playvideo_download}]</a>
EOM
			} else {
				$body.=<<EOM;
@{[&make_link_target("$playsite/$fname.$zip","","","$::resource{playvideo_download}")]}
[$::resource{playvideo_download}]</a>
EOM
			}
		}
		$body.=<<EOM if($params{notime} eq "");
($time)
<br />
EOM
		%vcounter=&plugin_counter_do("playvideo_$fname","r");
		$body.=<<EOM;
<span class="counter">
$::resource{playvideo_total}: $vcounter{total} $::resource{playvideo_today}: $vcounter{today} $::resource{playvideo_yesterday}:$vcounter{yesterday}
</span>
EOM
	}
	return $body;
}

sub playvideo_err {
	my($f, $n)=@_;
	my $r=$::resource{playvideo_err_notfound};
	$r=~s/\$1/$f/g;
	$r=~s/\$2/$n/g;
	return qq(<span class="error">$r</span>);
}

sub html5video {
	my($file,$path,$videourl,%videourls)=@_;

	my $agent=$ENV{HTTP_USER_AGENT};
	my $tag="";
	my $url;

	if(($url=&checkurl($file,$mp4,$path,$videourl,%videourls)) ne '') {
		$tag.=<<EOM;
<source src="$url" type="video/mp4" />
EOM
	}

	if(($url=&checkurl($file,$ogv,$path,$videourl,%videourls)) ne '') {
		$tag.=<<EOM;
<source src="$url" type='video/ogg; codecs="theora, vorbis"' />
EOM
	}

	if(($url=&checkurl($file,$webm,$path,$videourl,%videourls)) ne '') {
		$tag.=<<EOM;
<source src="$url" type='video/webm; codecs="vp8, vorbis"' />
EOM
	}

	return $tag;
}

sub html5videoposter {
	my($file,$path,$videourl,%videourls)=@_;

	my $agent=$ENV{HTTP_USER_AGENT};
	my $tag="";
	my $url;

	if(($url=&checkurl($file,"jpg",$path,$videourl,%videourls)) ne '') {
		return $url;
	}
	if(($url=&checkurl($file,"png",$path,$videourl,%videourls)) ne '') {
		return $url;
	}
	if(($url=&checkurl($file,"gif",$path,$videourl,%videourls)) ne '') {
		return $url;
	}
	if(($url=&checkurl($file,"jpeg",$path,$videourl,%videourls)) ne '') {
		return $url;
	}
	return "";
}


sub checkurl {
	my ($file,$ext,$path,$url,%urls)=@_;
	if(-r "$path/$file.$ext") {
		return "$url/$file.$ext";
	}

	if($::package eq '' || $::version eq '') {
		open(R,"$::explugin_dir/wiki.cgi");
		foreach(<R>) {
			if(/\$\:\:package/) {
				eval $_ ;
			}
			if(/\$\:\:version/) {
				eval $_ ;
			}
		}
		close(R);
	}

	foreach (split(/\n/,$urls{$ext})) {
		my $http=new Nana::HTTP('plugin'=>"playvideo");
		s/\/$//;
		my ($result, $stream) = $http->head("$_/$file.$ext");
		if($result eq 0) {
			return "$_/$file.$ext";
		}
	}
	return "";
}

sub checkhtml5videosupport {
	my $agent=$ENV{HTTP_USER_AGENT};
	my $html5supportflg=0;

	foreach(@HTML5_VIDEO_TARGETS_MP4) {
		my($arg1,$arg2,$arg3)=split(/ /,$_);
		if($arg2 eq "") {
			if($agent=~/$arg1/) {
				$html5supportflg=1;
			}
		} elsif($arg3 eq "") {
			if($agent=~/$arg1[\s|\/](\d+)\./) {
				if($1 >= $arg2) {
					$html5supportflg=1;
				}
			} else {
				if($agent=~/$arg1[\s|\/](\d+)\./) {
					if($1 >= $arg2) {
						$html5supportflg=1;
					}
				}
			}
			if($1 >= $arg2) {
				$html5supportflg=1;
			}
		} elsif($agent=~/$arg1/) {
			if($agent=~/$arg2[\s|\/](\d+)\./) {
				if($1 >= $arg3) {
					$html5supportflg=1;
				}
			}
		}
	}

	foreach(@HTML5_VIDEO_TARGETS_OGV) {
		my($arg1,$arg2,$arg3)=split(/ /,$_);
		if($arg3 eq "") {
			if($agent=~/$arg1[\s|\/](\d+)\./) {
				if($1 >= $arg2) {
					$html5supportflg=1;
				}
			} else {
				if($agent=~/$arg1[\s|\/](\d+)\./) {
					if($1 >= $arg2) {
						$html5supportflg=1;
					}
				}
			}
			if($1 >= $arg2) {
				$html5supportflg=1;
			}
		} elsif($agent=~/$arg1/) {
			if($agent=~/$arg2[\s|\/](\d+)\./) {
				if($1 >= $arg3) {
					$html5supportflg=1;
				}
			}
		}
	}

	foreach(@HTML5_VIDEO_TARGETS_WEBM) {
		my($arg1,$arg2,$arg3)=split(/ /,$_);
		if($arg3 eq "") {
			if($agent=~/$arg1[\s|\/](\d+)\./) {
				if($1 >= $arg2) {
					$html5supportflg=1;
				}
			} else {
				if($agent=~/$arg1[\s|\/](\d+)\./) {
					if($1 >= $arg2) {
						$html5supportflg=1;
					}
				}
			}
			if($1 >= $arg2) {
				$html5supportflg=1;
			}
		} elsif($agent=~/$arg1/) {
			if($agent=~/$arg2[\s|\/](\d+)\./) {
				if($1 >= $arg3) {
					$html5supportflg=1;
				}
			}
		}
	}
	return $html5supportflg;
}
	
sub init_dtd {
	%::dtd = (
		"html4"=>qq(<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n<html lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="text/html; charset=$::charset" />\n<meta http-equiv="Content-Style-Type" content="text/css" />\n<meta http-equiv="Content-Script-Type" content="text/javascript" />),
		"xhtml11"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">\n<head>),
		"xhtml10"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" lang="$::lang" xml:lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"xhtml10t"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" lang="$::lang" xml:lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"xhtmlbasic10"=>qq(<?xml version="1.0" encoding="$::charset" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">\n<head>\n<meta http-equiv="Content-Language" content="$::lang" />\n<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=$::charset" />),
		"html5_plugin"=>qq(<!doctype html>\n<html lang="$::lang">\n<head>\n<meta http-equiv="content-type" content="text/html; charset=$::charset" /><meta http-equiv="Content-Style-Type" content="text/css" />\n<meta http-equiv="Content-Script-Type" content="text/javascript" />),
	);

	$::dtd=$::dtd{$::htmlmode};
	$::dtd=$::dtd{html4} if($::dtd eq '') || &is_no_xhtml(0);
	$::dtd.=qq(\n<meta name="generator" content="PyukiWiki $::version" />\n);

	$::is_xhtml=$::dtd=~/xhtml/;
}


1;
__END__
=head1 NAME

playvideo.inc.pl - PyukiWiki External Plugin

=head1 SYNOPSIS

Playvideo Plugin

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/playvideo/

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/playvideo/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/v.cgi>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/playvideo.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/playvideo_v_cgi.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
