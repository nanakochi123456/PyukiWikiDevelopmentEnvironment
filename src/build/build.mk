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
VERSIONALL= `perl -e '$$ARGV[0]="all";if(-f "./build/getversion.pl"){ require "./build/getversion.pl" }elsif(-f "../../build/getversion.pl"){ require "../../build/getversion.pl";};'`
export VERSIONALL

######################################################
all:
	@echo "---------------------------------------------------------------"
	@echo "PyukiWIki ${VERSION} Release Builder"
	@echo "---------------------------------------------------------------"
	@echo "Make Javascript:"
	@echo "  ${MAKE} [build]"
	@echo "Make XS Binary"
	@echo "  ${MAKE} [installxs][updatexs][deinstallxs][removexs][cleanxs]"
	@echo "Make releases"
	@echo "  ${MAKE} [release] [pkg]"
	@echo "Make document"
	@echo "  ${MAKE} [builddoc]"
	@echo "Make image"
	@echo "  ${MAKE} [buildimage] [cleanimage]"
	@echo "Make free mail address database"
	@echo "  ${MAKE} [mailaddr]"
	@echo "Make release more..."
	@echo "  ${MAKE} [buildrelease][buildreleaseutf8]"
	@echo "  ${MAKE} [builddevel][builddevelutf8]"
	@echo "  ${MAKE} [buildcompact][buildcompactutf8]"
	@echo "Make clean more"
	@echo "  ${MAKE} [clean][realclean][cvsclean]"

buildimage:FORCE
	@${MAKE} make -f ${BUILDDIR}/build_img.mk

cleanimage:FORCE


######################################################
version:
	@echo "PyukiWiki ${VERSION}"

versionall:
	@echo "${VERSIONALL}"

######################################################
BUILDMAKER=\
			${BUILDDIR}/makesampleini.pl \
			${BUILDDIR}/Jcode-convert.pl \
			${BUILDDIR}/lang.pl \
			${BUILDDIR}/getversion.pl \
			${BUILDDIR}/build.mk \
			${BUILDDIR}/build_doc.mk \
			${BUILDDIR}/build_xs.mk \
			${BUILDDIR}/build_img.pl \
			${BUILDDIR}/build_img.mk \
			${BUILDDIR}/build.pl \
			${BUILDDIR}/buildhtfiles.pl \
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
			${BUILDDIR}/list_hiragana.pl \
			${BUILDDIR}/list_hiragana.txt \
			${BUILDDIR}/mail_freemail.txt \
			${BUILDDIR}/mail_mobile.txt \
			${BUILDDIR}/mail_msnlive.txt \
			${BUILDDIR}/mail_sp.txt \
			${BUILDDIR}/mkngwords.pl \
			${BUILDDIR}/ngwords.txt \
			${BUILDDIR}/ngwords_frozenwrite.txt \
			${BUILDDIR}/ngwords_frozenwrite_ja.txt \
			${BUILDDIR}/ngwords_ja.txt \
			${BUILDDIR}/ngwords_username.txt \
			${BUILDDIR}/ngwords_username_ja.txt \
			${BUILDDIR}/worddic.txt \
			${BUILDDIR}/mkwordlist.pl \
			${BUILDDIR}/mime_res.txt \
			${BUILDDIR}/mime_add.txt \
			${BUILDDIR}/makemimetypes.pl \
			Makefile

#			lib/wiki_version.cgi \
#			${BUILDDIR}/list_hiragana.pl \
#			${BUILDDIR}/list_hiragana.txt \

######################################################
WIKIFILES=\
			src/wiki/lang.wiki \
			src/wiki/all.en.wiki \
			src/wiki/all.ja.wiki \
			src/wiki/FormatRule.ja.wiki \
			src/wiki/FrontPage.en.wiki \
			src/wiki/FrontPage.ja.wiki \
			src/wiki/Help.en.wiki \
			src/wiki/Help.ja.wiki \
			src/wiki/InterWikiName.en.wiki \
			src/wiki/InterWikiName.ja.wiki \
			src/wiki/InterWikiSandBox.en.wiki \
			src/wiki/InterWikiSandBox.ja.wiki \
			src/wiki/license_art.en.wiki \
			src/wiki/license_art.ja.wiki \
			src/wiki/license_gpl.en.wiki \
			src/wiki/license_gpl.ja.wiki \
			src/wiki/MenuBar.en.wiki \
			src/wiki/MenuBar.ja.wiki \
			src/wiki/RecentPages.en.wiki \
			src/wiki/RecentPages.ja.wiki \
			src/wiki/SandBox.en.wiki \
			src/wiki/SandBox.ja.wiki

