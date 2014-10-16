#!/bin/sh
# PyukiWiki Document builder
# $Id$


pod2wiki() {
	export	REQUEST_METHOD="GET"
	export	QUERY_STRING="cmd=perlpod"

	perl index.cgi $2.ja.pod | perl -pe 's/\#/\&\#x23;/g;s/\&/\&amp;/g;'> $2.ja.pod.1
	if test "$?" != "0"; then
		exit 1;
	fi
	cat $2.ja.pod.1|perl -pe '$flg=0;while(<STDIN>) {$flg=0 if(/\xbb\xb2\xb9\xcd/);$flg=0 if(/\xe5\x8f\x82\ex8\x80\x83/);print $_ if($flg);$flg=1 if(/^\*\*NAME/);}'>$2.ja.pod.2
	echo $2|sed -e 's/\.ja.pod//g' | sed -e 's/.*\//\*/g' > $2.ja.pod.3
	cat $2.ja.pod.2 >> $2.ja.pod.3
	cat $2.ja.pod.3 | perl -pe 's/\x5/\&\#x23;/g;s/\x6/\&\#x26;/g;s/\x4/\&\#x3a;/g;s/(\&|\&amp;)br;/&br;/g;'|perl -pe 's/&amp;#x23;/#/g; s/&amp;/&/g;' >> $2.ja.pod.4
	cat $2.ja.pod.4 >> $1
	cat $2.ja.pod.4 >> doc/plugin_all.ja.wiki
	rm -f $2.ja.pod.1 $2.ja.pod.2 $2.ja.pod.3 $2.ja.pod.4


}

rm -f doc/plugin_*.ja.wiki

echo "*PyukiWikiプラグイン">doc/plugin_all.ja.wiki
echo "<<\$Id\$>>">>doc/plugin_all.ja.wiki
echo "#contents(,1)">>doc/plugin_all.ja.wiki

echo "*PyukiWiki管理者向けプラグイン">doc/plugin_admin.ja.wiki
echo "<<\$Id\$>>">>doc/plugin_admin.ja.wiki
echo "#contents(,1)">>doc/plugin_admin.ja.wiki

pod2wiki doc/plugin_admin.ja.wiki plugin/admin.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/adminchangepassword.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/adminedit.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/compressbackup.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/convertutf8.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/counter_viewer.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/deletecache.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/freezeconvert.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/listfrozen.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/logs_viewer.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/perlpod.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/rename.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/server.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/servererror.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/setupeditor.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/sitemaps.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/stdin.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/topicpath.inc.pl
pod2wiki doc/plugin_admin.ja.wiki plugin/versionlist.inc.pl

rm -f doc/plugin_explugin.ja.wiki
echo "*PyukiWiki Explugin">doc/plugin_explugin.ja.wiki
echo "<<\$Id\$>>">>doc/plugin_explugin.ja.wiki
echo "#contents(,1)">>doc/plugin_explugin.ja.wiki

pod2wiki doc/plugin_explugin.ja.wiki lib/aguse.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/antispam.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/antispamwiki.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/authadmin_cookie.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/autometarobot.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/canonical.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/captcha.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/cdn.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/google_analytics.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/google_translate.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/iecompatiblehack.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/ignoreoldbrowser.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/lang.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/linktrack.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/logs.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/ogp.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/pathmenu.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/ping.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/punyurl.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/slashpage.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/stdin.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/trackback.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/urlhack.inc.pl
pod2wiki doc/plugin_explugin.ja.wiki lib/xframe.inc.pl

rm -f doc/plugin_plugin_ah.ja.wiki
echo "*PyukiWiki プラグイン (A-H)">doc/plugin_plugin_ah.ja.wiki
echo "<<\$Id\$>>">>doc/plugin_plugin_ah.ja.wiki
echo "#contents(,1)">>doc/plugin_plugin_ah.ja.wiki

pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/agent.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/alias.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/aname.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/article.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/attach.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/back.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/backlink.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/backup.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/br.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/bugtrack.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/calendar.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/calendar2.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/captcha.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/ck.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/clear.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/color.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/comment.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/contents.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/counter.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/date.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/diff.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/download.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/edit.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/env.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/font.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/googlemap.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/help.inc.pl
pod2wiki doc/plugin_plugin_ah.ja.wiki plugin/hr.pl

rm -f doc/plugin_plugin_ip.ja.wiki
echo "*PyukiWiki プラグイン (I-P)">doc/plugin_plugin_ip.ja.wiki
echo "<<\$Id\$>>">>doc/plugin_plugin_ip.ja.wiki
echo "#contents(,1)">>doc/plugin_plugin_ip.ja.wiki

pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/img.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/include.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/ipv6check.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/link.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/links.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/list.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/location.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/lookup.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/ls2.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/mailform.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/metarobots.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/multiarticle.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/multicomment.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/multimailform.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/navi.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/new.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/newpage.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/nofollow.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/now.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/online.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/opml.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/pagenavi.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/pcomment.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/popular.inc.pl
pod2wiki doc/plugin_plugin_ip.ja.wiki plugin/popup.inc.pl

rm -f doc/plugin_plugin_rz.ja.wiki
echo "*PyukiWiki プラグイン (R-Y)">doc/plugin_plugin_rz.ja.wiki
echo "<<\$Id\$>>">>doc/plugin_plugin_rz.ja.wiki
echo "#contents(,1)">>doc/plugin_plugin_rz.ja.wiki

pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/recent.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/ref.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/rss.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/rss10.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/rsspage.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/rss10page.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/ruby.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/sbookmark.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/search.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/search_fuzzy.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/setlinebreak.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/setting.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/showrss.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/sitemap.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/sitemaps.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/size.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/skin.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/smedia.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/source.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/star.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/sub.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/sup.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/tb.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/time.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/title.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/twitter.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/verb.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/vote.inc.pl
pod2wiki doc/plugin_plugin_rz.ja.wiki plugin/yetlist.inc.pl
