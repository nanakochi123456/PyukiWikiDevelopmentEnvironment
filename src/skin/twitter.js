/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */










var OAuth; if (OAuth == null) OAuth = {};

OAuth.setProperties = function setProperties(into, from) {
    if (into != null && from != null) {
        for (var key in from) {
            into[key] = from[key];
        }
    }
    return into;
}

OAuth.setProperties(OAuth, // utility functions
{
    percentEncode: function percentEncode(s) {
        if (s == null) {
            return "";
        }
        if (s instanceof Array) {
            var e = "";
            for (var i = 0; i < s.length; ++s) {
                if (e != "") e += '&';
                e += OAuth.percentEncode(s[i]);
            }
            return e;
        }
        s = encodeURIComponent(s);
        // Now replace the values which encodeURIComponent doesn't do
        // encodeURIComponent ignores: - _ . ! ~ * ' ( )
        // OAuth dictates the only ones you can ignore are: - _ . ~
        // Source: http://developer.mozilla.org/en/docs/Core_JavaScript_1.5_Reference:Global_Functions:encodeURIComponent
        s = s.replace(/\!/g, "%21");
        s = s.replace(/\*/g, "%2A");
        s = s.replace(/\'/g, "%27");
        s = s.replace(/\(/g, "%28");
        s = s.replace(/\)/g, "%29");
        return s;
    }
,
    decodePercent: function decodePercent(s) {
        if (s != null) {
            // Handle application/x-www-form-urlencoded, which is defined by
            // http://www.w3.org/TR/html4/interact/forms.html#h-17.13.4.1
            s = s.replace(/\+/g, " ");
        }
        return decodeURIComponent(s);
    }
,
    
    getParameterList: function getParameterList(parameters) {
        if (parameters == null) {
            return [];
        }
        if (typeof parameters != "object") {
            return OAuth.decodeForm(parameters + "");
        }
        if (parameters instanceof Array) {
            return parameters;
        }
        var list = [];
        for (var p in parameters) {
            list.push([p, parameters[p]]);
        }
        return list;
    }
,
    
    getParameterMap: function getParameterMap(parameters) {
        if (parameters == null) {
            return {};
        }
        if (typeof parameters != "object") {
            return OAuth.getParameterMap(OAuth.decodeForm(parameters + ""));
        }
        if (parameters instanceof Array) {
            var map = {};
            for (var p = 0; p < parameters.length; ++p) {
                var key = parameters[p][0];
                if (map[key] === undefined) { // first value wins
                    map[key] = parameters[p][1];
                }
            }
            return map;
        }
        return parameters;
    }
,
    getParameter: function getParameter(parameters, name) {
        if (parameters instanceof Array) {
            for (var p = 0; p < parameters.length; ++p) {
                if (parameters[p][0] == name) {
                    return parameters[p][1]; // first value wins
                }
            }
        } else {
            return OAuth.getParameterMap(parameters)[name];
        }
        return null;
    }
,
    formEncode: function formEncode(parameters) {
        var form = "";
        var list = OAuth.getParameterList(parameters);
        for (var p = 0; p < list.length; ++p) {
            var value = list[p][1];
            if (value == null) value = "";
            if (form != "") form += '&';
            form += OAuth.percentEncode(list[p][0])
              +'='+ OAuth.percentEncode(value);
        }
        return form;
    }
,
    decodeForm: function decodeForm(form) {
        var list = [];
        var nvps = form.split('&');
        for (var n = 0; n < nvps.length; ++n) {
            var nvp = nvps[n];
            if (nvp == "") {
                continue;
            }
            var equals = nvp.indexOf('=');
            var name;
            var value;
            if (equals < 0) {
                name = OAuth.decodePercent(nvp);
                value = null;
            } else {
                name = OAuth.decodePercent(nvp.substring(0, equals));
                value = OAuth.decodePercent(nvp.substring(equals + 1));
            }
            list.push([name, value]);
        }
        return list;
    }
,
    setParameter: function setParameter(message, name, value) {
        var parameters = message.parameters;
        if (parameters instanceof Array) {
            for (var p = 0; p < parameters.length; ++p) {
                if (parameters[p][0] == name) {
                    if (value === undefined) {
                        parameters.splice(p, 1);
                    } else {
                        parameters[p][1] = value;
                        value = undefined;
                    }
                }
            }
            if (value !== undefined) {
                parameters.push([name, value]);
            }
        } else {
            parameters = OAuth.getParameterMap(parameters);
            parameters[name] = value;
            message.parameters = parameters;
        }
    }
,
    setParameters: function setParameters(message, parameters) {
        var list = OAuth.getParameterList(parameters);
        for (var i = 0; i < list.length; ++i) {
            OAuth.setParameter(message, list[i][0], list[i][1]);
        }
    }
,
    
    completeRequest: function completeRequest(message, accessor) {
        if (message.method == null) {
            message.method = "GET";
        }
        var map = OAuth.getParameterMap(message.parameters);
        if (map.oauth_consumer_key == null) {
            OAuth.setParameter(message, "oauth_consumer_key", accessor.consumerKey || "");
        }
        if (map.oauth_token == null && accessor.token != null) {
            OAuth.setParameter(message, "oauth_token", accessor.token);
        }
        if (map.oauth_version == null) {
            OAuth.setParameter(message, "oauth_version", "1.0");
        }
        if (map.oauth_timestamp == null) {
            OAuth.setParameter(message, "oauth_timestamp", OAuth.timestamp());
        }
        if (map.oauth_nonce == null) {
            OAuth.setParameter(message, "oauth_nonce", OAuth.nonce(6));
        }
        OAuth.SignatureMethod.sign(message, accessor);
    }
,
    setTimestampAndNonce: function setTimestampAndNonce(message) {
        OAuth.setParameter(message, "oauth_timestamp", OAuth.timestamp());
        OAuth.setParameter(message, "oauth_nonce", OAuth.nonce(6));
    }
,
    addToURL: function addToURL(url, parameters) {
        newURL = url;
        if (parameters != null) {
            var toAdd = OAuth.formEncode(parameters);
            if (toAdd.length > 0) {
                var q = url.indexOf('?');
                if (q < 0) newURL += '?';
                else       newURL += '&';
                newURL += toAdd;
            }
        }
        return newURL;
    }
,
    
    getAuthorizationHeader: function getAuthorizationHeader(realm, parameters) {
        var header = 'OAuth realm="' + OAuth.percentEncode(realm) + '"';
        var list = OAuth.getParameterList(parameters);
        for (var p = 0; p < list.length; ++p) {
            var parameter = list[p];
            var name = parameter[0];
            if (name.indexOf("oauth_") == 0) {
                header += ',' + OAuth.percentEncode(name) + '="' + OAuth.percentEncode(parameter[1]) + '"';
            }
        }
        return header;
    }
,
    
    correctTimestampFromSrc: function correctTimestampFromSrc(parameterName) {
        parameterName = parameterName || "oauth_timestamp";
        var scripts = document.getElementsByTagName('script');
        if (scripts == null || !scripts.length) return;
        var src = scripts[scripts.length-1].src;
        if (!src) return;
        var q = src.indexOf("?");
        if (q < 0) return;
        parameters = OAuth.getParameterMap(OAuth.decodeForm(src.substring(q+1)));
        var t = parameters[parameterName];
        if (t == null) return;
        OAuth.correctTimestamp(t);
    }
,
    
    correctTimestamp: function correctTimestamp(timestamp) {
        OAuth.timeCorrectionMsec = (timestamp * 1000) - (new Date()).getTime();
    }
,
    
    timeCorrectionMsec: 0
,
    timestamp: function timestamp() {
        var t = (new Date()).getTime() + OAuth.timeCorrectionMsec;
        return ~~(t / 1000);
    }
,
    nonce: function nonce(length) {
        var chars = OAuth.nonce.CHARS;
        var result = "";
        for (var i = 0; i < length; ++i) {
            var rnum = ~~(Math.random() * chars.length);
            result += chars.substring(rnum, rnum+1);
        }
        return result;
    }
});

OAuth.nonce.CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";


OAuth.declareClass = function declareClass(parent, name, newConstructor) {
    var previous = parent[name];
    parent[name] = newConstructor;
    if (newConstructor != null && previous != null) {
        for (var key in previous) {
            if (key != "prototype") {
                newConstructor[key] = previous[key];
            }
        }
    }
    return newConstructor;
}


OAuth.declareClass(OAuth, "SignatureMethod", function OAuthSignatureMethod(){});

OAuth.setProperties(OAuth.SignatureMethod.prototype, // instance members
{
    
    sign: function sign(message) {
        var baseString = OAuth.SignatureMethod.getBaseString(message);
        var signature = this.getSignature(baseString);
        OAuth.setParameter(message, "oauth_signature", signature);
        return signature; // just in case someone's interested
    }
,
    
    initialize: function initialize(name, accessor) {
        var consumerSecret;
        if (accessor.accessorSecret != null
            && name.length > 9
            && name.substring(name.length-9) == "-Accessor")
        {
            consumerSecret = accessor.accessorSecret;
        } else {
            consumerSecret = accessor.consumerSecret;
        }
        this.key = OAuth.percentEncode(consumerSecret)
             +"&"+ OAuth.percentEncode(accessor.tokenSecret);
    }
});


OAuth.setProperties(OAuth.SignatureMethod, // class members
{
    sign: function sign(message, accessor) {
        var name = OAuth.getParameterMap(message.parameters).oauth_signature_method;
        if (name == null || name == "") {
            name = "HMAC-SHA1";
            OAuth.setParameter(message, "oauth_signature_method", name);
        }
        OAuth.SignatureMethod.newMethod(name, accessor).sign(message);
    }
,
    
    newMethod: function newMethod(name, accessor) {
        var impl = OAuth.SignatureMethod.REGISTERED[name];
        if (impl != null) {
            var method = new impl();
            method.initialize(name, accessor);
            return method;
        }
        var err = new Error("signature_method_rejected");
        var acceptable = "";
        for (var r in OAuth.SignatureMethod.REGISTERED) {
            if (acceptable != "") acceptable += '&';
            acceptable += OAuth.percentEncode(r);
        }
        err.oauth_acceptable_signature_methods = acceptable;
        throw err;
    }
,
    
    REGISTERED : {}
,
    
    registerMethodClass: function registerMethodClass(names, classConstructor) {
        for (var n = 0; n < names.length; ++n) {
            OAuth.SignatureMethod.REGISTERED[names[n]] = classConstructor;
        }
    }
,
    
    makeSubclass: function makeSubclass(getSignatureFunction) {
        var superClass = OAuth.SignatureMethod;
        var subClass = function() {
            superClass.call(this);
        };
        subClass.prototype = new superClass();
        // Delete instance variables from prototype:
        // delete subclass.prototype... There aren't any.
        subClass.prototype.getSignature = getSignatureFunction;
        subClass.prototype.constructor = subClass;
        return subClass;
    }
,
    getBaseString: function getBaseString(message) {
        var URL = message.action;
        var q = URL.indexOf('?');
        var parameters;
        if (q < 0) {
            parameters = message.parameters;
        } else {
            // Combine the URL query string with the other parameters:
            parameters = OAuth.decodeForm(URL.substring(q + 1));
            var toAdd = OAuth.getParameterList(message.parameters);
            for (var a = 0; a < toAdd.length; ++a) {
                parameters.push(toAdd[a]);
            }
        }
        return OAuth.percentEncode(message.method.toUpperCase())
         +'&'+ OAuth.percentEncode(OAuth.SignatureMethod.normalizeUrl(URL))
         +'&'+ OAuth.percentEncode(OAuth.SignatureMethod.normalizeParameters(parameters));
    }
,
    normalizeUrl: function normalizeUrl(url) {
        var uri = OAuth.SignatureMethod.parseUri(url);
        var scheme = uri.protocol.toLowerCase();
        var authority = uri.authority.toLowerCase();
        var dropPort = (scheme == "http" && uri.port == 80)
                    || (scheme == "https" && uri.port == 443);
        if (dropPort) {
            // find the last : in the authority
            var index = authority.lastIndexOf(":");
            if (index >= 0) {
                authority = authority.substring(0, index);
            }
        }
        var path = uri.path;
        if (!path) {
            path = "/"; // conforms to RFC 2616 section 3.2.2
        }
        // we know that there is no query and no fragment here.
        return scheme + "://" + authority + path;
    }
,
    parseUri: function parseUri (str) {
        
        var o = {key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
                 parser: {strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@\/]*):?([^:@\/]*))?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/ }};
        var m = o.parser.strict.exec(str);
        var uri = {};
        var i = 14;
        while (i--) uri[o.key[i]] = m[i] || "";
        return uri;
    }
