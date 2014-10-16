#!/bin/sh
CMD=$1
MYCMD=$2
disable='disabled="disabled"'
btnstyle='style="width:150px;"'
chk='checked="checked"'
update=`echo $BUILD|grep update`
HT="$T/headtmp"
R=rm
CHKPM=

csub() {
	CHKPM=""
	C=$2
	D='$'
	D="$D$C"
	P='$'
	P="$P$C::VERSION"
	VER=`perl -m$C -e "print $P;" 2>/dev/null`
	if [ "$?" == "0" ]; then
		CHKPM="$1 - $VER - OK $3"
	else
		CHKPM="$1 - NG $3"
	fi
	echo "$CHKPM"
}

chkpm() {
	if [ "`echo $LN | grep ja`" != "" ]; then
		REQ="(必須)"
		OPT="(オプショナル)"
		PLG="(プラグインのみ)"
	else
		REQ="(Recommand)"
		OPT="(Optional)"
		PLG="(Plugin Only)"
	fi
	CHKPM=$CHKPM`csub "CGI.pm" "CGI" $REQ`"<br>"
	CHKPM=$CHKPM`csub "Jcode.pm" "Jcode" $REQ`"<br>"
	CHKPM=$CHKPM`csub "Time::Local" "Time::Local" $REQ`"<br>"
	CHKPM=$CHKPM`csub "File::Temp" "File::Temp" $REQ`"<br>"
	CHKPM=$CHKPM`csub "Compress::Zlib" "Compress::Zlib" $OPT`"<br>"
	CHKPM=$CHKPM`csub "Digest::MD5" "Digest::MD5" $OPT`"<br>"
	CHKPM=$CHKPM`csub "Digest::Perl::MD5" "Digest::Perl::MD5" $OPT`"<br>"
	CHKPM=$CHKPM`csub "DBI" "DBI" $OPT`"<br>"
	CHKPM=$CHKPM`csub "GD" "GD" $PLG`"<br>"
	CHKPM=$CHKPM`csub "Digest::SHA" "Digest::SHA" $PLG`"<br>"
	CHKPM=$CHKPM`csub "MIME::Base64" "MIME::Base64" $PLG`"<br>"
	CHKPM=$CHKPM`csub "SOAP::Lite" "SOAP::Lite" $PLG`"<br>"
	CHKPM=$CHKPM`csub "MeCab" "MeCab" $PLG`"<br>"
	CHKPM=$CHKPM`csub "Text::MeCab" "Text::MeCab" $PLG`"<br>"
	CHKPM=$CHKPM`csub "LWP::UserAgent" "LWP::UserAgent" $PLG`"<br>"
	CHKPM=$CHKPM`csub "HTTP::Lite" "HTTP::Lite" $PLG`"<br>"
	CHKPM=$CHKPM`csub "Net::OpenID::Consumer" "Net::OpenID::Consumer" $PLG`"<br>"
	CHKPM=$CHKPM`csub "Net::OAuth" "Net::OAuth" $PLG`"<br>"
}