######################################################
BUILDFILES=\
			lib/wiki_sub.cgi \
			sample/pyukiwiki.ini.cgi \
			skin/loader.js skin/loader.js.gz \
			skin/captcha.js skin/captcha.js.gz \
			skin/instag.js skin/instag.js.gz \
			skin/instag.css skin/instag.css.gz \
			skin/common.en.js skin/common.en.js.gz \
			skin/common.unicode.ja.js skin/common.unicode.ja.js.gz \
			skin/edit.js skin/edit.js.gz \
			skin/setting.js skin/setting.js.gz \
			skin/passwd.js skin/passwd.js.gz \
			skin/login.js skin/login.js.gz \
			skin/login.css skin/login.css.gz \
			skin/location.js skin/location.js.gz \
			skin/twitter.js skin/twitter.js.gz \
			skin/smedia.js skin/smedia.js.gz \
			skin/smedia.css skin/smedia.css.gz \
			skin/fileinfo.css skin/fileinfo.css.gz \
			lib/File/magic.txt lib/File/magic_compact.txt \
			skin/pyukiwiki.default.css skin/pyukiwiki.default.css.gz \
			skin/pyukiwiki.print.css skin/pyukiwiki.print.css.gz \
			skin/pyukiwikigreen.default.css skin/pyukiwikigreen.default.css.gz \
			skin/pyukiwikigreen.print.css skin/pyukiwikigreen.print.css.gz \
			skin/tdiary.default.css skin/tdiary.default.css.gz \
			skin/tdiary.print.css skin/tdiary.print.css.gz \
			skin/pyukiwikigreen.skin.cgi \
			skin/logs_viewer.css \
			sample/mikachan.default.css sample/mikachan.print.css \
			sample/mikachan.default.css.org sample/mikachan.print.css.org \
			sample/mikachan.skin.cgi \
			skin/blosxom.css \
			skin/img-exedit.css skin/img-exedit.css.gz \
			skin/img-icon.css skin/img-icon.css.gz \
			skin/img-lang.css skin/img-lang.css.gz \
			skin/img-login.css skin/img-login.css.gz \
			skin/img.css skin/img.css.gz \
			skin/debugscript.js skin/debugscript.js.gz \
			skin/jquery/jquery.js skin/jquery/jquery.js.gz \
			skin/jquery/jquery-2.js skin/jquery/jquery-2.js.gz \
			skin/jquery/jquery-migrate.js  skin/jquery/jquery-migrate.js.gz \
			skin/jquery/farbtastic.js skin/jquery/farbtastic.js.gz \
			skin/jquery/farbtastic.css skin/jquery/farbtastic.css.gz \
			skin/jquery/jqModal.js skin/jquery/jqModal.js.gz \
			skin/jquery/jqModal.css skin/jquery/jqModal.css.gz \
			skin/player/playmedia.js skin/player/playmedia.js.gz \
			skin/player/audio.js skin/player/audio.js.gz \
			skin/player/mediaelement-and-player.js skin/player/mediaelement-and-player.js.gz \
			skin/player/mediaelementplayer.css skin/player/mediaelementplayer.css.gz \
			skin/player/mejs-skins.css skin/player/mejs-skins.css.gz \
			skin/ad.css skin/ad.css.gz \
			build/list_hiragana_euc.txt \
			ngwords.ini.cgi \
			./resource/wiki-compact.en.txt.gz \
			./resource/wiki-compact.ja.txt.gz \
			./resource/wiki-full.en.txt.gz \
			./resource/wiki-full.ja.txt.gz \
			./resource/wiki-devel.en.txt.gz \
			./resource/wiki-devel.ja.txt.gz \
			./resource/mimetypes.en.txt \
			./resource/mimetypes.ja.txt \
			attach/.htaccess \
			attach/index.html \
			backup/.htaccess \
			backup/index.html \
			build/.htaccess \
			build/index.html \
			cache/.htaccess \
			cache/index.html \
			counter/.htaccess \
			counter/index.html \
			diff/.htaccess \
			diff/index.html \
			image/.htaccess \
			image/index.html \
			info/.htaccess \
			info/index.html \
			lib/.htaccess \
			lib/index.html \
			logs/.htaccess \
			logs/index.html \
			plugin/.htaccess \
			plugin/index.html \
			resource/.htaccess \
			resource/index.html \
			sample/.htaccess \
			sample/index.html \
			session/.htaccess \
			session/index.html \
			session/.htaccess \
			session/index.html \
			skin/.htaccess \
			skin/index.html \
			src/.htaccess \
			src/index.html \
			trackback/.htaccess \
			trackback/index.html \
			user/.htaccess \
			user/index.html \
			wiki/.htaccess \
			wiki/index.html \
			.htaccess \
			.htpasswd

