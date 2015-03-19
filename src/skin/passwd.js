/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */



var
//	CHROME			= ua("CHROME"),
//	MACOS			= ua("MACOS"),
//	IPAD			= ua("IPAD"),
//	NINTENDODS		= ua("NINTENDODS"),
//	VERSION			= ua("VERSION"),

	ef="editform", fid,
	w				= window,
	d				= w.document,
	l				= d.location,
	n				= navigator;

function pencf(pass_form,enc_form,token_form) {
	var out;

	if(pass_form == null || token_form == null)
		return;

	if(pass_form.value == '' || token_form.value == null)
		return;

	enc_form.value = penc(utf16to8(pass_form.value) ,utf16to8(token_form.value));
	pass_form.value = '';
}



function penc(str, enc_list) {
	var i, dd, res,dif;
	res=h;
	str += "\t" + ~~(new Date/1000);
	for (i = 0; i < str.length; i++) {
		dif = (~~( Math.random() * 127 ) + i) % 127;
		res = res + enc_list.substr(dif / 0x10,1) + enc_list.substr(dif % 0x10, 1);
		dd = str.charCodeAt(i) + dif;
		res = res + enc_list.substr(dd / 0x10,1) + enc_list.substr(dd % 0x10, 1);
	}
	return res;
}



function keyCode(e){
	var e=eve(e);

	if(d.all)
          return e.keyCode;
     else if(d.getElementById)
         return e.keyCode ? e.keyCode : e.charCode;
     else if(d.layers)
         return e.which;
}

function keypress(e) {
	if(e == null) return true;
	var key=keyCode(e);
	if(key == 32 || key == 13) return true;
	return false;
}

function fsubmit(id,type,ev) {
	if(keypress(ev) == false) return;

	var mypassword="mypassword_";
	pencf(
		  gid(mypassword + type)
		, gid(mypassword + type + "_enc")
		, gid(mypassword + type + "_token")
	);
	fsubmitdelay(id,ev);
}

function fsubmitdelay(id,e) {
	if(keypress(e) == false) return;

	fid=id;
	setTimeout("fsub();", 30);
}

function fsub() {
	gid(fid).submit();
}

function ep(form, mode, value) {
	if(form) {
		form.value=h;
		if(mode == value) {
			form.value="1";
		}
	}
}

function editpost(mode, e) {
	var form=gid(ef);

	ep(form.mypreviewjs_adminedit, mode, 0);
	ep(form.mypreviewjs_edit, mode, 0);
	ep(form.mypreviewjs_write, mode, 1);
	ep(form.mypreviewjs_cancel, mode, 2);
	ep(form.mypreviewjs_blog_adminedit, mode, 0);
	ep(form.mypreviewjs_blog_edit, mode, 0);
	ep(form.mypreviewjs_blog_write, mode, 1);
	ep(form.mypreviewjs_blog_cancel, mode, 2);

	fsubmit(ef,"frozen",e);
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


