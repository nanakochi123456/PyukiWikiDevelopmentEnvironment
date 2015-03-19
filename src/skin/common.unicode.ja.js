/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */





var	d=document,
	n=navigator,
	l=document.location,
	u = n.userAgent.toUpperCase(),
	s=screen,
	x=-1,
	ur={},
	p='px',
	bl="_blank",
	h="",
	s=" ",
	iP = null,
	ex = 7776000000, // 3*30*86400*1000,
	pck = "pcp",
	lang="ja"		
	;

uz();

function uz() {
	var	VERSION, START, END;

	// browser
	ur["OPERA"]			= us("OPERA");
	ur["FIREFOX"]		= us("FIREFOX");
	ur["GECKO"]			= us("GECKO") || us("FIREFOX");
	ur["CHROME"]		= us("CHROME");
	ur["SAFARI"]		= us("SAFARI") && !ur["CHROME"];
	ur["MSIE"]			= us("MSIE") && !ur["OPERA"] && !ur["GECKO"] || us("TRIDENT");

	// OS
	ur["WINDOWS" + h + "PHONE"]	= us("WINDOWS" + s + "PHONE");
	ur["WINDOWS"]		= us("WINDOWS") && !ur["WINDOWS"];
	ur["MACOS"]			= us("MACINTOSH")
						||us("MAC_POWERPC");
	ur["LINUX"]			= us("LINUX");
	ur["FREEBSD"]		= us("FREEBSD");

	// Phone & tablet
	ur["ANDROID"]		= us("ANDROID") && ur["LINUX"];
	ur["IOS"]			= us("IPHONE") || us["IPHONE OS"];
	ur["IPOD"]			= us("IPOD;") && ur["MACOS"];
	ur["IPAD"]			= us("IPAD;") && ur["MACOS"];
	ur["PHONE"]			= us("PHONE;") && ur["MACOS"];

	// Game machine
	ur["WII"]			= us("WII");
	ur["GAMEBOY"]		= us("GAMEBOY");
	ur["NINTENDODS"]	= us("NITRO");
	ur["PSP"]			= us("PSP" + s + "PLAYSTATION" + s + "PORTABLE");
	ur["PS2"]			= us("PS2");
	ur["PS3"]			= us("PLAYSTATION" + s + "3");

	if(ur["MSIE"]) {
		START		= u.indexOf("MSIE"),
		END			= u.indexOf(";",START);
		VERSION		= u.substring(START+5,END);
		if(VERSION) {
		// for IE11 or later
			START		= u.indexOf("RV:"),
			END			= u.indexOf(")",START);
			VERSION		= u.substring(START+3,END);
		}
		ur["NAME"]	= "MSIE";
	}
	if(ur["FIREFOX"]) {
		START		= u.indexOf("FIREFOX"),
		END			= u.length;
		VERSION		= u.substring(START+8,END);
		ur["NAME"]	= "FIREFOX";
	}
	if(ur["OPERA"]) {
		START		= u.indexOf("OPERA"),
		END			= u.length;
		VERSION		= u.substring(START+8,END);
		ur["NAME"]	= "OPERA";
	}
	if(ur["SAFARI"]) {
		START		= u.indexOf("VERSION");
		END			= u.indexOf(" ",START);
		VERSION		= u.substring(START+8,END);
		ur["NAME"]	= "SAFARI";
	}
	if(ur["CHROME"]) {
		START		= u.indexOf("CHROME");
		END			= u.indexOf(" ",START);
		VERSION		= u.substring(START+7,END);
		ur["NAME"]="CHROME";
	}
	ur["VERSION"]=VERSION;
	ur["MAGERVERSION"]=VERSION.substring(0, VERSION.indexOf("."));
}

function ua(s) {
	s =  s.toUpperCase();
	return ur[s];
}

function us(s) {
	s =  s.toUpperCase();
	return u.indexOf(s) > x;
}



function ln() {
	for(var i=0; arguments[i + 1] != h; i = i + 2) {
		if(arguments[i] == lang)
			return arguments[i + 1];
	}
	for(var i=0; arguments[i + 1] != h; i = i + 2) {
		if(arguments[i] == "en")
			return arguments[i + 1];
	}
	return "undef";
}


