/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */



var noOverwrite=false, alertText,
	x=-1,
	d				= document,

//	CHROME			= ua("CHROME"),
	SAFARI			= ua("SAFARI"),
	MSIE			= ua("MSIE"),
//	ANDROID			= ua("ANDROID"),
//	WII				= ua("WII"),
//	PS2				= ua("PS2"),

	id=1,
	crlf="\\n",
	h="",
	instag=h
	;


function insTagForm(readyJquery, useFacemark) {
	sinss("editextend", mkinsTagForm(readyJquery, useFacemark));
}


function mkinsTagForm(readyJquery, useFacemark) {
	var html,
		samplesize=25;


	html = mkextend(ln(
		"ja", "\u592a\u6587\u5b57",
		"en", "Bold",
		h), "\\'\\'", "\\'\\'", "<strong>B</strong>");

	html += mkextend(ln(
		"ja", "\u659c\u4f53",
		"en", "Italic",
		h), "\\'\\'\\'", "\\'\\'\\'", "<i>I</i>");

	html += mkextend(ln(
		"ja", "\u4e0b\u7dda",
		"en", "UnderLine",
		h), "%%%", "%%%", "<ins>U</ins>");

	html += mkextend(ln(
		"ja", "\u53d6\u308a\u6d88\u3057\u7dda",
		"en", "Strikethrough",
		h), "%%", "%%", "<del>D</del>");


	var ul_list=new Array(
		ln(
			"ja", liststr("-", 1, "\u30ea\u30b9\u30c8"),
			"en", liststr("-", 1, "List"),
		h),
		ln(
			"ja", liststr("--", 2, "\u30ea\u30b9\u30c8"),
			"en", liststr("--", 2, "List"),
		h),
		ln(
			"ja", liststr("---", 3, "\u30ea\u30b9\u30c8"),
			"en", liststr("---", 3, "List"),
		h)
	);

	html+=mkextendmenu(ln(
			"ja", "\u30ea\u30b9\u30c8",
			"en", "List",
		h), ul_list, h, "ul", teststring, samplesize, "list_ex");

	var ol_list=new Array(
		ln(
			"ja", liststr("+", 1, "\u9023\u756a\u30ea\u30b9\u30c8"),
			"en", liststr("+", 1, "Number List"),
		h),
		ln(
			"ja", liststr("++", 2, "\u9023\u756a\u30ea\u30b9\u30c8"),
			"en", liststr("++", 2, "Number List"),
		h),
		ln(
			"ja", liststr("+++", 3, "\u9023\u756a\u30ea\u30b9\u30c8"),
			"en", liststr("+++", 3, "Number List"),
		h)
	);

	html+=mkextendmenu(ln(
			"ja", "\u9023\u756a\u30ea\u30b9\u30c8",
			"en", "Number List",
		h), ol_list, h, "ol", teststring, samplesize, "numbered");

	html += mkextend(ln(
		"ja", "\u30bb\u30f3\u30bf\u30ea\u30f3\u30b0",
		"en", "Centering",
		h), crlf + "CENTER:", h, "_center");

	html += mkextend(ln(
		"ja", "\u5de6\u5bc4\u305b",
		"en", "Left adjust",
		h), crlf + "LEFT:", h, "_left_just");

	html += mkextend(ln(
		"ja", "\u53f3\u5bc4\u305b",
		"en", "Right adjust",
		h), crlf + "RIGHT:", h, "_right_just");

	var h_list=new Array(
		ln(
			"ja", liststr("*", 1, "\u8868\u984c"),
			"en", liststr("*", 1, "Head"),
		h),
		ln(
			"ja", liststr("**", 2, "\u8868\u984c"),
			"en", liststr("**", 2, "Head"),
		h),
		ln(
			"ja", liststr("***", 3, "\u8868\u984c"),
			"en", liststr("***", 3, "Head"),
		h),
		ln(
			"ja", liststr("****", 4, "\u8868\u984c"),
			"en", liststr("****", 4, "Head"),
		h),
		ln(
			"ja", liststr("*****", 5, "\u8868\u984c"),
			"en", liststr("*****", 5, "Head"),
		h)
	);

	html+=mkextendmenu("<strong>H</strong>",
		h_list, h, "h", teststring, samplesize);

	html += mkextend(ln(
		"ja", "Wiki\u30da\u30fc\u30b8",
		"en", "Wiki Page",
		h), '[[',']]', "[[]]");

	html += mkextend(ln(
		"ja", "\u30ea\u30f3\u30af",
		"en", "Link",
		h), '[[','&gt;http://]]', "http:://");

	html += mkextend(ln(
		"ja", "\u753b\u50cf\u30fb\u6dfb\u4ed8\u30d5\u30a1\u30a4\u30eb",
		"en", "Image or Attach file",
		h), '&ref(',');', "_attach");

	html += mkextend(ln(
		"ja", "\u6539\u884c",
		"en", "New Line",
		h), '','~' + crlf, "&lt;BR&gt;");

	html += mkextend(ln(
		"ja", "\u6c34\u5e73\u7dda",
		"en", "Horizontal line",
		h), crlf + '----' + crlf,'', "<strong>--</strong>");

	if(readyJquery) {
		var color_teststring=ln(
				"ja", "\u3042",
				"en", "A",
				h),

			color_title=ln(
				"ja", "\u6587\u5b57\u8272",
				"en", "Color",
				h),

			color_default="#000000",

			backgroundcolor_title=ln(
				"ja", "\u80cc\u666f\u8272",
				"en", "Background Color",
				h),

			backgroundcolor_default="#FFFFFF",
			size_title=ln(
				"ja", "\u30b5\u30a4\u30ba",
				"en", "Font size",
				h),
			teststring=ln(
				"ja", "\u3042\u3044\u3046\u3048\u304a",
				"en", "ABCDE",
				h),
			size_list=new Array(10,12,14,16,18,20,24,28,32);
			font_title=ln(
				"ja", "\u30d5\u30a9\u30f3\u30c8",
				"en", "Font",
				h),
			font_list=ln(
				"ja", new Array(
						"serif:\u660e\u671d\u4f53",
						"sans-seri:\u30b4\u30b7\u30c3\u30af\u4f53",
						"cursive:\u7b46\u8a18\u4f53",
						"fantasy:\u88c5\u98fe\u6587\u5b57",
						"monospace:\u7b49\u5e45",
						"MS UI Gothic",
						"\uff2d\uff33 \uff30\u30b4\u30b7\u30c3\u30af",
						"\uff2d\uff33 \u30b4\u30b7\u30c3\u30af",
						"\uff2d\uff33 \uff30\u660e\u671d",
						"\uff2d\uff33 \u660e\u671d",
						"\u30e1\u30a4\u30ea\u30aa",
						"Arial",
						"Arial Black",
						"Comic Sans MS",
						"Courier New",
						"Times New Roman",
						"Verdana"
					),
				"en", new Array(
						"serif",
						"sans-seri",
						"cursive",
						"fantasy",
						"monospace",
						"MS UI Gothic",
						"Arial",
						"Arial Black",
						"Comic Sans MS",
						"Courier New",
						"Times New Roman",
						"Verdana"
					),
				h),
			face_title=ln(
				"ja", "\u7d75\u6587\u5b57",
				"en", "Pictogram",
				h),
			facemark=new Array(
				"bigsmile:bigsmile",
				"huh:huh",
				"oh:oh",
				"sad:sad",
				"smile:smile",
				"wink:wink",
				"worried:worried",

				"big_plus:extend_bigsmile",
				"heart:heart",
				"ohplus:extend_oh",
				"sadplus:extend_sad",
				"smileplus:extend_smile",
				"winkplus:extend_wink",
				"worriedplus:extend_worried",
				"ummr:umm",
				"star:star",
				"tear:tear",
				"heartplus:extend_heart"
			);

			html+=mkextendmenu(font_title, font_list, h, "font", teststring, samplesize);

			html+=mkextendmenu(size_title, size_list, "px", "size", teststring, samplesize);

			id++;
			html+='<a class="exlink" href="#" onclick="return false;" id="panellink' + id + '"><span style="font-weight: bold; color:red;">' + color_teststring + '</span></a><span class="editpanel editcolorpicker" id="panelbody' + id + '"><input type="text" class="colortext" id="panel' + id + '" name="panel' + id + '" value="#000000" /><a href="#" onclick="insTag(\'&amp;color(\'+gid(\'editform\').panel' + id + '.value+\'){\',\'};\',\'' + color_title + '\');return false;" class="jqmClose"><span id="picker' + id + '"></span></a></span>';

			id++;
			html+='<a class="exlink" href="#" onclick="return false;" id="panellink' + id + '"><span style="font-weight: bold; color:white; background-color:red;">' + color_teststring + '</span></a><span class="editpanel editcolorpicker" id="panelbody' + id + '"><input type="text" class="colortext" id="panel' + id + '" name="panel' + id + '" value="#ffffff" /><a href="#" onclick="insTag(\'&amp;color(,\'+gid(\'editform\').panel' + id + '.value+\'){\',\'};\',\'' + backgroundcolor_title + '\');return false;" class="jqmClose"><span id="picker' + id + '"></span></a></span>';

			if(useFacemark) {
			id++;
				html+='<a class="exlink" href="#" onclick="return false;" id="panellink' + id + '"><span style="font-weight: bold;">' + face_title + '</span></a><span class="editpanel editfacepanel" id="panelbody' + id + '">';
				for (var fm in facemark) {
					var f=facemark[fm].split(":"),
						name=f[0],
						image=f[1];
					var a='<a href="#" onclick="insTag(\'&amp;' + name + ';\',\'\',\'\');return false;" class="jqmClose facesample icnface" id="icn_' + image + '" title="&amp;' + name + ';" />&nbsp;&nbsp;</a>';

					html+=a;
				}
				html+='</span>';
			}
	}
	return html;
}

