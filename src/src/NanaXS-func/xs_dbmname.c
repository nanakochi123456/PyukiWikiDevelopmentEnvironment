/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "../xslib/xslib.h"

#define	hexc(c)	((((c) < 10) ? ((c) + '0') : ((c) + '7')))

char	*xs_dbmname(char *dst, char *src) {
	char	*save = dst;
	register	char	c;

	for(; c = *src++;) {
		*dst++ = hexc((c) / 16);
		*dst++ = hexc((c) % 16);
	}
	*dst='\0';
	return save;
}
