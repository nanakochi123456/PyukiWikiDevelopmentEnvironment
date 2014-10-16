#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

if($ARGV[0] eq "lite") {
	@CHANGES=(
		'\$::useExPlugin\s?=\s?1;	$::useExPlugin=0;',
		'\$::usefacemark\s?=\s?1;	$::usefacemark=0;',
		'\$::use_popup\s?=\s?[0-3];	$::use_popup=0;',
		'\$::allview\s?=\s?1;	$::allview=0;',
		'\$::recent_format\s?=\s?"Y-m-d(lL) H:i:s";	$::recent_format="Y-m-d H:i:s";',
		'\$::extend_edit\s?=\s?1;	$::extend_edit=0;',
		'\$::pukilike_edit\s?=\s?[0-3];	$::pukilike_edit=0;',
		'\$::edit_afterpreview\s?=\s?1;	$::edit_afterpreview=0;',
		'\#\$::new_refer	$::new_refer',
		'\$::new_dirnavi\s?=\s?1;	$::new_dirnavi=0;',
		'\$::usePukiWikiStyle\s?=\s?1;	$::usePukiWikiStyle=0;',
		'\$::nowikiname\s?=\s?0;	$::nowikiname=1;',
		'\$::automaillink\s?=\s?1;	$::automaillink=0;',
		'\$::file_uploads\s?=\s?3;	$::file_uploads=1;',
		'\$::use_FuzzySearch\s?=\s?1;	$::use_FuzzySearch=0;',
		'\$::use_Highlight\s?=\s?1;	$::use_Highlight=0;',
		'\$::no_HelpLink\s?=\s?0;		$::no_HelpLink=1;',
		'\$::write_location\s?=\s?1;	$::write_location=0;',
		'\$::useBackUp\s?=\s?1;	$::useBackUp=0;',
		'\$::partedit\s?=\s?1;	$::partedit=0;',
		'\$::toolbar\s?=\s?2;	$::toolbar=1;',
		'\$::useTopicPath\s?=\s?1;	$::useTopicPath=0;',
		'\$::use_Setting\s?=\s?1;	$::use_Setting=0;',
		'\$::use_SkinSel\s?=\s?1;	$::use_SkinSel=0;',
		'\$::nowikiname\s?=\s?0;	$::nowikiname=1;',
		'\$::autourllink\s?=\s?1;	$::autourllink=0;',
		'\$::automaillink\s?=\s?1;	$::automaillink=0;',
		'\$::use_autoimg\s?=\s?1;	$::use_autoimg=0;',
		'\$::time_format\s?=\s?"H:i:s";	$::time_format="H:i";',	
		'\$::now_format\s?=\s?"Y-m-d(lL) H:i:s";	$::now_format="Y-m-d H:i";',
		'\$::lastmod_format\s?=\s?"Y-m-d(lL) H:i:s";	$::lastmod_format="Y-m-d H:i";',
		'\$::recent_format\s?=\s?"Y-m-d(lL) H:i:s";	$::recent_format="Y-m-d H:i";',
		'\$::backup_format\s?=\s?"Y-m-d(lL) H:i:s";	$::backup_format="Y-m-d H:i";',
		'\$::attach_format\s?=\s?"Y-m-d(lL) H:i:s";	$::attach_format="Y-m-d H:i";',
		'\$::ref_format\s?=\s?"Y-m-d(lL) H:i:s";	$::ref_format="Y-m-d H:i";',
		'\$::new_dirnavi\s?\s?1;	$::new_dirnavi=0;',
		'\$::auto_meta_maxkeyword\s?=\s?(\d*?);	$::auto_meta_maxkeyword=0;',
	#	'^\x09#\s.*	',
	#	'^#\$.*	'
	);

} elsif($ARGV[0] eq "secure") {
	@CHANGES=(
		'\$::newpage_auth\s?=\s?0;	$::newpage_auth=1;',
	);
}

open(R,"pyukiwiki.ini.cgi");
foreach $f(<R>) {
	foreach $r(@CHANGES) {
		($s,$e)=split(/\t/,$r);
		$f=~s!$s!$e!g;
	}
	print $f;
}
close(W);
close(R);
