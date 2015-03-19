/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */




var	w=window,
	d=w.document,
	n=navigator,
	l=location,
	x=-1,
	u = n.userAgent.toLowerCase(),
	op = (u.indexOf("opera") > x),
	ff = (u.indexOf("firefox") > x),
	moz = (u.indexOf("gecko") > x || ff),
	ie = (u.indexOf("msie") > x && !op && !moz),
	h="",

	jp_twfo='\u3092\u30d5\u30a9\u30ed\u30fc</a>',
	jp_s='\u3059\u308b',
	jp_subsc_s="\u8cfc\u8aad" + jp_s,
	jp_subsc_d="\u3067" + jp_subsc_s,
	jp_bk="\u30d6\u30c3\u30af\u30de\u30fc\u30af",
	jp_favorite="\u304a\u6c17\u306b\u5165\u308a",
	jp_add="\u8ffd\u52a0",
	jp_addha=jp_add  + "\u306f",
	jp_addni="\u306b" + jp_add,
	jp_share="\u30b7\u30a7\u30a2",
	jc='\u3001',
	nbsp="&nbsp;",
	view=new Array();

function smedia_init(url, rssurl, pagename, addparam, form) {
	var html, nameprefix,
		text_share=
			 ln(								
				"en",						 	
				"Share"							
				,								
				"ja",							
				text_share=jp_share + jp_s		
			)									
			;
		text_bookmark=
			 ln(								
				"en",						 	
				"Bookmark"						
				,								
				"ja",							
				jp_bk							
			)									
			;
		text_subscribe=
			 ln(								
				"en",						 	
				"Subscribe"						
				,								
				"ja",							
				jp_subsc_s						
			)									
			;

		obj=gid("smediabutton");

	if(form == "menubar" || form == "sidebar") {
		nameprefix="smediamenubar";
		html='<ul class="smediamenubarbutton">';
	} else {
		nameprefix="smedia";
		html='<ul class="smediabodybutton">';
	}
	html+=
		'<li><a href="javascript:void 0;" class="smediabutton" onclick="smedia_show(\'' + url + '\',\'' + rssurl + '\',\'' + pagename + '\',\'' + addparam + '\',\'' + form + '\',\'' + smedia_share + '\', \'' + nameprefix + '_share\');return false;">' + text_share + '</a></li>'
		+
		'<li><a href="javascript:void 0;" class="smediabutton" onclick="smedia_show(\'' + url + '\',\'' + rssurl + '\',\'' + pagename + '\',\'' + addparam + '\',\'' + form + '\',\'' + smedia_bookmark + '\', \'' + nameprefix + '_bookmark\');return false;">' + text_bookmark + '</a></li>'
		+
		'<li><a href="javascript:void 0;" class="smediabutton" onclick="smedia_show(\'' + url + '\',\'' + rssurl + '\',\'' + pagename + '\',\'' + addparam + '\',\'' + form + '\',\'' + smedia_subscribe + '\', \'' + nameprefix + '_subscribe\');return false;">' + text_subscribe + '</a></li>'
		+"</ul>"
		+'<p><span id="' + nameprefix + '_share"></span><span id="' + nameprefix + '_bookmark"></span><span id="' + nameprefix + '_subscribe"></span></p>';
	sins(obj, html);

	
	if(ie) {
		smedia_show(url, rssurl, pagename, addparam, form, smedia_share, nameprefix + '_share', "none");
	}

	try {
		obj.style.display="block";
	} catch (e) {}


}

function smedia_show(url, rssurl, pagename, addparam, form, mode, formname, flag) {
	var html;

	var u=encodeURIComponent(url),
		t=encodeURIComponent(pagename),
		p=encodeURIComponent(addparam),
		obj=gid(formname),
		height, width;

	try {
		gid("smedia_share").style.display="none";
		gid("smedia_bookmark").style.display="none";
		gid("smedia_subscribe").style.display="none";
	} catch (e) {}

	try {
		gid("smediamenubar_share").style.display="none";
		gid("smediamenubar_bookmark").style.display="none";
		gid("smediamenubar_subscribe").style.display="none";
	} catch (e) {}

	if(!view[formname]) {
		view[formname]=1;
		var	element2 = d.createElement('div');

		var	element = d.createElement('ul');
		if(form == "menubar" || form == "sidebar") {
			element2.className="smediamenubarclose";
			width=125;
			height=240;
			element.className="smediamenubar";
			smediaarray["twitter_follow"]=0;
		} else {
			element2.className="smediaclose";
			width=550;
			height=100;
			element.className="smedia";
		}
		sins(element2, '<a href="javascript:void 0;" class="smediaclosebutton" onclick="smedia_hide();">&times;</a>');
		obj.appendChild(element2);

		obj.style.width=width;
		obj.style.height=height;

		smedia_button(element,mode, url, rssurl, pagename, smediaarray);
		obj.appendChild(element);
	}
	if(flag != "none") {
		obj.style.display="block";
	}
}