,
    normalizeParameters: function normalizeParameters(parameters) {
        if (parameters == null) {
            return "";
        }
        var list = OAuth.getParameterList(parameters);
        var sortable = [];
        for (var p = 0; p < list.length; ++p) {
            var nvp = list[p];
            if (nvp[0] != "oauth_signature") {
                sortable.push([ OAuth.percentEncode(nvp[0])
                              + " " // because it comes before any character that can appear in a percentEncoded string.
                              + OAuth.percentEncode(nvp[1])
                              , nvp]);
            }
        }
        sortable.sort(function(a,b) {
                          if (a[0] < b[0]) return  -1;
                          if (a[0] > b[0]) return 1;
                          return 0;
                      });
        var sorted = [];
        for (var s = 0; s < sortable.length; ++s) {
            sorted.push(sortable[s][1]);
        }
        return OAuth.formEncode(sorted);
    }
});

OAuth.SignatureMethod.registerMethodClass(["PLAINTEXT", "PLAINTEXT-Accessor"],
    OAuth.SignatureMethod.makeSubclass(
        function getSignature(baseString) {
            return this.key;
        }
    ));

OAuth.SignatureMethod.registerMethodClass(["HMAC-SHA1", "HMAC-SHA1-Accessor"],
    OAuth.SignatureMethod.makeSubclass(
        function getSignature(baseString) {
            b64pad = '=';
            var signature = b64_hmac_sha1(this.key, baseString);
            return signature;
        }
    ));