######################################################
pkg:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk cvsclean
	@${MAKE} -f ${BUILDDIR}/build.mk tempclean
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=release PKGPREFIX="-full" CODE="euc" CRLF="lf"	#euc
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=update PKGPREFIX="-update-full"	 CODE="euc" CRLF="lf"	#euc
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=compact PKGPREFIX="-compact" CODE="euc" CRLF="lf"	#euc
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatecompact PKGPREFIX="-update-compact" CODE="euc" CRLF="lf"	#euc
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=devel PKGPREFIX="-devel" CODE="euc" CRLF="lf"	#euc
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatedevel PKGPREFIX="-update-devel" CODE="euc" CRLF="lf"	#euc
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=release PKGPREFIX="-full-utf8-utf8" CODE="utf8" CRLF="lf"	#utf8
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=update PKGPREFIX="-update-full"	 CODE="utf8" CRLF="lf"	#utf8
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=compact PKGPREFIX="-compact-utf8" CODE="utf8" CRLF="lf"	#utf8
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatecompact PKGPREFIX="-update-compact-utf8" CODE="utf8" CRLF="lf"	#utf8
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=devel PKGPREFIX="-devel-utf8" CODE="utf8" CRLF="lf"	#utf8
	@${MAKE} -f ${BUILDDIR}/build.mk pkgtgz PKGTYPE=updatedevel PKGPREFIX="-update-devel-utf8" CODE="utf8" CRLF="lf"	#utf8


######################################################
release:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk cvsclean
	@${MAKE} -f ${BUILDDIR}/build.mk tempclean
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="release" PKGPREFIX="-full" CODE="euc" CRLF="lf"
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="compact" PKGPREFIX="-compact" CODE="euc" CRLF="lf"
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="update" PKGPREFIX="-update" CODE="euc" CRLF="lf"
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="updatecompact" PKGPREFIX="-update-compact" CODE="euc" CRLF="lf"
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="devel" PKGPREFIX="-devel" CODE="euc" CRLF="lf"
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="updatedevel" PKGPREFIX="-update-devel" CODE="euc" CRLF="lf"

######################################################
releasedevel:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="devel" PKGPREFIX="-devel" CODE="euc" CRLF="lf"

######################################################
buildall:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="devel" PKGPREFIX="-devel" CODE="euc" CRLF="lf" ALL="all"

######################################################
buildallutf8:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="devel" PKGPREFIX="-devel-utf8" CODE="utf8" CRLF="lf" ALL="all"

######################################################
builddevel:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="devel" PKGPREFIX="-devel" CODE="euc" CRLF="lf"

######################################################
builddevelutf8:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber

######################################################
buildcompact:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="compact" PKGPREFIX="-compact" CODE="euc" CRLF="lf"

######################################################
buildcompactutf8:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber

######################################################
buildrelease:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE="release" PKGPREFIX="-full" CODE="euc" CRLF="lf"

######################################################
buildreleaseutf8:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber

######################################################
mk:FORCE
	@echo "=========================================================="
	@echo " Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@echo "=========================================================="
	mkdir -p ${TEMP}
	mkdir -p ${RELEASE}
	mkdir -p "${RELEASE}/${CODE}-${CRLF}/${PKGNAME}-${VERSION}${PKGPREFIX}"
	${PERL} ${BUILDDIR}/build.pl mk ${TEMP} ${RELEASE}/${CODE}-${CRLF}/${PKGNAME}-${VERSION}${PKGPREFIX} ${TEMP}/${CODE}-${CRLF}-${PKGNAME}-${VERSION}${PKGPREFIX}.mk ${PKGTYPE} ${CRLF} ${CODE} ${ALL}
	${MAKE} -f ${TEMP}/${CODE}-${CRLF}-${PKGNAME}-${VERSION}${PKGPREFIX}.mk PKGTYPE=${PKGTYPE} RELEASE=${RELEASE} CODE=${CODE} CRLF=${CRLF} PKGNAME=${PKGNAME} VERSION=${VERSION} PKGPREFIX=${PKGPREFIX} GZIP_7Z="${GZIP_7Z}"

