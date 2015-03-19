/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */









var
	$I = "indexOf",
	$R = "replace",
	$L = "length",
	x=-1, h="",
	W=window, D=W.document,
	T=true, S="script",
	U=navigator.appVersion;
	I=U[$I]('MSIE') > x ? (
		U[$I]('Opera') > x ? 0
	  : parseInt(U[$R](/.*MSIE[ ]/,'').match(/^[0-9]+/))
	) : 0;





var z={
	l: [],
	s: {},
	d: {},
	m: 1,
	n: 0,
	a: 0,
	c: h,
	t: 50,
	s: function() {
		
		//_dl("Start z.script");
		


		z.c = arguments[0];
		for(var i = 1, j = 0; i < arguments[$L]; i++) {
			var arg1=arguments[i],
				arg2=arg1,
				JQ="jquery",
				JQUERY=JQ + ".",
				JQUERYMIGRATE=JQ + "-migrate.";

			if(arg1[$I](JQUERY) > x) {
				if(!I || I > 8) {
					arg1=arg1[$R](JQUERY, JQUERY);
				}
				z.l[j++] = arg1;
				arg2=arg2[$R](JQUERY, JQUERYMIGRATE);
			}
			z.l[j++]=arg2;
		}
		z.z();
	},
	
	z: function() {
		
		//_dl("Start z.z");
		

		for(var i = z.m; i <  z.l[$L]; i++) {
			var ScriptURL=z.l[i], objInterval;
//			}
			//_dl("z loop m=" + z.m + " + no=" + i + " ma=" + z.l[$L]);
			z.n++;
			//_dl("z.l[" + i + "]=" + z.l[i]);

			if(ScriptURL == h) {
				z.a = i;
				////_dl("loop wait check start m=" + z.m + " no=" + i + " a=" + z.a)

				objInterval=setInterval(function() {
					
					//_dl("Start setInterval");
					

					var chk=z.n - z.m, j;
					
					//_dl("Check setTimeout " + chk + "(" + z.no + "-" + z.m + ")");
					
					for(j = z.m; j < z.n; j++) {
						if(z.s[j] == T)
							
							//			 {
							//_dl("Checked setTimeout check " + j + " = true");
							
							chk--;
						
						//} else {
							//_dl("Checked setTimeout check " + j + " = wait");
						//}
						

						
						//_dl("Check setTimeout end " + chk);
						
					}
					if(chk < 1 || z.t-- < x) {
						
						//_dl("Call clearTimeout " + chk);
						
						clearInterval(objInterval);
						z.m = z.n + 1;
						z.z();
						if(i > z.l[$L] - 2)
							z.c();
					}
				}, z.t);
				break;
			} else
				z.j(i);
		}
	},
	
	j: function(ScriptArray) {

		
		//_dl("Start z.j " + c + "(" + z.l[c] + ")");
		

		var ScriptURL=z.l[ScriptArray];
		if(ScriptURL == h)
			z.s[ScriptArray]=T;
		else {
			var xhr,
				xhrOpenCallback = function(e) {
				if (xhr.readyState == 4 && xhr.status == 200) {
					
					//_dl("Start g " + c);
					
					z.d[ScriptURL] = xhr.responseText;
					z.i(ScriptArray);
				}
			};

			xhr = z.X( xhrOpenCallback );
			if (xhr) {
				
				//_dl("Start z.j sendreq " + c + "(" + z.l[c] + ")");
				
		 		xhr.open("GET", ScriptURL, T);
				xhr.send(null);
			}
		}
	}
	,
	i: function(ScriptArray) {
		var Element = D.createElement(S), defer="defer";
		Element.type="text/java" + S;
		Element.charset="utf-8";
		Element.setAttribute(defer, defer);
		Element.src=z.l[ScriptArray];
		D.getElementsByTagName("head")[0].appendChild(Element);

		z.s[ScriptArray]=T;
	},
	X: function(xhrOpenCallback, undefined) {
		var xhr =
			typeof XMLHttpRequest != undefined
			? new XMLHttpRequest() : 
				(  new ActiveXObject("Msxml2.XMLHTTP")
				|| new ActiveXObject("Microsoft.XMLHTTP")
				);
		if (xhr) xhr.onreadystatechange = xhrOpenCallback;
		return xhr;
	},
}, ld=z.s;
