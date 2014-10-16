# release file makefile for pyukiwiki 
# $Id$

ARCHIVEDIR=./archive
BUILDDIR=./build
TEMP=./temp
RELEASE=./release

SH?=/usr/local/bin/bash
#SH?=/bin/sh
PERL=perl

TAR=tar cvf
#ZIP=zip -9 -r
#GZIP=gzip -9
#BZIP=bzip2 -9
#XZ=xz -9

# vv use this...
GZIP_7Z=7za a -tgzip -mx9 -mpass=10 -mfb=256
BZIP2_7Z=7za a -tbzip2 -mx9 -mpass=10 -md=100m
XZ_7Z=7za a -txz -mx9 -m0=BCJ2 -m1=LZMA:d23
ZIP_7Z=7za a -tzip -mx9 -mpass=10 -mfb=256
7Z_7Z=7za a -t7z -m1=LZMA:d25:fb255 -m2=LZMA:d19 -m3=LZMA:d19 -mb0:1 -mb0s1:2 -mb0s2:3 -mx

#GZIP_JC=gzip -9 >
GZIP_JC=7za a -tgzip -mx9 -si

POD2HTML=pod2html
HTML2TEXT=w3m

PKGNAME=pyukiwiki

######################################################
export ARCHIVEDIR
export BUILDDIR
export TEMP
export RELEASE
export SH
export PERL
export TAR
export ZIP
export GZIP
export BZIP
export XZ
export GZIP_7Z
export BZIP2_7Z
export XZ_7Z
export ZIP_7Z
export 7Z_7Z
export GZIP_JC
export PKGNAME

VERSION= `perl -e '$$ARGV[0]="version";if(-f "./build/getversion.pl"){ require "./build/getversion.pl" }elsif(-f "../../build/getversion.pl"){ require "../../build/getversion.pl";};'`
export VERSION

all:
	@echo "PyukiWIki ${VERSION} Release Builder"
	@echo "Usage: ${MAKE} [build|builddoc|prof|release|buildrelease|buildreleaseutf8|builddevel|builddevelutf8|buildcompact|buildcompactutf8|pkg|clean|realclean|cvsclean|ftp]"

version:
	@echo "PyukiWIki ${VERSION}"

BUILDMAKER=${BUILDDIR}/makesampleini.pl \
			${BUILDDIR}/Jcode-convert.pl \
			${BUILDDIR}/lang.pl \
			${BUILDDIR}/getversion.pl \
			${BUILDDIR}/build.mk \
			${BUILDDIR}/build_doc.mk \
			${BUILDDIR}/build_xs.mk \
			${BUILDDIR}/build.pl \
			${BUILDDIR}/compactmagic.pl \
			${BUILDDIR}/compressfile.pl \
			${BUILDDIR}/text.pl \
			${BUILDDIR}/makeinstaller.sh \
			${BUILDDIR}/installer.sh \
			${BUILDDIR}/installer2.sh \
			${BUILDDIR}/installer_sub.sh \
			${BUILDDIR}/b64decode.pl \
			${BUILDDIR}/base64.pl \
			${BUILDDIR}/makewikisub.pl \
			Makefile

