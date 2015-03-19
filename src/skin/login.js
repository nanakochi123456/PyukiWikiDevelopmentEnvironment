/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */





var
//	CHROME			= ua("CHROME"),
//	MACOS			= ua("MACOS"),
//	IPAD			= ua("IPAD"),
//	NINTENDODS		= ua("NINTENDODS"),
//	VERSION			= ua("VERSION"),

	w				= window,
	d				= w.document,
	l				= d.location,
	n				= navigator,


	a="&amp;",
	e="=",
	h="",

	lj="ja",
	le="en",
	cm="?cmd=login",
	oid="mode=openid",
	rf="refer=",

	od="OpenID",
	j_p="\u30d1\u30b9\u30ef\u30fc\u30c9",
	e_p="Password",
	j_u="\u30e6\u30fc\u30b6\u30fcID",
	e_u="UserID",
	j_n="\u30cb\u30c3\u30af\u30cd\u30fc\u30e0",
	e_n="Nickname",
	j_e="\u30e1\u30fc\u30eb\u30a2\u30c9\u30ec\u30b9",
	e_e="E-Mail",

	j_masu="\u307e\u3059\u3002",
	j_ch="\u6587\u5b57",
	j_st="\u306e" + j_ch + "\u5217",
	j_cant="\u306b\u4f7f\u7528\u3067\u304d\u306a\u3044" + j_ch + "\u304c\u3042\u308a" + j_masu,
	j_pcant=j_p + j_cant,
	j_d="\u304c\u9055\u3044" + j_masu,
	j_ed=j_e + j_d,
	e_d=" is different.",
	e_ed=e_e + e_d,

	oc="onchange",
	of="onfocus",
	ob="onblur",
	ou="onkeyup",
	os="onsubmit",
	_p=true,
	nn=h,
	ui=h,
	_y=0,
	_m=0,
	_d=0,
	// in password dictionary build/worddic.txt
 s="word_text";




(function(){
	$(window).load(function(){
		$('input[type=text],input[type=password],textarea').each(function(){
			var thisTitle = $(this).attr('title');
			if(!(thisTitle === '')){
				$(this).wrapAll('<span style="text-align:left;display:inline-block;position:relative;"></span>');
				$(this).parent('span').append('<span class="placeholder">' + thisTitle + '</span>');
				$('.placeholder').css({
					top:'4px',
					left:'5px',
					fontSize:'100%',
					lineHeight:'120%',
					textAlign:'left',
					color:'#999',
					overflow:'hidden',
					position:'absolute',
					zIndex:'99'
				}).click(function(){
					$(this).prev().focus();
				});

				$(this).focus(function(){
					$(this).next('span').css({display:'none'});
				});

				$(this).blur(function(){
					var thisVal = $(this).val();
					if(thisVal === ''){
						$(this).next('span').css({display:'inline-block'});
					} else {
						$(this).next('span').css({display:'none'});
					}
				});

				var thisVal = $(this).val();
				if(thisVal === ''){
					$(this).next('span').css({display:'inline-block'});
				} else {
					$(this).next('span').css({display:'none'});
				}
			}
		});
	});
});



function oauthlogin(script, refer, urlform, url, sform, service, oform, oid, uform, uid, undefined) {
	return _ologin(script, refer, urlform, url, sform, service, oform, oid, uform, uid, 'mode=oauth');
}


function openidlogin(script, refer, urlform, url, sform, service, oform, oid, uform, uid, undefined) {
	return _ologin(script, refer, urlform, url, sform, service, oform, oid, uform, uid, 'mode=openid');
}


