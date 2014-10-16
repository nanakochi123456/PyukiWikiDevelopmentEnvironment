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

$PLUGIN="playvideo";
$VERSION="2.2b";

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

%::functions = (
	"load_module" => \&load_module,
);

require "$::plugin_dir/counter.inc.pl";
require "$::plugin_dir/playvideo.inc.pl";
$::counter_ext = '.count';
$::info_dir="./info";
use Nana::Cache;
use Nana::HTTP;
use Image::ExifTool;

#use LWP::UserAgent;

my %playvideo_mime=(
	"wvx"=>"video/x-ms-wvx",
	"wax"=>"audio/x-ms-wax",
	"asx"=>"video/x-ms-asf",
	"wmv"=>"video/x-ms-wmv",
	"wmv"=>"audio/x-ms-wma",
	"asf"=>"video/x-ms-asf",
);

$::zip_cmds=$::playvideo_plugin_zipcmds;
$::zip_opts=$::playvideo_plugin_zipflags;
$::zip_tmp=$::playvideo_plugin_ziptmp;

$v_css=qq(@@yuicompressor_css="./plugin/v_css.css"@@);
#$v_flash_js=qq(@@yuicompressor_js="./plugin/v_js_flashvideo.js"@@);
#$v_html5_js=qq(@@yuicompressor_js="./plugin/v_js_html5video.js"@@);

&main;

