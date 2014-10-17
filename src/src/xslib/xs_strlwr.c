/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "xslib.h"

char	*xs_strlwr(char *s) {
	char	*str=s;
	char	c;

	for(; (c = *str); str++) {
		*str=xs_tolower(c);
	}
	return s;
}