try {
    OAuth.correctTimestampFromSrc();
} catch(e) {
}



var hexcase = 0;  
var b64pad  = ""; 
var chrsz   = 8;  


function hex_sha1(s){return binb2hex(core_sha1(str2binb(s),s.length * chrsz));}
function b64_sha1(s){return binb2b64(core_sha1(str2binb(s),s.length * chrsz));}
function str_sha1(s){return binb2str(core_sha1(str2binb(s),s.length * chrsz));}
function hex_hmac_sha1(key, data){ return binb2hex(core_hmac_sha1(key, data));}
function b64_hmac_sha1(key, data){ return binb2b64(core_hmac_sha1(key, data));}
function str_hmac_sha1(key, data){ return binb2str(core_hmac_sha1(key, data));}


function sha1_vm_test()
{
  return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
}


function core_sha1(x, len)
{
  
  x[len >> 5] |= 0x80 << (24 - len % 32);
  x[((len + 64 >> 9) << 4) + 15] = len;

  var w = Array(80);
  var a =  1732584193;
  var b = -271733879;
  var c = -1732584194;
  var d =  271733878;
  var e = -1009589776;

  for(var i = 0; i < x.length; i += 16)
  {
    var olda = a;
    var oldb = b;
    var oldc = c;
    var oldd = d;
    var olde = e;

    for(var j = 0; j < 80; j++)
    {
      if(j < 16) w[j] = x[i + j];
      else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
      var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)),
                       safe_add(safe_add(e, w[j]), sha1_kt(j)));
      e = d;
      d = c;
      c = rol(b, 30);
      b = a;
      a = t;
    }

    a = safe_add(a, olda);
    b = safe_add(b, oldb);
    c = safe_add(c, oldc);
    d = safe_add(d, oldd);
    e = safe_add(e, olde);
  }
  return Array(a, b, c, d, e);

}


