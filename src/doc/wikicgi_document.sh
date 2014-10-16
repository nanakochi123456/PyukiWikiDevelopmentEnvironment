#!/bin/sh

pod2wiki() {
	export	REQUEST_METHOD="GET"
	export	QUERY_STRING="cmd=perlpod"

	perl index.cgi $2 | perl -pe 's/\#/\&\#x23;/g;s/\&/\&amp;/g;'> $2.ja.pod.1
	if test "$?" != "0"; then
		exit 1;
	fi
	cat $2.ja.pod.1|perl -pe '$flg=0;while(<STDIN>) {$flg=0 if(/\xbb\xb2\xb9\xcd/);$flg=0 if(/\xe5\x8f\x82\ex8\x80\x83/);$flg=1 if(/^\*\*/); print $_ if($flg);$flg=1 if(/^\*\*NAME/);}'>$2.ja.pod.2
	echo $2|sed -e 's/\.ja.pod//g' | sed -e 's/.*\//\*/g' > $2.ja.pod.3
	cat $2.ja.pod.2 >> $2.ja.pod.3
	cat $2.ja.pod.3 | perl -pe 's/\x5/\&\#x23;/g;s/\x6/\&\#x26;/g;s/\x4/\&\#x3a;/g;s/(\&|\&amp;)br;/&br;/g;'|perl -pe 's/&amp;#x23;/#/g; s/&amp;/&/g;' >> $2.ja.pod.4
	cat $2.ja.pod.4 >> $1
	cat $2.ja.pod.4 >> doc/specification_wikicgi.ja.wiki
	rm -f $2.ja.pod.1 $2.ja.pod.2 $2.ja.pod.3 $2.ja.pod.4


}

rm -f doc/wikicgi_*.ja.wiki

echo "*内部モジュール仕様">doc/specification_wikicgi.ja.wiki
echo "<<\$Id\$>>">>doc/specification_wikicgi.ja.wiki
echo "#contents(,2)">>doc/specification_wikicgi.ja.wiki

echo "*内部モジュール仕様 - wiki.cgi">doc/wikicgi_wikicgi.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikicgi.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikicgi.ja.wiki
pod2wiki doc/wikicgi_wikicgi.ja.wiki lib/wiki.cgi

echo "*内部モジュール仕様 - wiki_auth.cgi">doc/wikicgi_wikiauth.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikiauth.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikiauth.ja.wiki
pod2wiki doc/wikicgi_wikiauth.ja.wiki lib/wiki_auth.cgi

echo "*内部モジュール仕様 - wiki_db.cgi">doc/wikicgi_wikidb.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikidb.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikidb.ja.wiki
pod2wiki doc/wikicgi_wikidb.ja.wiki lib/wiki_db.cgi

echo "*内部モジュール仕様 - wiki_func.cgi">doc/wikicgi_wikifunc.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikifunc.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikifunc.ja.wiki
pod2wiki doc/wikicgi_wikifunc.ja.wiki lib/wiki_func.cgi

echo "*内部モジュール仕様 - wiki_html.cgi">doc/wikicgi_wikihtml.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikihtml.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikihtml.ja.wiki
pod2wiki doc/wikicgi_wikihtml.ja.wiki lib/wiki_html.cgi

echo "*内部モジュール仕様 - wiki_http.cgi">doc/wikicgi_wikihttp.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikihttp.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikihttp.ja.wiki
pod2wiki doc/wikicgi_wikihttp.ja.wiki lib/wiki_http.cgi

echo "*内部モジュール仕様 - wiki_init.cgi">doc/wikicgi_wikiinit.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikiinit.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikiinit.ja.wiki
pod2wiki doc/wikicgi_wikiinit.ja.wiki lib/wiki_init.cgi

echo "*内部モジュール仕様 - wiki_link.cgi">doc/wikicgi_wikilink.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikilink.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikilink.ja.wiki
pod2wiki doc/wikicgi_wikilink.ja.wiki lib/wiki_link.cgi

echo "*内部モジュール仕様 - wiki_plugin.cgi">doc/wikicgi_wikiplugin.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikiplugin.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikiplugin.ja.wiki
pod2wiki doc/wikicgi_wikiplugin.ja.wiki lib/wiki_plugin.cgi

echo "*内部モジュール仕様 - wiki_skin.cgi">doc/wikicgi_wikiskin.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikiskin.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikiskin.ja.wiki
pod2wiki doc/wikicgi_wikiskin.ja.wiki lib/wiki_skin.cgi

echo "*内部モジュール仕様 - wiki_spam.cgi">doc/wikicgi_wikispam.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikispam.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikispam.ja.wiki
pod2wiki doc/wikicgi_wikispam.ja.wiki lib/wiki_spam.cgi

echo "*内部モジュール仕様 - wiki_wiki.cgi">doc/wikicgi_wikiwiki.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikiwiki.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikiwiki.ja.wiki
pod2wiki doc/wikicgi_wikiwiki.ja.wiki lib/wiki_wiki.cgi

echo "*内部モジュール仕様 - wiki_write.cgi">doc/wikicgi_wikiwrite.ja.wiki
echo "<<\$Id\$>>">>doc/wikicgi_wikiwrite.ja.wiki
echo "#contents(,1)">>doc/wikicgi_wikiwrite.ja.wiki
pod2wiki doc/wikicgi_wikiwrite.ja.wiki lib/wiki_write.cgi

