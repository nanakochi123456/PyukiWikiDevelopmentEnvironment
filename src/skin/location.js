/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */



var _u, _t, _f, _o, _m,_c, _jm, _l, _fu, _mf, _g=0;

function jslocation(obj, url, time, fakeurl) {
	if(time < 0) {
		jslocationstop();
		return;
	}
	_u=url;
	_t=time;
	_o=obj;
	_f=0;
	_fu=fakeurl;
	_mf=0;
	_j(_o, _t, 0);
	_l=window.setTimeout("_jsl();", 1000);
}

function jsdownload(obj, url, time, fakeurl) {
	if(time < 0) {
		jslocationstop();
		return;
	}
	_u=url;
	_t=time;
	_o=obj;
	_f=0;
	_fu=fakeurl;
	_mf=1;
	_j(_o, _t, 1);
	_l=window.setTimeout("_jsl();", 1000);
}

function jslocationstop() {
	_t=-1;
	_f=1;
	_j(_o, _t, _mf);
	window.clearTimeout(_l);
}

function _jsl() {
	window.clearTimeout(_l);

	if(_f+0 > 0)
		return;

	if(_t > 0) {
		_t = _t - 1;
		_l=window.setTimeout("_jsl();", 1000);
	}
	_j(_o, _t, _mf);
	if(_t < 1 && !_g) {
		window.location=_u;
		_g=1;
	}
}

function _j(obj, sec, msgflag) {
	var msg, clickmsg, jumpmsg;

	if(msgflag) {
		msg=ln(
			'en','Start the download of <a href="\$url" onclick="jslocationstop();">\$dispurl</a> in \$sec seconds.'
			,
			'ja','\$sec\u79d2\u5f8c\u306b<a href="\$url" onclick="jslocationstop();">\$dispurl</a>\u306e\u30c0\u30a6\u30f3\u30ed\u30fc\u30c9\u304c\u958b\u59cb\u3055\u308c\u307e\u3059\u3002'
		),
		clickmsg=ln(
			'en','Starting Download <a href="\$url">\$dispurl</a>.'
			,
			'ja','<a href="\$url">\$dispurl</a>\u306e\u30c0\u30a6\u30f3\u30ed\u30fc\u30c9\u3092\u958b\u59cb\u4e2d\u3067\u3059\u3002'
		);
		jumpmsg=ln(
			'en','Starting Download <a href="\$url">\$dispurl</a>.'
			,
			'ja','<a href="\$url">\$dispurl</a>\u306e\u30c0\u30a6\u30f3\u30ed\u30fc\u30c9\u3092\u958b\u59cb\u4e2d\u3067\u3059\u3002'
		);
	} else {
		msg=ln(
			'en','Go to <a href="\$url" onmouseover="jslocationstop();">\$dispurl</a> after \$sec seconds'
			,
			'ja','\$sec\u79d2\u5f8c\u306b<a href="\$url" onmouseover="jslocationstop();">\$dispurl</a>\u306b\u30b8\u30e3\u30f3\u30d7\u3057\u307e\u3059'
		),
		clickmsg=ln(
			'en','When click <a href="\$url">\$dispurl</a> go to <a href="\$url">\$dispurl</a>'
			,
			'ja','\u30af\u30ea\u30c3\u30af\u3059\u308b\u3068<a href="\$url">\$dispurl</a>\u306b\u30b8\u30e3\u30f3\u30d7\u3057\u307e\u3059'
		),
		jumpmsg=ln(
			'en','Moving to <a href="\$url">\$dispurl</a>'
			,
			'ja','<a href="\$url">\$dispurl</a>\u3078\u79fb\u52d5\u4e2d\u3067\u3059'
		);
	}

	var _displayurl=_fu !== void 0 && _fu != "" ? _fu : _u,
		url=_u,
		displayurl=_displayurl.substr(0,40);

	if(displayurl != _displayurl) {
		displayurl+="...";
	}

	msg=msg.replaceAll('\$sec', sec);
	msg=msg.replaceAll('\$url', url);
	msg=msg.replaceAll('\$dispurl', displayurl);
	clickmsg=clickmsg.replaceAll('\$url', url);
	clickmsg=clickmsg.replaceAll('\$dispurl', displayurl);
	jumpmsg=jumpmsg.replaceAll('\$url', url);
	jumpmsg=jumpmsg.replaceAll('\$dispurl', displayurl);
	if(sec + 0 < 0) {
		sinss(obj, clickmsg);
	} else if(sec + 0 < 1) {
		sinss(obj, jumpmsg);
	} else {
		sinss(obj, msg);
	}
}