function addec_link(cs, ad) {
	var dec=ae(cs, ad);

	if(confirm(
'\u9001\u4fe1\u5148\u3092\n>> '  + dec + '\n\u3068\u3057\u3066\u65b0\u898f\u306b\u30e1\u30fc\u30eb\u3092\u4f5c\u6210\u3057\u307e\u3059\u3002'
		) ) {
		window.location=dec;
	}
}

function addec_text(cs, ad, id) {
	sinss(id, ae(cs, ad));
}

function ae(cs, ad) {
	for (var dec=h, i = 0; i < ad.length; i+=4) {
		var dif = cs.indexOf(ad.charAt(i))*cs.length+cs.indexOf(ad.charAt(i+1)),
			c0 = cs.indexOf(ad.charAt(i + 2)),
			c = c0 * cs.length + cs.indexOf(ad.charAt(i+3)) - dif;
		dec = dec+String.fromCharCode(c);
	}
	return dec;
}



function keyCode(e){
	var e=eve(e);

	if(document.all)
          return e.keyCode;
     else if(document.getElementById)
         return e.keyCode ? e.keyCode : e.charCode;
     else if(document.layers)
         return e.which;
}



function Ck(o, l, t) {
	var	p, i,
		a="&amp;", ck=script + "?cmd=ck" + a,
		vp="p=", vl="l=", r;

	p=hs(mypage);
	i=hs(l);
	var u=ck + vp + p + a + vl + i;
	o.href=u;
	if(t == 'r') {
		r=ck+ "r=y" + a + vp + p + a + vl + i;
		window.location=r;
		o.href=u;
		return true;
	} else if(t != h) {
		ou(u, t);
		return false;
	}
	o.href=u;
}

function hs(s) {
	for(var r=h, i=0; i < s.length; i++) {
		r=r +
			s.charCodeAt(i).toString(16).toUpperCase();
	}
	return r;
}


function sins(o, h) {
	try {
		o.innerHTML=h;
	} catch (e) {}
}

function sinss(o, h) {
	sins(gid(o), h);
}


function gid(i) {
	return document.getElementById(i);
}


function ou(u, f){
	if(f == "b") {
		f=bl;
	}
	window.open(u, f);
	return false;
}



function getClientWidth(){
	if(self.innerWidth){
		return self.innerWidth;
	} else if(document.documentElement && document.documentElement.clientWidth){
		return document.documentElement.clientWidth;
	} else if(document.body){
		return document.body.clientWidth;
	}
}

function getClientHeight(){
	if(self.innerHeight){
		return self.innerHeight;
	} else if(document.documentElement && document.documentElement.clientHeight){
		return document.documentElement.clientHeight;
	} else if(document.body){
		return document.body.clientHeight;
	}
}

function getDocHeight(){
	var h;
	if(document.documentElement && document.body){
		h = Math.max(
			document.documentElement.scrollHeight,
			document.documentElement.offsetHeight,
			document.body.scrollHeight
		);
	} else h = document.body.scrollHeight;
	return (arguments.length==1) ? h + p : h;
}

function getScrollY(undefined){
	if(typeof window.pageYOffset !== undefined){
		return window.pageYOffset;
	} else if(document.body && typeof document.body.scrollTop !== undefined){
		if(document.compatMode == 'CSS1Compat'){
			return document.documentElement.scrollTop;;
		}
		return document.body.scrollTop;
	} else if(document.documentElement && typeof document.documentElement.scrollTop !== undefined){
		return document.documentElement.scrollTop;
	}
	return 0;
}

PopupSub = function(w, h) {
	with (iP.style){
		left = Math.round((getClientWidth()-w) / 2) + p;
		top = Math.round((getClientHeight()-h) / 2 + getScrollY()) + p;
//		display = "none";
	}
	document.body.appendChild(iP);
}



imagePop = function (e, path, w, h){
	if(iP==null){
		iP = document.createElement("img");
		iP.className="popup";
		iP.src = path;
		PopupSub(w, h);

		if(iP.complete)
			iP.style.display = "block";

		iP.onload = function() {
			iP.style.display="block";
		}
		iP.onclick = function() {
			document.body.removeChild(iP);
			iP=null;
		}
		iP.title = "\u30de\u30a6\u30b9\u30af\u30ea\u30c3\u30af\u3067\u9589\u3058\u307e\u3059";	
	}
}



