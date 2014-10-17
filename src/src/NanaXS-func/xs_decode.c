/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "../xslib/xslib.h"

#define	unhex(c)	( \
						( \
							(xs_isdigit(c)) \
							 ? ((c) - '0') \
							 : (xs_isxdigitb(c)) \
								? ((c) - '7') \
							 : (xs_isxdigita(c)) \
								? ((c) - 'W') \
								: -1 \
						) \
					)

char	*xs_decode(char *dst, char *src) {
	char	*save = dst;
	register	char	c, t;

	for(;t = *src++;) {
		if(t == '+') {
			*dst++ = ' ';
		} else if(t == '%') {
			t = *src++;
			c = unhex(t) * 0x10;
			if(c == -1) {
				return NULL;
			}
			t = *src++;
			c += unhex(t);
			if(c == -1) {
				return NULL;
			}
			*dst++ = c;
		} else {
			*dst++ = t;
		}
	}
	*dst='\0';
	return save;
}