######################################################
pkgtgz:FORCE
#	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	mkdir -p ${RELEASE} 2>/dev/null
	@${MAKE} -j ${JOBS} -f ${BUILDDIR}/build.mk mk  PKGTYPE=${PKGTYPE} PKGPREFIX=${PKGPREFIX} CODE=${CODE} CRLF=${CRLF} ALL=${ALL}
	@${MAKE} -f ${BUILDDIR}/build.mk tgz  PKGTYPE=${PKGTYPE} PKGPREFIX=${PKGPREFIX} CODE=${CODE} CRLF=${CRLF} ALL=${ALL}

######################################################
tgz:
	mkdir -p ${ARCHIVEDIR}/${PKGNAME}-${VERSION} 2>/dev/null
	@echo "=========================================================="
	@echo " Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz"
	@echo "=========================================================="
	cd ${RELEASE}/${CODE}-${CRLF} && ${TAR} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar ${PKGNAME}-${VERSION}${PKGPREFIX} >/dev/null 2>/dev/null
	cd ${RELEASE}/${CODE}-${CRLF} && ${GZIP_7Z} ${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${PKGNAME}-${VERSION}${PKGPREFIX}.tar >/dev/null 2>/dev/null
	@rm ${RELEASE}/${CODE}-${CRLF}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar
	@cp ${RELEASE}/${CODE}-${CRLF}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}
	@rm ${RELEASE}/${CODE}-${CRLF}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz
	@echo "=========================================================="
	@echo " Make installer ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@echo "=========================================================="
	${SH} ${BUILDDIR}/makeinstaller.sh "${ZIP_7Z}" "${7Z_7Z}" ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.tar.gz ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}_installer ${VERSION} ${PKGPREFIX} gz shar ${CODE}

######################################################
pkgzip:
#	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE=${PKGTYPE} PKGPREFIX=${PKGPREFIX} CODE=${CODE} CRLF=${CRLF} ALL=${ALL}
	@${MAKE} -f ${BUILDDIR}/build.pl zip PKGTYPE=${PKGTYPE} PKGPREFIX=${PKGPREFIX} CODE=${CODE} CRLF=${CRLF} ALL=${ALL}

