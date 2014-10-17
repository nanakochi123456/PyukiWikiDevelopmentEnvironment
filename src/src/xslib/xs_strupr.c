/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "xslib.h"

char	*xs_strupr(char *s) {
	char	*str=s;
	char	c;	
	for(; (c = *str); str++) {
		*str=xs_toupper(c);
	}
	return s;
}
