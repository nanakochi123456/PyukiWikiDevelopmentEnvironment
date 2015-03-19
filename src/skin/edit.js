/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */




var	w				= window,
	d				= w.document,
	l				= d.location,
	n				= navigator,

//	CHROME			= ua("CHROME"),
//	MACOS			= ua("MACOS"),
//	IPAD			= ua("IPAD"),
//	NINTENDODS		= ua("NINTENDODS"),
//	VERSION			= ua("VERSION"),

	ef="editform",
	h="",
	edit=h,

	fb=false,
	fo,
	autoSaveFlg = false,
	autoSaveBuf,

	autoSaveTime = 1000,				// \u81ea\u52d5\u4fdd\u5b58\u306e\u9593\u9694\uff08\u30df\u30ea\u79d2\uff09
	autoSaveInittime = 100,
	expire=864000000,					// cookie\u306e\u6709\u52b9\u671f\u9650\uff08\u30df\u30ea\u79d2\uff09
	_isave=1,
	objTimeout,
	objautoSaveInit,
	url,
	parm,
	cookiekey,
	encrypt,
	namekey;


ev.add("onload", "autoSaveInit", autoSaveInit);


function ep(form, mode, value) {
	if(form) {
		form.value=h;
		if(mode == value) {
			form.value="1";
		}
			autoSaveEnd();
			_isave=0;
		if(value >0) {
		}
	}
}

function editpost(mode, e) {
	var form=gid(ef);
	_isave=0;
	ep(form.mypreviewjs_adminedit, mode, 0);
	ep(form.mypreviewjs_edit, mode, 0);
	ep(form.mypreviewjs_write, mode, 1);
	ep(form.mypreviewjs_cancel, mode, 2);
//	ep(form.mypreviewjs_blog_cancel, mode, 2);

	for(var f=0; f < d.forms.length; f++) {
		var frm=d.forms[f];
		if(frm.name == form) {
			for(var e=0; e < frm.elements.length; e++) {
				var ele=frm.elements[e];
				if(ele.name.substr(0,"mypassword".length) == "mypassword") {
					fsubmit(ef,"frozen",e);
				}
			}
		}
	}

	gid(ef).submit();
}



function autoSaveInit () {
	try {
		url=l.protocol + "//" + l.host + l.pathname;
		parm=l.search.substr(1);
		fo=getform("editform", "mymsg");
		namekey = MD5_hexhash(
			url + parm + getform("editform", "mypage").value);
		cookiekey = MD5_hexhash(getrand() + namekey + getrand() + getexpire());
		encrypt=cookiekey;

		var array=getCookie("EBK" + namekey);
		for(var i = 2; i < ~~(Math.random() * 99); i++) {
			encrypt = MD5_hexhash(
				fo.value + encrypt + url + parm + getexpire()  + getrand());
		}
		setCookie("EBK" + namekey, expire, "k", cookiekey, "p" , encrypt);

		autoSaveStart();
		ev.add("onbeforeunload", "editunload", editunload);
		clearTimeout(objautoSaveInit);
	} catch(e) {
		objautoSaveInit = setTimeout(autoSaveInit, autoSaveInittime);
	}
}

function fa() {
	return false;
}

function getrand() {
	return ~~(Math.random()*10000000);
}

function editunload(event) {
	var event=eve(event);
	if(_isave == 1) {
		if(!(
			focuselement("mypreviewjs_button_" + "edit")
		 || focuselement("mypreviewjs_button_" + "adminedit")
		 || focuselement("mypreviewjs_button_" + "write")
		 || focuselement("mypreviewjs_button_" + "cancel")
		)) {
			if(fb != fo.value) {
				event.returnValue = ln(
					"ja", "\u30da\u30fc\u30b8\u3092\u79fb\u52d5\u3059\u308b\u3068\u3001\u7de8\u96c6\u3057\u305f\u5185\u5bb9\u306f\u6d88\u53bb\u3055\u308c\u307e\u3059\u3002\n\u30da\u30fc\u30b8\u3092\u79fb\u52d5\u3057\u307e\u3059\u304b\uff1f",
					"en", "When you move a page, your edit will be erased.\nAre you sure you want to move page?"
				);
			}
		}
	}
}


