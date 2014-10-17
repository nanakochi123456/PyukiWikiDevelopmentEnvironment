/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */





var swfobject = function() {
	
	var UNDEF = "undefined",
		OBJECT = "object",
		SHOCKWAVE_FLASH = "Shockwave Flash",
		SHOCKWAVE_FLASH_AX = "ShockwaveFlash.ShockwaveFlash",
		FLASH_MIME_TYPE = "application/x-shockwave-flash",
		EXPRESS_INSTALL_ID = "SWFObjectExprInst",
		ON_READY_STATE_CHANGE = "onreadystatechange",
		
		win = window,
		doc = document,
		nav = navigator,
		
		plugin = false,
		domLoadFnArr = [main],
		regObjArr = [],
		objIdArr = [],
		listenersArr = [],
		storedAltContent,
		storedAltContentId,
		storedCallbackFn,
		storedCallbackObj,
		isDomLoaded = false,
		isExpressInstallActive = false,
		dynamicStylesheet,
		dynamicStylesheetMedia,
		autoHideShow = true,
	
		
	ua = function() {
		var w3cdom = typeof doc.getElementById != UNDEF && typeof doc.getElementsByTagName != UNDEF && typeof doc.createElement != UNDEF,
			u = nav.userAgent.toLowerCase(),
			p = nav.platform.toLowerCase(),
			windows = p ? /win/.test(p) : /win/.test(u),
			mac = p ? /mac/.test(p) : /mac/.test(u),
			webkit = /webkit/.test(u) ? parseFloat(u.replace(/^.*webkit\/(\d+(\.\d+)?).*$/, "$1")) : false, // returns either the webkit version or false if not webkit
			ie = !+"\v1", // feature detection based on Andrea Giammarchi's solution: http://webreflection.blogspot.com/2009/01/32-bytes-to-know-if-your-browser-is-ie.html
			playerVersion = [0,0,0],
			d = null;
		if (typeof nav.plugins != UNDEF && typeof nav.plugins[SHOCKWAVE_FLASH] == OBJECT) {
			d = nav.plugins[SHOCKWAVE_FLASH].description;
			if (d && !(typeof nav.mimeTypes != UNDEF && nav.mimeTypes[FLASH_MIME_TYPE] && !nav.mimeTypes[FLASH_MIME_TYPE].enabledPlugin)) { // navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin indicates whether plug-ins are enabled or disabled in Safari 3+
				plugin = true;
				ie = false; // cascaded feature detection for Internet Explorer
				d = d.replace(/^.*\s+(\S+\s+\S+$)/, "$1");
				playerVersion[0] = parseInt(d.replace(/^(.*)\..*$/, "$1"), 10);
				playerVersion[1] = parseInt(d.replace(/^.*\.(.*)\s.*$/, "$1"), 10);
				playerVersion[2] = /[a-zA-Z]/.test(d) ? parseInt(d.replace(/^.*[a-zA-Z]+(.*)$/, "$1"), 10) : 0;
			}
		}
		else if (typeof win.ActiveXObject != UNDEF) {
			try {
				var a = new ActiveXObject(SHOCKWAVE_FLASH_AX);
				if (a) { // a will return null when ActiveX is disabled
					d = a.GetVariable("$version");
					if (d) {
						ie = true; // cascaded feature detection for Internet Explorer
						d = d.split(" ")[1].split(",");
						playerVersion = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
					}
				}
			}
			catch(e) {}
		}
		return { w3:w3cdom, pv:playerVersion, wk:webkit, ie:ie, win:windows, mac:mac };
	}(),
	
	 
	onDomLoad = function() {
		if (!ua.w3) { return; }
		if ((typeof doc.readyState != UNDEF && doc.readyState == "complete") || (typeof doc.readyState == UNDEF && (doc.getElementsByTagName("body")[0] || doc.body))) { // function is fired after onload, e.g. when script is inserted dynamically 
			callDomLoadFunctions();
		}
		if (!isDomLoaded) {
			if (typeof doc.addEventListener != UNDEF) {
				doc.addEventListener("DOMContentLoaded", callDomLoadFunctions, false);
			}		
			if (ua.ie && ua.win) {
				doc.attachEvent(ON_READY_STATE_CHANGE, function() {
					if (doc.readyState == "complete") {
						doc.detachEvent(ON_READY_STATE_CHANGE, arguments.callee);
						callDomLoadFunctions();
					}
				});
				if (win == top) { // if not inside an iframe
					(function(){
						if (isDomLoaded) { return; }
						try {
							doc.documentElement.doScroll("left");
						}
						catch(e) {
							setTimeout(arguments.callee, 0);
							return;
						}
						callDomLoadFunctions();
					})();
				}
			}
			if (ua.wk) {
				(function(){
					if (isDomLoaded) { return; }
					if (!/loaded|complete/.test(doc.readyState)) {
						setTimeout(arguments.callee, 0);
						return;
					}
					callDomLoadFunctions();
				})();
			}
			addLoadEvent(callDomLoadFunctions);
		}
	}();
	
	function callDomLoadFunctions() {
		if (isDomLoaded) { return; }
		try { // test if we can really add/remove elements to/from the DOM; we don't want to fire it too early
			var t = doc.getElementsByTagName("body")[0].appendChild(createElement("span"));
			t.parentNode.removeChild(t);
		}
		catch (e) { return; }
		isDomLoaded = true;
		var dl = domLoadFnArr.length;
		for (var i = 0; i < dl; i++) {
			domLoadFnArr[i]();
		}
	}
	
	function addDomLoadEvent(fn) {
		if (isDomLoaded) {
			fn();
		}
		else { 
			domLoadFnArr[domLoadFnArr.length] = fn; // Array.push() is only available in IE5.5+
		}
	}
	
	
	function addLoadEvent(fn) {
		if (typeof win.addEventListener != UNDEF) {
			win.addEventListener("load", fn, false);
		}
		else if (typeof doc.addEventListener != UNDEF) {
			doc.addEventListener("load", fn, false);
		}
		else if (typeof win.attachEvent != UNDEF) {
			addListener(win, "onload", fn);
		}
		else if (typeof win.onload == "function") {
			var fnOld = win.onload;
			win.onload = function() {
				fnOld();
				fn();
			};
		}
		else {
			win.onload = fn;
		}
	}
	
	
	function main() { 
		if (plugin) {
			testPlayerVersion();
		}
		else {
			matchVersions();
		}
	}
	
	
	function testPlayerVersion() {
		var b = doc.getElementsByTagName("body")[0];
		var o = createElement(OBJECT);
		o.setAttribute("type", FLASH_MIME_TYPE);
		var t = b.appendChild(o);
		if (t) {
			var counter = 0;
			(function(){
				if (typeof t.GetVariable != UNDEF) {
					var d = t.GetVariable("$version");
					if (d) {
						d = d.split(" ")[1].split(",");
						ua.pv = [parseInt(d[0], 10), parseInt(d[1], 10), parseInt(d[2], 10)];
					}
				}
				else if (counter < 10) {
					counter++;
					setTimeout(arguments.callee, 10);
					return;
				}
				b.removeChild(o);
				t = null;
				matchVersions();
			})();
		}
		else {
			matchVersions();
		}
	}
	
	
	function matchVersions() {
		var rl = regObjArr.length;
		if (rl > 0) {
			for (var i = 0; i < rl; i++) { // for each registered object element
				var id = regObjArr[i].id;
				var cb = regObjArr[i].callbackFn;
				var cbObj = {success:false, id:id};
				if (ua.pv[0] > 0) {
					var obj = getElementById(id);
					if (obj) {
						if (hasPlayerVersion(regObjArr[i].swfVersion) && !(ua.wk && ua.wk < 312)) { // Flash Player version >= published SWF version: Houston, we have a match!
							setVisibility(id, true);
							if (cb) {
								cbObj.success = true;
								cbObj.ref = getObjectById(id);
								cb(cbObj);
							}
						}
						else if (regObjArr[i].expressInstall && canExpressInstall()) { // show the Adobe Express Install dialog if set by the web page author and if supported
							var att = {};
							att.data = regObjArr[i].expressInstall;
							att.width = obj.getAttribute("width") || "0";
							att.height = obj.getAttribute("height") || "0";
							if (obj.getAttribute("class")) { att.styleclass = obj.getAttribute("class"); }
							if (obj.getAttribute("align")) { att.align = obj.getAttribute("align"); }
							// parse HTML object param element's name-value pairs
							var par = {};
							var p = obj.getElementsByTagName("param");
							var pl = p.length;
							for (var j = 0; j < pl; j++) {
								if (p[j].getAttribute("name").toLowerCase() != "movie") {
									par[p[j].getAttribute("name")] = p[j].getAttribute("value");
								}
							}
							showExpressInstall(att, par, id, cb);
						}
						else { // Flash Player and SWF version mismatch or an older Webkit engine that ignores the HTML object element's nested param elements: display alternative content instead of SWF
							displayAltContent(obj);
							if (cb) { cb(cbObj); }
						}
					}
				}
				else {	// if no Flash Player is installed or the fp version cannot be detected we let the HTML object element do its job (either show a SWF or alternative content)
					setVisibility(id, true);
					if (cb) {
						var o = getObjectById(id); // test whether there is an HTML object element or not
						if (o && typeof o.SetVariable != UNDEF) { 
							cbObj.success = true;
							cbObj.ref = o;
						}
						cb(cbObj);
					}
				}
			}
		}
	}
	
	function getObjectById(objectIdStr) {
		var r = null;
		var o = getElementById(objectIdStr);
		if (o && o.nodeName == "OBJECT") {
			if (typeof o.SetVariable != UNDEF) {
				r = o;
			}
			else {
				var n = o.getElementsByTagName(OBJECT)[0];
				if (n) {
					r = n;
				}
			}
		}
		return r;
	}
	
	
	function canExpressInstall() {
		return !isExpressInstallActive && hasPlayerVersion("6.0.65") && (ua.win || ua.mac) && !(ua.wk && ua.wk < 312);
	}
	
	
	function showExpressInstall(att, par, replaceElemIdStr, callbackFn) {
		isExpressInstallActive = true;
		storedCallbackFn = callbackFn || null;
		storedCallbackObj = {success:false, id:replaceElemIdStr};
		var obj = getElementById(replaceElemIdStr);
		if (obj) {
			if (obj.nodeName == "OBJECT") { // static publishing
				storedAltContent = abstractAltContent(obj);
				storedAltContentId = null;
			}
			else { // dynamic publishing
				storedAltContent = obj;
				storedAltContentId = replaceElemIdStr;
			}
			att.id = EXPRESS_INSTALL_ID;
			if (typeof att.width == UNDEF || (!/%$/.test(att.width) && parseInt(att.width, 10) < 310)) { att.width = "310"; }
			if (typeof att.height == UNDEF || (!/%$/.test(att.height) && parseInt(att.height, 10) < 137)) { att.height = "137"; }
			doc.title = doc.title.slice(0, 47) + " - Flash Player Installation";
			var pt = ua.ie && ua.win ? "ActiveX" : "PlugIn",
				fv = "MMredirectURL=" + win.location.toString().replace(/&/g,"%26") + "&MMplayerType=" + pt + "&MMdoctitle=" + doc.title;
			if (typeof par.flashvars != UNDEF) {
				par.flashvars += "&" + fv;
			}
			else {
				par.flashvars = fv;
			}
			// IE only: when a SWF is loading (AND: not available in cache) wait for the readyState of the object element to become 4 before removing it,
			// because you cannot properly cancel a loading SWF file without breaking browser load references, also obj.onreadystatechange doesn't work
			if (ua.ie && ua.win && obj.readyState != 4) {
				var newObj = createElement("div");
				replaceElemIdStr += "SWFObjectNew";
				newObj.setAttribute("id", replaceElemIdStr);
				obj.parentNode.insertBefore(newObj, obj); // insert placeholder div that will be replaced by the object element that loads expressinstall.swf
				obj.style.display = "none";
				(function(){
					if (obj.readyState == 4) {
						obj.parentNode.removeChild(obj);
					}
					else {
						setTimeout(arguments.callee, 10);
					}
				})();
			}
			createSWF(att, par, replaceElemIdStr);
		}
	}
	
	
	function displayAltContent(obj) {
		if (ua.ie && ua.win && obj.readyState != 4) {
			// IE only: when a SWF is loading (AND: not available in cache) wait for the readyState of the object element to become 4 before removing it,
			// because you cannot properly cancel a loading SWF file without breaking browser load references, also obj.onreadystatechange doesn't work
			var el = createElement("div");
			obj.parentNode.insertBefore(el, obj); // insert placeholder div that will be replaced by the alternative content
			el.parentNode.replaceChild(abstractAltContent(obj), el);
			obj.style.display = "none";
			(function(){
				if (obj.readyState == 4) {
					obj.parentNode.removeChild(obj);
				}
				else {
					setTimeout(arguments.callee, 10);
				}
			})();
		}
		else {
			obj.parentNode.replaceChild(abstractAltContent(obj), obj);
		}
	} 

	function abstractAltContent(obj) {
		var ac = createElement("div");
		if (ua.win && ua.ie) {
			ac.innerHTML = obj.innerHTML;
		}
		else {
			var nestedObj = obj.getElementsByTagName(OBJECT)[0];
			if (nestedObj) {
				var c = nestedObj.childNodes;
				if (c) {
					var cl = c.length;
					for (var i = 0; i < cl; i++) {
						if (!(c[i].nodeType == 1 && c[i].nodeName == "PARAM") && !(c[i].nodeType == 8)) {
							ac.appendChild(c[i].cloneNode(true));
						}
					}
				}
			}
		}
		return ac;
	}
	
	
	function createSWF(attObj, parObj, id) {
		var r, el = getElementById(id);
		if (ua.wk && ua.wk < 312) { return r; }
		if (el) {
			if (typeof attObj.id == UNDEF) { // if no 'id' is defined for the object element, it will inherit the 'id' from the alternative content
				attObj.id = id;
			}
			if (ua.ie && ua.win) { // Internet Explorer + the HTML object element + W3C DOM methods do not combine: fall back to outerHTML
				var att = "";
				for (var i in attObj) {
					if (attObj[i] != Object.prototype[i]) { // filter out prototype additions from other potential libraries
						if (i.toLowerCase() == "data") {
							parObj.movie = attObj[i];
						}
						else if (i.toLowerCase() == "styleclass") { // 'class' is an ECMA4 reserved keyword
							att += ' class="' + attObj[i] + '"';
						}
						else if (i.toLowerCase() != "classid") {
							att += ' ' + i + '="' + attObj[i] + '"';
						}
					}
				}
				var par = "";
				for (var j in parObj) {
					if (parObj[j] != Object.prototype[j]) { // filter out prototype additions from other potential libraries
						par += '<param name="' + j + '" value="' + parObj[j] + '" />';
					}
				}
				el.outerHTML = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"' + att + '>' + par + '</object>';
				objIdArr[objIdArr.length] = attObj.id; // stored to fix object 'leaks' on unload (dynamic publishing only)
				r = getElementById(attObj.id);	
			}
			else { // well-behaving browsers
				var o = createElement(OBJECT);
				o.setAttribute("type", FLASH_MIME_TYPE);
				for (var m in attObj) {
					if (attObj[m] != Object.prototype[m]) { // filter out prototype additions from other potential libraries
						if (m.toLowerCase() == "styleclass") { // 'class' is an ECMA4 reserved keyword
							o.setAttribute("class", attObj[m]);
						}
						else if (m.toLowerCase() != "classid") { // filter out IE specific attribute
							o.setAttribute(m, attObj[m]);
						}
					}
				}
				for (var n in parObj) {
					if (parObj[n] != Object.prototype[n] && n.toLowerCase() != "movie") { // filter out prototype additions from other potential libraries and IE specific param element
						createObjParam(o, n, parObj[n]);
					}
				}
				el.parentNode.replaceChild(o, el);
				r = o;
			}
		}
		return r;
	}
	
	function createObjParam(el, pName, pValue) {
		var p = createElement("param");
		p.setAttribute("name", pName);	
		p.setAttribute("value", pValue);
		el.appendChild(p);
	}
	
	
	function removeSWF(id) {
		var obj = getElementById(id);
		if (obj && obj.nodeName == "OBJECT") {
			if (ua.ie && ua.win) {
				obj.style.display = "none";
				(function(){
					if (obj.readyState == 4) {
						removeObjectInIE(id);
					}
					else {
						setTimeout(arguments.callee, 10);
					}
				})();
			}
			else {
				obj.parentNode.removeChild(obj);
			}
		}
	}
	
	function removeObjectInIE(id) {
		var obj = getElementById(id);
		if (obj) {
			for (var i in obj) {
				if (typeof obj[i] == "function") {
					obj[i] = null;
				}
			}
			obj.parentNode.removeChild(obj);
		}
	}
	
	
	function getElementById(id) {
		var el = null;
		try {
			el = doc.getElementById(id);
		}
		catch (e) {}
		return el;
	}
	
	function createElement(el) {
		return doc.createElement(el);
	}
	
		
	function addListener(target, eventType, fn) {
		target.attachEvent(eventType, fn);
		listenersArr[listenersArr.length] = [target, eventType, fn];
	}
	
	
	function hasPlayerVersion(rv) {
		var pv = ua.pv, v = rv.split(".");
		v[0] = parseInt(v[0], 10);
		v[1] = parseInt(v[1], 10) || 0; // supports short notation, e.g. "9" instead of "9.0.0"
		v[2] = parseInt(v[2], 10) || 0;
		return (pv[0] > v[0] || (pv[0] == v[0] && pv[1] > v[1]) || (pv[0] == v[0] && pv[1] == v[1] && pv[2] >= v[2])) ? true : false;
	}
	
		
	function createCSS(sel, decl, media, newStyle) {
		if (ua.ie && ua.mac) { return; }
		var h = doc.getElementsByTagName("head")[0];
		if (!h) { return; } // to also support badly authored HTML pages that lack a head element
		var m = (media && typeof media == "string") ? media : "screen";
		if (newStyle) {
			dynamicStylesheet = null;
			dynamicStylesheetMedia = null;
		}
		if (!dynamicStylesheet || dynamicStylesheetMedia != m) { 
			// create dynamic stylesheet + get a global reference to it
			var s = createElement("style");
			s.setAttribute("type", "text/css");
			s.setAttribute("media", m);
			dynamicStylesheet = h.appendChild(s);
			if (ua.ie && ua.win && typeof doc.styleSheets != UNDEF && doc.styleSheets.length > 0) {
				dynamicStylesheet = doc.styleSheets[doc.styleSheets.length - 1];
			}
			dynamicStylesheetMedia = m;
		}
		// add style rule
		if (ua.ie && ua.win) {
			if (dynamicStylesheet && typeof dynamicStylesheet.addRule == OBJECT) {
				dynamicStylesheet.addRule(sel, decl);
			}
		}
		else {
			if (dynamicStylesheet && typeof doc.createTextNode != UNDEF) {
				dynamicStylesheet.appendChild(doc.createTextNode(sel + " {" + decl + "}"));
			}
		}
	}
	
	function setVisibility(id, isVisible) {
		if (!autoHideShow) { return; }
		var v = isVisible ? "visible" : "hidden";
		if (isDomLoaded && getElementById(id)) {
			getElementById(id).style.visibility = v;
		}
		else {
			createCSS("#" + id, "visibility:" + v);
		}
	}

	
	function urlEncodeIfNecessary(s) {
		var regex = /[\\\"<>\.;]/;
		var hasBadChars = regex.exec(s) != null;
		return hasBadChars && typeof encodeURIComponent != UNDEF ? encodeURIComponent(s) : s;
	}
	
	
	var cleanup = function() {
		if (ua.ie && ua.win) {
			window.attachEvent("onunload", function() {
				// remove listeners to avoid memory leaks
				var ll = listenersArr.length;
				for (var i = 0; i < ll; i++) {
					listenersArr[i][0].detachEvent(listenersArr[i][1], listenersArr[i][2]);
				}
				// cleanup dynamically embedded objects to fix audio/video threads and force open sockets and NetConnections to disconnect
				var il = objIdArr.length;
				for (var j = 0; j < il; j++) {
					removeSWF(objIdArr[j]);
				}
				// cleanup library's main closures to avoid memory leaks
				for (var k in ua) {
					ua[k] = null;
				}
				ua = null;
				for (var l in swfobject) {
					swfobject[l] = null;
				}
				swfobject = null;
			});
		}
	}();
	
	return {
		 
		registerObject: function(objectIdStr, swfVersionStr, xiSwfUrlStr, callbackFn) {
			if (ua.w3 && objectIdStr && swfVersionStr) {
				var regObj = {};
				regObj.id = objectIdStr;
				regObj.swfVersion = swfVersionStr;
				regObj.expressInstall = xiSwfUrlStr;
				regObj.callbackFn = callbackFn;
				regObjArr[regObjArr.length] = regObj;
				setVisibility(objectIdStr, false);
			}
			else if (callbackFn) {
				callbackFn({success:false, id:objectIdStr});
			}
		},
		
		getObjectById: function(objectIdStr) {
			if (ua.w3) {
				return getObjectById(objectIdStr);
			}
		},
		
		embedSWF: function(swfUrlStr, replaceElemIdStr, widthStr, heightStr, swfVersionStr, xiSwfUrlStr, flashvarsObj, parObj, attObj, callbackFn) {
			var callbackObj = {success:false, id:replaceElemIdStr};
			if (ua.w3 && !(ua.wk && ua.wk < 312) && swfUrlStr && replaceElemIdStr && widthStr && heightStr && swfVersionStr) {
				setVisibility(replaceElemIdStr, false);
				addDomLoadEvent(function() {
					widthStr += ""; // auto-convert to string
					heightStr += "";
					var att = {};
					if (attObj && typeof attObj === OBJECT) {
						for (var i in attObj) { // copy object to avoid the use of references, because web authors often reuse attObj for multiple SWFs
							att[i] = attObj[i];
						}
					}
					att.data = swfUrlStr;
					att.width = widthStr;
					att.height = heightStr;
					var par = {}; 
					if (parObj && typeof parObj === OBJECT) {
						for (var j in parObj) { // copy object to avoid the use of references, because web authors often reuse parObj for multiple SWFs
							par[j] = parObj[j];
						}
					}
					if (flashvarsObj && typeof flashvarsObj === OBJECT) {
						for (var k in flashvarsObj) { // copy object to avoid the use of references, because web authors often reuse flashvarsObj for multiple SWFs
							if (typeof par.flashvars != UNDEF) {
								par.flashvars += "&" + k + "=" + flashvarsObj[k];
							}
							else {
								par.flashvars = k + "=" + flashvarsObj[k];
							}
						}
					}
					if (hasPlayerVersion(swfVersionStr)) { // create SWF
						var obj = createSWF(att, par, replaceElemIdStr);
						if (att.id == replaceElemIdStr) {
							setVisibility(replaceElemIdStr, true);
						}
						callbackObj.success = true;
						callbackObj.ref = obj;
					}
					else if (xiSwfUrlStr && canExpressInstall()) { // show Adobe Express Install
						att.data = xiSwfUrlStr;
						showExpressInstall(att, par, replaceElemIdStr, callbackFn);
						return;
					}
					else { // show alternative content
						setVisibility(replaceElemIdStr, true);
					}
					if (callbackFn) { callbackFn(callbackObj); }
				});
			}
			else if (callbackFn) { callbackFn(callbackObj);	}
		},
		
		switchOffAutoHideShow: function() {
			autoHideShow = false;
		},
		
		ua: ua,
		
		getFlashPlayerVersion: function() {
			return { major:ua.pv[0], minor:ua.pv[1], release:ua.pv[2] };
		},
		
		hasFlashPlayerVersion: hasPlayerVersion,
		
		createSWF: function(attObj, parObj, replaceElemIdStr) {
			if (ua.w3) {
				return createSWF(attObj, parObj, replaceElemIdStr);
			}
			else {
				return undefined;
			}
		},
		
		showExpressInstall: function(att, par, replaceElemIdStr, callbackFn) {
			if (ua.w3 && canExpressInstall()) {
				showExpressInstall(att, par, replaceElemIdStr, callbackFn);
			}
		},
		
		removeSWF: function(objElemIdStr) {
			if (ua.w3) {
				removeSWF(objElemIdStr);
			}
		},
		
		createCSS: function(selStr, declStr, mediaStr, newStyleBoolean) {
			if (ua.w3) {
				createCSS(selStr, declStr, mediaStr, newStyleBoolean);
			}
		},
		
		addDomLoadEvent: addDomLoadEvent,
		
		addLoadEvent: addLoadEvent,
		
		getQueryParamValue: function(param) {
			var q = doc.location.search || doc.location.hash;
			if (q) {
				if (/\?/.test(q)) { q = q.split("?")[1]; } // strip question mark
				if (param == null) {
					return urlEncodeIfNecessary(q);
				}
				var pairs = q.split("&");
				for (var i = 0; i < pairs.length; i++) {
					if (pairs[i].substring(0, pairs[i].indexOf("=")) == param) {
						return urlEncodeIfNecessary(pairs[i].substring((pairs[i].indexOf("=") + 1)));
					}
				}
			}
			return "";
		},
		
		// For internal usage only
		expressInstallCallback: function() {
			if (isExpressInstallActive) {
				var obj = getElementById(EXPRESS_INSTALL_ID);
				if (obj && storedAltContent) {
					obj.parentNode.replaceChild(storedAltContent, obj);
					if (storedAltContentId) {
						setVisibility(storedAltContentId, true);
						if (ua.ie && ua.win) { storedAltContent.style.display = "block"; }
					}
					if (storedCallbackFn) { storedCallbackFn(storedCallbackObj); }
				}
				isExpressInstallActive = false;
			} 
		}
	};
}();



// |Firefox3.0    | mp3         |       -       |      mp3       |   mp3    |
// |Chrome4+      | mp3,ogg,    |(mp3) ogg      |      mp3       |   mp3    |
// |IE6,IE7,IE8   | mp3         |       -       |      mp3       |   mp3    |

var ptimer,
	w				= window,
	d				= w.document,
	l				= d.location,
	n				= navigator,

	OPERA			= ua("OPERA"),
	FIREFOX 		= ua("FIREFOX"),
	GECKO			= ua("GECKO"),
	CHROME			= ua("CHROME"),
	SAFARI			= ua("SAFARI"),
	MSIE			= ua("MSIE"),
	WINDOWS			= ua("WINDOWS"),
//	IPOD			= ua("IPOD"),
//	GAMEBOY			= ua("GAMEBOY"),
//	PS3				= ua("PS3"),
	VERSION			= ua("VERSION"),
	MAGERVERSION	= ua("MAGERVERSION"),

	p='0px',
	h=""
	;

var FlashAudio = {
	ready : false,
	swf	: null,
	obj : p,
	play : function(src) {
		debug("FlashAudio:play(" + src + "); start");
		var f = FlashAudio.getObj();
		if (f && f.playFile) {
			playaudio.vol(playaudio._volume);
			try {
				f.playFile(src);
				debug("FlashAudio:play(" + src + "); complete");
			} catch(e){}
			return true;
		}
		return false;
	},

	stop : function() {
		debug("FlashAudio:stop(); start");
		var f = FlashAudio.getObj();
		if (f && f.stop) {
			try {
				f.stop();
				debug("FlashAudio:stop(); completed");
			} catch(e){}
			return true;
		}
		return false;
	},

	vol : function(v) {
		debug("FlashAudio:vol(" + v + "); start");
		var f = FlashAudio.getObj();
		if (f && f.vol) {
			try {
				f.vol(v);
				debug("FlashAudio:vol(" + v + "); complete");
			} catch(e){}
			return true;
		}
		return false;
	},

	getvol : function() {
		debug("FlashAudio:getvol(); start");
		var f = FlashAudio.getObj();
		if (f && f.getvol) {
			var v=100;
			try {
				v=f.getvol();
				debug("FlashAudio:getvol(); complete value=" + v);
			} catch(e){}
			return v;
		}
	},

	isReady : function() {
		return FlashAudio.ready;
	},

	isSupport : function(tst) {
		return /\.MP3$/i.test(tst);
	},

	getObj : function() {
		return document.getElementById(FlashAudio.obj);
	},

	init : function(skin) {
		if(FlashAudio.ready == true) {
			return;
		}
		FlashAudio.swf=skin + '/audio.swf';
		debug("FlashAudio:init(" + skin + "); start");

		var element = document.createElement('div');
		element.id = FlashAudio.obj;
		var objBody = document.getElementsByTagName("html").item(0);
		objBody.appendChild(element);

		swfobject.embedSWF(FlashAudio.swf, FlashAudio.obj, p, p, "8.0.0", "");
		FlashAudio.ready=true;
		debug("FlashAudio:init(" + skin + "); complete");
	}
}

var HTML5Audio = {
	audioclass : null,

	play : function(src) {
		debug("HTML5Audio:play(" + src + "); start");
		var tmp=false;
		try {
			HTML5Audio.audioclass = new Audio(src);
			HTML5Audio.audioclass.play();
			tmp=true;
			debug("HTML5Audio:play(" + src + "); complete");
		} catch(e){}
		return tmp;
	},

	stop : function() {
		debug("HTML5Audio:stop(); start");
		if(HTML5Audio.audioclass != null) {
			try {
				HTML5Audio.audioclass.pause();
				debug("HTML5Audio:stop(); complete");
				return true;
			} catch(e){}
		}
		return false;
	},

	vol : function(v) {
		debug("HTML5Audio:vol(" + v + "); start");
		try {
			HTML5Audio.audioclass.volume = v / 256;
			debug("HTML5Audio:vol(" + v + "); complete");
		} catch(e){}
	},

	getvol : function() {
		var v=1;
		debug("HTML5Audio:getvol(); start");
		try {
			v=HTML5Audio.audioclass.volume;
			debug("HTML5Audio:getvol(); complete value=" + v);
		} catch(e){}
		return ~~(v * 256);
	},

	isReady : function() {
		return w.HTMLAudioElement;
	},

	isSupport : function(tst) {
		if(
			FIREFOX && MAGERVERSION < 4
		 || MSIE && MAGERVERSION < 9 + 1
		 || OPERA && MAGERVERSION < 11
		 || SAFARI && MAGERVERSION < 4
			) {
			return false;
		}
		if (/\.MP3$/i.test(tst)) {
			if(MSIE || WINDOWS && SAFARI || CHROME) {
				return true;
			}
		}
		if (/\.OG\w+$/i.test(tst)) {
			if(GECKO || CHROME || OPERA) {
				return true;
			}
		}
		if (/\.WAV$/i.test(tst)) { // wav
			if(GECKO || WINDOWS && SAFARI || OPERA) {
				return true;
			}
		}
		return false;
	}
}
var NoAudio = {
	play: function(src) {
		if(confirm(ln(
				"ja", "\u3053\u306e\u30d6\u30e9\u30a6\u30b6\u30fc\u3067\u306f\u518d\u751f\u3067\u304d\u307e\u305b\u3093\u3002\nHTML Audio\u304c\u7121\u52b9\u306b\u306a\u3063\u3066\u3044\u306a\u3044\u304b\u3001Adobe Flash\u304c\u30a4\u30f3\u30b9\u30c8\u30fc\u30eb\u3055\u308c\u3066\u3044\u308b\u304b\u78ba\u8a8d\u3057\u3066\u4e0b\u3055\u3044\u3002",
				"en", "Can't play on this browser.\nPlease check HTML Audio is disabled or Adobe Flash installed.",
				h))) {
			return false;
		}
	},

	stop : function() {
		return false;
	},

	vol : function() {
		return false;
	},

	getvol : function() {
		return false;
	},

	isReady : function() {
		return true;
	},

	isSupport: function(src) {
		return true;
	},
}

var playaudio = {
	ver			: '1.0',
	feedouttime	: 0,
	volume		: 100,
	sp			: 0,
	_volume		: 100,
	_dupplay	: 0,
	_isplay		: 0,
	_timeout	: null,
	_flash		: 0,
	_html5		: 1,
	name		: null,
	backend		: null,
	backendName	: h,
	backendOrder: new Array("HTML5Audio", "FlashAudio", "NoAudio"),
	Class : {
		"HTML5Audio":	HTML5Audio,
		"FlashAudio":	FlashAudio,
		"NoAudio":		NoAudio
	},

	play : function(src1, src2, src3, src4, src5) {
		if(playaudio._dupplay == 1) return;
		if(playaudio.feedouttime > 0 && playaudio._isplay == 1) {
			playaudio.feedout(
				playaudio.feedouttime,
				"playaudio.stop();playaudio._play(\""
				+ src1 + "\",\""
				+ src2 + "\",\""
				+ src3 + "\",\""
				+ src4 + "\",\""
				+ src5 + "\");");
		} else {
			playaudio._play(src1, src2, src3, src4, src5);
		}
	},

	_play : function(src1, src2, src3, src4, src5) {
		if(playaudio._isplay==0) {
			var flag=false;

			for(var i=0; i < playaudio.backendOrder.length; i++) {
				var backendName=playaudio.backendOrder[i];

				var Class = playaudio.Class[backendName];
				if(flag == false && Class) {
					if(Class.isReady) {
						if(Class.isReady()) {
							if(Class.isSupport) {
								if(Class.isSupport(src1)) {
									flag=true;
									playaudio.name=src1;
								}
								if(Class.isSupport(src2)) {
									flag=true;
									playaudio.name=src2;
								}
								if(Class.isSupport(src3)) {
									flag=true;
									playaudio.name=src3;
								}
								if(Class.isSupport(src4)) {
									flag=true;
									playaudio.name=src4;
								}
 								if(Class.isSupport(src5)) {
									flag=true;
									playaudio.name=src5;
								}
								if(flag == true) {
									playaudio.backend=Class;
									playaudio.backendName=backendName;
								}
							}
						}
					}
				}

			}

			if(playaudio.backend.play(playaudio.name)) {
				playaudio._dupplay=0;
				playaudio._isplay=1;
			}
		}
	},

	stop : function () {
		playaudio._stop();
	},

	_stop : function () {
		if(playaudio.backend) {
			if(playaudio.backend.stop()) {
				playaudio._isplay=0;
				return true;
			}
		}
		return false;
	},

	feed: function(sec, start, end, now, callback) {
		playaudio._dupplay=1;
		start=parseInt(start);
		end=parseInt(end);
		var interval=
			~~
				(
					sec * 1000
					/ (now < end ? end - now : now - end)
				);
		if(start == end) {
			clearTimeout(ptimer);
			eval(callback);
			return;
		} else if(start < end) {
			start++;
			playaudio.vol(start);
		} else if(end < start) {
			start--;
			playaudio.vol(start);
		}
		clearTimeout(ptimer);
		ptimer=setTimeout(
			"playaudio.feed("
				+ sec + ","
				+ start + ","
				+ end + ","
				+ now + ","
				+ "'" + callback + "');"
			, interval);
	},

	feedout: function(sec, callback) {
		playaudio._volume=playaudio.getvol();
		playaudio.volume=playaudio._volume;
		playaudio.feed(sec, playaudio.volume, 0, playaudio.volume, callback);
	},

	vol : function (v) {
		if(v === void 0) {
			return playaudio._getvol();
		}
		playaudio._vol(v);
	},

	_vol : function (v) {
		if(playaudio.backend) {
			if(playaudio.backend.vol(v)) {
				playaudio.volume=v;
				return true;
			}
		}
		return false;
	},

	getvol : function () {
		return playaudio._getvol();
	},

	_getvol : function () {
		var tmp;
		if(playaudio.backend) {
			tmp=playaudio.backend.getvol();
		}
		if(tmp) {
 			playaudio.volume=tmp;
		}
		return playaudio.volume;
	},

	setfeed : function(v) {
		playaudio.feed=v;
	},

	init : function (skin, feedouttime) {
		debug("playaudio:init();");

		ev.add("onkeypress", "playaudiokey", playaudiokey);
		playaudio.feedouttime=feedouttime;
		for(var i=0; i < playaudio.backendOrder.length; i++) {
			var backendName=playaudio.backendOrder[i];

			var Class = playaudio.Class[backendName];
			if (Class && Class.init) {
				Class.init(skin);
			}

		}
	},
	key : function(e) {
		if(this._isplay == 0) return true;
		if(keyCode(e) == 27) {
			if(confirm(ln(
					"ja", "\u505c\u6b62\u3057\u307e\u3059\u304b\uff1f",
					"en", "Stop Sound ?",
					h))) {
				playaudio.stop();
			}
		}
		if(keyCode(e) == 37) {
			var vol=playaudio.getvol() - 1;
			playaudio.vol(vol > 0 ? vol : 0);
		}
		if(keyCode(e) == 39) {
			var vol=playaudio.getvol() + 1;
			playaudio.vol(vol < 255 ? vol : 255);
		}
	}
}

function playaudiokey {
	playaudio.key(event);
}