sub main {
	$query=new CGI;

	foreach my $i (0x00 .. 0xFF) {
		$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
		$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
	}

	$ENV{PATH_INFO}=~s/^\///g;
	$file=$ENV{PATH_INFO};
	$loop=$file;
	$file=~s/\..*//g;
	$fname=$file;
	$ext=$ENV{PATH_INFO};
	$ext=~s/.*\.//g;
	$loopflg=0;
	if($loop=~/\.loop/) {
		$loopflg=1;
	}

	if(-r "$::explugin_dir/lang.inc.cgi") {
		require "$::explugin_dir/lang.inc.cgi";
		my %ret=&plugin_lang_init;
	}

	%::resource = &read_resource("$::res_dir/playvideo.$::lang.txt");

	$playvideo::nicovideourl=$::resource{playvideo_niconico_url};
	$playvideo::youtubeurl=$::resource{playvideo_youtube_url};
	$playvideo::youtube_fakeniconico_url=$::resource{playvideo_youtube_fakeniconico_url};
	$playvideo::youtubeobject=$::resource{playvideo_youtube_object};
	$playvideo::nicovideoobject=$::resource{playvideo_niconico_object};

	$videopath=$::playvideo_plugin_videopath;
	$videourl=$::playvideo_plugin_videourl;

	my $exifTool = new Image::ExifTool;
	my $info;

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
	my $title;
	my $author;
	my $copyright;
	if($buf eq '') {
		if(-r "$videopath/$fname.$wmv" || -r "$videopath/$fname.$mp4") {
			my $info;
			my $mp4info;
			my $mp4tag;
			my $time;
			my $exifTool = new Image::ExifTool;
			&load_module("Jcode");
			if(-r "$videopath/$fname.$wmv") {
				$info = $exifTool->ImageInfo("$videopath/$fname.$wmv");
				$title=&Jcode::convert($$info{Title}, 'sjis');
				$author=&Jcode::convert($$info{Author}, 'sjis');
				$copyright=&Jcode::convert($$info{Copyright}, 'sjis');
				$time=$$info{PlayDuration};
				$width=$$info{ImageWidth};
				$height=$$info{ImageHeight};
			} elsif(&load_module("MP4::Info") && -r "$videopath/$fname.$mp4") {
				$info = $exifTool->ImageInfo("$videopath/$fname.$mp4");
				$mp4tag = MP4::Info::get_mp4tag("$videopath/$fname.$mp4");
				$title=&Jcode::convert($mp4tag->{NAM}, 'sjis');
				$author=&Jcode::convert($mp4tag->{ART} ne '' ? $mp4tag->{ART} : $mp4tag->{WRT}, 'sjis');
				$copyright=&Jcode::convert($author, 'sjis');
				$mp4info = MP4::Info::get_mp4info("$videopath/$fname.$mp4");
				$time = $mp4info->{TIME};
				$width=$$info{ImageWidth};
				$height=$$info{ImageHeight};
			} elsif(-r "$videopath/$fname.$mp4") {
				$info = $exifTool->ImageInfo("$videopath/$fname.$wmv");
				$title=&Jcode::convert($$info{Title}, 'sjis');
				$author="";
				$copyright="";
				$width=$$info{ImageWidth};
				$height=$$info{ImageHeight};
				$time="";
			}
		}
	} else {
		($dmy,$title,$author,$copyright,$width,$height)=split(/\t/,$buf);
	}

	my $footer=72;
	my $widthdiff=0;
	if($ENV{HTTP_USER_AGENT}=~/Windows/) {
		$footer=50 if($ENV{HTTP_USER_AGENT}=~/MSIE/ || $ENV{HTTP_USER_AGENT}=~/Trident/);
		$footer=72 if($ENV{HTTP_USER_AGENT}=~/MSIE 8|MSIE 7|MSIE 6/);
		$footer=94 if($ENV{HTTP_USER_AGENT}=~/Fire[Ff]ox/);
		$footer=24 if($ENV{HTTP_USER_AGENT}=~/Safari/);
		$widthdiff=10 if($ENV{HTTP_USER_AGENT}=~/Safari/);
		$footer=86 if($ENV{HTTP_USER_AGENT}=~/Chrome/);
		$widthdiff=10 if($ENV{HTTP_USER_AGENT}=~/Chrome/);
	}

	if($ext eq "asx" || $ext eq "wmx" || $ext eq "wvx") {
#		$title=&code_convert(\$$info{Title}, 'utf8');
#		$author=&code_convert(\$$info{Author}, 'utf8');
#		$copyright=&code_convert(\$$info{Copyright}, 'utf8');
#		$mod=&code_convert(\$::modifier, 'utf8');
		$mod=&code_convert(\$::modifier, 'sjis');
		&plugin_counter_do("playvideo_$file","w");
		$f=&code_convert(\$file, 'utf8');
		if($loopflg eq 0) {
			print <<EOM;
Content-Type: $playvideo_mime{$ext}; charset=Shift_JIS

<asx version="3.0">
<entry>
<title>@{[$title ne '' ? $title : $f]}</title>
<author>@{[$author ne '' ? $author : $::mod]}</author>
@{[$copyright ne '' ? "<copyright>$copyright</copyright>" : ""]}
<ref href="$videourl/$file.$wmv" />
</entry>
</asx>
EOM
		} else {
			print <<EOM;
Content-Type: $playvideo_mime{$ext}; charset=Shift_JIS

<asx version="3.0">
<repeat>
<entry>
<title>@{[$title ne '' ? $title : $f]}</title>
<author>@{[$author ne '' ? $author : $::mod]}</author>
@{[$copyright ne '' ? "<copyright>$copyright</copyright>" : ""]}
<ref href="$videourl/$file.$wmv" />
</entry>
</repeat>
</asx>
EOM
		}
	} elsif($ext eq "zip" && $::playvideo_plugin_usedownload eq 1) {
		&plugin_counter_do("playvideo_$file","w");
		foreach $cmd (split(/\n/,$::zip_cmds)) {
			if (-x $cmd) {
				$fname="$zip_tmp/$file.$wmv-$ENV{REMOTE_ADDR}.zip";
				# 簡易ロック
				do {
					sleep 1;
				} if (-r $fname);

				chdir($videopath);
				my $cmdline;
				if(-r "$file.$wmv") {
					$cmdline="$cmd $zip_opts $fname $file.$wmv |";
				} elsif(-r "$file.$mp4") {
					$cmdline="$cmd $zip_opts $fname $file.$mp4 |";
				}
				if(open(PIPE,$cmdline)) {
					@TMP=<PIPE>;
					close(PIPE);
					$size = -s $fname;
					if(open(R, $fname)) {
						my $downloadfile="$file.zip";
						if($::playvideo_plugin_downloadfilename_inwmv) {
							my $in_author;

							if($::playvideo_plugin_downloadfilename_inwmv_withauthor) {
								$in_author=" ($author)" if($author ne '');
							}
							if($title ne '') {
								$downloadfile="$title$in_author.zip";
							}
						}
						$::defaultcode='sjis';
						($charset,$downloadfile)=&dlfileconvert($downloadfile);
						print $query->header(
							-type=>"application/zip; charset=$charset",
							-Content_disposition=>"attachment; $downloadfile",
							-Content_length=>$size,
							-expires=>"now",
							-P3P=>""
						);

						binmode	R;
						binmode STDOUT;
						print <R>;
						close(R);
						unlink($fname);
						exit;
					} else {
						unlink($fname);
						&err("Can't create zip file. sorry.");
						exit;
					}
				} else {
					unlink($fname);
					&err("Can't create pipe. sorry.");#
					exit;
				}
				exit;
			}
		}
		&err("Not found zip command.");
		exit;
	} elsif($ext eq "dl" && $::playvideo_plugin_usedownload eq 1) {
		my $dlfile;
		if(-r "$videopath/$file.$wmv") {
			$dlfile="$file.$wmv";
		} elsif(-r "$videopath/$file.$mp4") {
			$dlfile="$file.$mp4";
		}
		$size = -s "$videopath/$dlfile";
		my $downloadfile="$dlfile";
		if($::playvideo_plugin_downloadfilename_inwmv) {
			my $in_author;

			if($::playvideo_plugin_downloadfilename_inwmv_withauthor) {
				$in_author=" ($author)" if($author ne '');
			}
			if($title ne '') {
				if($dlfile=~/$mp4/) {
					$downloadfile="$title$in_author.$mp4";
				} else {
					$downloadfile="$title$in_author.$wmv";
				}
			}
		}

		($charset,$downloadfile)=&dlfileconvert($downloadfile);
		print $query->header(
			-type=>"application/zip; charset=$charset",
			-Content_disposition=>"attachment; $downloadfile",
			-Content_length=>$size,
			-expires=>"now",
			-P3P=>""
		);

		if(open(R, "$videopath/$dlfile")) {
			binmode	R;
			binmode STDOUT;
			print <R>;
			close(R);
			exit;
		} else {
			&err("Can't open download file. sorry.");
			exit;
		}
	} elsif($ext eq $flv || $ext eq $vhtml) {
		if ($::lang eq 'ja') {
			if($::defaultcode eq 'euc') {
				if(lc $::charset eq 'utf-8') {
					$::kanjicode='utf8';
				} else {
					$::charset=(
						$::kanjicode eq 'euc' ? 'EUC-JP' :
						$::kanjicode eq 'utf8' ? 'UTF-8' :
						$::kanjicode eq 'sjis' ? 'Shift-JIS' :
						$::kanjicode eq 'jis' ? 'iso-2022-jp' : '')
				}
			} else {
				$::kanjicode="utf8";
			}
		}
		&getbasehref if($::skin_url!~/^https?\:\/\//);
		&skin_init;
		if(-r "$::explugin_dir/setting.inc.cgi") {
			require "$::explugin_dir/setting.inc.cgi";
			my %ret=&plugin_setting_init;
		}
		&plugin_counter_do("playvideo_$file","w");
		$title=&code_convert(\$title, $::defaultcode);
		$author=&code_convert(\$author, $::defaultcode);
		$copyright=&code_convert(\$copyright, $::defaultcode);
		$title=$file if($title eq '');
		my $iecompatible;
		if(-r "$::explugin_dir/iecompatiblehack.inc.cgi") {
			require "$::explugin_dir/iecompatiblehack.inc.cgi";
			my %ret=&plugin_iecompatiblehack_init;
			if($ret{'http_header'} ne '') {
				$iecompatible=$ret{'http_header'};
				$iecompatible=~s/\n//g;
				$iecompatible="\n$iecompatible";
			}
		}
		$csscharset=qq( charset="$::charset");

		$flvpath=&checkurl($file,$flv,$videopath,$videourl,%::playvideo_plugin_videourl);
		$flvpath=&checkurl($file,$mp4,$videopath,$videourl,%::playvideo_plugin_videourl)
			if($flvpath eq '');

		if($ext eq $vhtml) {
			$html5videotag=&html5video($file,$videopath,$videourl,%::playvideo_plugin_videourl);
			$poster=&html5videoposter($file,$videopath,$videourl,%::playvideo_plugin_videourl);
			if(&checkhtml5videosupport eq 1) {
				$bottom=24;
				$body=<<EOM;
Content-Type: text/html; charset=$::charset$iecompatible

<!DOCTYPE html>
<html lang="$::lang">
<head>
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/video-js.css" type="text/css" media="screen" />@{[$::playvideo_plugin_addcss ne '' ? qq(\n<link rel="stylesheet" href="$basehref$::skin_url/$::playvideo_plugin_addcss" type="text/css" media="screen" />) : '']}
<title>$title</title>
<style type="text/css"><!--
$v_css
//--></style>
<title>$title</title>
<script type="text/javascript"><!--
var swf="$basehref$::skin_url/video-js.swf";
//--></script>
<script src="$basehref$::skin_url/video.js" type="text/javascript"$csscharset></script>
<script type="text/javascript"><!--
window.focus();
initVideoSize($width,$height,$widthdiff,@{[$footer+$bottom]});
//--></script>
</head>
<body>
<div id="page">
<div class="video-js-box" id="player">
EOM
				if($ENV{HTTP_USER_AGENT}=~/iPod|iPhone|iPad|Android/) {
					$body.=<<EOM;
<video id="playvideo" class="video-js vjs-default-skin" width="$width" height="$height" controls="controls" preload="none" onclick="this.play();"@{[$poster ne "" ? qq( poster="$poster") : ""]} data-setup="{}"@{[$loopflg ne 0 ? ' loop="loop"' : '']}>
$html5videotag
</video>
</div>
EOM
				} else {
					$body.=<<EOM;
<video id="playvideo" class="video-js vjs-default-skin" width="$width" height="$height" controls="controls" preload="auto" autoplay="autoplay" data-setup="{}"@{[$loopflg ne 0 ? ' loop="loop"' : '']}>
$html5videotag
</video>
</div>
EOM
				}

			} else {
				$body.=<<EOM;
Content-Type: text/html; charset=$::charset$iecompatible

<?xml version="1.0" encoding="$::charset" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">
<head>
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
<title>$title</title>
<script type="text/javascript" src="$basehref$::skin_url/flowplayer-3.2.6.min.js"></script>
<script src="$basehref$::skin_url/videoresize.js" type="text/javascript"$csscharset></script>
<style type="text/css"><!--
$v_css
//--></style>
<title>$title</title>
</head>
<body oncontextmenu="return false">
<div id="page">
<div style="width:@{[$width]};height:@{[$height]}px" id="player"></div>
<script type="text/javascript"><!--
var swf="$basehref$::skin_url/flowplayer-3.2.7.swf";
var flv="$flvpath";
window.focus();
@{[$loopflg eq 0 
	? "startflowplayer_auto(swf, flv);"
	: "startflowplayer_auto_loop(swf, flv);"]}
initVideoSize($width,$height,$widthdiff,$footer);
//--></script>
EOM
			}
		} else {
			$body.=<<EOM;
Content-Type: text/html; charset=$::charset$iecompatible

<?xml version="1.0" encoding="$::charset" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="$::lang">
<head>
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{default_css}" type="text/css" media="screen"$csscharset />
<link rel="stylesheet" href="$basehref$::skin_url/$::skin{print_css}" type="text/css" media="print"$csscharset />
<title>$title</title>
<script type="text/javascript" src="$basehref$::skin_url/flowplayer-3.2.6.min.js"></script>
<script src="$basehref$::skin_url/videoresize.js" type="text/javascript"$csscharset></script>
<style type="text/css"><!--
$v_css
//--></style>
<title>$title</title>
</head>
<body oncontextmenu="return false">
<div id="page">
<div style="width:@{[$width]};height:@{[$height]}px" id="player"></div>
<script type="text/javascript"><!--
var swf="$basehref$::skin_url/flowplayer-3.2.7.swf";
var flv="$flvpath";
window.focus();
@{[$loopflg1 eq 0 
	? qq(@@yuicompressor_js="./plugin/v_js_flashvideo.js"@@)
	: qq(@@yuicompressor_js="./plugin/v_js_flashvideo_loop.js"@@)]}
initVideoSize($width,$height,$widthdiff,@{[$footer+$bottom]});
//--></script>
EOM
		}
		if($author ne '' && $copyright ne '') {
			$body.=<<EOM;
<table width="100%"><tr><td>$::resource{playvideo_vcgi_author}$author&nbsp;$::resource{playvideo_vcgi_copyright}$copyright</td>
<td align="right"><form action="#"><input type="button" value="$::resource{playvideo_vcgi_closebutton}" onclick="self.close();"></form></td></tr></table>
EOM
		} elsif($author ne '' && $copyright eq '') {
			$body.=<<EOM;
<table width="100%"><tr><td>$::resource{playvideo_vcgi_author}$author</td>
<td align="right"><form action="#"><input type="button" value="$::resource{playvideo_vcgi_closebutton}" onclick="self.close();"></form></td></tr></table>
EOM
		} elsif($author eq '' && $copyright ne '') {
			$body.=<<EOM;
<table width="100%"><tr><td>$::resource{playvideo_vcgi_copyright}：$copyright</td>
<td align="right"><form action="#"><input type="button" value="$::resource{playvideo_vcgi_closebutton}" onclick="self.close();"></form></td></tr></table>
EOM
		} else {
			$body.=<<EOM;
<p align="right"><form action="#"><input type="button" value="$::resource{playvideo_vcgi_closebutton}" onclick="self.close();"></form></p>
EOM
		}
		$body.=<<EOM;
</div></body></html>
EOM
		print &code_convert(\$body, $::kanjicode);

	} elsif($ext=~/^sm(\d+)/) {
		&plugin_counter_do("playvideo_$file","w");
		print <<EOM;
Location: $playvideo::nicovideourl$ext

EOM
	} else {
		&plugin_counter_do("playvideo_$file","w");
		if($playvideo::usefakeyoutubeurl eq 1) {
			print <<EOM;
Location: $playvideo::youtube_fakeniconico_url$ext

EOM
		} else {
			print <<EOM;
Location: $playvideo::youtubeurl$ext

EOM
		}
	}
}

sub dlfileconvert {
	my ($downloadfile)=shift;
	$::defaultcode='sjis';

	if($downloadfile=~/[\x81-\xfe]/) {
		if($ENV{HTTP_USER_AGENT} =~/Chrome/) {
			$downloadfile=&code_convert(\$downloadfile,"utf8");
			$downloadfile=qq(filename="$downloadfile");
			$downloadfile=~s/%2e/\./g;
			$charset="utf-8";
		} elsif($ENV{HTTP_USER_AGENT}=~/MSIE/ || $ENV{HTTP_USER_AGENT}=~/Trident/) {
			$downloadfile=qq{filename="} . &code_convert(\$downloadfile,"sjis") . qq{"};
			$charset="Shift-JIS";
		} else {
			$downloadfile=&code_convert(\$downloadfile,"utf8");
			$downloadfile=qq(filename="$downloadfile");
			$charset="utf-8";
		}
	} else {
		$downloadfile=qq(filename="$downloadfile");
		$charset="utf-8";
	}
	return ($charset,$downloadfile);
}

sub is_exist_page {
	return 1;
}

sub encode {
	my ($encoded) = @_;
	$encoded =~ s/(\W)/$::_urlescape{$1}/g;
	return $encoded;
}

sub dbmname {
	my ($name) = @_;
	$name =~ s/(.)/$::_dbmname_encode{$1}/g;
	return $name;
}

my $_tz='';
sub gettz {
	if($_tz eq '') {
		$_tz=(localtime(time))[2]+(localtime(time))[3]*24+(localtime(time))[4]*24
			+(localtime(time))[5]*24-(gmtime(time))[2]-(gmtime(time))[3]*24
			-(gmtime(time))[4]*24-(gmtime(time))[5]*24;
	}
	return $_tz;
}

sub code_convert {
	my ($contentref, $kanjicode, $icode) = @_;
	if($$contentref ne '') {
		if ($::lang eq 'ja') {
			if($::code_method{ja} eq 'jcode.pl') {
				die "Unsupport jcode.pl";
			} else {
				&load_module("Jcode");
				$$contentref .= '';
				$$contentref=~s/\xef\xbd\x9e/\xe3\x80\x9c/g;
				&Jcode::convert($contentref, $kanjicode, $icode);
				$$contentref=~s/\xe3\x80\x9c/\xef\xbd\x9e/g;
			}
		}
	}
	return $$contentref;
}

sub err {
	($msg)=@_;
	print <<EOM;
Content-type: text/plain

$msg
EOM
}

sub getbasehref {
	return if($::basehref ne '');
	$::basehost = "$ENV{'HTTP_HOST'}";

	if (($ENV{'https'} =~ /on/i) || ($ENV{'SERVER_PORT'} eq '443')) {
		$::basehost = 'https://' . $::basehost;
	} else {
		$::basehost = 'http://' . $::basehost;
		# Special Thanks to gyo
		$::basehost .= ":$ENV{'SERVER_PORT'}"
			if ($ENV{'SERVER_PORT'} ne '80' && $::basehost !~ /:\d/);
	}

	my $uri=$ENV{REQUEST_URI};
	$uri=~s/v\.cgi.*//g;
	$::basehref=$::basehost . $uri;
	$::basepath=$uri;
	$::basepath=~s/\/[^\/]*$//g;
	$::basepath="/" if($::basepath eq '');
	$::script=$uri if($::script eq '');
}

sub skin_init {
	$::skin_file="$::skin_dir/" . &skin_check("$::skin_name.skin%s.cgi",".$::lang","");
	$::skin{default_css}=&skin_check("$::skin_name.default%s.css",".$::lang","");
	$::skin{print_css}=&skin_check("$::skin_name.print%s.css",".$::lang","");
	$::skin{common_js}=&skin_check("common%s.js",".$::kanjicode.$::lang",".$::lang");
}

sub skin_check {
	my($file)=@_;
	foreach(@_) {
		my $f=sprintf($file,$_);
		return $f if(-f "$::skin_dir/$f");
	}
	die sprintf("$file not found","");
	exit;
}

sub exec_explugin_sub {
	my($explugin)=@_;
	foreach(@::loaded_explugin) {
		return if($explugin eq $_);
	}
	if (&exist_explugin($explugin) eq 1) {
		my $action = "\&plugin_" . $explugin . "_init";
		push(@::loaded_explugin,$explugin);
		my %ret = eval $action;
		$::_exec_plugined{$explugin} = 2 if($ret{init});
		$::HTTP_HEADER.="$ret{http_header}\n";
		$::IN_HEAD.=$ret{header};
		$::IN_BODY.=$ret{bodytag};

		$explugin_last.="$ret{last_func},";
		if (($ret{msg} ne '') && ($ret{body} ne '')) {
			$exec = 0;
			&skinex($ret{msg}, $ret{body});
			exit;
		}
	}
}

sub exist_explugin {
	my ($explugin) = @_;

	if (!$_exec_plugined{$explugin}) {
		my $path = "$::explugin_dir/$explugin" . '.inc.cgi';
		if (-e $path) {
			require $path;
			$::debug.=$@;
			$_exec_plugined{$1} = 1;
			return 1;
		}
		return 0;
	}
	return $_exex_plugined{$explugin};
}

sub getcookie {
	my($cookieID,%buf)=@_;
	my @pairs;
	my $pair;
	my $cname;
	my $value;
	my %DUMMY;

	@pairs = split(/;/,&decode($ENV{'HTTP_COOKIE'}));
	foreach $pair (@pairs) {
		($cname,$value) = split(/=/,$pair,2);
		$cname =~ s/ //g;
		$DUMMY{$cname} = $value;
	}
	@pairs = split(/,/,$DUMMY{$cookieID});
	foreach $pair (@pairs) {
		($cname,$value) = split(/:/,$pair,2);
		$buf{$cname} = $value;
	}
	return %buf;
}

sub decode {
	my ($s) = @_;
	$s =~ tr/+/ /;
	$s =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
	return $s;
}

sub load_module{
	my $mod = shift;
	return $mod if $::_module_loaded{$mod}++;
	eval qq( require $mod; );
	$mod=undef if($@);
	return $mod;
}

sub read_resource {
	my ($file,%buf) = @_;
	return %buf if $::_resource_loaded{$file}++;
	open(FILE, $file) or die;
	while (<FILE>) {
		s/[\r\n]//g;
		next if /^#/;
		s/\\n/\n/g;
		my ($key, $value) = split(/=/, $_, 2);
		$buf{$key}=$value;
		$buf{$key}=$::resource_patch{$key} if(defined($::resource_patch{$key}));
	}
	close(FILE);
	return %buf;
}


sub escapeoff {};

1;
__END__
=head1 NAME

playvideo_v_cgi.pl - PyukiWiki External Plugin of video player

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