halfhide = function () {
	// http://javascript.go-th.net/Entry/2/

	ds = document.createElement('div');
	ds.setAttribute('id','ts');
	ds.className="half";
//		position='absolute';
//		zIndex = 500;
//		ds.style.filter='alpha(opacity=90)';
	document.body.appendChild(ds);
	ds.style.display = 'block';
}

clearhalfhide = function () {
	ds.style.display = "none";
	if (MSIE && ur["VERSION"] < 10) {
		ds.style.filter='alpha(opacity=0)';
	} else {
		ds.style.opacity=.0;
	}
	document.body.appendChild(ds);
}

PopupOpen = function (html, ref, w, h){
	var cookarray=getCookie(pck),
		cook=cookarray[pck];

	if(cook == pck)
		return;

	if(document.referrer.match(ref))
		return;

	if(iP==null){
		iP = document.createElement("div");
		iP.innerHTML=html;
		iP.className="popup";
		PopupSub(w, h);

		halfhide();
		iP.style.display = "block";
	}
}

PopupClose = function(url) {
	document.body.removeChild(iP);
	iP=null;
	if(url == "") {
		clearhalfhide();
		setCookie(pck, 0, pck, pck);
	} else {
		window.location=url;
	}
}


function getCookie(key) {
	var tmp1, tmp2, xx1, xx2, xx3, array={};

	tmp1 = " " + document.cookie + ";";
	xx1 = xx2 = 0;
	len = tmp1.length;
	while (xx1 < len) {
		xx2  = tmp1.indexOf(";", xx1);
		tmp2 = tmp1.substring(xx1 + 1, xx2);
		xx3  = tmp2.indexOf("=");
		if (tmp2.substring(0, xx3) == key) {
			var str=tmp2.substring(xx3 + 1, xx2 - xx1 - 1);
			var cookie=str.split(",");
			for (var i = 0; i < cookie.length; i++) {
				var cook=cookie[i].split(":");
				array[cook[0]]=unescape(cook[1]);
			}
			return array;
		}
		xx1 = xx2 + 1;
	}
	return(array);
}

function setCookie() {
	var tmp=escape(arguments[0]) + "=",
		expire=arguments[1] < 1 ? arguments[1] : ex;

	for(var i=2; i < arguments.length; i = i + 2) {
		if(i != 1) {
			tmp += ",";
		}
		tmp += escape(arguments[i]) + ":" + escape(arguments[i + 1]);
	}
	tmp += ";" + "path=" + l.pathname;
	if(expire > 0)
		tmp += ";expires=" + getexpire(expire);

	document.cookie = tmp;
}

function clearCookie(key) {
	document.cookie = key + "=x;expires=Tue, 1-Jan-1980 00:00:00;";
}

function getexpire(expire) {
	var date = new Date();
	date.setTime(date.getTime() + expire);
	return date.toGMTString();
}



hF = function(e){
	var aa=document.getElementsByTagName('a'),
		tT=document.createElement('div'),
		sd=document.createElement('div');

	with(tT.style) {
		position='absolute';
		backgroundColor='ivory';
		border='1px solid #333';
		padding='1px 3px 1px 3px';
		font='500 11px arial';
		zIndex=10000;
		top="-100px";
	}
	with (sdocument.style) {
		position='absolute';
		MozOpacity=0.3;
		MozBorderRadius='3px';
		background='#000';
		zIndex=tT.style.zIndex - 1;
	}
	for(i=0,l=aa.length;i<l;i++){
		if(aa[i].getAttribute('title') != null || aa[i].getAttribute('alt') != null){
			aa[i].onmouseover=function(e){
				var _title=this.getAttribute('title')!=null ? this.getAttribute('title') : this.getAttribute('alt');
				this.setAttribute('title', '');
				_title=_title.replace(/[\r\n]+/g,'<br/>').replace(/\s/g,'&nbsp;');
				if(_title=='') return;
				tT.style.left=20+e.pageX+p;
				tT.style.top=10+e.pageY+p;
				tT.innerHTML=_title;
				with(sd.style){
					width=tT.offsetWidth-2+p;
					height=tT.offsetHeight-2+p;
					left=parseInt(tT.style.left)+5+p;
					top=parseInt(tT.style.top)+5+p;
				}
			}
			aa[i].onmouseout=function(){
				this.setAttribute('title', tT.innerHTML.replace(/<br\/>/g,'&#13;&#10;').replace(/&nbsp;/g,' '));
				tT.style.top='-1000px';
				sd.style.top='-1000px';
				tT.innerHTML='';
			}
		}
	}
	document.body.appendChild(sd);
	document.body.appendChild(tT);
}

