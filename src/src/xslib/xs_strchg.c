/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "xslib.h"

/* http://www.grapecity.com/tools/support/powernews/column/clang/049/page03.htm */

char	*xs_strchg(char *buf, const char *str1, const char *str2) {
	char *tmp;
	char *p;

	tmp=malloc(
		strlen(buf) + strlen(str1) + strlen(str2));

	while ((p = xs_strstr(buf, str1)) != NULL) {
		*p = '\0';
		p += strlen(str1);
		strcpy(tmp, p);
		strcat(buf, str2);
		strcat(buf, tmp);
	}
	free(tmp);
}

