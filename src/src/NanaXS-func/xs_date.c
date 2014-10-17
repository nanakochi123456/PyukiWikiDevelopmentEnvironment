/*
######################################################################
# @@HEADER4_NANAMI@@
######################################################################
*/

#include "../xslib/xslib.h"

char	*date_tmp;

void	xs_chg_sprintf(char *ret, char *fmt, char *spformat, int value) {
	if(xs_strstr(ret, fmt) != NULL) {
		sprintf(date_tmp, spformat, value);
		xs_strchg(ret, fmt, date_tmp);
	}
}

void	xs_chg_str(char *ret, char *fmt, char *chg) {
	if(xs_strstr(ret, fmt) != NULL) {
		xs_strchg(ret, fmt, chg);
	}
}

void	xs_chg_strn(char *ret, char *fmt, char *chg, int n) {
	if(xs_strstr(ret, fmt) != NULL) {
		strncpy(date_tmp, chg, n);
		date_tmp[n]='\0';
		xs_strchg(ret, fmt, date_tmp);
	}
}

int	xs_getwday(int year, int mon, int mday) {
	if(mon == 1 || mon == 2) {
		year--;
		mon += 12;
	}

	return (
		year + year / 4 - year / 100 + year / 400
		+ ((13 * mon + 8) / 5) + mday) % 7;
}

int	xs_lastday(int year, int mon) {
	switch(mon) {
		case	1:
		case	3:
		case	7:
		case	8:
		case	10:
		case	12:
			return 31;

		case	4:
		case	6:
		case	9:
		case	11:
			return 30;
	}

	return (
		28 +
			(year % 4 == 0 &&
				(year % 400 == 0 || year % 100 != 0)
			)
		);
}

