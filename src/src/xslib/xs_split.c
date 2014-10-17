/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "xslib.h"

char	*xs_split(char *buf, char *split, char *src, int n) {
	char	*pt;
	int		i;

	strcpy(buf, src);

	pt = strtok(buf, split);
	if(pt == NULL) {
		return src;
	}
	if(n == 0) {
		return pt;
	}

	for(i = 1; (pt = strtok(NULL, split)) != NULL && i < n; i++);

	return pt;
}