BUILDDOCS=\
			README.ja.txt \
			./build/CGI_INSTALLER.ja.txt \
			DEVEL.ja.txt \
			document/sample.ja.txt \
			document/htaccess-sample.ja.txt \
			document/specification.ja.txt \
			document/specification_wikicgi.ja.txt \
			README.ja.html \
			document/README.ja.html \
			document/menu.ja.html \
			./build/CGI_INSTALLER.ja.html \
			document/DEVEL.ja.html \
			document/sample.ja.html \
			document/htaccess-sample.ja.html \
			document/specification.ja.html \
			document/specification_wikicgi.ja.html \
			document/specification_xs.ja.html \
			document/specification_xs.ja.txt \
			document/plugin_admin.ja.txt \
			document/plugin_explugin.ja.txt \
			document/plugin_all.ja.txt \
			document/plugin_admin.ja.html \
			document/plugin_explugin.ja.html \
			document/plugin_plugin_ah.ja.html \
			document/plugin_plugin_ip.ja.html \
			document/plugin_plugin_rz.ja.html \
			doc/plugin_admin.ja.wiki \
			doc/plugin_explugin.ja.wiki \
			doc/plugin_plugin_ah.ja.wiki \
			doc/plugin_plugin_ip.ja.wiki \
			doc/plugin_plugin_rz.ja.wiki \
			build/license_art.en.html \
			build/license_art.ja.html \
			build/license_gpl.en.html \
			build/license_gpl.ja.html \
			document/plugindoc-ad.ja.html \
			document/plugindoc-ad.ja.txt \
			document/plugindoc-bookmark.ja.html \
			document/plugindoc-bookmark.ja.txt \
			document/plugindoc-exdate.ja.html \
			document/plugindoc-exdate.ja.txt \
			document/plugindoc-htmlhead.ja.html \
			document/plugindoc-htmlhead.ja.txt \
			document/plugindoc-playvideo.ja.html \
			document/plugindoc-playvideo.ja.txt \
			document/plugindoc-qrcode.ja.html \
			document/plugindoc-qrcode.ja.txt \
			document/plugindoc-sh.ja.html \
			document/plugindoc-sh.ja.txt \


builddoc:FORCE ${BUILDDOCS} ${BUILDMAKER}

######################
temp/head.html: doc/head.html temp/installer.css
	@perl build/build.pl cp "./temp" "0644" "doc/head.html" "./temp/head.html" "devel" "lf" "euc" "all" >/dev/null

DOC=${BUILDFILES} ${BUILDMAKER}

######################
%.html : %.wiki temp/head.html doc/foot.html temp/installer.css ${DOC}
	mkdir -p ${TEMP}
	perl build/build.pl cp "./temp" "0644" "$<" "$@.1" "devel" "lf" "euc" "all" >/dev/null
	cat $@.1 | REQUEST_METHOD="GET" QUERY_STRING="cmd=stdin" perl index.cgi |nkf -w -E > $@.2
	cat temp/head.html $@.2 doc/foot.html > $@.3
	perl build/compressfile.pl html $@  $@.3

######################
%.txt : %.wiki temp/head.html doc/foot.html temp/installer.css ${DOC}
	mkdir -p ${TEMP}
	perl build/build.pl cp "./temp" "0644" "$<" "$@.1" "devel" "lf" "euc" "all" >/dev/null
	cat $@.1 | REQUEST_METHOD="GET" QUERY_STRING="cmd=stdin" perl index.cgi |nkf -w > $@.2
	cat temp/head.html $@.2 doc/foot.html > $@.3
	cat $@.3 |grep -v jumpmenu > $@.3.html
	w3m $@.3.html | nkf -w | perl -pe 's/\?\)/\xe2\x98\x85\)/g;' > $@

######################
./temp/installer.css: ./build/installer.css
	mkdir -p ${TEMP}
	perl build/compressfile.pl css ./temp/installer.css.1 ./build/installer.css
	tail -1 <./temp/installer.css.1 > ./temp/installer.css

######################
README.ja.html: doc/index.ja.html
	cp doc/index.ja.html README.ja.html

document/menu.ja.html: doc/menu.ja.html
	cp doc/menu.ja.html document/menu.ja.html

######################
temp/README.ja.html: temp/README.ja.wiki ${DOC}

temp/README.ja.txt: temp/README.ja.wiki ${DOC}

temp/README.ja.wiki: doc/README.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/README.ja.wiki temp/README.ja.wiki

document/README.ja.html: temp/README.ja.html
	cp temp/README.ja.html document/README.ja.html

README.ja.txt: temp/README.ja.txt
	cp temp/README.ja.txt README.ja.txt

######################
temp/DEVEL.ja.html: temp/DEVEL.ja.wiki ${DOC}

temp/DEVEL.ja.txt: temp/DEVEL.ja.wiki ${DOC}

temp/DEVEL.ja.wiki: doc/DEVEL.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/DEVEL.ja.wiki temp/DEVEL.ja.wiki

document/DEVEL.ja.html: temp/DEVEL.ja.html
	cp temp/DEVEL.ja.html document/DEVEL.ja.html

