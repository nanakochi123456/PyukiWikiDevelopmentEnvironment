/* @@PYUKIWIKIVERSIONSHORT@@
 * $Id$
 */



var d=document;

function _db(str) {
	if(window["console"] || d["console"]) {
		eval("console.log(str)");
	}
	var f=d.getElementById("db_js");
	if(!f)
		f=gf("dbform", "db_js");

	if(f) {
		f.value=f.value + str + "\n";
	}
}

function _Display(id,mode){
	var obj;
	if(d.all || d.getElementById){	//IE4, NN6 or later
		if(d.all){
			obj = d.all(id).style;
		} else if(d.getElementById){
			obj = d.getElementById(id).style;
		}
		if(mode == "view") {
			obj.display = "block";
		} else if(mode == "none") {
			obj.display = "none";
		} else if(obj.display == "block"){
			obj.display = "none";		//hidden
		}else if(obj.display == "none"){
			obj.display = "block";		//view
		}
	}
}
