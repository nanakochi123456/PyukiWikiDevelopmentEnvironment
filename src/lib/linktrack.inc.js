/*/////////////////////////////////////////////////////////////////////
# @@HEADER2_NANAMI@@
/////////////////////////////////////////////////////////////////////*/

// lk=this.href
// tg=b=_blank, r=right click

function Ck(lk,tg) {
	var	mypage, link,
		amp="&amp;", ck="?cmd=ck" + amp,
		valuep="p=", valuel="l=", u,
		d=document;

	mypage=hs('$::form{mypage}');
	link=hs(lk);

	var url=ck + p + mypage + amp + k + link;

	if(tg == 'r') {
		u=ck+ "r=y" + amp + valuep + mypage + amp + valuel + link;
		d.location=u;
		return true;
	} else if(tg != "") {
		ou(url, tg);
	} else {
		d.location=url;
	}
	return false;
}

function hs(str) {
	var ret="";
	for(var i=0; i < str.length; i++) {
		var chr=str.charCodeAt(i).toString(16).toUpperCase();
		ret=ret + chr;
	}
	return ret;
}
