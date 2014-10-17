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
								? ((c) - 'V') \
							 : ((c) == '\n') \
								? (char)-3 \
							 : ((c) == '\0') \
								? (char)-2 \
								: (char)-1 \
						) \
					)

char	*xs_undbmname(char *dst, char *src) {
	char	*save = dst;
	register	char	c, t;

	for(;t = *src++;) {
		c = unhex(t);
		switch(c) {
			case	(char)-3:
				*dst++ = '\n';
				break;
			case	(char)-1:
				break;
			default:
				t = *src++;
				t = unhex(t);
				switch(t) {
					case	(char)-3:
						*dst++ = '\n';
						break;
					case	(char)-2:
						*dst='\0';
						return save;
					case	(char)-1:
						break;
					default:
						*dst++ = c * 0x10 + t;
				}
		}
	}
	*dst='\0';
	return save;
}