function _ologin(script, refer, urlform, url, sform, service, oform, oid, uform, uid, m, undefined) {
	var loginform, u;

	if(uid !== undefined) {
		if(uid != h) {
			loginform=gf(uform,uid);
			if(loginform.value == h) {
				alert(ln(
					lj, "\u8a8d\u8a3cURL\u304c\u5165\u529b\u3055\u308c\u3066\u3044\u307e\u305b\u3093\u3002\n" + j_e + "\u307e\u305f\u306f\u30a2\u30ab\u30a6\u30f3\u30c8\u540d\u306b\u5165\u529b\u3057\u3066\u4e0b\u3055\u3044\u3002"
					,
					le, "Authentication URL has not been entered.\nEnter e-mail address or account name."
				));
				loginform.focus();
				return false;
			}
			u=
				script
				+ cm + + a + oid + a
				+ rf + refer + a
				+ urlform + e
				+ loginform + a
				+ sform + e + service;
		}
	} else if(oid !== undefined) {
		if(oid != h) {
			loginform=gf(oform,oid);
			if(loginform.value == h) {
				alert(ln(
					lj, "\u30b5\u30fc\u30d3\u30b9\u30d7\u30ed\u30d0\u30a4\u30c0\u30fc\u306e\u30ed\u30b0\u30a4\u30f3ID\u304c\u5165\u529b\u3055\u308c\u3066\u3044\u307e\u305b\u3093\u3002\n" + j_e + "\u307e\u305f\u306f\u30a2\u30ab\u30a6\u30f3\u30c8\u540d\u306b\u5165\u529b\u3057\u3066\u4e0b\u3055\u3044\u3002"
					,
					le, "Login ID of the service provider has not been entered.\nEnter e-mail address or account name."
				));
				loginform.focus();
				return false;
			}
			u=
				script
				+ cm + a + m + a
				+ rf + refer + a
				+ urlform + e
				+ url + loginform.value + a
				+ sform + e + service;
		}
	} else {
		u=
			script
			+ cm + a + m + a
			+ rf + refer + a
			+ urlform + e
			+ url + a
			+ sform + e + service;
	}
	location.href=u;
	return false;
}


function nchk(o, s) {
	return(
		(s > 0 && o.value.length == 0)
		? 1 : 0);
}


function lchk(o, s, l) {
	return(
		(o.value.length >= s && o.value.length <= l)
		? 0 : 1);
}


function lerr(obj, errform, errclass, str) {
	obj.className=errclass;
	sinss(errform, str);
}


function lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def, msg) {

	if(nchk(obj, minstr) || obj.value == def) {
		lerr(obj, errform, errclass, ln(
			lj, msg + j_st + "\u304c\u5165\u529b\u3055\u308c\u3066\u3044\u307e\u305b\u3093\u3002"
			,
			le, "It has not been entered in the string " + msg + "."
		));
		obj.value="";
		s_blur(obj, def, defclass);
		return 1;
	}

	if(lchk(obj, minstr, maxstr)) {
		lerr(obj, errform, errclass, ln(
			lj, msg + j_st + "\u306f" + minstr + j_ch + "\u301c" + maxstr + j_ch + "\u306e\u9593\u3067\u3059\u3002"
			,
			le, msg + " string of characters is between " + minstr + " to " + maxstr + " characters."
		));
		s_blur(obj, def, defclass);
		return 1;
	}
	if(!checkstr(obj)) {
		lerr(obj, errform, errclass, ln(
			lj, msg + j_cant
			,
			le, "There is a character that can not be used in " + a + "."
		));
		obj.value=h;
		obj.focus();
		s_blur(obj, def, defclass);
		return 1;
	}
	return 0;
}


function s_focus(obj, def, inclass) {
	if(obj.value == def) {
		obj.value=h;
	}
	obj.className=inclass;
}


function s_blur(obj, def, defclass) {
	if(obj.value == h) {
		obj.value=def;
		obj.className=defclass;
	}
}


function s_onchange(obj, inclass) {
	obj.className=inclass;
}


function j_nickname(formtest, mode, formid, form, errform, obj, objs) {
	var obj=gf(formid, form),
		sobj=gid(form),
		def=sobj.getAttribute("default"),
		inclass=sobj.getAttribute("inclass"),
		defclass=sobj.getAttribute("defclass"),
		errclass=sobj.getAttribute("errclass"),
		minstr=sobj.getAttribute("minlength"),
		maxstr=sobj.getAttribute("maxlength");

	if(mode == oc) {
		s_onchange(obj, inclass);
		return;
	}
	if(mode == of) {
		s_focus(obj, def, inclass);
		return;
	}
	if(mode == ob || mode == os){
		if(lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def,
			ln(
			lj, j_n
			,
			le, e_n
		))) {
			if(mode == os && formtest == true)
				obj.focus();
			return false;
		}
	}
	lerr(obj, errform, inclass, h);
	s_blur(obj, def, defclass);
	nn=obj.value;
	return true;
}