hFi=function() {
	if(ur["GECKO"]) {
		try {
			hF(event);
		} catch (e) {}
	}
}





window.sprintf || (function() {
	var _BITS = {
		i: 0x8011, d: 0x8011, u: 0x8021, o: 0x8161, x: 0x8261,
		X: 0x9261, f: 0x92, c: 0x2800, s: 0x84
	};

	window.sprintf = _sprintf;

	function _sprintf(format) {
		function _fmt(m, argidx, flag, width, prec, size, types) {
			if (types === "%") {
				return "%";
			}
			var v = "", w = _BITS[types], overflow, pad;

			idx = argidx ? parseInt(argidx) : next++;

			w & 0x400 || (v = (av[idx] === void 0) ? "" : av[idx]);
			w & 3 && (v = (w & 1) ? parseInt(v) : parseFloat(v), v = isNaN(v) ? "": v);
			w & 4 && (v = ((types === "s" ? v : types) || "").toString());
			w & 0x20  && (v = (v >= 0) ? v : v % 0x100000000 + 0x100000000);
			w & 0x300 && (v = v.toString(w & 0x100 ? 8 : 16));
			w & 0x40  && (flag === "#") && (v = ((w & 0x100) ? "0" : "0x") + v);
			w & 0x80  && prec && (v = (w & 2) ? v.toFixed(prec) : v.slice(0, prec));
			w & 0x6000 && (overflow = (typeof v !== "number" || v < 0));
			w & 0x2000 && (v = overflow ? "" : String.fromCharCode(v));
			w & 0x8000 && (flag = (flag === "0") ? "" : flag);
			v = w & 0x1000 ? v.toString().toUpperCase() : v.toString();

			if (!(w & 0x800 || width === void 0 || v.length >= width)) {
				pad = Array(width - v.length + 1).join(!flag ? " " : flag === "#" ? " " : flag);
				v = ((w & 0x10 && flag === "0") && !v.indexOf("-"))
				? ("-" + pad + v.slice(1)) : (pad + v);
			}
			return v;
		}
		var next = 1, idx = 0, av = arguments;

		return format.replace(
			/%(?:(\d+)\$)?(#|0)?(\d+)?(?:\.(\d+))?(l)?([%iduoxXfcs])/g
			, _fmt);
	}
})();


function ar() {
	return new Array(arguments);
}






var Http = {};
Http.getTranspoter = function (){
	var imprements = [
		function() {return new XMLHttpRequest()},
		function() {return new ActiveXObject('Msxml2.XMLHTTP')},
		function() {return new ActiveXObject('Microsoft.XMLHTTP')}
	];
	var transporter;
	for (var i = 0; i < imprements.length; i++) {
		try {
			transporter = imprements[i]();
			break;
		} catch (e) { }
	}
	return transporter;
};

var Http = Http||{};
Http.Client = function(){ this.initialize.apply(this, arguments); };
Http.Client.prototype = {
	initialize : function( setting ){
		var defaults = {
			headers : {},
			method  : 'GET',
			url          : null,
			needXml: false,
			timeout  : 0
		};
		this.isAsync = null;

		for( var prop in defaults )
			this[prop] = setting[prop]||defaults[prop];

		return this;
	},

	call : function( requestBody ) {
		var req = this;
		var callback = arguments[1]||false;
		// autodetection Sync-mode
		this.isAsync = ( callback && typeof callback === 'function' );

		var xhr =  Http.getTranspoter();

		if (xhr) {

			xhr.onerror = function(){
				xhr.abort();
				if(callback)
					callback(xhr.status, xhr.responseText);
			}

			xhr.onreadystatechange = function() {
				if( req.isAsync && xhr.readyState == 4 && xhr.status == 20) {

					if( callback ) {
						callback(xhr.status,
							req.needXml ? xhr.responseXML : xhr.responseText );
					}

				}
			};

			//	2012-06-07 : timeout (\u52d5\u4f5c\u672a\u78ba\u8a8d\u3067\u3059\u304c)

			try {
				xhr.open( req.method, req.url, req.isAsync );

				xhr.setRequestHeader( "X-Requested-With", "XMLHttpRequest" );
				for(var key in req.headers ) {
					xhr.setRequestHeader(key, req.headers[key]);
				}

				xhr.send( requestBody );

				req.responseHeaders = xhr.getAllResponseHeaders();

				return req.isAsync
					? true
					: req.needXml
						? xhr.responseXML
						: xhr.responseText;
			} catch(e) {
				return null;
			}
		};
		//	throw new Error('not implement XmlHTTPRequest Object.');
		return false;
	}
};



Http.get = function( url, callback ){
	return new Http.Client( {
			method: 'GET',
			url:url
		} ).call( null, callback );
};

Http.post = function( url, requestbody, callback ){
	return new Http.Client( {
			method:'POST', url:url,
			headers: {
				'Content-Type':
					'application/x-www-form-urlencoded;'
			}
		} ).call( requestbody, callback );
};

Http.jsonRpc = function( url, requestbody, callback ) {
	var rslt = new Http.Client( {
			method:'POST', url:url,
			headers:{
				'content-type':'application/json'
			}
		} ).call( requestbody, callback );
	return ( typeof rslt !== 'boolean' )
		? JSON.parse( rslt )
		: rslt;
};





function gf(f, e, undefined) {
	for(var i=0; i < document.forms.length; i++) {
		if(document.forms[i].name == f) {
			for(var j=0; j < document.forms[i].elements.length; j++) {
				if(document.forms[i].elements[j].name == e) {
					return document.forms[i].elements[j];
				}
			}
		}
	}
	return undefined;
}


function defined(prop, undefined) {
	try{
		return eval(
		'typeof '
		 + prop) != undefined;
	} catch(e) {}
	return false;
}





String.prototype.replaceAll = function (org, dest) {
	return this.split(org).join(dest);
}





function debug(s) {
	try {
		if(defined("_db")) {
			_db(s);
		}
	} catch(e) {}
}


function eve(e) {
	return e || window.event;
}

var ev = {
	eve : ar(),
	event: null,

	add : function(n, f, p, t) {
		if(!ev.eve[n]) {
			ev.eve[n] = ar();
		}
		ev.eve[n][f]=f;
		ev.eve[n][f]["_p"]=p;
//		}
	},
	del : function(n, f) {
		if(ev.eve[n]) {
			if(ev.eve[n][f]) {
				delete ev.eve[n][f];
			}
		}
	},
	ex : function(n, event) {
		var ret;
		if(ev.eve[n]) {
			for(var f in ev.eve[n]) {
				var x=ev.eve[n][f];
				if(typeof x == "string") {
					eval("ret=" + x + "(event," + ev.eve[n][x] + ");");
				}
			}
		}
		return ret;
	}
}


window.onload = function(event) {
	return ev.ex("onload", event);
}

window.onkeypress = function(event) {
	return ev.ex("onkeypress", event);
}

window.onkeydown = function(event) {
	return ev.ex("onkeydown", event);
}

window.onkeyup = function(event) {
	return ev.ex("onkeyup", event);
}

window.onclick = function(event) {
	return ev.ex("onclick", event);
}

window.onbeforeunload = function(event) {
	return ev.ex("onbeforeunload", event);
}

window.oncontextmenu = function(event) {
	return ev.ex("oncontextmenu", event);
}

window.onreset = function(event) {
	return ev.ex("onreset", event);
}

ev.add("onload", "hFi", hFi);




if (!Array.prototype.forEach) {
	Array.prototype.forEach = function(fun ) {
		var len = this.length;
		if (typeof fun != "function")
			throw new TypeError();
			var thisp = arguments[1];
			for (var i = 0; i < len; i++) {
			if (i in this)
				fun.call(thisp, this[i], i, this);
		}
	};
}