DEVEL.ja.txt: temp/DEVEL.ja.txt
	cp temp/DEVEL.ja.txt DEVEL.ja.txt

######################
temp/htaccess-sample.ja.html: temp/htaccess-sample.ja.wiki ${DOC}

temp/htaccess-sample.ja.txt: temp/htaccess-sample.ja.wiki ${DOC}

temp/htaccess-sample.ja.wiki: doc/htaccess-sample.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/htaccess-sample.ja.wiki temp/htaccess-sample.ja.wiki

document/htaccess-sample.ja.html: temp/htaccess-sample.ja.html
	cp temp/htaccess-sample.ja.html document/htaccess-sample.ja.html

document/htaccess-sample.ja.txt: temp/htaccess-sample.ja.txt
	cp temp/htaccess-sample.ja.txt document/htaccess-sample.ja.txt

######################
temp/sample.ja.html: temp/sample.ja.wiki ${DOC}

temp/sample.ja.txt: temp/sample.ja.wiki ${DOC}

temp/sample.ja.wiki: doc/sample.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/sample.ja.wiki temp/sample.ja.wiki

document/sample.ja.html: temp/sample.ja.html
	cp temp/sample.ja.html document/sample.ja.html

document/sample.ja.txt: temp/sample.ja.txt
	cp temp/sample.ja.txt document/sample.ja.txt

######################
temp/CGI_INSTALLER.ja.html: temp/CGI_INSTALLER.ja.wiki ${DOC}

temp/CGI_INSTALLER.ja.txt: temp/CGI_INSTALLER.ja.wiki ${DOC}

temp/CGI_INSTALLER.ja.wiki: doc/CGI_INSTALLER.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/CGI_INSTALLER.ja.wiki temp/CGI_INSTALLER.ja.wiki

build/CGI_INSTALLER.ja.html: temp/CGI_INSTALLER.ja.html
	cp temp/CGI_INSTALLER.ja.html build/CGI_INSTALLER.ja.html

build/CGI_INSTALLER.ja.txt: temp/CGI_INSTALLER.ja.txt
	cp temp/CGI_INSTALLER.ja.txt build/CGI_INSTALLER.ja.txt

######################
temp/specification.ja.html: temp/specification.ja.wiki ${DOC}

temp/specification.ja.txt: temp/specification.ja.wiki ${DOC}

temp/specification.ja.wiki: doc/specification.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/specification.ja.wiki temp/specification.ja.wiki

document/specification.ja.html: temp/specification.ja.html
	cp temp/specification.ja.html document/specification.ja.html

document/specification.ja.txt: temp/specification.ja.txt
	cp temp/specification.ja.txt document/specification.ja.txt

######################
temp/specification_wikicgi.ja.html: temp/specification_wikicgi.ja.wiki ${DOC}

temp/specification_wikicgi.ja.txt: temp/specification_wikicgi.ja.wiki ${DOC}

temp/specification_wikicgi.ja.wiki: doc/specification_wikicgi.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/specification_wikicgi.ja.wiki temp/specification_wikicgi.ja.wiki

document/specification_wikicgi.ja.html: temp/specification_wikicgi.ja.html
	cp temp/specification_wikicgi.ja.html document/specification_wikicgi.ja.html

document/specification_wikicgi.ja.txt: temp/specification_wikicgi.ja.txt
	cp temp/specification_wikicgi.ja.txt document/specification_wikicgi.ja.txt

######################
temp/specification_xs.html: temp/specification_xs.ja.wiki ${DOC}

temp/specification_xs.ja.txt: temp/specification_xs.ja.wiki ${DOC}

temp/specification_xs.ja.wiki: doc/specification_xs.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/specification_xs.ja.wiki temp/specification_xs.ja.wiki

document/specification_xs.ja.html: temp/specification_xs.ja.html
	cp temp/specification_xs.ja.html document/specification_xs.ja.html

document/specification_xs.ja.txt: temp/specification_xs.ja.txt
	cp temp/specification_xs.ja.txt document/specification_xs.ja.txt

