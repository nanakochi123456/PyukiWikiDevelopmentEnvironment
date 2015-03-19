/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */




function tdiarypreview(o) {
	var linkObjs = document.getElementsByTagName('link');
	var selObj = o;
	for(i=0; i<linkObjs.length; i++){
		if(linkObjs.item(i).href.indexOf("theme") >= 0) {
			linkObjs.item(i).disabled = true;
		}
	}
	for(i=0; i<linkObjs.length; i++){
		if((linkObjs.item(i).href.indexOf("theme") >= 0) &&
		   linkObjs.item(i).href.indexOf(selObj.value) != -1) {
			linkObjs.item(i).disabled = false;
		}
	}
}