function j_form(formtest, mode, formid, form, errform, obj, objs) {
	var obj=gf(formid, form),
		sobj=gid(form),
		def=sobj.getAttribute("default"),
		inclass=sobj.getAttribute("inclass"),
		defclass=sobj.getAttribute("defclass"),
		errclass=sobj.getAttribute("errclass"),
		minstr=sobj.getAttribute("minlength"),
		maxstr=sobj.getAttribute("maxlength");

	if(mode == oc) {
		s_onchange(obj, inclass);
		return;
	}
	if(mode == of) {
		s_focus(obj, def, inclass);
		return;
	}
	s_blur(obj, def, defclass);
	return true;
}


function j_userid(formtest, mode, formid, form, errform, obj, objs) {
	var obj=gf(formid, form),
		sobj=gid(form),
		def=sobj.getAttribute("default"),
		inclass=sobj.getAttribute("inclass"),
		defclass=sobj.getAttribute("defclass"),
		errclass=sobj.getAttribute("errclass"),
		minstr=sobj.getAttribute("minlength"),
		maxstr=sobj.getAttribute("maxlength");

	if(mode == oc) {
		s_onchange(obj, inclass);
		return;
	}
	if(mode == of) {
		s_focus(obj, def, inclass);
		return;
	}
	if(mode == ob || mode == os){
		if(lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def,
			ln(
			lj, j_u
			,
			le, e_u
		))) {
			if(mode == os && formtest == true)
				obj.focus();
			return false;
		}
	}
	lerr(obj, errform, inclass, h);
	s_blur(obj, def, defclass);
	ui=obj.value;
	return true;
}


function j_passwd(formtest, mode, formid, form, errform, obj, objs) {
	var obj=gf(formid, form),
		sobj=gid(form),
		def=sobj.getAttribute("default"),
		inclass=sobj.getAttribute("inclass"),
		defclass=sobj.getAttribute("defclass"),
		errclass=sobj.getAttribute("errclass"),
		minstr=sobj.getAttribute("minlength"),
		maxstr=sobj.getAttribute("maxlength");

	if(mode == oc) {
		s_onchange(obj, inclass);
		return;
	}
	if(mode == of) {
		s_focus(obj, def, inclass);
		return;
	}
	if(mode == ob) {
		if(lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def,
			ln(
			lj, j_p
			,
			le, e_p
		))) {
			return false;
		}
		if(!checkpass(obj)) {
			lerr(obj, errform, errclass, ln(
				lj, j_pcant
				,
				le, e_p
			));
			obj.value=h;
			obj.focus();
			s_blur(obj, def, defclass);
			return 1;
		}
	}
	lerr(obj, errform, inclass, h);
	s_blur(obj, def, defclass);
	return true;
}


function j_newpass(formtest, mode, formid, form, errform, obj, objs) {
	var obj=gf(formid, form),
		sobj=gid(form),
		def=sobj.getAttribute("default"),
		inclass=sobj.getAttribute("inclass"),
		defclass=sobj.getAttribute("defclass"),
		errclass=sobj.getAttribute("errclass"),
		minstr=sobj.getAttribute("minlength"),
		maxstr=sobj.getAttribute("maxlength");

	if(mode == oc || mode == ou) {
		lerr(obj, errform, inclass, strength_html(strength(obj.value), minstr - obj.value.length));
		return;
	}
	if(mode == of) {
		s_focus(obj, def, inclass);
		lerr(obj, errform, inclass, strength_html(strength(obj.value), minstr - obj.value.length));
		return;
	}
	if(mode == ob) {
		if(lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def,
			ln(
			lj, j_p
			,
			le, e_p
		))) {
			return false;
		}
		if(!checkpass(obj)) {
			lerr(obj, errform, errclass, ln(
				lj, j_pcant
				,
				le, e_p
			));
			obj.value=h;
			obj.focus();
			s_blur(obj, def, defclass);
			return 1;
		}
	}

	var pf=objs.split(","),
		pass1=gf(formid, pf[0]),
		pass2=gf(formid, pf[1]),
		flg=0;
	if(mode == os) {
		if(lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def,
			ln(
			lj, j_p
			,
			le, e_p
		))) {
			return false;
		}

		if(pass1.value != pass2.value) {
			lerr(obj, errform, errclass, ln(
				lj, j_p + j_d
				,
				le, e_p + e_d
			));
			pass1.value=h;
			pass2.value=h;
			pass1.focus();
			return false;
		}


	}
	lerr(obj, errform, inclass, h);
	s_blur(obj, def, defclass);
	return true;
}