function smedia_hide() {
	try {
		parent.gid("smedia_share").style.display="none";
		parent.gid("smedia_bookmark").style.display="none";
		parent.gid("smedia_subscribe").style.display="none";
	} catch (e) {}
	try {
		parent.gid("smediamenubar_share").style.display="none";
		parent.gid("smediamenubar_bookmark").style.display="none";
		parent.gid("smediamenubar_subscribe").style.display="none";
	} catch (e) {}
}



function BrowserBookMark(url, title){
	var err=
		 ln(							
			"en",						
			'Add to browser favorites, Not supported than Internet Explorer and FireFox, Opera.'				
			,							
			"ja",						
			'\u30d6\u30e9\u30a6\u30b6\u3078\u306e' + jp_favorite + jp_addha + jc  + 'Internet Explorer \u3068 FireFox \u3068 Opera \u4ee5\u5916\u306b\u306f\u5bfe\u5fdc\u3057\u3066\u304a\u308a\u307e\u305b\u3093'	
		)								
		;

	var u=decodeURIComponent(url),
		t=decodeURIComponent(title);

	if(ie) {
		w.external.AddFavorite(u,t);
	} else if(moz) {
		w.sidebar.addPanel(t , u, '');
	} else {
		w.alert(err);
	}
}

function browser_button(url, pagename) {
	var button_name=
		 ln(							
			"en",						
			"Add Favorites"				
			,							
			"ja",						
			jp_favorite + jp_addni	
		)								
		;

	if(op) {
		return '<a class="bookmarkbutton" href="' + url + '" rel="sidebar" title="' + pagename + '">' + button_name + '</a>';
	}
	if(ie || moz) {
		return '<a class="bookmarkbutton" href="javascript:void 0;" onclick="BrowserBookMark(\'' + url + '\',\'' + pagename + '\');">' + button_name + '</a>';
	}
	return '';
}