function sha1_ft(t, b, c, d)
{
  if(t < 20) return (b & c) | ((~b) & d);
  if(t < 40) return b ^ c ^ d;
  if(t < 60) return (b & c) | (b & d) | (c & d);
  return b ^ c ^ d;
}


function sha1_kt(t)
{
  return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
         (t < 60) ? -1894007588 : -899497514;
}


function core_hmac_sha1(key, data)
{
  var bkey = str2binb(key);
  if(bkey.length > 16) bkey = core_sha1(bkey, key.length * chrsz);

  var ipad = Array(16), opad = Array(16);
  for(var i = 0; i < 16; i++)
  {
    ipad[i] = bkey[i] ^ 0x36363636;
    opad[i] = bkey[i] ^ 0x5C5C5C5C;
  }

  var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * chrsz);
  return core_sha1(opad.concat(hash), 512 + 160);
}


function safe_add(x, y)
{
  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
  return (msw << 16) | (lsw & 0xFFFF);
}


function rol(num, cnt)
{
  return (num << cnt) | (num >>> (32 - cnt));
}


function str2binb(str)
{
  var bin = Array();
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < str.length * chrsz; i += chrsz)
    bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (32 - chrsz - i%32);
  return bin;
}


function binb2str(bin)
{
  var str = "";
  var mask = (1 << chrsz) - 1;
  for(var i = 0; i < bin.length * 32; i += chrsz)
    str += String.fromCharCode((bin[i>>5] >>> (32 - chrsz - i%32)) & mask);
  return str;
}


function binb2hex(binarray)
{
  var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i++)
  {
    str += hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8+4)) & 0xF) +
           hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8  )) & 0xF);
  }
  return str;
}


function binb2b64(binarray)
{
  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  var str = "";
  for(var i = 0; i < binarray.length * 4; i += 3)
  {
    var triplet = (((binarray[i   >> 2] >> 8 * (3 -  i   %4)) & 0xFF) << 16)
                | (((binarray[i+1 >> 2] >> 8 * (3 - (i+1)%4)) & 0xFF) << 8 )
                |  ((binarray[i+2 >> 2] >> 8 * (3 - (i+2)%4)) & 0xFF);
    for(var j = 0; j < 4; j++)
    {
      if(i * 8 + j * 6 > binarray.length * 32) str += b64pad;
      else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
    }
  }
  return str;
}





function twitwindow(token, id, keyword, title, max, border_color, header_background, header_font_color, header_link_color, content_background_color, content_font_color, link_color, width, popup, track) {
	tw.twitwindow(token, id, keyword, title, max, border_color, header_background, header_font_color, header_link_color, content_background_color, content_font_color, link_color, width, popup, track);
}






var d=document,
	w=window,
	h="";


