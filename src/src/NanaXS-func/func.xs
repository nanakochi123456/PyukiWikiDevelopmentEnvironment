/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#define	XS	1
#include "../xslib/xslib.h"

MODULE = NanaXS::func		PACKAGE = NanaXS::func

SV *
dbmname(src)
	char	*src;

	PROTOTYPE: $

	PREINIT:
	char	*dst;
	STRLEN	len;

	CODE:
		len = strlen(src) *  2;
		Newx(dst, len + 1, char);
		xs_dbmname(dst, src);
		RETVAL = newSVpv(dst, len);

	OUTPUT:
		RETVAL

SV *
undbmname(src)
	char	*src;

	PROTOTYPE: $

	PREINIT:
	char	*dst;

	CODE:
		Newx(dst, strlen(src)  + 1, char);
		xs_undbmname(dst, src);
		RETVAL = newSVpv(dst, strlen(dst));

	OUTPUT:
		RETVAL

SV *
encode(src)
	char	*src;

	PROTOTYPE: $

	PREINIT:
	char	*dst;

	CODE:
		Newx(dst, strlen(src) *  3 + 1, char);
		xs_encode(dst, src);
		RETVAL = newSVpv(dst, strlen(dst));

	OUTPUT:
		RETVAL

SV *
decode(src)
	char	*src;

	PROTOTYPE: $

	PREINIT:
	char	*dst;

	CODE:
		Newx(dst, strlen(src) *  3 + 1, char);
		xs_decode(dst, src);
		RETVAL = newSVpv(dst, strlen(dst));

	OUTPUT:
		RETVAL

SV *
xdate(format, tm, gmtime_flg, tz, res_ampm_en, res_ampm_locale, res_weekday_en, res_weekday_en_short, res_weekday_locale, res_weekday_locale_short)
	char	*format;
	int		tm;
	int		gmtime_flg;
	int		tz;
	char	*res_ampm_en;
	char	*res_ampm_locale;
	char	*res_weekday_en;
	char	*res_weekday_en_short;
	char	*res_weekday_locale;
	char	*res_weekday_locale_short;

	PROTOTYPE: $$$%

	PREINIT:
	char	*dst;
	HV		*hv;
	char	*hkey;
	I32		hkeylen;
	SV		*value;

	CODE:
		Newx(dst, STR_TMPLENGTH_10000, char);
		xs_date(dst, format, tm, gmtime_flg,
				tz,
				res_ampm_en, res_ampm_locale,
				res_weekday_en, res_weekday_en_short,
				res_weekday_locale, res_weekday_locale_short);

		RETVAL = newSVpv(dst, strlen(dst));

	OUTPUT:
		RETVAL

SV *
htmlspecialchars(src, flg)
	char	*src;
	int		flg;

	PROTOTYPE: $$

	PREINIT:
	char	*dst;

	CODE:
		Newx(dst, strlen(src) * 2, char);
		xs_htmlspecialchars(dst, src, flg);
		RETVAL = newSVpv(dst, strlen(dst));

	OUTPUT:
		RETVAL

SV *
javascriptspecialchars(src, flg)
	char	*src;
	int		flg;

	PROTOTYPE: $$

	PREINIT:
	char	*dst;

	CODE:
		Newx(dst, strlen(src) * 2, char);
		xs_javascriptspecialchars(dst, src, flg);
		RETVAL = newSVpv(dst, strlen(dst));

	OUTPUT:
		RETVAL