function editbutton() {
	var type, name, value, _editpost, checked, title, str=h,
		strinput='<input ',
		strclass=strinput + ' class="',
		strtype='" type="',
		strname='" name="',
		strid='" id="',
		strvalue='" value="';

	for(var i = 0; i < arguments.length;) {
		type=arguments[i];
		name=arguments[i + 1];
		if(type == "hidden") {
			str+=strinput + strtype + type + strname + name + strid + name + '" value="" />';
			i = i + 2;
		} else if(type == "button") {
			value=arguments[i + 2];
			_editpost=arguments[i + 3];
			str+=strclass + 'editformbutton' + strtype + type + strname + name + strid + name + strvalue + value + '" onclick="editpost(' + _editpost + ');" onkeypress="editpost(' + _editpost + ',event);" />';
			i = i + 4;
		} else if(type == "checkbox") {
			value=arguments[i + 2];
			checked=arguments[i + 3];
			title=arguments[i + 4];
			str+=strclass + 'editformcheck' + strtype + type + strname + name + strid + name + strvalue + value + '"' + checked + ' />' +title;
			i = i + 5;
		}
	}
	return str;
}

function autoSaveStart () {
	ev.add("onreset", "fa", fa);
	if(objTimeout) {
		clearTimeout(objTimeout);
	}
	objTimeout = setTimeout(autosave,autoSaveTime);
}

function autoSaveEnd () {
	ev.del("onbeforeunload", "editunload");
	if(objTimeout) {
		clearTimeout(objTimeout);
	}
}

function autosave() {
	if(_isave == 1) {
		ebak();
		if(fb != fo.value) {
			if(autoSaveBuf != fo.value) {
				_isave=0;
				http("POST", url
					, "cmd=edit&autosave=" + cookiekey
					+ "&mymsg="
					+ cookiekey + "\t" + encrypt + "\t"
					+ getform("editform", "mypage").value + "\n"
					+ ec(fo.value)
					, callback, callback);
				autoSaveBuf = fo.value;
			}
		}
	}
	autoSaveStart();
}

function ec(str) {
	str=str.replaceAll("&","\f1");
	str=str.replaceAll(";","\f2");
	str=str.replaceAll("\r","\f3");
	str=str.replaceAll("\n","\f4");
	return str;
}

function callback(stat, str) {
	_isave=1;
}









function ebak() {
	fo=getform("editform", "mymsg");
	if(fb != false) {
		return;
	}
	autoSaveInit();
	if(fo != null) {
		fb=fo.value;
	}
}

function getform(form, name) {
	for(var f=0; f < d.forms.length; f++) {
		var frm=d.forms[f];
		if(frm.name == form) {
			for(var e=0; e < frm.elements.length; e++) {
				var ele=frm.elements[e];
				if(ele.name == name) {
					return ele;
				}
			}
		}
	}
	return null;
}




function eprn(e) {
	return esp(e, 0);
}

function eprs(e) {
	return esp(e, 1);
}
function eprsc(e) {
	return esp(e, 2);
}

function focuselement(ele) {
	var element = (d.activeElement || w.getSelection().focusNode);
	return element.name == ele ? true : false;
}

function esp(e, flg) {
	if(e == null) return true;
	ebak();

	// document.onload\u3067\u3082\u884c\u306a\u3046\u304c\u3001\u6700\u521d\u306e\uff11\u6587\u5b57\u3092\u5165\u529b\u3057\u305f\u6642\u306b\u3001
	// JavaScript\u3067\u30d0\u30c3\u30af\u30a2\u30c3\u30d7\u3092\u53d6\u308b\u3002
	if(keyCode(e) == 27) {
		if(focuselement("mymsg") && flg > 0) {
			if(fo.value != fb) {
				if(flg == 2) {
					if(confirm(ln(
							"ja", "\u30d5\u30a9\u30fc\u30e0\u306e\u5185\u5bb9\u3092\u5143\u306b\u623b\u3057\u307e\u3059\u304b\uff1f",
							"en", "Are you want to reset form ?",
							h))) {
						ev.del("onbeforeunload", "editunload");
						fo.value=fb;
					}
				} else {
					ev.del("onbeforeunload", "editunload");
					fo.value=fb;
				}
			}
		}
		// MSIE\u3067\u306f\u3001\u30c7\u30d5\u30a9\u30eb\u30c8\u306e\u5143\u306b\u623b\u3059\u6a5f\u80fd\u3092\u7121\u52b9\u306b\u3059\u308b
		return false;
	} else {
		autoSaveStart();
	}
	return true;
}


