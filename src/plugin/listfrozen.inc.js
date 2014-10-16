/*/////////////////////////////////////////////////////////////////////
# @@HEADER2_NANAMI@@
/////////////////////////////////////////////////////////////////////*/

function allcheckbox(v) {
	var	f=d.getElementById("sel"),
		len=f.elements.length;

	for(i=0;i<len;i++) {
		l=f.elements[i];
		if(l.type == "checkbox") {
			if(v == 1) {
				if(!l.checked) {
					l.click();
				}
			} else {
				if(l.checked) {
					l.click();
				}
			}
		}
	}
}