function liststr(ins, level, str) {
	return ":" + crlf + ins + ":" + ":" + str + "(" + ln(
		"ja", "\u30ec\u30d9\u30eb",
		"en", "Level",
		h) + " " + level + ")";
}

function mkextend(str, start, end, title) {
	var html;
	html='<a class="exlink" title="' + str + '" href="javascript:insTag(' + "'" + start + "','" + end + "','" + str + "'" + ');">';
	if(title.substr(0,1) != "_") {
		html += title
	} else {
		title = title.substr(1);
		html += '<span class="icneditex" id="icn_' + title + '">&nbsp;&nbsp;</span>';
	}
	return html;
}

function mkextendmenu(title, list, adddisplay, plugin, teststring, samplesize, image) {
	var html;

	id++;
	if(image === void 0)
		image=h;

	if(image == h)
		html='<a class="exlink" href="#" onclick="return false;" title="' + title + '" id="panellink' + id + '"><span style="font-weight: bold;">' + title;
	else
		html='<a class="exlink" href="#" onclick="return false;" title="' + title + '" id="panellink' + id + '"><span class="icneditex" id="icn_' + image + '">&nbsp;&nbsp;';

	html += '</span></a><span class="editpanel edit' + plugin + 'panel" id="panelbody' + id + '">';

	for(var loop in list) {
		var l=list[loop], arg, name, display, start, end;
		if(typeof l == 'number') {
			name=l;
			display=l + adddisplay;
		} else {
			arg=l.split(":");
			if(arg[0] == h) {
				name=h;
				start=arg[1];
				end=arg[2];
				display=arg[3];
			} else {
				name=arg[0],
				display=(arg[1] === void 0 ? arg[0] : arg[1]);
			}
		}
		if(name == h) {
			html += '<a href="#" onclick="insTag(' + "'" + start + "','" + end + "','" + display + "'" + ');return true;" class="jqmClose ' + plugin + 'sample"';
		} else {
			html += '<a href="#" onclick="insTag(\'&amp;' + plugin + '(' + name + '){\',\'};\',\'' + title + '\');return true;" class="jqmClose ' + plugin + 'sample"';
		}
		if(plugin == "font") {
			html += ' style="font-size:' + samplesize + 'px; font-family:' + name + ';"';
		} else if(plugin == "size") {
			html += ' style="font-size:' + name + 'px;"';
		} else {
			html += ' style="font-size:' + samplesize + 'px;"';
		}
		html += '>'
			 + (teststring === void 0 ? display : teststring
				 +  ' (' + display + ')')
			+ '</a><br />';
	}
	html+='</span>';
	return html;
}