function j_email(formtest, mode, formid, form, errform, obj, objs) {
	var obj=gf(formid, form),
		sobj=gid(form),
		def=sobj.getAttribute("default"),
		inclass=sobj.getAttribute("inclass"),
		defclass=sobj.getAttribute("defclass"),
		errclass=sobj.getAttribute("errclass"),
		minstr=sobj.getAttribute("minlength"),
		maxstr=sobj.getAttribute("maxlength");

	var em=objs.split(","),
		em0=gf(formid, em[0]);
		em1=gf(formid, em[1]);
		em2=gf(formid, em[2]);

	var str=
		(form == em[0] ? em0.value : em1.value + '@' + em2.value);

	if(mode == oc) {
		s_onchange(obj, inclass);
		return;
	}
	if(mode == of) {
		s_focus(obj, def, inclass);
		return;
	}
	if(mode == ob || mode == os){
		if(form == em[0] &&
		   lform(errform, errclass, inclass, defclass, obj, minstr, maxstr, def,
			ln(
			lj, j_e
			,
			le, e_e
		))) {
			if(mode == os && formtest == true)
				obj.focus();
			return false;
		}
		if(form == em[0] &&
		   !checkEMail(str, 0)) {
			lerr(obj, errform, errclass, ln(
				lj, j_ed
				,
				le, e_ed
			));
			em0.value=h;
			em0.focus();
			return false;
		}
		if(form == em[1] || form == em[2]) {
			if( em1.value != h && em2.value != h
			&&  !checkEMail(str, 0)) {
			lerr(obj, errform, errclass, ln(
				lj, j_ed
				,
				le, e_ed
			));
			em1.value=h;
			em2.value=h;
			em1.focus();
			return false;
}
		}
	}
	lerr(obj, errform, inclass, h);
	s_blur(obj, def, defclass);
	return true;
}


function checkEMail(s, i){
	var r=true;

	if (s=='') return r;

	if(!i) {
		if (s.indexOf('.') == -1)
			r=false;
	}
	if(s.indexOf('@') == -1)
		r=false;
	else if(s.substr(s.indexOf('@')+1).indexOf('@') > -1)
		r=false;

	var t=s.match(/[0-9a-zA-Z\\.\\@\\-\\_]+/g);
	if(t!=s){
		r=false;
	}
	return r;
}