function smedia_button(obj,work,url,rssurl, title, varray) {
	var works=work.split(","),
		loaded=ar(),
		facebook_str="facebook";

	for (var i=0; i < works.length; i++) {
		var mode=works[i],
			schme = "//",
			http="http:" + schme,
			https="https:" + schme,
			twitter_domain="twitter.com",
			twitter_url=https + twitter_domain + "/",
			yahoo_japan_domain="yahoo.co.jp",
			yahoo_japan_image_url=http + "i.yimg.jp/",
			google_domain="google.com",
			livedoor_domain="livedoor.com",
			textjavascript="text/javascript",
			eurl=encodeURIComponent(url),
			etitle=encodeURIComponent(title),
			erssurl=encodeURIComponent(rssurl),
			element, element2, html;


		
		

		if(mode == "twitter") {
			element = d.createElement('li');
			element.className="twitter_tweet";
			sins(element, '<a href="' + twitter_url + 'share" data-url="'+url+'" data-text="'+title+'" class="twitter-share-button" data-lang=' + 
				 ln(								
					"en",						 	
					'"en">Tweet'					
					,								
					"ja",							
					'"ja">\u30c4\u30a3\u30fc\u30c8'					
				)									
				+ '</a>');
			obj.appendChild(element);
			loaded["twitter"]=1;
		}

		
		

		if(mode == "twitter_follow") {
			var twitter_username=varray["twitter_username"],
				twitter_follow=varray["twitter_follow"];
				element = d.createElement('li');
			var follow_name=
				 ln(							
					"en",						 	
					'"en">Follow @' + twitter_username	
					,								
					"ja",							
					'"ja">@' + twitter_username		
					+ jp_twfo						
				)									
			;

			if(twitter_follow === 0) {	
				element.className="twitter_follow0";
				sins(element, '<a href="' + twitter_url + twitter_username  + '" class="twitter-follow-button" data-show-count="false" data-show-screen-name="false" ' + 'data-lang=' + follow_name + '</a>');

			} else if(twitter_follow === 1) {	
				element.className="twitter_follow1";
				sins(element, '<a href="' + twitter_url + twitter_username  + '" class="twitter-follow-button" data-show-count="false" data-show-screen-name="true" ' +	'data-lang=' + follow_name + '</a>');
			} else if(twitter_follow === 2) {	
				element.className="twitter_follow2";
				sins(element, '<a href="' + twitter_url + twitter_username  + '" class="twitter-follow-button" data-show-count="true" data-show-screen-name="false" ' +	'data-lang=' + follow_name + '</a>');
			} else if(twitter_follow === 3) {	
				element.className="twitter_follow3";
				sins(element, '<a href="' + twitter_url + twitter_username  + '" class="twitter-follow-button" data-show-count="true" data-show-screen-name="true" ' +	'data-lang=' + follow_name + '</a>');
			}
			obj.appendChild(element);
			loaded["twitter"]=1;
		}

		
		

		if(mode == facebook_str || mode == facebook_str + "_like" || mode == facebook_str + "_recommend") {
			element = d.createElement('li');
			element.className=facebook_str + "_like";
			html='<div class="fb-like" data-href="' + eurl + '" data-send="false" data-layout="button_count" data-width="100" data-show-faces="true"';
			if(mode == facebook_str + "_recommend") {
				html = html + ' data-action="recommend"';
			}
			html = html + '></div>';
			sins(element, html);
			obj.appendChild(element);
			loaded[facebook_str]=1;
		}

		
		if(mode == facebook_str + "_share") {
			element = d.createElement('li');
			element.className=facebook_str + "_share";
			html='<a name="fb_share" type="box_count" share_url="' + url + '">' + 
				 ln(			
					"en", 		
					"Share"		
					,			
					"ja",		
					jp_share	
				)				
			+ '</a>';
			html = html + '<script src="' + http + 'static.ak.fbcdn.net/connect.php/js/FB.Share" type="' + textjavascript + '"></script>';
			sins(element, html);
			obj.appendChild(element);
			loaded[facebook_str]=1;
		}

		
		

		if(mode == facebook_str + "_comment" || mode == facebook_str + "_bbs") {
			element = d.createElement('li');
			element.className=facebook_str + "_comment";
			html='<div class="fb-comments" data-href="' + eurl + '" data-num-posts="5" data-width="470"></div>';
			sins(element, html);
			obj.appendChild(element);
			loaded[facebook_str]=1;
		}

		
		
		

		if(mode == "google") {
			element = d.createElement('div');
			element.className = "google_plusone";
			sins(element, '<g:plusone size="medium"></g:plusone><script type="' + textjavascript + '">w.___gcfg = {lang: "' +
				 ln(		
					"en", 	
					"en"	
					,		
					"ja",	
					"ja"	
				)			
			+ '"};(function(){var po=d.createElement("script");po.type="' + textjavascript + '";po.async=true;po.src="' + https + 'apis.' + google_domain + '/js/plusone.js";var s=d.getElementsByTagName("script")[0];s.parentNode.insertBefore(po,s);})();</script>');

			element2 = document.createElement('li');
			element2.className = "google_plusone_m";
			element2.appendChild(element);
			obj.appendChild(element2);
			loaded["google"]=1;
		}

		
		
		
		

		if((mode == "mixi" || mode == "mixicheck") && smedia_mixikey) {
			element = d.createElement("li");
			element2 = d.createElement("div");
			element2.setAttribute("data-plugins-type", "mixi-favorite");
			element2.setAttribute("data-service-key", smedia_mixikey);
			element2.setAttribute("data-size", "medium");
			element2.setAttribute("data-show-faces", "false");
			element2.setAttribute("data-show-count", "true");
			element2.setAttribute("data-show-comment", "true");
			element2.setAttribute("data-width", "");

			element.appendChild(element2);
			element.className = 'mixi_favorite';
			obj.appendChild(element);
			loaded["mixi"]=1;
		}

		
		

		if(mode == "hatena") {
			element = d.createElement("div");
			sins(element, '<a href="' + http + 'b.hatena.ne.jp/entry/'+url+'" class="hatena-bookmark-button" data-hatena-bookmark-title="'+title+'" data-hatena-bookmark-layout="standard" title="' + 
			 ln(									
				"en", 								
				"Add to this entry to Hatena bookmark"
				,									
				"ja",								
				"\u3053\u306e\u30a8\u30f3\u30c8\u30ea\u30fc\u3092\u306f\u3066\u306a"			
				+ jp_bk + jp_addni				
				)									
			+ '"><img src="' + http + 'b.st-hatena.com/images/entry-button/button-only.gif" alt="" width="20" height="20" style="border: none;" /></a>');	
			element2 = d.createElement('li');
			element2.className="hatena_bookmark";
			element2.appendChild(element);
			obj.appendChild(element2);
			loaded["hatena"]=1;
		}

		
		if(mode == "gree") {
			element=d.createElement('li');
			element.className="gree";
			sins(element, '<iframe src="' + http + 'share.gree.jp/share?url=' + eurl + '&amp;type=' + varray["gree_type"] + '&amp;height=' + varray["gree_height"] + '" scrolling="no" frameborder="0" marginwidth="0" marginheight="0" style="border:none; overflow:hidden; width:100px; height:' + varray["gree_height"] + 'px;" allowTransparency="true"></iframe>');
			obj.appendChild(element);
		}
		
		if(mode == "livedoor") {
			element=d.createElement('li');
			element.className="livedoor_clip";
			sins(element, '<div id="bmicon"><span><a href="javascript:void 0;" onclick="ou(\'' + http + 'clip.' + livedoor_domain + '/clip/add?link=' + eurl + '&amp;title=' + etitle + '\',\'_target\');"><img src="' + http + 'clip.' + livedoor_domain + '/img/icon/bm_clip.gif" width="47" height="24" alt="clip!" title="clip!"></a></span></div>');
			obj.appendChild(element);
		}
		
		

		if(mode == "yahoo") {
			element=d.createElement('li');
			element.className="yahoo_bookmark";
			sins(element, '<a href="javascript:void 0;" onclick="w.open(\'' + http + 'bookmarks.' + yahoo_japan_domain + '/bookmarklet/showpopup?t=' + etitle + '&amp;u=' + eurl + '&amp;ei=UTF-8\',\'_blank\',\'width=550,height=480,left=100,top=50,scrollbars=1,resizable=1\',0);"><img src="' + yahoo_japan_image_url + 'images/ybm/blogparts/addmy_btn.gif" width="125" height="17" alt="' + 
				 ln(								
					"en", 							
					"Yahoo Bookmark"				
					,								
					"ja",							
					"Yahoo" + jp_bk				
				)									
				+ '" style="border:none;"></a>');
			obj.appendChild(element);
		}
		
		if(mode == "googleb") {
			element=d.createElement('li');
			element.className="google_bookmark";
			sins(element, '<a class="bookmarkbutton" href="javascript:void 0;" onclick=\'(function(){var a=w.open("' + http + 'www.' + google_domain + '/bookmarks/mark?op=edit&amp;output=popup&amp;bkmk=' + eurl + '&amp;title=' + etitle + '","bkmk_popup","left="+((w.screenX||w.screenLeft)+10)+",top="+((w.screenY||w.screenTop)+10)+",height=420px,width=550px,resizable=1,alwaysRaised=1");w.setTimeout(function(){a.focus()},300)})();\'>' + 
				 ln(								
					"en", 							
					"Google Bookmark"				
					,								
					"ja",							
					"Google" + nbsp + jp_bk			
				)									
				+ '</a>');
			obj.appendChild(element);
		}
		if(mode == "bookmark") {
			element=d.createElement('span');
			sins(element, browser_button(url, title));
			element2=d.createElement('li');
			element2.className="bookmark";
			element2.appendChild(element);
			obj.appendChild(element2);
		}
		
		if(mode == "googlerss") {
			element=d.createElement('li');
			element.className="google_rss";
			sins(element, '<a href="' + http + 'fusion.' + google_domain + '/add?feedurl='  + erssurl + '" target="_blank"><img src="' + http + 'gmodules.com/ig/images/plus_google.gif" border="0" alt="' + 
				 ln(								
					"en", 							
					"Subscribe with Google reader"	
					,								
					"ja",							
					"Google\u30ea\u30fc\u30c0\u30fc" + jp_subsc_d	
				)									
				+ '"></a>');
			obj.appendChild(element);
		}

		
		if(mode == "livedoorrss") {
			element=d.createElement('li');
			element.className="livedoor_rss";
			var image=varray["livedoorrss"]+0 == 1 ? 1 : 2;
			sins(element, '<a href="' + http + 'reader.' + livedoor_domain + '/subscribe/' + rssurl + '" target="_blank" title="Subscribe with livedoor Reader"><img src="' + http + 'image.reader.' + livedoor_domain + '/img/banner/80_15_' + image + '.gif" border="0" width="80" height="15" alt="' + 
				 ln(								
					"en", 							
					"Subscribe with livedoor Reader"
					,								
					"ja",							
					"livedoor Reader" + jp_subsc_d	
				)									
				+ '"></a>');
			obj.appendChild(element);
		}

		
		if(mode == "myyahoo" || mode == "yahoorss") {
			element = document.createElement('li');
			element.className="yahoo_rss";
			sins(element,  '<a target=_blank href="' + http + 'rd.' + yahoo_japan_domain + '/myyahoo/rss/addtomy/users/\*' + http + 'add.my.' + yahoo_japan_domain + '/rss?url=' + erssurl + '"><img src="' + yahoo_japan_image_url + 'i/jp/my/addtomy/mini_1b.gif" width="89" height="33" border="0" align=middle alt="' +
				 ln(								
					"en", 							
					"Add My Yahoo!"					
					,								
					"ja",							
					"My Yahoo!" + nbsp + jp_subsc_d	
				)									
				 + '"></a>');
			obj.appendChild(element);

		
		
		

		}
	}

	
	if(loaded["twitter"]) {
		!function(d,s,id){
			var	js,
				fjs=d.getElementsByTagName(s)[0];
			if(!d.getElementById(id)){
				js=d.createElement(s);
				js.id=id;
				js.src=schme + "platform." + twitter_domain + "/widgets.js";
				fjs.parentNode.insertBefore(js,fjs);
			}
		}
		(d,"script","twitter-wjs");
	}

	
	if(loaded[facebook_str]) {
		(function(d,s,id){
			var js,
				fjs=d.getElementsByTagName(s)[0];
			if(d.getElementById(id)) return;
			js=d.createElement(s);js.id=id;
			js.src=schme + "connect.facebook.net/" + 
				 ln(		
					"en", 	
					"en-US"	
					,		
					"ja",	
					"ja-J"	
				)			
				+ "/all.js#xfbml=1";
			fjs.parentNode.insertBefore(js,fjs);
		}
		(d,'script','facebook-jssdk'));
	}

	
	if(loaded["google"]) {
		w.gapi=w.gapi||{};
		if (typeof(w.gapi.plusone) == 'undefined') {
			if (d.getElementsByTagName("body")[0]) {
				element = d.createElement('script');
				element.type = textjavascript;
				element.src = https + 'apis.' + google_domain + '/js/plusone.js';
				element.text = "{lang: '" + 
					 ln(		
						"en", 	
						"en"	
						,		
						"ja",	
						"ja"	
					)			
					 + "'}";
				d.getElementsByTagName("body")[0].insertBefore(element, d.getElementsByTagName("body")[0].firstChild);
			}
		}
	}

	
	if (loaded["hatena"] && d.getElementsByTagName("body")[0]) {
	    element = document.createElement('script');
	    element.type = textjavascript;
	    element.src = http + 'b.st-hatena.com/js/bookmark_button.js';
	    d.getElementsByTagName("body")[0].insertBefore(element, d.getElementsByTagName("body")[0].firstChild);
	}

	
	if(loaded["mixi"]) {
	    (function(d) {
	        var s = d.createElement('script');
			s.type = textjavascript;
			s.async = true;
	        s.src = schme + 'static.mixi.jp/js/plugins.js#lang=' +
				 ln(		
					"en", 	
					"en"	
					,		
					"ja",	
					"ja"	
				)			
				;
	        d.getElementsByTagName('head')[0].appendChild(s);
	    })(d);
	}
}