char	*xs_date(
				char *ret,
				char *format, int tm, int gmtime_flg,
				int tz,
				char *res_ampm_en, char *res_ampm_locale,
				char *res_weekday_en, char *res_weekday_en_short,
				char *res_weekday_locale, char *res_weekday_locale_short) {

	time_t		timer;
	struct tm	*tmt;
	struct tm	*g_tm, *l_tm;
	int			sec, min, hour,
				mday, mon, year,
				wday, yday, isdst;
	int			hr12, ampm;
	char		*ampm_en, *ampm_locale,
				*weekday_en, *weekday_en_short,
				*weekday_locale, *weekday_locale_short;

	char	*monthname_array[13];

	monthname_array[1]="January";
	monthname_array[2]="February";
	monthname_array[3]="March";
	monthname_array[4]="April";
	monthname_array[5]="May";
	monthname_array[6]="June";
	monthname_array[7]="July";
	monthname_array[8]="August";
	monthname_array[9]="September";
	monthname_array[10]="October";
	monthname_array[11]="November";
	monthname_array[12]="December";

	ampm_en = (char *)xs_memalloc(STR_TMPLENGTH_1000);
	ampm_locale = (char *)xs_memalloc(STR_TMPLENGTH_1000);
	weekday_en = (char *)xs_memalloc(STR_TMPLENGTH_1000);
	weekday_en_short = (char *)xs_memalloc(STR_TMPLENGTH_1000);
	weekday_locale = (char *)xs_memalloc(STR_TMPLENGTH_1000);
	weekday_locale_short = (char *)xs_memalloc(STR_TMPLENGTH_1000);
	date_tmp = (char *)xs_memalloc(STR_TMPLENGTH_1000);

	strcpy(ret, format);

	if(tm > 0) {
		timer=tm;
	} else {
		time(&timer);
	}

	if(gmtime_flg) {
		tmt = gmtime(&timer);
	} else {
		tmt = localtime(&timer);
	}

	sec = tmt->tm_sec;
	min = tmt->tm_min;
	hour = tmt->tm_hour;
	mday = tmt->tm_mday;
	mon = tmt->tm_mon + 1;
	year = tmt->tm_year + 1900;
	wday = tmt->tm_wday;
	yday = tmt->tm_yday;

	hr12 = ((hour >= 12) ? hour - 12 : hour);
	ampm = ((hour >= 12) ? 1 : 0);

	/* am / pm strings */
	strcpy(ampm_en, xs_split(date_tmp, ",", res_ampm_en, ampm));
	strcpy(ampm_locale, xs_split(date_tmp, ",", res_ampm_locale, ampm));

	/* weekday strings */
	strcpy(weekday_en, xs_split(date_tmp, ",", res_weekday_en, wday));
	strcpy(weekday_en_short, xs_split(date_tmp, ",", res_weekday_en_short, wday));
	strcpy(weekday_locale,xs_split(date_tmp, ",", res_weekday_locale, wday));
	strcpy(weekday_locale_short, xs_split(date_tmp, ",", res_weekday_locale_short, wday));

	/* RFC822 (only this) */
	if(xs_strstr(ret, "r") != NULL) {
		strcpy(ret, "D, j M Y H:i:s O");
	}

	/* gmtime */
	xs_chg_sprintf(ret, "O", "%+03d:00", tz);

	/* gmtime sec */
	xs_chg_sprintf(ret, "Z", "%d", tz * 3600);

	/* internet time */
	if(xs_strstr(ret, "B") != NULL) {
		xs_chg_sprintf(ret, "B", "%03d", 
			((tm - tz * 3600 + 90000) / 86400 * 1000) % 1000
			);
	}

	/* unix time */
	xs_chg_sprintf(ret, "U", "%u", tm);

	/* Weekday escape */

	/* lL:escape Æü-ÅÚ */
	xs_chg_str(ret, "lL", "\x2\x13");

	/* DL:escape ÆüÍËÆü-ÅÚÍËÆü */
	xs_chg_str(ret, "DL", "\x2\x14");

	/* D:escape Sun-Sat */
	xs_chg_str(ret, "D", "\x2\x14");

	/* aL:escape ¸áÁ° or ¸á¸å */
	xs_chg_str(ret, "aL", "\x1\x13");

	/* AL:escape ¸áÁ° or ¸á¸å ¤ÎÂçÊ¸»ú*/
	xs_chg_str(ret, "AL", "\x1\x14");

	/* l:escape Sunday-Saturday */
	xs_chg_str(ret, "l", "\x2\x11");

	/* a:escape am pm */
	xs_chg_str(ret, "a", "\x1\x11");

	/* A:escape AM PM */
	xs_chg_str(ret, "A", "\x1\x12");

	/* M:escape Jan-Dec */
	xs_chg_str(ret, "M", "\x3\x11");

	/* F:escape January-December */
	xs_chg_str(ret, "F", "\x3\x12");

	/* ¤¦¤ë¤¦Ç¯ */
	if(xs_strstr(ret, "L") != NULL) {
		xs_chg_sprintf(ret, "L", "%d",
				(year / 4 == 0 &&
				(year % 400 == 0 || year % 100 != 0)
				) ? 1 : 0);
	}

	/* ¤³¤Î·î¤ÎÆü¿ô */
	if(xs_strstr(ret, "t") != NULL) {
		xs_chg_sprintf(ret, "t", "%d", xs_lastday(year, mon));
	}

	/* year 4char */
	xs_chg_sprintf(ret, "Y", "%04d", year);

	/* year 2char */
	xs_chg_sprintf(ret, "y", "%02d", year % 100);

	/* month */
	xs_chg_sprintf(ret, "n", "%d", mon);
	xs_chg_sprintf(ret, "m", "%02d", mon);

	/* day */
	xs_chg_sprintf(ret, "j", "%d", mday);
	xs_chg_sprintf(ret, "d", "%02d", mday);

	/* hour */
	xs_chg_sprintf(ret, "g", "%d", hr12);	/* g:1-12 */
	xs_chg_sprintf(ret, "G", "%d", hour);	/* G:0-23 */
	xs_chg_sprintf(ret, "h", "%02d", hr12);/* h:01-12 */
	xs_chg_sprintf(ret, "H", "%02d", hour);/* H:00-23 */

	/* minutes */
	xs_chg_sprintf(ret, "k", "%d", min);	/* k:0-59 */
	xs_chg_sprintf(ret, "i", "%02d", min);	/* i;00-59 */

	/* second */
	xs_chg_sprintf(ret, "S", "%d", sec);	/* S:0-59 */
	xs_chg_sprintf(ret, "s", "%02d", sec);	/* s:00-59 */

	/* wday */
	xs_chg_sprintf(ret, "w", "%d", wday);	/* w:0-6 */

	/* isdst */
	xs_chg_sprintf(ret, "I", "%d", isdst);	/* I:0,1 */

	/* a:am or pm */
	xs_chg_str(ret, "\x1\x11", ampm_en);

	/* A:AM or PM */
	xs_chg_str(ret, "\x1\x12", xs_strupr(ampm_en));

	/* aL:¸áÁ° or ¸á¸å */
	xs_chg_str(ret, "\x1\x13", ampm_locale);

	/* AL:¸áÁ° or ¸á¸å¤ÎÂçÊ¸»ú */
	xs_chg_str(ret, "\x1\x14", xs_strupr(ampm_locale));

	/* l:Sunday-Saturday */
	xs_chg_str(ret, "\x2\x11", weekday_en);

	/* D:Sun-Sat */
	xs_chg_str(ret, "\x2\x12", weekday_en_short);

	/* lL:Æü-ÅÚ */
	xs_chg_str(ret, "\x2\x13", weekday_locale_short);

	/* DL:ÆüÍËÆü-ÅÚÍËÆü */
	xs_chg_str(ret, "\x2\x14", weekday_locale);

	/* M:Jan-Dec */
	xs_chg_strn(ret, "\x3\x11", monthname_array[mon], 3);

	/* F:January-December */
	xs_chg_str(ret, "\x3\x12", monthname_array[mon]);

	/* z:days/year 0-366 */
	xs_chg_sprintf(ret, "z", "%d", yday);

	xs_memfree(date_tmp);
	xs_memfree(weekday_locale_short);
	xs_memfree(weekday_locale);
	xs_memfree(weekday_en_short);
	xs_memfree(weekday_en);
	xs_memfree(ampm_locale);
	xs_memfree(ampm_en);

	return (ret);
}
