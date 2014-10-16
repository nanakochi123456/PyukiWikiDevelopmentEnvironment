/*/////////////////////////////////////////////////////////////////////
# @@HEADER2_NANAMI@@
/////////////////////////////////////////////////////////////////////*/

function ViewPassForm(id,mode){
	var	obj,
		block="block",
		none="none";

	if(d.all || d.getElementById){	//IE4, NN6 or later
		if(d.all){
			obj = d.all(id).style;
		}else if(d.getElementById){
			obj = d.getElementById(id).style;
		}
		if(mode == "view") {
			obj.display = block;
		} else if(mode == none) {
			obj.display = none;
		} else if(obj.display == block){
			obj.display = none;		//hidden
		}else if(obj.display == none){
			obj.display = block;		//view
		}
	}
}