function checkstr(o){
	if(o.value.match(/[\,\=\\\$\'\"]+/g)) {
		return false;
	}
	return true;
}


function checkpass(o){
	return checkstr(o);
}


function ischr(ch) {
	var code=ch.charCodeAt(0);

	return	code < 48	? 0			
		:	code < 58	? 2			
		: 	code < 65	? 0			
		:	code < 91	? 1			
		:	code < 97	? 0			
		:	code < 123	? 1			
		:	code < 128	? 0			
		:				  0;		
}


//	});


function tozen(str) {
	return str.replace(/[\!-\~]/g, function(s) {
		return String.fromCharCode(s.charCodeAt(0) + 0xFEE0);
	});
}


function j_date(mode, value) {
	if(mode == 0)
		_y=value;
	if(mode == 1)
		_m=value;
	if(mode == 2)
		_d=value;
}


function j_word(mode, formid, sel, check, text, span, err, title, sample) {
	// no, string, min, max, unknown
	var	obj=gf(formid, text),
		selform=gf(formid, sel),
		txtform=gf(formid, text),
		checkform=gf(formid, check),
		checkspan=gid(check),
		spanspan=gid(span),
		errform=gid(err),
		arr=selform.value.split("\|");

	if(sample === void 0)
		sample=h;

	if(mode == "sel") {
		if(arr[4] == h) {
			checkspan.style.display="none";
		} else {
			checkspan.style.display="inline";
		}
		checkform.checked=false;
		txtform.value=h;
		spanspan.innerHTML=arr[4];
		errform.innerHTML=h;
	} else if(mode == "chk") {
		if(checkform.checked) {
			txtform.value=arr[4];
			s_onchange(txtform, "inputword");
		} else {
			txtform.value=h;
		}
		mode = ob;
	} else if(mode == of) {
		s_focus(obj, sample, "inputword");
		return;
	} else {
		if(lform(err, "errword", "inputword", "defword", obj, arr[2], arr[3], sample, title)) {
			return;
		} else {
			errform.innerHTML=h;
		}
	}
	s_blur(obj, sample, "defword");
}


function mktestword(teststr) {
	var cnt=0,
		testwords=ar(),
		testchar = h,
		testword = h,
		testflg = 0;

	for(var i=0; i < teststr.length; i++) {
		var tst=teststr.toLowerCase().charAt(i),
			flg = ischr(tst);
		if(testflg == flg && tst != 32) {
			testword += tst;
			testchar = tst;
			testwords[cnt]=testword;
		} else {
			if(testword != h && testword != " ") {
				testwords[cnt++]=testword;
			}
			testflg=flg;
			testword=tst;
		}
	}
	testwords[cnt]=testword;
	return testwords;
}

var	tst, _cr=0;


function strength(str) {


	var kb=new Array();

	var level=2,
		tmp=h,
		testpass,
		_z="0",
		_s=" ",
		teststr=nn + _s + ui + _s;
		if(_y + _m + _d > 0) {
			teststr +=
				+ _y + _s
//				+ _z + _m + _y + _s
				+ _m + _d + _s
				+ _z + _m + _d + _s
				+ _m + _z + _d + _s
				+ _z + _m + _z + _d + _s
//				+ _z + _d + _z + _m + _s
			;
		}

	var arr=s.split("_");
	for (var i=0; i < arr.length; i++) {
		teststr += arr[i] + _s;
	}
	if(!_cr) {
		tst=mktestword(teststr);
		_cr=1;
	}
	testpass=mktestword(str);


	if(str == h)
		return 0;

	var loop=tst.length;
	testcounts=0;

	for(var i=0; i < tst.length; i++) {
		for(var j=0; j < testpass.length; j++) {
			if(tst[i] != h && testpass[j] != h) {
				if(tst[i] == testpass[j]) {
					return 2;
				}
			}
		}
	}

	
	if(str.match(/[a-zA-Z]/) && str.match(/\d+/))
		level += 10;

	
	if(str.match(/[a-z]/) && str.match(/[A-Z]/) && str.match(/\d+/))
		level += 15;

	
	if(str.match(/(\d.*\d.*\d)/))
		level += 10;

	
	if(str.match(/[!,@#$%^&*?_~]/))
		level += 15;

	
	if(str.match(/[a-z]/) && str.match(/[A-Z]/) && str.match(/\d/) && str.match(/[!,@#$%^&*?_~]/))
		level += 15;

	
	if(level > 0)
		level +=
			str.length < 9 ? 0 : (str.length - 9) * 2;

	if(level > 100)
		level=100;

	for(var i=0; i < str.length; i++) {
		var chr=str.substr(i, 1);
		if(chr in kb) {
			kb[chr]=1;
		} else {
			level--;
		}
	}

	if(str.length < 6)
		return 1;
	else if(level < 2)
		return 2;


	return level;
}


function strength_html(level, len) {
	var msg=(
		level == 0
			? ln(
				lj, "\u5165\u529b\u3057\u3066\u4e0b\u3055\u3044"
				,
				le, "Please enter"
			)
			: (
			level == 1
				? ln(
					lj, "\u3042\u3068" + len + j_ch
					,
					le, len + " characters after"
				)
			: h)
		);
		if(level > 10)
			level=10;

		if(level < 0)
			level=1;

	var	cl="strengthcommon strength",
		td='<td class="',
		tdcl='&nbsp;</td>',
		body=
		  '<table class="' + cl + '"><tr>'
		+ td + cl + 'l' + level + '">' + msg + tdcl
		+ td + cl + 'r' + level + '">' + tdcl
		+ '</tr></table>';
	return body;
}


function lsubmit(flg, id, pform, ev) {
	if(!flg) return false;
	if(keypress(ev) == false) return;
	var frms=pform.split(",");
	for(var i=0; i < frms.length; i++) {
		pencf(
			  gf(id, frms[i])
			, gf(id, frms[i] + "_enc")
			, gf(id, frms[i] + "_token")
		);
	}
	fsubmitdelay(id,ev);
}