######################################################
zip:
	@mkdir ${ARCHIVEDIR} 2>/dev/null
	@mkdir ${ARCHIVEDIR}/${PKGNAME}-${VERSION} 2>/dev/null
	@echo "=========================================================="
	@echo " Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.zip"
	@echo "=========================================================="
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/* ${PKGNAME}-${VERSION}${PKGPREFIX}/.htaccess >/dev/null 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.zip
	@rm ${RELEASE}/zip.zip

######################################################
pkgzipupdate:
#	@echo "Building ${PKGNAME}-${VERSION}${PKGPREFIX}"
	@mkdir ${RELEASE} 2>/dev/null
	@mkdir ${RELEASE}/${PKGNAME}-${VERSION}${PKGPREFIX} 2>/dev/null
	@${MAKE} -f ${BUILDDIR}/build.mk mk  PKGTYPE=${PKGTYPE} PKGPREFIX=${PKGPREFIX} CODE=${CODE} CRLF=${CRLF} ALL=${ALL}
	@${MAKE} -f ${BUILDDIR}/build.pl zipupdate PKGTYPE=${PKGTYPE} PKGPREFIX=${PKGPREFIX} CODE=${CODE} CRLF=${CRLF} ALL=${ALL}

######################################################
zipupdate:
	@mkdir ${ARCHIVEDIR} 2>/dev/null
	@mkdir ${ARCHIVEDIR}/${PKGNAME}-${VERSION} 2>/dev/null
	@echo "=========================================================="
	@echo " Compress ${PKGNAME}-${VERSION}${PKGPREFIX}.zip"
	@echo "=========================================================="
	@cd ${RELEASE} && ${ZIP_7Z} zip.zip ${PKGNAME}-${VERSION}${PKGPREFIX}/*  >/dev/null 2>/dev/null
	@cp ${RELEASE}/zip.zip ${ARCHIVEDIR}/${PKGNAME}-${VERSION}/${PKGNAME}-${VERSION}${PKGPREFIX}.zip
	@rm ${RELEASE}/zip.zip

######################################################
clean:
	@echo "Cleaning work directorys"
	@rm -rf ${TEMP} ${RELEASE}

######################################################
tempclean:
	@rm -rf ${TEMP}

######################################################
pkgclean:
	@echo "Cleaning Archive directorys"
	@rm -rf ${TEMP} ${RELEASE} ${ARCHIVEDIR}

######################################################
realclean:
	@echo "Cleaning all build files"
	@rm -rf ${TEMP} ${RELEASE} ${ARCHIVEDIR}
	@rm -rf ${BUILDFILES}

######################################################
cvsclean:
	@echo "Cleaning CVS tags"
	@for p in `find .|grep CVS`; do rm -rf $${p}; done

######################################################
touch:FORCE
	@echo "Update time stamp for build files"
	@touch ${BUILDFILES}

######################################################
prof:FORCE
	@${PERL} -d:DProf index.cgi >/dev/null 2>/dev/null
	@dprofpp -O 30
	@rm -f tmon.out

######################################################
build:FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber
	@${MAKE} -j ${JOBS} -f ${BUILDDIR}/build.mk buildsub

######################################################
buildsub:FORCE ${BUILDFILES} ${BUILDMAKER}

######################################################
# Build file define
######################################################
lib/File/magic.txt: lib/File/magic.txt.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compactmagic.pl lib/File/magic.txt.src>lib/File/magic.t

######################################################
lib/File/magic_compact.txt: lib/File/magic.txt.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compactmagic.pl lib/File/magic.txt.src compact>lib/File/magic_compact.txt 

######################################################
skin/common.sjis.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl sjis skin/common.sjis.ja.js skin/common.ja.js

######################################################
skin/common.unicode.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/common.unicode.ja.js.tmp skin/common.ja.js.src
	${PERL} ${BUILDDIR}/utf16.pl skin/common.unicode.ja.js.tmp skin/common.unicode.ja.js.tmp2
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/common.unicode.ja.js skin/common.unicode.ja.js.tmp2
	rm -f skin/common.unicode.ja.js.tmp skin/common.unicode.ja.js.tmp2

######################################################
skin/common.utf8.ja.js: skin/common.ja.js ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/common.utf8.ja.js skin/common.ja.js

######################################################
skin/edit.js: skin/edit.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/edit.js.tmp skin/edit.js.src
	${PERL} ${BUILDDIR}/utf16.pl skin/edit.js.tmp skin/edit.js.tmp2
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/edit.js skin/edit.js.tmp2
	rm -f skin/edit.js.tmp skin/edit.js.tmp2

skin/setting.js: skin/setting.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/setting.js.tmp skin/setting.js.src
	${PERL} ${BUILDDIR}/utf16.pl skin/setting.js.tmp skin/setting.js.tmp2
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/setting.js skin/setting.js.tmp2
	rm -f skin/setting.js.tmp skin/setting.js.tmp2

######################################################
sample/pyukiwiki.ini.cgi: pyukiwiki.ini.cgi ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makesampleini.pl > sample/pyukiwiki.ini.cgi

######################################################
skin/instag.js: skin/instag.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/instag.js.2 skin/instag.js.src
	${PERL} ${BUILDDIR}/utf16.pl skin/instag.js.2 skin/instag.js.3
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/instag.js skin/instag.js.3
	rm -f skin/instag.js.2 skin/instag.js.3

######################################################
skin/loader.js: skin/loader.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/loader.js skin/loader.js.src

######################################################

######################################################
skin/captcha.js: skin/captcha.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/captcha.js skin/captcha.js.src

######################################################
skin/instag.css: skin/instag.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/instag.css skin/instag.css.src

######################################################
skin/passwd.js: skin/passwd.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/passwd.js skin/passwd.js.src

######################################################
skin/login.js: skin/login.js.src build/worddic.txt ${BUILDMAKER}
	${PERL} ${BUILDDIR}/mkwordlist.pl skin/login.js.src build/worddic.txt > skin/login.js.0
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/login.js.tmp skin/login.js.0
	${PERL} ${BUILDDIR}/utf16.pl skin/login.js.tmp skin/login.js.tmp2
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/login.js skin/login.js.tmp2
	rm -f skin/login.js.tmp skin/login.js.tmp2 skin/login.js.0

######################################################
skin/login.css: skin/login.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/login.css skin/login.css.org

######################################################
skin/twitter.js: skin/twitter.js.src skin/oauth.js.src skin/sha1.js.src ${BUILDMAKER}
	cat skin/oauth.js.src skin/sha1.js.src skin/twitter.js.src > skin/twitter.js.1
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/twitter.js.tmp skin/twitter.js.1
	${PERL} ${BUILDDIR}/utf16.pl skin/twitter.js.tmp skin/twitter.js.tmp2
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/twitter.js skin/twitter.js.tmp2
	rm -f skin/twitter.js.1 skin/twitter.js.tmp2 skin/twitter.js.tmp

######################################################
skin/location.js: skin/location.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/location.js.tmp skin/location.js.src
	${PERL} ${BUILDDIR}/utf16.pl skin/location.js.tmp skin/location.js.tmp2
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/location.js skin/location.js.tmp2
	rm -f skin/location.js.tmp2 skin/location.js.tmp

######################################################
skin/twitstat.js: skin/twitstat.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js skin/twitstat.js skin/twitstat.js.src
######################################################
skin/smedia.js: skin/smedia.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 skin/smedia.js.tmp skin/smedia.js.src
	${PERL} ${BUILDDIR}/utf16.pl skin/smedia.js.tmp skin/smedia.js.t2
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/smedia.js skin/smedia.js.t2
	rm -f skin/smedia.js.tmp skin/smedia.js.t2

######################################################
skin/common.en.js: skin/common.en.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/common.en.js skin/common.en.js.src

######################################################
skin/common.ja.js: skin/common.ja.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/common.ja.js skin/common.ja.js.src

######################################################
skin/common.en.js.src: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl en skin/common.lang.js.src

######################################################
skin/common.ja.js.src: skin/common.lang.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/lang.pl ja skin/common.lang.js.src

######################################################
skin/pyukiwiki.default.css: skin/pyukiwiki.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwiki.default.css skin/pyukiwiki.default.css.org

######################################################
skin/tdiary.default.css: skin/tdiary.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/tdiary.default.css skin/tdiary.default.css.org

######################################################
skin/tdiary.print.css: skin/tdiary.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/tdiary.print.css skin/tdiary.print.css.org

######################################################
skin/pyukiwiki.default.css.org: skin/pyukiwiki.default.css.src skin/pyukiwiki.table.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/csscolorbuilder.pl skin/pyukiwiki.default.css.src skin/pyukiwiki.table.src > skin/pyukiwiki.default.css.org

######################################################
sample/mikachan.default.css.org: skin/pyukiwiki.default.css.org
	cp skin/pyukiwiki.default.css.org sample/mikachan.default.css.org

######################################################
sample/mikachan.print.css.org: skin/pyukiwiki.print.css.org
	cp skin/pyukiwiki.print.css.org sample/mikachan.print.css.org

######################################################
skin/pyukiwiki.print.css: skin/pyukiwiki.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwiki.print.css skin/pyukiwiki.print.css.org

######################################################
skin/pyukiwikigreen.default.css: skin/pyukiwikigreen.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/pyukiwikigreen.default.css skin/pyukiwikigreen.default.css.org

######################################################
skin/pyukiwikigreen.default.css.org: skin/pyukiwiki.default.css.src skin/pyukiwikigreen.table.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/csscolorbuilder.pl skin/pyukiwiki.default.css.src skin/pyukiwikigreen.table.src > skin/pyukiwikigreen.default.css.org

######################################################
skin/pyukiwikigreen.print.css: skin/pyukiwiki.print.css ${BUILDMAKER}
	cp skin/pyukiwiki.print.css skin/pyukiwikigreen.print.css

######################################################
skin/pyukiwikigreen.skin.cgi: skin/pyukiwiki.skin.cgi ${BUILDMAKER}
	cp skin/pyukiwiki.skin.cgi skin/pyukiwikigreen.skin.cgi

######################################################
skin/img.css.org: skin/img-face.css.org skin/img-navi.css.org skin/img-org.css.org
	cat skin/img-face.css.org skin/img-navi.css.org skin/img-org.css.org > skin/img.css.org

######################################################
skin/img.css: skin/img.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/img.css skin/img.css.org

######################################################
skin/img-lang.css: skin/img-lang.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/img-lang.css skin/img-lang.css.org

######################################################
skin/img-login.css: skin/img-login16.css.org skin/img-login32.css.org ${BUILDMAKER}
	cat skin/img-login16.css.org skin/img-login32.css.org > skin/img-login.css.org
	${PERL} ${BUILDDIR}/compressfile.pl css skin/img-login.css skin/img-login.css.org

######################################################
skin/img-exedit.css: skin/img-exedit.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/img-exedit.css skin/img-exedit.css.org

######################################################
skin/img-icon.css: skin/img-icon.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/img-icon.css skin/img-icon.css.org

######################################################
skin/img-face.css.org: FORCE
	@echo -n ''

######################################################
skin/img-navi.css.org: FORCE
	@echo -n ''

######################################################
skin/img-org.css.org: FORCE
	${MAKE} -f ${BUILDDIR}/build_img.mk make

######################################################
skin/img-exedit.css.org: FORCE
	@echo -n ''

######################################################
skin/img-lang.css.org: FORCE
	@echo -n ''

######################################################
skin/img-icon.css.org: FORCE
	@echo -n ''

######################################################
skin/img-login.css.org: FORCE
	@echo -n ''

######################################################
skin/blosxom.css: skin/blosxom.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/blosxom.css skin/blosxom.css.org

######################################################
skin/logs_viewer.css: skin/logs_viewer.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/logs_viewer.css skin/logs_viewer.css.org

######################################################
skin/player/playmedia.js: skin/player/playmedia.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/player/playmedia.js skin/player/playmedia.js.src

######################################################
skin/player/audio.js: skin/player/audio.js.src skin/swfobject-2.js.src ${BUILDMAKER}
	cat skin/swfobject-2.js.src skin/player/audio.js.src > tmpjsaudiojs
	${PERL} ${BUILDDIR}/Jcode-convert.pl utf8 tmpjsaudiojs2 tmpjsaudiojs
	${PERL} ${BUILDDIR}/utf16.pl tmpjsaudiojs2 tmpjsaudiojs3
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/player/audio.js tmpjsaudiojs3
	rm -f tmpjsaudiojs tmpjsaudiojs2 tmpjsaudiojs3

######################################################
skin/player/mediaelement-and-player.js: skin/player/mediaelement-and-player.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/player/mediaelement-and-player.js skin/player/mediaelement-and-player.js.src

######################################################
skin/player/mediaelementplayer.css: skin/player/mediaelementplayer.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/player/mediaelementplayer.css skin/player/mediaelementplayer.css.org

######################################################
skin/player/mejs-skins.css: skin/player/mejs-skins.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/player/mejs-skins.css skin/player/mejs-skins.css.org

######################################################
skin/debugscript.js: skin/debugscript.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js2 skin/debugscript.js skin/debugscript.js.src

######################################################
skin/jquery/jquery.js: skin/jquery/jquery.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/jquery/jquery.js skin/jquery/jquery.js.src

######################################################
skin/jquery/jquery-2.js: skin/jquery/jquery-2.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/jquery/jquery-2.js skin/jquery/jquery-2.js.src

######################################################
skin/jquery/jquery-migrate.js: skin/jquery/jquery-migrate.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/jquery/jquery-migrate.js skin/jquery/jquery-migrate.js.src

######################################################
skin/jquery/jqModal.js: skin/jquery/jqModal.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/jquery/jqModal.js skin/jquery/jqModal.js.src

######################################################
skin/jquery/jqModal.css: skin/jquery/jqModal.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/jquery/jqModal.css skin/jquery/jqModal.css.src

######################################################
skin/jquery/farbtastic.js: skin/jquery/farbtastic.js.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl js3 skin/jquery/farbtastic.js skin/jquery/farbtastic.js.src

######################################################
skin/jquery/farbtastic.css: skin/jquery/farbtastic.css.src ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/jquery/farbtastic.css skin/jquery/farbtastic.css.src

######################################################
skin/smedia.css: skin/smedia.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/smedia.css skin/smedia.css.org

######################################################
skin/fileinfo.css: skin/fileinfo.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/fileinfo.css skin/fileinfo.css.org

######################################################
skin/ad.css: skin/ad.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css skin/ad.css skin/ad.css.org

######################################################
sample/mikachan.default.css: sample/mikachan.default.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css sample/mikachan.default.css sample/mikachan.default.css.org

######################################################
sample/mikachan.print.css: sample/mikachan.print.css.org ${BUILDMAKER}
	${PERL} ${BUILDDIR}/compressfile.pl css sample/mikachan.print.css sample/mikachan.print.css.org

######################################################
sample/mikachan.skin.cgi: skin/pyukiwiki.skin.cgi ${BUILDMAKER}
	cp skin/pyukiwiki.skin.cgi sample/mikachan.skin.cgi

######################################################
lib/wiki_sub.cgi: lib/wiki_auth.cgi lib/wiki_db.cgi lib/wiki_func.cgi lib/wiki_html.cgi lib/wiki_http.cgi lib/wiki_init.cgi lib/wiki_link.cgi lib/wiki_plugin.cgi lib/wiki_spam.cgi lib/wiki_wiki.cgi lib/wiki_write.cgi ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewikisub.pl lib/wiki_*.cgi >lib/wiki_sub.cgi

######################################################
lib/wiki_version.cgi: FORCE
	@${MAKE} -f ${BUILDDIR}/build.mk buildnumber

######################################################
ngwords.ini.cgi: ${BUILDMAKER}
	${PERL} build/mkngwords.pl

######################################################
resource/mimetypes.en.txt: ${BUILDMAKER}
	${PERL} build/makemimetypes.pl en resource/mimetypes.en.txt

######################################################
resource/mimetypes.ja.txt: ${BUILDMAKER}
	${PERL} build/makemimetypes.pl ja resource/mimetypes.ja.txt

######################################################
resource/wiki-devel.en.txt.gz: resource/wiki-devel.en.txt
	cd resource && ${GZIP_7Z} wiki-devel.en.txt.gz wiki-devel.en.txt >/dev/null 2>/dev/null
#	cd resource && rm wiki-devel.en.txt

######################################################
resource/wiki-full.en.txt.gz: resource/wiki-full.en.txt
	cd resource && ${GZIP_7Z} wiki-full.en.txt.gz wiki-full.en.txt >/dev/null 2>/dev/null
#	cd resource && rm wiki-full.en.txt

######################################################
resource/wiki-compact.en.txt.gz: resource/wiki-compact.en.txt
	cd resource && ${GZIP_7Z} wiki-compact.en.txt.gz wiki-compact.en.txt >/dev/null 2>/dev/null
#	cd resource && rm wiki-compact.en.txt

######################################################
resource/wiki-devel.ja.txt.gz: resource/wiki-devel.ja.txt
	cd resource && ${GZIP_7Z} wiki-devel.ja.txt.gz wiki-devel.ja.txt >/dev/null 2>/dev/null
#	cd resource && rm wiki-devel.ja.txt

######################################################
resource/wiki-full.ja.txt.gz: resource/wiki-full.ja.txt
	cd resource && ${GZIP_7Z} wiki-full.ja.txt.gz wiki-full.ja.txt >/dev/null 2>/dev/null
#	cd resource && rm wiki-full.ja.txt

######################################################
resource/wiki-compact.ja.txt.gz: resource/wiki-compact.ja.txt
	cd resource && ${GZIP_7Z} wiki-compact.ja.txt.gz wiki-compact.ja.txt >/dev/null 2>/dev/null
#	cd resource && rm wiki-compact.ja.txt

######################################################
resource/wiki-devel.ja.txt: ${WIKIFILE} ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewiki.pl devel

######################################################
resource/wiki-full.ja.txt: ${WIKIFILE} ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewiki.pl full

######################################################
resource/wiki-compact.ja.txt: ${WIKIFILE} ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewiki.pl compact

######################################################
resource/wiki-devel.en.txt: ${WIKIFILE} ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewiki.pl devel

######################################################
resource/wiki-full.en.txt: ${WIKIFILE} ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewiki.pl full

######################################################
resource/wiki-compact.en.txt: ${WIKIFILE} ${BUILDMAKER}
	${PERL} ${BUILDDIR}/makewiki.pl compact

######################################################
attach/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
attach/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
backup/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
backup/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
build/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
build/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
cache/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
cache/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
counter/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
counter/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
diff/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
diff/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
image/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
image/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
info/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
info/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
lib/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
lib/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
logs/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
logs/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
plugin/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
plugin/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
resource/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
resource/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
sample/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
sample/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
session/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
session/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
skin/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
skin/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
src/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
src/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
trackback/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
trackback/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
user/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
user/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
wiki/.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
wiki/index.html: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
.htaccess: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@

######################################################
.htpasswd: ${BUILDMAKER}
	${PERL} ${BUILDDIR}/buildhtfiles.pl $@


######################################################
ftp:
	@echo "Uploading public file mirrorling"
	${PERL} ${BUILDDIR}/ftp.pl


######################################################
%.js.gz : %.js
	echo $<
	rm -f $<.gz
	cat $<|grep -v '^\/\*'|grep -v '^ \*'|grep -v '^ \*\/' > $<.tmp
	${GZIP_JC} $<.gz < $<.tmp >/dev/null
	rm -f $<.tmp

######################################################
%.css.gz : %.css
	rm -f $<.gz
	cat $<|grep -v '^\/\*'|grep -v '^ \*'|grep -v '^ \*\/' > $<.tmp
	${GZIP_JC} $<.gz < $<.tmp >/dev/null
	rm -f $<.tmp


######################################################
build/list_hiragana_euc.txt: ${BUILDMAKER}
	perl ${BUILDDIR}/list_hiragana.pl

######################################################
buildnumber:FORCE
	${PERL} build/getversion.pl write

######################################################
FORCE:

######################################################
mailaddr:FORCE
	${PERL} build/mkfreemaillist.pl