cop() {
	echo $1 to $2
	mkdir -f $2 >/dev/null 2>/dev/null
	if [ "$3" = "r" ]; then
		cp -R $1/* $2 >/dev/null 2>/dev/null
	else
		cp $1/* $2 >/dev/null 2>/dev/null
	fi
	cp $1/.htaccess $2 >/dev/null 2>/dev/null
}

pgbar () {
	N="$1"
	T="$2"
	P='$'
	V="$P$N"
	V1=`perl -e 'print $V * 6;'`
	V2=`perl -e 'print 600 - $V * 6;'`

	if [ "$CGI" = "1" ]; then
		cat <<EOF
<script type="text/javascript">
document.getElementById("pg").innerHTML=$N + "% - " + "$T";
</script>
EOF
	fi
}

DOM='<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'
HEAD='<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type="text/css">@@yuicompressor_css="./build/installer.css"@@</style></head>'
if [ "$update" != "" ]; then
	NAMEJA="アップデーター"
	DOJA="アップデート"
	NAMEEN="Updater"
	DOEN="Update"
	DOZEN=$DOEN
	DOZZEN=$DOEN
else
	NAMEJA="インストーラー"
	DOJA="インストール"
	NAMEEN="Installer"
	DOEN="Install"
	DOZEN="installation"
	DOZZEN="Installation"
fi
HEADJA="<html><head><title>$PYU$NAMEJA</title>"
HEADEN="<html><head><title>$PYU $NAMEEN</title>"
BODYJA="<body><h2>$PYU$NAMEJA</h2>"
BODYEN="<body><h2>$PYU $NAMEEN</h2>"
FOOTJA="<hr><div id=\"footer\"><strong><a href=\"@@PYUKI_URL@@\" class=\"link\" title=\"$PYU @@PYUKIVER@@\">$PYU @@PYUKIVER@@</a></strong>Copyright&copy; 2004-@@YEAR@@ by Nekyo, <a href=\"@@PYUKI_URL@@\" class=\"link\" title=\"$PYU Developers Team\">$PYU Developers Team</a>License is <a href=\"@@GPLJP_URL@@\" class=\"link\" title=\"GPL\">GPL</a>, <a href=\"@@ARTISTICJP_URL@@\" class=\"link\" title=\"Artistic\">Artistic</a><br>Based on &quot;<a href=\"@@YUKIWIKI_URL@@\" class=\"link\" title=\"YukiWiki\">YukiWiki</a>&quot; 2.1.0 by <a href=\"@@YUKI_URL@@\" class=\"link\" title=\"yuki\">yuki</a>and <a href=\"@@PUKIWIKI_URL@@\" class=\"link\" title=\"PukiWiki\">PukiWiki</a> by <a href=\"@@PUKIWIKI_URL@@\" class=\"link\" title=\"PukiWiki Developers Term\">PukiWiki Developers Term</a><br><a href=\"@@PYUKI_URL@@\" class=\"link\" title=\"$PYU Installer version $IVER\">$PYU Installer version $IVER</a></div></div></div></body></html>"
FOOTEN="<hr><div id=\"footer\"><strong><a href=\"@@PYUKI_URL@@\" class=\"link\" title=\"$PYU Installer @@PYUKIVER@@\">$PYU Installer @@PYUKIVER@@</a></strong>Copyright&copy; 2004-@@YEAR@@ by Nekyo, <a href=\"@@PYUKI_URL@@\" class=\"link\" title=\"$PYU Developers Team\">$PYU Developers Team</a>License is <a href=\"@@GPL_URL@@\" class=\"link\" title=\"GPL\">GPL</a>, <a href=\"@@ARTISTIC_URL@@\" class=\"link\" title=\"Artistic\">Artistic</a><br>Based on &quot;<a href=\"@@YUKIWIKI_URL@@\" class=\"link\" title=\"YukiWiki\">YukiWiki</a>&quot; 2.1.0 by <a href=\"@@YUKI_URL@@\" class=\"link\" title=\"yuki\">yuki</a>and <a href=\"@@PUKIWIKI_URL@@\" class=\"link\" title=\"PukiWiki\">PukiWiki</a> by <a href=\"http://pukiwiki.sfjp.jp/\" class=\"link\" title=\"PukiWiki Developers Term\">PukiWiki Developers Term</a><br><a href=\"@@PYUKI_URL@@\" class=\"link\" title=\"$PYU Installer version $IVER\">$PYU Installer version $IVER</a></div></div></div></body></html>"

getversion() {
	if [ -f $F ]; then
		V=`grep \$::version $F`
		OLDVER=""
		if [ "$V" != "" ]; then
			OLDVER=`perl -e '$V;print \$::version;'`
			OLDVER="$PYU version $OLDVER"
		else
			# pukiwiki
			V=`grep S_VERSION $F`
			if [ "$V" != "" ]; then
				OLDVER=`echo $V|sed -e 's/.*S_VERSION//g'|sed -e "s/'//g"|sed -e "s/,//g"|sed -e "s/ //g"|sed -e "s/\(//g"|sed -e "s/\)//g|sed -e "s/;//g""`
				OLDVER="PukiWiki version $OLDVER"
			fi
		fi
	fi
}

updatecheck() {
	UPDFLG=0
	if [ "`ls index.cgi 2>/dev/null``ls nph-index.cgi 2>/dev/null``ls index.php 2>/dev/null`" == "" ]; then
		F=lib/wiki.cgi
		getversion
		UPDFLG=3
		if [ "$OLDVER" != "" ]; then
			F=index.cgi
			getversion
			UPDFLG=2
		fi
		if [ "$OLDVER" != "" ]; then
			F=lib/init.php
			getversion
			UPDFLG=1
		fi
		if [ "$OLDVER" != "" ]; then
			OLDVER="Other script"
			UPDFLG=-1
		fi
	fi
}

if [ "$CMD" = "cgistart" ]; then
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOM
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
$PYUを$DOJAします。<br>
「次へ」を押して下さい。
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="戻る" $btnstyle $disable>
<input type="submit" name="step1" value="次へ" $btnstyle>
<input type="submit" name="cancel" value="キャンセル" $btnstyle $disable>
</form></div>
</td></tr>
</table>
EOF
	echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
	echo $DOM
	echo $HEADEN
	echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
$DOEN $PYU.<br>
Press "Next"
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="Back" $btnstyle $disable>
<input type="submit" name="step1" value="Next" $btnstyle>
<input type="submit" name="cancel" value="Cancel" $btnstyle $disable>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "gpl" ]; then
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOM
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_gpl_ja" width="999" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="戻る" $btnstyle>
<input type="submit" name="step2" value="同意する" $btnstyle>
<input type="submit" name="cancel" value="同意しない" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOM
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_gpl_en" width="999" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="dummy" value="Back" $btnstyle>
<input type="submit" name="step2" value="Agreement" $btnstyle>
<input type="submit" name="cancel" value="Disagree" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "art" ]; then
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOM
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_art_ja" width="999" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="step1" value="戻る" $btnstyle>
<input type="submit" name="step3" value="同意する" $btnstyle>
<input type="submit" name="cancel" value="キャンセル" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOM
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
<iframe src="$SCRIPT_NAME?license_art_en" width="999" height="300"></iframe>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<input type="submit" name="step1" value="Back" $btnstyle>
<input type="submit" name="step3" value="Agreement" $btnstyle>
<input type="submit" name="cancel" value="Disagree" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "license" ]; then
	cat $T/$QS.htm
	exit
fi

if [ "$CMD" = "cgititle" ]; then
	chkpm
	UPDATEHTML=""
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOM
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
$PYUの$DOJAの準備は完了しました。<br>
<hr>
perlモジュールのインストール状況は、以下の通りです。<br>
<span style="font-size: 12px;">
$CHKPM
</style>
<hr>
以下のオプションを選択して下さい。<br>
次へをクリックすると、$DOJAを開始します。<br>
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<table>
<tr><td>$DOJAモード</td><td>
<input type="radio" name="installmode" value="normal" $chk>通常$DOJA
<input type="radio" name="installmode" value="secure">セキュア$DOJA（パーミッションを厳格に設定します。）
</td></tr>
<tr><td>.htaccessファイル</td><td>
<input type="radio" name="htaccess" value="htaccesson" $chk>設置する
<input type="radio" name="htaccess" value="htaccessoff">削除する
</td></tr>
EOF
		if [ "$update" != "" ]; then
			cat <<EOF
<input type="hidden" name="freeze" value="freezeoff">
EOF
		else
			cat <<EOF
<input type="hidden" name="freeze" value="freezeoff">
EOF
		fi
		cat <<EOF
<tr><td>gzip圧縮転送</td><td>
<input type="radio" name="gzip" value="gzipoff">無効
<input type="radio" name="gzip" value="gzipon" $chk>有効
</td></tr>
EOF
		if [ "`echo $BUILD|grep compact`" == "" ] ; then
			cat <<EOF
<input type="hidden" name="htmldoc" value="htmldocoff">
EOF
		else
			cat <<EOF
<tr><td>HTMLドキュメント、サンプルファイル</td><td>
<input type="radio" name="htmldoc" value="htmldocoff" $chk>インストールしない
<input type="radio" name="htmldoc" value="htmldocon">インストールする
</td></tr>
EOF
		fi
		cat <<EOF
<tr><td>$DOJAするパス:</td>
<td>$PWD</td></tr>
<tr><td>$DOJAする$PYUのバージョン:</td>
<td>$VER$BUILD ($CODE)$UPDATEHTML</td></tr>
</table>
<input type="submit" name="step3" value="戻る" $btnstyle>
<input type="submit" name="install" value="次へ" $btnstyle>
<input type="submit" name="cancel" value="キャンセル" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOM
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
Complete of preparing for the $DOZEN of $PYU<br>
Please select the options.<br>
Press Next, $DOZEN complete.
<div align="left">
<form action="$SCRIPT_NAME" method="GET">
<table>
<tr><td>$DOEN Mode</td><td>
<input type="radio" name="installmode" value="normal" $chk>Default $DOEN
<input type="radio" name="installmode" value="secure">Secure $DOEN (Setting strict file and permissions.)
</td></tr>
<tr><td>.htaccess File</td><td>
<input type="radio" name="htaccess" value="htaccesson" $chk>Install
<input type="radio" name="htaccess" value="htaccessoff">Delete
</td></tr>
EOF
		if [ "$update" != "" ]; then
			cat <<EOF
<input type="hidden" name="freeze" value="freezeoff">
EOF
		else
			cat <<EOF
<input type="hidden" name="freeze" value="freezeoff">
EOF
		fi
		cat <<EOF
<tr><td>gzip compress transfer</td><td>
<input type="radio" name="gzip" value="gzipoff">Disable
<input type="radio" name="gzip" value="gzipon" $chk>Enable
</td></tr>
<tr><td>HTML Document, Sample file (Japanese)</td><td>
<input type="radio" name="htmldoc" value="htmldocoff" $chk>none
<input type="radio" name="htmldoc" value="htmldocon">Install
</td></tr>
<tr><td>Target Path:</td>
<td>$PWD</td></tr>
<tr><td>$PYU Version:</td>
<td>$VER$BUILD ($CODE)$UPDATEHTML</td></tr>
</table>
<input type="submit" name="step3" value="Back" $btnstyle>
<input type="submit" name="install" value="Next" $btnstyle>
<input type="submit" name="cancel" value="Cancel" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "setperl" ]; then
	PERL=`which perl`
	if [ "`echo $PERL`" != "" ]; then
		echo \#\!$PERL>index.cgi.tmp
		cat index.cgi>>index.cgi.tmp
		cp index.cgi.tmp index.cgi
		$R -f index.cgi.tmp
	fi
fi

if [ "$CMD" = "schm" ]; then
	chmod 700 backup cache counter diff info wiki session user 2>/dev/null
	chmod 700 backup.* cache.* counter.* diff.* info.*  wiki.* 2>/dev/null
	chmod 700 lib plugin release resource sample 2>/dev/null
	chmod 701 attach image skin 2>/dev/null
	chmod 701 attach.* skin.* 2>/dev/null
	chmod 701 index.cgi 2>/dev/null
	chmod 700 pyukiwiki.ini.cgi 2>/dev/null
fi

if [ "$CMD" = "chm" ]; then
	chmod 755 backup cache counter diff info wiki session user 2>/dev/null
	chmod 755 backup.* cache.* counter.* diff.* info.*  wiki.* 2>/dev/null
	chmod 755 lib plugin release resource sample 2>/dev/null
	chmod 755 attach image skin 2>/dev/null
	chmod 755 attach.* skin.* 2>/dev/null
	chmod 755 index.cgi 2>/dev/null
	chmod 755 pyukiwiki.ini.cgi 2>/dev/null
fi

if [ "$CMD" = "extract" ]; then
	pgbar 0

	pgbar 0 "cp $I $I.$TET"
	cp $I $I.$TET

	pgbar 0 "$R -f $I"
	$R -f $I

	pgbar 0 "perl $TP < $I.$TET > $I.$AET"
	perl $TP < $I.$TET > $I.$AET

	pgbar 20 "	$ACD $I.$AET >/dev/null  2>/dev/null"
	$ACD $I.$AET >/dev/null  2>/dev/null

	pgbar 22 "	perl $AE $I"
	perl $AE $I

	PP="pyukiwiki-$VER$BUILD"

echo "====================================================="
echo `pwd`
echo $P
echo "$PP/1"
echo "$PP 1"
echo $PP" 1"
echo "====================================================="
	pgbar 23 "$R -rf ./wiki"
	$R -rf ./wiki

	pgbar 25 "cop $PP ."
	cop "$PP" .

	pgbar 30 "cop $PP/attach ./attach"
	cop "$PP/attach" "./attach"

	pgbar 30 "cop $PP/cache ./cache"
	cop "$PP/cache" "./cache"

	pgbar 30 "cop $PP/counter ./counter"
	cop "$PP/counter" "./counter"

	pgbar 30 "cop $PP/diff ./diff"
	cop "$PP/diff" "./diff"

	pgbar 30 "cop $PP/info ./info"
	cop "$PP/info" "./info"

	pgbar 30 "cop $PP/wiki ./wiki"
	cop "$PP/wiki" "./wiki"

	pgbar 35 "cop $PP/build ./build"
	cop "$PP/build" "./build" r

	pgbar 37 "cop $PP/doc ./doc"
	cop "$PP/doc" "./doc" r

	pgbar 40 "cop $PP/document ./document"
	cop "$PP/document" "./document" r

	pgbar 45 "cop $PP/image ./image"
	cop "$PP/image" "./image" r

	pgbar 50 "cop $PP/lib ./lib"
	cop "$PP/lib" "./lib" r

	pgbar 55 "cop $PP/plugin ./plugin"
	cop "$PP/plugin" "./plugin"

	pgbar 60 "cop $PP/resource ./resource"
	cop "$PP/resource" "./resource"

	pgbar 65 "cop $PP/sample ./sample"
	cop "$PP/sample" "./sample" r

	pgbar 70 "cop $PP/skin ./skin"
	cop "$PP/skin" "./skin" r

	pgbar 75 "cop $PP/src ./src"
	cop "$PP/src" "./src" r

	pgbar 85 "$R -rf $PP"
	$R -rf $PP

	pgbar 90 "Waiting"
fi

if [ "$CMD" = "cgiinstall" ]; then
	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOM
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td>
インストール中です。しばらくお待ち下さい。<br>
<br>
<span id="pg"></span>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOM
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td>
Installing now. Please wait<br>
<br>
<table>
<tr>
<td width="500" height="100"name="pg"></td>
</tr>
</table>
</td></tr>
</table>
EOF
	fi
	$SH $X extract $MYCMD
	pgbar 90 "Set perl"
	$SH $X setperl $MYCMD
	cat <<EOF
<script type="text/javascript">
location.href=window.location + "&complete=yes";
</script>
EOF
fi
if [ "$CMD" = "cgicomplete" ]; then
	if [ "`echo $QS|grep secure`" != "" ] ; then
		pgbar 95 "Secure chmod"
		$SH $X schm $MYCMD
		if [ "`echo $LN | grep ja`" != "" ]; then
			INSTALLMODE="セキュア$DOJAモードで$DOJAをしました。<br>"
		else
			INSTALLMODE="$DOZZEN complete in secure mode.<br>"
		fi
	else
		pgbar 95 "Chmod"
		$SH $X chm $MYCMD
		INSTALLMODE=""
	fi
	if [ "`echo $QS|grep htaccessoff`" != "" ] ; then
		pgbar 95 "Remove .htaccess"
		$R -rf .htac*
		$R -rf .htpa*
		$R -rf attach/.htac*
		$R -rf cache/.htac*
		$R -rf image/.htac*
		$R -rf skin/.htac*
		echo '1;'>>./info/setup.ini.cgi
		if [ "`echo $LN | grep ja`" != "" ]; then
			HTACCESS=".htaccessファイルを削除しました<br>"
		else
			HTACCESS="Deleted .htaccess file<br>"
		fi
	fi
	if [ "`echo $QS|grep freezeon`" != "" ] ; then
		cd wiki
		for l in `ls`; do if [ "$l" != "526563656E744368616E676573.txt" ]; then grep -v '#freeze' < $l > $l.tmp; echo '#freeze' > $l; cat $l.tmp >> $l; rm -f $l.tmp; fi; done
		if [ "`echo $LN | grep ja`" != "" ]; then
			FREEZE="初期ページを凍結しました。凍結解除するには、初期パスワード「pass」を使用して下さい。<br>"
		else
			FREEZE="Initial page has been frozen. To cancel the freeze, please use the password "pass".<br>"
		fi
	fi

	if [ "`echo $QS|grep gzipon`" != "" ] ; then
		pgbar 95 "Set gzip compress"
		echo '$::gzip_path="";'>>./info/setup.ini.cgi
		echo '1;'>>./info/setup.ini.cgi
		if [ "`echo $LN | grep ja`" != "" ]; then
			GZIP="gzip圧縮転送は有効です<br>"
		else
			GZIP="gzip compression transfer is enebled<br>"
		fi
	else
		pgbar 95 "Unset gzip compress"
		echo '$::gzip_path="nouse";'>>./info/setup.ini.cgi
		echo '1;'>>./info/setup.ini.cgi
		GZIP=""
	fi

	if [ "`echo $QS|grep resetpassword`" != "" ] ; then
		pgbar 95 "Reset admin password"
		echo '$::adminpass=crypt("pass", "AA");'>>./info/setup.ini.cgi
		echo '$::adminpass{admin}="";'>>./info/setup.ini.cgi
		echo '$::adminpass{frozen}="";'>>./info/setup.ini.cgi
		echo '$::adminpass{attach}="";'>>./info/setup.ini.cgi
		if [ "`echo $LN | grep ja`" != "" ]; then
			PASSRESET="管理者パスワードをリセットしました。<br>"
		else
			PASSRESET="Reset  administrator password.<br>"
		fi
	fi

	if [ "`echo $QS|grep htmldocoff`" != "" ] ; then
		pgbar 95 "Delete document"
		rm -rf doc document
	else
		if [ "`echo $LN | grep ja`" != "" ]; then
			HTMLDOC="日本語HTMLドキュメントを [<a target=_blank href=README.ja.html>こちら</a>]にインストールしました。<br>"
		else
			HTMLDOC="Installed Japanese HTML Document on [a target=_blank href=README.ja.html>This</a>]<br>"
		fi
	fi

	if [ "`echo $LN | grep ja`" != "" ]; then
		echo $DOM
		echo $HEADJA
		echo $HEAD
		cat <<EOF
$BODYJA
<table>
<tr><td colspan="2">
$PYUの$DOJAが完了しました。<br>
$INSTALLMODE$HTACCESS$FREEZE$GZIP$PASSRESET$HTMLDOC
$NAMEJAは、動作を確認した後、不正アクセス防止の為に、必ず削除して下さい。<br>
初回起動時の管理者パスワードは「pass」です。<br>
<br>
動作しない時は、戻るボタンを押してから、$DOJAオプションを変更すると動作する可能性があります。
<br><br>
[<font soze="+1"><a href="index.cgi">動作確認はこちらから</a></font>]
EOF
		if [ "`echo $QS|grep htmldoc`" != "" ] ; then
			cat <<EOF
 [<font soze="+1"><a target="_blank" href="README.html">ドキュメントはこちらから</a></font>]
EOF
		fi
		cat <<EOF
<div align="left">
<form action="index.cgi" method="GET">
<input type="submit" value="戻る" $btnstyle $disable>
<input type="submit" value="次へ" $btnstyle $disable>
<input type="submit" name="complete" value="完了" $btnstyle>
</form></div>
</td></tr>
</table>
EOF
		echo $FOOTJA|sed -e s/\$IVER/$IVER/g;
	else
		echo $DOM
		echo $HEADEN
		echo $HEAD
		cat <<EOF
$BODYEN
<table>
<tr><td colspan="2">
$DOEN Complete<br>
$INSTALLMODE$HTACCESS$GZIP
Must remove $NAMEEN file, after that it works, to prevent unauthorized access.<br>
Initial administrator password is "pass".<br>
<br>
When this does not work, press the back button, you may work with to change the $DOEN options.
<br><br>
[<font size="+1"><a href="index.cgi">Test $PYU Hear</a></font>]
EOF
		if [ "`echo $QS|grep htmldoc`" != "" ] ; then
			cat <<EOF
 [<font soze="+1"><a target="_blank" href="README.html">HTML Document</a></font>]
EOF
		fi
		cat <<EOF
<div align="left">
<form action="index.cgi" method="GET">
<input type="submit" value="Back" $btnstyle $disable>
<input type="submit" value="Next" $btnstyle $disable>
<input type="submit" name="complete" value="Complete" $btnstyle>
</form></div>
</td></tr>
</table>
</body></html>
EOF
		echo $FOOTEN|sed -e s/\$IVER/$IVER/g;
	fi
fi

if [ "$CMD" = "shell" ]; then
	updatecheck
	echo $DOEN $PYU
	echo "Version:$VER$BUILD ($CODE)"
	echo Install $DOEN to $PWD
	echo -n "Secure $DOEN ? (y/n) : "
	read secure
	echo -n "Press any key to $DOEN (Stop:Ctrl+C) : "
	read ans

	$SH $X extract $MYCMD
	$SH $X setperl $MYCMD
	if [ "`echo $secure|grep '[Yy]'`" != "" ]; then
		$SH $X schm $MYCMD
	else
		$SH $X chm $MYCMD
	fi
	echo "$DOEN complete."
fi

$R -f $HT