function insTag(tagOpen, tagClose, sampleText) {
	var txtarea = gid(ef).mymsg;
	
	if (MSIE) {
		var theSelection = document.selection.createRange().text;
		if (!theSelection) { theSelection=sampleText;}
		txtarea.focus();
		if (theSelection.charAt(theSelection.length - 1) == " ") {
			
			theSelection = theSelection.substring(0, theSelection.length - 1);
			document.selection.createRange().text = tagOpen + theSelection + tagClose + " ";
		} else {
			document.selection.createRange().text = tagOpen + theSelection + tagClose;
		}

	
	} else if(txtarea.selectionStart || txtarea.selectionStart == '0') {
 		var startPos = txtarea.selectionStart,
			endPos = txtarea.selectionEnd,
			scrollTop=txtarea.scrollTop,
			myText = (txtarea.value).substring(startPos, endPos);
		if(!myText) { myText=sampleText;}
		if(myText.charAt(myText.length - 1) == " "){ 
			subst = tagOpen + myText.substring(0, (myText.length - 1)) + tagClose + " ";
		} else {
			subst = tagOpen + myText + tagClose;
		}
		txtarea.value = txtarea.value.substring(0, startPos) + subst +
			txtarea.value.substring(endPos, txtarea.value.length);
		txtarea.focus();

		var cPos=startPos+(tagOpen.length+myText.length+tagClose.length);
		txtarea.selectionStart=cPos;
		txtarea.selectionEnd=cPos;
		txtarea.scrollTop=scrollTop;

	
	} else {
		var copy_alertText=alertText,
			re1=new RegExp("\\$1","g"),
			re2=new RegExp("\\$2","g"),
			text;
		copy_alertText=copy_alertText.replace(re1,sampleText);
		copy_alertText=copy_alertText.replace(re2,tagOpen+sampleText+tagClose);

		if (sampleText) {
			text=prompt(copy_alertText);
		} else {
			text=h;
		}
		if(!text) { text=sampleText;}
		text=tagOpen+text+tagClose;
		document.infoform.infobox.value=text;
		
		if(!SAFARI) {
			txtarea.focus();
		}
		noOverwrite=true;
	}
	
	if (txtarea.createTextRange) txtarea.caretPos = document.selection.createRange().duplicate();
}



var op=null;
try {



function pick() {
		for(var i=1; i <= id; i++) {
			if(i == 7 || i == 8) {
				$('#picker' + i).farbtastic('#panel' + i);
			}

			$('#panelbody' + i).jqm({
				trigger:'#panellink' + i,
				overlay: 0,
				onShow: function(h) {

					if(op != null) {
						op.w.jqmHide();
					}
					op=h;
					h.w.show();
				},
				onHide: function(h) {
					
					op=null;
					h.w.hide();
					if(h.o) h.o.remove();
				}
			});
		}
		$("#mymsg").mousedown(
			function () {
				if(op != null) {
					op.w.jqmHide();
				}
			}
		);
	}

} catch (e) {}

