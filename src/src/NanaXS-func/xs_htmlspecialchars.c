/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "../xslib/xslib.h"

char	*sgmlescape[]={
	"Aacute",
	"Acirc",
	"Agrave",
	"Aring",
	"Atilde",
	"Auml",
	"Ccedil",
	"Dagger",
	"ETH",
	"Eacute",
	"Ecirc",
	"Egrave",
	"Euml",
	"Iacute",
	"Icirc",
	"Igrave",
	"Iuml",
	"Ntilde",
	"Oacute",
	"Ocirc",
	"Ograve",
	"Oslash",
	"Otilde",
	"Oumltimes",
	"THORN",
	"Uacute",
	"Ucirc",
	"Ugrave",
	"Uuml",
	"Yacute",
	"aacute",
	"acirc",
	"acute",
	"aelig",
	"agrave",
	"amp",
	"aring",
	"atilde",
	"auml",
	"bdquo",
	"bigsmile",
	"brvbar",
	"bull",
	"ccedil",
	"cedil",
	"cent",
	"copy",
	"curren",
	"dagger",
	"deg",
	"divide",
	"eacute",
	"ecirc",
	"egrave",
	"eth",
	"euml",
	"euro",
	"frac12",
	"frac14",
	"frac34",
	"heart",
	"huh",
	"iacute",
	"icirc",
	"iexcl",
	"igrave",
	"iquest",
	"iuml",
	"laquo",
	"ldquo",
	"lsquo",
	"macr",
	"mdash",
	"micro",
	"middot",
	"nbsp",
	"ndash",
	"not",
	"ntilde",
	"oacute",
	"ocirc",
	"ograve",
	"oh",
	"ordf",
	"ordm",
	"oslash",
	"otilde",
	"ouml",
	"para",
	"permil",
	"plusmn",
	"pound",
	"raquo",
	"rdquo",
	"reg",
	"rsquo",
	"sad",
	"sbquo",
	"sect",
	"shy",
	"smile",
	"sup1",
	"sup2",
	"sup3",
	"szlig",
	"thorn",
	"trade",
	"uacute",
	"ucirc",
	"ugrave",
	"uml",
	"uuml",
	"wink",
	"worried",
	"yacute",
	"yen",
	"yuml",
};

char	*xs_htmlspecialchars(char *dst, char *src, int flg) {
	char	tmp1[20];
	char	tmp2[20];
	int		i;

	xs_strchg(dst, "&",  "&amp;");
	xs_strchg(dst, "<",  "&lt;");
	xs_strchg(dst, ">",  "&gt;");
	xs_strchg(dst, "\"", "&quat;");
	if(flg) {
		return dst;
	}

	strcpy(tmp1, "&amp;");
	strcpy(tmp2, "&");

	for(i = 0; i < 117; i++) {
		strcpy(tmp1 + 5, sgmlescape[i]);
		strcat(tmp1 + 5, ";");
		strcpy(tmp2 + 1, sgmlescape[i]);
		strcat(tmp2 + 1, ";");
		xs_strchg(dst, tmp1, tmp2);
	}

	xs_strchg(dst, "&amp;#",  "&#");
	return dst;
}

char	*xs_javascriptspecialchars(char *dst, char *src, int flg) {
	char	tmp1[20];
	char	tmp2[20];
	int		i;

	xs_strchg(dst, "&",  "&amp;");
	xs_strchg(dst, "<",  "&lt;");
	xs_strchg(dst, ">",  "&gt;");
	xs_strchg(dst, "\"", "&quat;");
	xs_strchg(dst, "\'", "&apos;");
	if(flg) {
		return dst;
	}

	strcpy(tmp1, "&amp;");
	strcpy(tmp2, "&");

	for(i = 0; i < 117; i++) {
		strcpy(tmp1 + 5, sgmlescape[i]);
		strcat(tmp1 + 5, ";");
		strcpy(tmp2 + 1, sgmlescape[i]);
		strcat(tmp2 + 1, ";");
		xs_strchg(dst, tmp1, tmp2);
	}

	xs_strchg(dst, "&amp;#",  "&#");
	return dst;
}