function getCookie(key) {
	var tmp1, tmp2, xx1, xx2, xx3, array=ar();

	tmp1 = " " + d.cookie + ";";
	xx1 = xx2 = 0;
	len = tmp1.length;
	while (xx1 < len) {
		xx2  = tmp1.indexOf(";", xx1);
		tmp2 = tmp1.substring(xx1 + 1, xx2);
		xx3  = tmp2.indexOf("=");
		if (tmp2.substring(0, xx3) == key) {
			var str=unescape(tmp2.substring(xx3 + 1, xx2 - xx1 - 1));
			var cookie=str.split(",");
			for (var i = 0; i < cookie.length; i++) {
				var cook=cookie[i].split(":");
				array[cook[0]]=cook[1];
			}
			return array;
		}
		xx1 = xx2 + 1;
	}
	return(array);
}

function setCookie() {
	var tmp=escape(arguments[0]) + "=";
	for(var i=1; i < arguments.length; i = i + 2) {
		if(i != 1) {
			tmp += ",";
		}
		tmp += escape(arguments[i]) + ":" + escape(arguments[i + 1]);
	}
	tmp += ";" + "path=" + l.pathname + ";" + "expires=" + getexpire() + ";";
	d.cookie = tmp;
}



function getexpire() {
	var date = new Date();
	date.setTime(date.getTime() + expire);
	return date.toGMTString();
}














var MD5Z=0, MD5_T;
if(!MD5Z) {
	MD5_T=ar();
	for(var i=1; i < 65; i++) {
		MD5_T[i] = parseInt(Math.abs(Math.sin(i)) * 4294967296.0);
	}
	MD5_T[0]=0;
}


var MD5_round1 = new Array(
					new Array( 0, 7, 1),	new Array( 1,12, 2),
					new Array( 2,17, 3),	new Array( 3,22, 4),
					new Array( 4, 7, 5),	new Array( 5,12, 6),
					new Array( 6,17, 7),	new Array( 7,22, 8),
					new Array( 8, 7, 9),	new Array( 9,12,10),
					new Array(10,17,11),	new Array(11,22,12),
					new Array(12, 7,13),	new Array(13,12,14),
					new Array(14,17,15),	new Array(15,22,16)
				);

var MD5_round2 = new Array(
					new Array( 1, 5,17),	new Array( 6, 9,18),
					new Array(11,14,19),	new Array( 0,20,20),
					new Array( 5, 5,21),	new Array(10, 9,22),
					new Array(15,14,23),	new Array( 4,20,24),
					new Array( 9, 5,25),	new Array(14, 9,26),
					new Array( 3,14,27),	new Array( 8,20,28),
					new Array(13, 5,29),	new Array( 2, 9,30),
					new Array( 7,14,31),	new Array(12,20,32)
				);

var MD5_round3 = new Array(
					new Array( 5, 4,33),	new Array( 8,11,34),
					new Array(11,16,35),	new Array(14,23,36),
					new Array( 1, 4,37),	new Array( 4,11,38),
					new Array( 7,16,39),	new Array(10,23,40),
					new Array(13, 4,41),	new Array( 0,11,42),
					new Array( 3,16,43),	new Array( 6,23,44),
					new Array( 9, 4,45),	new Array(12,11,46),
					new Array(15,16,47),	new Array( 2,23,48)
				);

var MD5_round4 = new Array(
					new Array( 0, 6,49),	new Array( 7,10,50),
					new Array(14,15,51),	new Array( 5,21,52),
					new Array(12, 6,53),	new Array( 3,10,54),
					new Array(10,15,55),	new Array( 1,21,56),
					new Array( 8, 6,57),	new Array(15,10,58),
					new Array( 6,15,59),	new Array(13,21,60),
					new Array( 4, 6,61),	new Array(11,10,62),
					new Array( 2,15,63),	new Array( 9,21,64)
				);