######################
temp/license_art.en.html: temp/license_art.en.wiki ${DOC}

temp/license_art.en.txt: temp/license_art.en.wiki ${DOC}

temp/license_art.en.wiki: src/wiki/license_art.en.wiki ${DOC}
	cat src/wiki/license_art.en.wiki|grep -v \>\>\>\>\>\>\> >  temp/license_art.en.wiki

build/license_art.en.html: temp/license_art.en.html
	cp temp/license_art.en.html build/license_art.en.html

build/license_art.en.txt: temp/license_art.en.txt
	cp temp/license_art.en.txt build/license_art.en.txt

######################
temp/license_art.ja.html: temp/license_art.ja.wiki ${DOC}

temp/license_art.ja.txt: temp/license_art.ja.wiki ${DOC}

temp/license_art.ja.wiki: src/wiki/license_art.ja.wiki ${DOC}
	cat src/wiki/license_art.ja.wiki|grep -v \>\>\>\>\>\>\> | nkf -e >  temp/license_art.ja.wiki

build/license_art.ja.html: temp/license_art.ja.html
	cp temp/license_art.ja.html build/license_art.ja.html

build/license_art.ja.txt: temp/license_art.ja.txt
	cp temp/license_art.ja.txt build/license_art.ja.txt

######################
temp/license_gpl.en.html: temp/license_gpl.en.wiki ${DOC}

temp/license_gpl.en.txt: temp/license_gpl.en.wiki ${DOC}

temp/license_gpl.en.wiki: src/wiki/license_gpl.en.wiki ${DOC}
	cat src/wiki/artistic.ja.wiki|grep -v \>\>\>\>\>\>\> | nkf -e >  temp/license_gpl.en.wiki

build/license_gpl.en.html: temp/license_gpl.en.html
	cp temp/license_gpl.en.html build/license_gpl.en.html

build/license_gpl.en.txt: temp/license_gpl.en.txt
	cp temp/license_gpl.en.txt build/license_gpl.en.txt

######################
temp/license_gpl.ja.html: temp/license_gpl.ja.wiki ${DOC}

temp/license_gpl.ja.txt: temp/license_gpl.ja.wiki ${DOC}

temp/license_gpl.ja.wiki: src/wiki/license_gpl.ja.wiki ${DOC}
	cat src/wiki/license_gpl.ja.wiki|grep -v \>\>\>\>\>\>\> | nkf -e >  temp/license_gpl.ja.wiki

build/license_gpl.ja.html: temp/license_gpl.ja.html
	cp temp/license_gpl.ja.html build/license_gpl.ja.html

build/license_gpl.ja.txt: temp/license_gpl.ja.txt
	cp temp/license_gpl.ja.txt build/license_gpl.ja.txt

######################
temp/plugin_admin.ja.html: temp/plugin_admin.ja.wiki ${DOC}

temp/plugin_admin.ja.txt: temp/plugin_admin.ja.wiki ${DOC}

temp/plugin_admin.ja.wiki: doc/plugin_admin.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugin_admin.ja.wiki temp/plugin_admin.ja.wiki

document/plugin_admin.ja.html: temp/plugin_admin.ja.html
	cp temp/plugin_admin.ja.html document/plugin_admin.ja.html

document/plugin_admin.ja.txt: temp/plugin_admin.ja.txt
	cp temp/plugin_admin.ja.txt document/plugin_admin.ja.txt

######################
temp/plugin_explugin.ja.html: temp/plugin_explugin.ja.wiki ${DOC}

temp/plugin_explugin.ja.txt: temp/plugin_explugin.ja.wiki ${DOC}

temp/plugin_explugin.ja.wiki: doc/plugin_explugin.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugin_explugin.ja.wiki temp/plugin_explugin.ja.wiki

document/plugin_explugin.ja.html: temp/plugin_explugin.ja.html
	cp temp/plugin_explugin.ja.html document/plugin_explugin.ja.html

document/plugin_explugin.ja.txt: temp/plugin_explugin.ja.txt
	cp temp/plugin_explugin.ja.txt document/plugin_explugin.ja.txt

