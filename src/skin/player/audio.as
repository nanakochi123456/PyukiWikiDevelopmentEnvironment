/*/////////////////////////////////////////////////////////////////////
# audio.as - This is PyukiWiki yet another Wiki clone
# $Id: audio.as,v 1.187 2013/03/16 17:12:33 papu Exp $
# Build 2013-03-08 11:48:49
#
# "PyukiWiki" ver 0.2.1-customoer-preview $$
# Author Nanami http://nanakochi.daiba.cx/
# Copyright(C) 2004-2007 Nekyo
# Copyright(C) 2005-2013 PyukiWiki Developers Team
# http://pyukiwiki.info/
# Based on YukiWiki http://www.hyuki.com/yukiwiki/
# Powerd by PukiWiki http://pukiwiki.sfjp.jp/
# License GPL3 and/or Artistic or each later version
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
# Return=CRLF Code=EUC-JP 1TAB=4Spaces
/////////////////////////////////////////////////////////////////////*/

/*
 * http://codezine.jp/article/detail/995
 *
 */

import flash.external.*;

class playaudio {
	var _isplay=0;
	var _dupchk=0;

	static function main () {
		// playaudioクラスの生成
		var instance:playaudio = new playaudio();
		// JavaScriptから利用する関数を登録
		ExternalInterface.addCallback("playFile",
			  instance, instance.playFile);
		ExternalInterface.addCallback("stop",
			  instance, instance.stop);
		ExternalInterface.addCallback("vol",
			  instance, instance.vol);
		ExternalInterface.addCallback("getvol",
			  instance, instance.getvol);

	}
	// MP3再生関数
	function playFile(url:String, loop:Number):Void {
		var snd:Sound = new Sound();
		var l=loop;

//		if(this._dupchk > 0) {
//			return;
//		}

		snd.stop();
		if(l < 0) {
			l=999999;
		}
		if(l == 0) {
			l=0;
		}

		this._dupchk=1;
		snd.onLoad = function() {
			this._isplay=1;
			snd.start(0, l);
			this._dupchk=0;
		}
		snd.loadSound(url);
	}

	// MP3停止関数
	function stop(Void):Void {
		var snd:Sound = new Sound();
		snd.stop();
		this._isplay=0;
		this._dupchk=0;
	}

	// 音量
	function vol(vol:Number):Void {
		var snd:Sound = new Sound();
		snd.setVolume(vol);
	}

	// 音量
	function getvol(Void):Number {
		var snd:Sound = new Sound();
		return snd.getVolume();
	}

	// 再生中？
	function isplay(Void):Number {
		return this._isplay;
	}
}