function MD5_F(x, y, z) { return (x & y) | (~x & z);}
function MD5_G(x, y, z) { return (x & z) | (y & ~z);}
function MD5_H(x, y, z) { return x ^ y ^ z; 		}
function MD5_I(x, y, z) { return y ^ (x | ~z);		}

var MD5_round = new Array(
					new Array(MD5_F, MD5_round1),
					new Array(MD5_G, MD5_round2),
					new Array(MD5_H, MD5_round3),
					new Array(MD5_I, MD5_round4)
				);

function MD5_pack(n32) {
	return String.fromCharCode(n32 & 0xff) +
		String.fromCharCode((n32 >>> 8) & 0xff) +
		String.fromCharCode((n32 >>> 16) & 0xff) +
		String.fromCharCode((n32 >>> 24) & 0xff);
}

function MD5_unpack(s4) {
	return  s4.charCodeAt(0)        |
		(s4.charCodeAt(1) <<  8) |
		(s4.charCodeAt(2) << 16) |
		(s4.charCodeAt(3) << 24);
}

function MD5_number(n) {
	while (n < 0)
		n += 4294967296;
	while (n > 4294967295)
		n -= 4294967296;
	return n;
}

function MD5_apply_round(x, s, f, abcd, r) {
	var a, b, c, d,
		kk, ss, ii,
		t, u;

	a = abcd[0];
	b = abcd[1];
	c = abcd[2];
	d = abcd[3];
	kk = r[0];
	ss = r[1];
	ii = r[2];

	u = f(s[b], s[c], s[d]);
	t = s[a] + u + x[kk] + MD5_T[ii];
	t = MD5_number(t);
	t = ((t<<ss) | (t>>>(32-ss)));
	t += s[b];
	s[a] = MD5_number(t);
}

function MD5_hash(data) {
	var abcd, x, state, s,
		len, index, padLen, f, r,
		i, j, k,
		tmp;

	state = new Array(0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476);
	len = data.length;
	index = len & 0x3f;
	padLen = (index < 56) ? (56 - index) : (120 - index);
	if(padLen > 0) {
		data += "\x80";
		for(i = 0; i < padLen - 1; i++)
			data += "\x00";
	}
	data += MD5_pack(len * 8);
	data += MD5_pack(0);
	len  += padLen + 8;
	abcd = new Array(0, 1, 2, 3);
	x    = new Array(16);
	s    = new Array(4);

	for(k = 0; k < len; k += 64) {
		for(i = 0, j = k; i < 16; i++, j += 4) {
			x[i] = data.charCodeAt(j) |
				(data.charCodeAt(j + 1) <<  8) |
				(data.charCodeAt(j + 2) << 16) |
				(data.charCodeAt(j + 3) << 24);
	    }
		for(i = 0; i < 4; i++)
			s[i] = state[i];
		for(i = 0; i < 4; i++) {
			f = MD5_round[i][0];
			r = MD5_round[i][1];
			for(j = 0; j < 16; j++) {
				MD5_apply_round(x, s, f, abcd, r[j]);
				tmp = abcd[0];
				abcd[0] = abcd[3];
				abcd[3] = abcd[2];
				abcd[2] = abcd[1];
				abcd[1] = tmp;
			}
		}

		for(i = 0; i < 4; i++) {
			state[i] += s[i];
			state[i] = MD5_number(state[i]);
		}
	}

	return	MD5_pack(state[0]) +
			MD5_pack(state[1]) +
			MD5_pack(state[2]) +
			MD5_pack(state[3]);
}

function MD5_hexhash(data) {
	var i, out, c,
		bit128;

	bit128 = MD5_hash(data);
	out = h;
	for(i = 0; i < 16; i++) {
		c = bit128.charCodeAt(i);
		out += "0123456789abcdef".charAt((c>>4) & 0xf);
		out += "0123456789abcdef".charAt(c & 0xf);
	}
	return out;
}











function utf16to8(str) {
	var out, i, len, c;

	out = h;
	len = str.length;
	for(i = 0; i < len; i++) {
		c = str.charCodeAt(i);
		if ((c >= 0x0001) && (c <= 0x007F)) {
			out += str.charAt(i);
		} else if (c > 0x07FF) {
			out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
			out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));
			out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));
		} else {
			out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));
			out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));
		}
	}
	return out;
}



ev.ex("onload");