######################
temp/plugin_plugin_ah.ja.html: temp/plugin_plugin_ah.ja.wiki ${DOC}

temp/plugin_plugin_ah.ja.wiki: doc/plugin_plugin_ah.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugin_plugin_ah.ja.wiki temp/plugin_plugin_ah.ja.wiki

document/plugin_plugin_ah.ja.html: temp/plugin_plugin_ah.ja.html
	cp temp/plugin_plugin_ah.ja.html document/plugin_plugin_ah.ja.html

######################
temp/plugin_plugin_ip.ja.html: temp/plugin_plugin_ip.ja.wiki ${DOC}

temp/plugin_plugin_ip.ja.wiki: doc/plugin_plugin_ip.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugin_plugin_ip.ja.wiki temp/plugin_plugin_ip.ja.wiki

document/plugin_plugin_ip.ja.html: temp/plugin_plugin_ip.ja.html
	cp temp/plugin_plugin_ip.ja.html document/plugin_plugin_ip.ja.html

######################
temp/plugin_plugin_rz.ja.html: temp/plugin_plugin_rz.ja.wiki ${DOC}

temp/plugin_plugin_rz.ja.wiki: doc/plugin_plugin_rz.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugin_plugin_rz.ja.wiki temp/plugin_plugin_rz.ja.wiki

document/plugin_plugin_rz.ja.html: temp/plugin_plugin_rz.ja.html
	cp temp/plugin_plugin_rz.ja.html document/plugin_plugin_rz.ja.html

######################
temp/plugin_plugin.ja.txt: temp/plugin_all.ja.wiki ${DOC}

temp/plugin_all.ja.wiki: doc/plugin_all.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugin_all.ja.wiki temp/plugin_all.ja.wiki

document/plugin_all.ja.txt: temp/plugin_all.ja.txt
	cp temp/plugin_all.ja.txt document/plugin_all.ja.txt

######################
doc/plugin_admin.ja.wiki: doc/plugins_document.sh
	perl doc/plugins_document.sh

doc/plugin_explugin.ja.wiki: doc/plugins_document.sh
#	perl doc/plugins_document.sh

doc/plugin_plugin_ah.ja.wiki: doc/plugins_document.sh
#	perl doc/plugins_document.sh

doc/plugin_plugin_ip.ja.wiki: doc/plugins_document.sh
#	perl doc/plugins_document.sh

doc/plugin_plugin_rz.ja.wiki: doc/plugins_document.sh
#	perl doc/plugins_document.sh

doc/specification_wikicgi.ja.wiki: doc/wikicgi_document.sh
	perl doc/wikicgi_document.sh

######################
temp/plugindoc-ad.ja.html: temp/plugindoc-ad.ja.wiki ${DOC}

temp/plugindoc-ad.ja.txt: temp/plugindoc-ad.ja.wiki ${DOC}

temp/plugindoc-ad.ja.wiki: doc/plugindoc-ad.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-ad.ja.wiki temp/plugindoc-ad.ja.wiki

document/plugindoc-ad.ja.html: temp/plugindoc-ad.ja.html
	cp temp/plugindoc-ad.ja.html document/plugindoc-ad.ja.html

document/plugindoc-ad.ja.txt: temp/plugindoc-ad.ja.txt
	cp temp/plugindoc-ad.ja.txt document/plugindoc-ad.ja.txt

######################
temp/plugindoc-bookmark.ja.html: temp/plugindoc-bookmark.ja.wiki ${DOC}

temp/plugindoc-bookmark.ja.txt: temp/plugindoc-bookmark.ja.wiki ${DOC}

temp/plugindoc-bookmark.ja.wiki: doc/plugindoc-bookmark.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-bookmark.ja.wiki temp/plugindoc-bookmark.ja.wiki

document/plugindoc-bookmark.ja.html: temp/plugindoc-bookmark.ja.html
	cp temp/plugindoc-bookmark.ja.html document/plugindoc-bookmark.ja.html

document/plugindoc-bookmark.ja.txt: temp/plugindoc-bookmark.ja.txt
	cp temp/plugindoc-bookmark.ja.txt document/plugindoc-bookmark.ja.txt