var	tw = {
	consumerKey: null,
	consumerSecret: null,
	accessToken: null,
	tokenSecret: null,
	cbid:0,
	subid:0,
	subarray:h,
	idarray:h,
	dtarray:h,
	urlarray:h,
	lc:0,
	counts:500,
	maxurl:40,
	d_text_color:"333",
	d_link_color:"307ace",
	d_back_color:"e1e1e1",
	n_font:13,
	n_color:"000",
	s_font:13,
	s_color:"555",
	i_font:11,
	i_color:"555",
	t_font:12,

	border_color: "434343",
	header_background: "434343",
	header_font_color:"fff",
	header_link_color:"fff",
	content_background_color: "e1e1e1",
	content_font_color: "333",
	link_color: "307ace",

	ch:"__C__",
	uh:"__UH__",
	target:0,
	track:0,
	url:h,
	http:"http://",
	https:"https://",
	tw:"twitter.com",
	api:"api.twitter.com",
	entities:"include_entities=true",
	am:"&amp;",
	flg:0,
	mode:h,
	
	cRE:/__C__([0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef]|[0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef])/gm,

	
	cb1 : function(data) {
		var obj=new Object();
		obj.method=tw.cbarray[1];
		obj.method(data, 1);
	},
	cb2 : function(data) {
		var obj=new Object();
		obj.method=tw.cbarray[2];
		obj.method(data, 2);
	},
	cb3 : function(data) {
		var obj=new Object();
		obj.method=tw.cbarray[3];
		obj.method(data, 3);
	},
	cb4 : function(data) {
		var obj=new Object();
		obj.method=tw.cbarray[4];
		obj.method(data, 4);
	},

	cb0 : function(data) {
		var obj=new Object();
		obj.method=tw.cbarray[0];
		obj.method(data, 0);
	},

	
	chk: function(c1, c2) {
		return (defined(c1) && c1 != "" ? c1 : c2);
	},

	
	twitwindow: function(token, id, keywordargs, title, max, border_color, header_background, header_font_color, header_link_color, content_background_color, content_font_color, link_color, width, popup, track) {
		var exttoken=token.split('|'),
			tokens=ae(exttoken[0], exttoken[1]);
			newtoken=tokens.split('|');

		tw.consumerKey=newtoken[0];
		tw.consumerSecret=newtoken[1];
		tw.accessToken=newtoken[2];
		tw.tokenSecret=newtoken[3];

		var keywords=keywordargs.split('|');
		if(popup == 1) tw.target=1;
		if(track == 1) tw.track=1;

		border_color = tw.chk(border_color, tw.border_color);
		header_background = tw.chk(header_background, tw.header_background);
		header_font_color = tw.chk(header_font_color, tw.header_font_color);
		header_link_color = tw.chk(header_link_color, tw.header_link_color);
		content_background_color = tw.chk(content_background_color, tw.content_background_color);
		content_font_color = tw.chk(content_font_color, tw.content_font_color);
		link_color = tw.chk(link_color, tw.link_color);

		
		if(keywords.length < 2) {
			tw.twa(token, id, keywords[0], title, max, border_color, header_background, header_font_color, header_link_color, content_background_color, content_font_color, link_color, width);
			tw.subid++;

		
		} else {
			var shtml=h, th=h,
				hhtml='<table width="' + width + '" style="background-color:' + tw.mkclr(content_background_color) + '; border:1px solid ' + tw.mkclr(border_color) + ';"><tr>';
			var firstid=tw.subid, ss=firstid;
			for (var i=0; i < keywords.length; i++) {
				if(!ss) {
					tw.subarray=ar();
				}
				tw.subarray[ss]="twsub_" + ss;
				if(i == 0) {
					shtml += '<span style="display: block;" id="' + tw.subarray[ss] + '"></span>';
				} else {
					shtml += '<span style="display: none;" id="' + tw.subarray[ss] + '"></span>';
				}
				ss++;
			}
			for(var i=firstid; i < ss; i++) {
				hhtml += '<th width="100%" style="background-color:' + tw.mkclr(header_background) + '; color:' + tw.mkclr(header_font_color) + ';">'
				  + '<a href="#" style="color: '+ tw.mkclr(header_link_color) + '" onclick="';

				for(var j=firstid; j < ss; j++) {
					hhtml += 'gid(\'' + tw.subarray[j] + '\').style.display=\'';
					if(i == j) {
						hhtml += 'block\';';
					} else {
						hhtml += 'none\';';
					}
				}
				hhtml += 'return false;">' + keywords[i - firstid] + '</a></th>';
			}

			shtml = shtml.replace(tw.cRE, '#$1');
			shtml = shtml.replace(tw.cRE, '#$1');
			shtml = shtml.replace(tw.cRE, '#$1');
			hhtml = hhtml.replace(tw.cRE, '#$1');
			hhtml = hhtml.replace(tw.cRE, '#$1');
			hhtml = hhtml.replace(tw.cRE, '#$1');
			sinss(token, id,
				hhtml
				+ '</tr><tr><td colspan="' + (ss - firstid) + '">'
				+ shtml
				+ '</td></tr></table>'
			);
			for (var i=firstid; i < ss; i++) {
				tw.twa(tw.subarray[i], keywords[i-firstid], "", max, border_color, header_background, header_font_color, header_link_color, content_background_color, content_font_color, link_color, width);
				tw.subid++;
			}
		}
	},

	
	twa: function(token, id, keyword, title, max, border_color, header_background, header_font_color, header_link_color, content_background_color, content_font_color, link_color, width) {
		if(!tw.cbid) {
			tw.idarray=ar();
			tw.cbarray=ar();
			tw.urlarray=ar();
		}
		if(tw.cbid > 5 && tw.cbid < 99) {
			alert(ln(
				"en","Can't place #twitter on this"
				,
					"ja","\u3053\u308c\u4ee5\u4e0a #twitter \u3092\u8a2d\u7f6e\u3067\u304d\u307e\u305b\u3093"
			));
			tw.cbid=99;
			return;
		}
		tw.idarray[tw.cbid]="tw_" + id;
		var html;
		html='<table width="' + width + '" style="background-color:' + tw.mkclr(content_background_color) + ';'
			+ (title == '' ? 'border:0px;' : 'border:1px solid ' + tw.mkclr(border_color) + ';')
			+ '">';
		if(title != "") {
			html += '<tr><th width="100%" style="background-color:' + tw.mkclr(header_background) + '; color:' + tw.mkclr(header_font_color) + ';">' + title + '</th></tr>';
		}
		html += '<tr><td width="100%" style="background-color:' + tw.mkclr(content_background_color) + '; color:' + tw.mkclr(content_font_color) + ';"><span id="' + tw.idarray[tw.cbid] + '"></span></td></tr>';
		+ '</table>';
		html = html.replace(tw.cRE, '#$1');
		tw.counts=max;

		if(keyword.match(/^@/)) {
			keyword=keyword.replace(/^@/, '');
			tw.getuser(keyword, tw.cbid);
		} else {
			tw.getsearch(keyword, tw.cbid);
		}
		sinss(id, html);
		tw.cbid++;
	},

	
	mksearchurl: function(str, callback, id) {
		var url=tw.http + "search." + tw.tw + "/search.json?" + tw.entities + tw.am + "rpp=" + tw.counts + tw.am + "q=" + encodeURIComponent(str);
		if(callback === void 0) {
			url = url + tw.am + "callback=?";
		} else {
			url = url + tw.am + "callback=" + callback;
		}
		return url;
	},

	
	getsearch: function(str, cbid) {
		tw.cbarray[cbid]=tw.getsearchhtml;
		tw.urlarray[cbid]=tw.mksearchurl(str, "tw.cb" + cbid);
		tw.dtarray[cbid]=tw.getjson(tw.urlarray[cbid], function(data, cbid) {
			tw.getsearchhtml(data, cbid);
		});
		tw.attach("search" + cbid);
	},

	
	getsearchhtml: function(data, cbid) {
		var a, html=h,
			p_text_color=tw.d_text_color,
			profile_link_color=tw.d_link_color,
			profile_sidebar_fill_color=tw.d_back_color,
			result=0;


		for(var i=0; i< tw.counts;i++) {
			try {
				a=data.results[i];
				var	text=a.text,
					user=a.from_user,
					user_name=a.from_user_name,
					image=a.profile_image_url,
					time=a.created_at,
					source=a.source,
					entities=a.entities;

				html += tw.twline(
					user, user_name, image, text,
					p_text_color,
					profile_link_color,
					profile_sidebar_fill_color,
					time,source,entities
				);
				result++;
			} catch (e) {}
		}
		if(!result)
			html=tw.nodata();

//		html = html.replace(tw.cRE, '#$1');
		sinss(tw.idarray[cbid], html);
	},

	
	mkuserurl: function(str, callback, id) {
//		var url=tw.https + tw.api + "/1.1/statuses/home_timeline.json?count=50";
		var url=tw.https + tw.api + "/1.1/statuses/user_timeline.json?count=50";
///1.1/statuses/user_timeline/" + str + ".json?" + tw.entities;
		if(callback === void 0) {
			url = url + tw.am + "callback=?";
		} else {
			url = url + tw.am + "callback=" + callback;
		}
		return url;
	},

	
	getuser: function(str, cbid) {
		tw.cbarray[cbid]=tw.getuserhtml;
 		tw.urlarray[cbid]=tw.mkuserurl(str, "tw.cb" + cbid);
		tw.dtarray[cbid]=tw.getjson(tw.urlarray[cbid], function(data, cbid) {
			tw.getuserhtml(data, cbid);
		});
		tw.attach("user" + cbid);
	},

	
	getuserhtml: function(data, cbid) {
		var html=h,
			p_text_color=h,
			profile_link_color=h,
			profile_sidebar_fill_color=h,
			result=0


		for(var i=0; i< tw.counts;i++) {
			try {
				var a=data[i];
				html=html + tw.twline(
					a.user.screen_name,
					a.user.name,
					a.user.profile_image_url,
					a.text,
					p_text_color ? p_text_color : data[i].user.p_text_color,
					profile_link_color ? profile_link_color : data[i].user.profile_link_color,
					profile_sidebar_fill_color ? profile_sidebar_fill_collor : data[i].user.profile_sidebar_fill_color,
					a.created_at,
					a.source,
					a.entities
				);
				result++;
			} catch (e) {}

		}
		if(!result)
			html=tw.nodata();

//		html = html.replace(tw.cRE, '#$1');
		sinss(tw.idarray[cbid], html);
	},

	
	nodata: function() {
		return ln(
			"en", "No recent tweet",
			"ja", "\u6700\u8fd1\u306e\u30c4\u30a3\u30fc\u30c8\u304c\u3042\u308a\u307e\u305b\u3093"
		);
	},

	
	attach: function(mode) {
		tw.mode=mode;
		if(w.attachEvent !== void 0)
			w.attachEvent('onload', tw.update);
		else if(d.addEventListener !== void 0)
			d.addEventListener("DOMContentLoaded", tw.update, false);
        else d.write(unescape('%3Cscript src="' + tw.update + '" type="text/javascript"%3E%3C/script%3E'));

	},

	
	update: function() {
		if(tw.subid > 2)
			return;

		setTimeout(tw.update, 1000*60);
		if(tw.flg == 0) {
			tw.flg=1;
		} else {
			var data=tw.getjson(tw.url, function(data) {
				var html;
				if(tw.mode == "user") {
				} else {
				}
			});
		}
	},

	
	getjson: function(url, data) {
		var tmp=url.split("?");
		var tmp2=tmp[1].replaceAll("&amp;", "&");
	    var accessor = {
	        consumerSecret: tw.consumerSecret,
	        tokenSecret: tw.tokenSecret
	    },	message = {
	        method: "GET",
	        action: tmp[0],
	        parameters: {
	            oauth_version: "1.0",
	            oauth_signature_method: "HMAC-SHA1",
	            oauth_consumer_key: tw.consumerKey,
	            oauth_token: tw.accessToken
	        }
	    }, content;
		var content=tmp2.split("&");

		for (var i=0; i < content.length; i++) {
			var onecontent=content[i].split("=");
			message.parameters[onecontent[0]] = onecontent[1];
		 }

		OAuth.setTimestampAndNonce(message);
		OAuth.SignatureMethod.sign(message, accessor);
		var target = OAuth.addToURL(message.action, message.parameters);
		target=target.replaceAll("&amp;", "&");



		var element = d.createElement("script");


		Http.get(target, tw.cc);
		element.src=target;
		element.id = "twitter_callback";
		d.body.appendChild(element);

	},

		
	twline: function(screen_name, name, image, text
		, text_color, link_color, sidebar_fill_color, time, source, entities) {
		var
			twitterUsernameRE= /@(\w+)/gm,
			twitterHashi18nRE= /(\#|\$)([^\s]+)/gm,
			urlRE= /((((ht|f){1}(tp:[/][/]){1})|((www.){1}))[-a-zA-Z0-9@:;%_\+.~#?\&\/\/=]+)/gm;

		tw.lc=link_color;

		for(var i=0; entities.urls[i] !== void 0 && i < tw.counts; i++) {
			text=text.split(entities.urls[i].url).join(entities.urls[i].expanded_url);

		}
		text = text.replace(
			urlRE, function(t) {
				return tw.replaceUrl(t);
			}
		);

		text= text.replace(
			twitterUsernameRE,
				tw.mklink(tw.http + tw.tw + "/$1","@$1","@$1")
		);

		text= text.replace(
			twitterHashi18nRE, function(t) {
				return tw.mkhash(t);
			}
		);

		text = tw.replaceAll(text, tw.uh, '#');

		var html="<div style='background-color:" + tw.mkclr(sidebar_fill_color) + "';>" +
			"<table><tr><td valign='top' style='background-color:" + tw.mkclr(sidebar_fill_color) + "';>" +
			tw.mklink(tw.http + tw.tw + "/" + screen_name, name) +
			"<img border='0' src=\'" +
			image +
			"\' /></a>" +
			"</td><td valign='top' width='100%' style='background-color:" + tw.mkclr(sidebar_fill_color) + "';>" +
			"<strong style='font-size:" + tw.n_font + "px; color:" + tw.mkclr(tw.n_color) + ";'>" +
			tw.mklink(tw.http + tw.tw + "/" + screen_name, name, name) +
			"</a></strong>" +
			"<span style='font-size:" + tw.s_font + "px; color:" + tw.mkclr(tw.s_color) + "'>" +
			"&nbsp;" + 
			tw.mklink(tw.http + tw.tw + "/" + screen_name, "@" + screen_name, "@" + screen_name) +
			"</a>" +
			"&nbsp;</span>" +
			"<span style='position:relative; right:0px; font-size:" + tw.i_font + "px; color:" + tw.mkclr(tw.i_color) + "'>(" +
			tw.timeformat(time) +
			")</span><br />" +
			"<span style='font-size:" + tw.t_font + "px; color:" + tw.mkclr(text_color) +"'>" +
			text +
			"</td></tr></table></div>";

		html = html.replace(tw.cRE, '#$1');
		return html;
	},

	replaceAll: function(s, o, n) {
		return s.split(o).join(n);
	},

	
	mkhash: function(keyword) {
		return tw.mklink(
			tw.http + tw.tw + "/search/"
			 + encodeURIComponent(keyword) , keyword, keyword)
	},

	
	replaceUrl:function(t) {
		var t=tw.replaceAll(t, '#', tw.uh);
		return tw.mklink(t, t, ((t.length > tw.maxurl) ? (t.substring(0, tw.maxurl - 4) + '&hellip;') : t));
	},

	
	mklink: function(url, title, title2) {
		var c;




		if(tw.track == 1) {
			if(tw.target == 1) {
				c="<a class=\"tlink\" href=\"" + url + "\" onclick=\"return Ck(this,this.href,\'b\');\" oncontextmenu=\"return Ck(this,this.href,'r');\" title=\"" + title + "\" style=\"text-decoration:none;color:" + tw.mkclr(tw.lc) + "\";>";
			} else {
				c="<a class=\"tlink\" href=\"" + url + "\" oncontextmenu=\"return Ck(this,this.href,'r');\" title=\"" + title + "\" style=\"text-decoration:none;color:" + tw.mkclr(tw.lc) + "\";>";
			}
		} else {
			if(tw.target == 1) {
				c="<a class=\"tlink\" href=\"" + url + "\" onclick=\"return window.open(this.href,\'_blank\');return false;\" title=\"" + title + "\" style=\"text-decoration:none;color:" + tw.mkclr(tw.lc) + "\";>";
			} else {


				c="<a class=\"tlink\" href=\"" + url + "\" title=\"" + title + "\" style=\"text-decoration:none;color:" + tw.mkclr(tw.lc) + "\";>";


			}
		}



		if(title2) {
			return c + title2 + "</a>";
		}
		return c;
	},

	
	mkclr: function(t, u) {
		if(t == u) return "transport";
		t = t.replace(/#/, '');
		t = t.toLowerCase()

		if(t.match(/^[0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef]/)) {
	 		return tw.ch + t;
		}

		if(t.match(/^[0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef][0123456789ABCDEFabcdef]$/)) {
			return tw.ch + t;
		}
		return t;
	},

	
	timeformat: function(t) {
		if(t.match(',')) {
			t=new Date(t);

		} else {
			t=t.replace(/(\d\d:\d\d:\d\d)\s\+0000\s(\d\d\d\d)$/,"$2 $1 +0000");
			t=new Date(t);
		}
		return		("000" + t.getFullYear()).slice(-4)
			+ '/' + ("0" + (t.getMonth() + 1)).slice(-2)
			+ '/' + ("0" + t.getDate()).slice(-2)
			+ ' ' + ("0" + t.getHours()).slice(-2)
			+ ':' + ("0" + t.getMinutes()).slice(-2)
			+ '  ' +niceTime(t);

	}
}



var niceTime = (function() {
	var ints = {
		second: 1,
		minute: 60,
		hour: 3600,
		day: 86400,
		week: 604800,
		month: 2592000,
		year: 31536000
	};

	var ints_ja = {
		second: "\u79d2",
		minute: "\u5206",
		hour: "\u6642\u9593",
		day: "\u65e5",
		week: "\u9031\u9593",
		month: "\u30f6\u6708",
		year: "\u5e74"
	};

	return function(time) {
		time = +new Date(time);

		var gap = ((+new Date()) - time) / 1000,
			amount, measure;

		for (var i in ints) {
			if (gap > ints[i]) { measure = i; }
		}

		amount = gap / ints[measure];
		amount = Math.round(amount);
		measure = ln("en", measure, "ja", ints_ja[measure]);
		amount += ln(
			"en", ' ' + measure + (amount > 1 ? 's' : '') + ' ago',
			"ja", measure + "\u7d4c\u904e");

		return amount;
	};
})();
