#!/bin/sh
######################################################################
# PyukiWiki Install CGI version 0.5
# $Id$
# PyukiWiki __PYUKIWIKIVERSION____BUILD__ (__CODE__)
# This installer is UTF-8
######################################################################
export PATH="/bin:/usr/bin:/usr/local/bin:/opt/bin:/usr/opt/bin:/opt/perl:/opt/perl/bin:$PATH"
export PYU=PyukiWiki
export IVER=0.5
export SH=sh
export ACD=__ARCCMD__
export AET=__ARCEXT__
export TCD=__TXTCMD__
export TET=__TXTEXT__
export VER="__PYUKIWIKIVERSION__"
export BUILD="__BUILD__"
export CODE="__CODE__"
export QS=$QUERY_STRING
export LN=$HTTP_ACCEPT_LANGUAGE
export IJA=インストー
export IUJ=$IJAル
export IAJ=$IJAラ
export IUE=Install
export IAE=Installer
export T="./itm.$REMOTE_ADDR"
export X="$T/installer_sub.sh"
export S="$T/itb"
export I="$T/iitb"
export TP="$T/b6"
export AE="$T/ar"
mkdir -p $T

hh() {
	echo "Content-type: text/html;charset=utf-8"
	echo
}
err() {
	if [ $CGI = 1 ]; then
		hh
		if [ "`echo $LN | grep ja`" != "" ]; then
			cat <<EOF
<html><head><title>$PYU$IAJ</title></head><body><h2>$PYU$IAJ エラー</h2><hr>$PYU CGI$IAJは以下の理由で正常に起動できませんでした。<br>手動で$IUJして下さい。<hr>
$1
EOF
		else
			cat <<EOF
<html><head><title>$PYU $IAE</title></head><body><h2>$PYU $IAE</h2><hr>Can't execute $PYU CGI $IAE<br>Prease manual $IUE<hr>
$1
EOF
		fi
		echo \<\/body\><\/html\>
	else
		echo Can\'t execute $PYU $IAE
		echo Prease manual $IUE
	fi
	exit
}

wrc() {
	tsf="./wtst_$PYU"
	echo test>$tsf
	if [ -f $tsf ]; then
		rm -rf $tsf
		return 0;
	fi
	rm -rf $tsf
	if [ "`echo $LN | grep ja`" != "" ]; then
		err "CGIがユーザー権限で実行されていないので、$IUJできません"
	else
		err "It is not running on the user rights CGI, you can not $IUE"
	fi
	return 1;
}

cmdc() {
	if [ "$1" = "" ]; then
		return 0;
	fi
	CMD=`which $1`
	if [ "$CMD" != "" ]; then
		return 0;
	else
		if [ "`echo $LN | grep ja`" != "" ]; then
			err "コマンド $1 がありません"
		else
			err "Not found command $1"
		fi
	fi
}

chk() {
	cmdc $SH
	cmdc echo
	cmdc chmod
	cmdc sed
	cmdc cp
	cmdc rm
	cmdc mv
	cmdc cat
	cmdc grep
	cmdc $ACD
	cmdc $TCD
	wrc
}

export PWD=`pwd`

if [ "$REMOTE_ADDR" != "" ]; then
	CGI=1
else
	CGI=0
fi

if [ $CGI = 1 ]; then
	hh
	chk
	SE=cgistart
	if [ "`echo $QS|grep license`" != "" ]; then
		SE=license
	fi
	if [ "`echo $QS|grep step1`" != "" ]; then
		SE=gpl
	fi
	if [ "`echo $QS|grep step2`" != "" ]; then
		SE=art
	fi
	if [ "`echo $QS|grep step3`" != "" ]; then
		SE=cgititle
	fi
	if [ "`echo $QS|grep install`" != "" ]; then
		SE=cgiinstall
	fi
	if [ "`echo $QS|grep complete`" != "" ]; then
		SE=cgicomplete
	fi
else
	chk
	SE=shell
fi