######################
temp/plugindoc-exdate.ja.html: temp/plugindoc-exdate.ja.wiki ${DOC}

temp/plugindoc-exdate.ja.txt: temp/plugindoc-exdate.ja.wiki ${DOC}

temp/plugindoc-exdate.ja.wiki: doc/plugindoc-exdate.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-exdate.ja.wiki temp/plugindoc-exdate.ja.wiki

document/plugindoc-exdate.ja.html: temp/plugindoc-exdate.ja.html
	cp temp/plugindoc-exdate.ja.html document/plugindoc-exdate.ja.html

document/plugindoc-exdate.ja.txt: temp/plugindoc-exdate.ja.txt
	cp temp/plugindoc-exdate.ja.txt document/plugindoc-exdate.ja.txt

######################
temp/plugindoc-htmlhead.ja.html: temp/plugindoc-htmlhead.ja.wiki ${DOC}

temp/plugindoc-htmlhead.ja.txt: temp/plugindoc-htmlhead.ja.wiki ${DOC}

temp/plugindoc-htmlhead.ja.wiki: doc/plugindoc-htmlhead.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-htmlhead.ja.wiki temp/plugindoc-htmlhead.ja.wiki

document/plugindoc-htmlhead.ja.html: temp/plugindoc-htmlhead.ja.html
	cp temp/plugindoc-htmlhead.ja.html document/plugindoc-htmlhead.ja.html

document/plugindoc-htmlhead.ja.txt: temp/plugindoc-htmlhead.ja.txt
	cp temp/plugindoc-htmlhead.ja.txt document/plugindoc-htmlhead.ja.txt

######################
temp/plugindoc-playvideo.ja.html: temp/plugindoc-playvideo.ja.wiki ${DOC}

temp/plugindoc-playvideo.ja.txt: temp/plugindoc-playvideo.ja.wiki ${DOC}

temp/plugindoc-playvideo.ja.wiki: doc/plugindoc-playvideo.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-playvideo.ja.wiki temp/plugindoc-playvideo.ja.wiki

document/plugindoc-playvideo.ja.html: temp/plugindoc-playvideo.ja.html
	cp temp/plugindoc-playvideo.ja.html document/plugindoc-playvideo.ja.html

document/plugindoc-playvideo.ja.txt: temp/plugindoc-playvideo.ja.txt
	cp temp/plugindoc-playvideo.ja.txt document/plugindoc-playvideo.ja.txt

######################
temp/plugindoc-qrcode.ja.html: temp/plugindoc-qrcode.ja.wiki ${DOC}

temp/plugindoc-qrcode.ja.txt: temp/plugindoc-qrcode.ja.wiki ${DOC}

temp/plugindoc-qrcode.ja.wiki: doc/plugindoc-qrcode.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-qrcode.ja.wiki temp/plugindoc-qrcode.ja.wiki

document/plugindoc-qrcode.ja.html: temp/plugindoc-qrcode.ja.html
	cp temp/plugindoc-qrcode.ja.html document/plugindoc-qrcode.ja.html

document/plugindoc-qrcode.ja.txt: temp/plugindoc-qrcode.ja.txt
	cp temp/plugindoc-qrcode.ja.txt document/plugindoc-qrcode.ja.txt

######################
temp/plugindoc-sh.ja.html: temp/plugindoc-sh.ja.wiki ${DOC}

temp/plugindoc-sh.ja.txt: temp/plugindoc-sh.ja.wiki ${DOC}

temp/plugindoc-sh.ja.wiki: doc/plugindoc-sh.ja.wiki ${DOC}
	mkdir -p ${TEMP}
	cp doc/plugindoc-sh.ja.wiki temp/plugindoc-sh.ja.wiki

document/plugindoc-sh.ja.html: temp/plugindoc-sh.ja.html
	cp temp/plugindoc-sh.ja.html document/plugindoc-sh.ja.html

document/plugindoc-sh.ja.txt: temp/plugindoc-sh.ja.txt
	cp temp/plugindoc-sh.ja.txt document/plugindoc-sh.ja.txt

FORCE:
