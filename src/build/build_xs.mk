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

XSSRC=./src
XSINSTALL=./blib

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

BUILDNUMBER= `perl -e '$$ARGV[0]="buildnumber";if(-f "./build/getversion.pl"){ require "./build/getversion.pl" }elsif(-f "../../build/getversion.pl"){ require "../../build/getversion.pl";};'`

export VERSION
export BUILDNUMBER

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
			${BUILDDIR}/list_hiragana.pl \
			${BUILDDIR}/list_hiragana.txt \
			Makefile

BUILDXS=NanaXS-func

BUILDXSFILES=${XSSRC}/build/.NanaXS-func.build

XSFILES=	${XSSRC}/xsmake/ppport.h \
			${XSSRC}/pyukiwikixs.pl

buildxs:FORCE
	cd ${XSSRC}/xslib; \
	${PERL} Makefile.PL; \
	${MAKE}
	@for X in ${BUILDXS}; \
	do \
		cd ${XSSRC}; \
		cd $$X; \
		${PERL} Makefile.PL; \
		${MAKE}; \
		cd .. ; \
		cd .. ; \
		mkdir -p ${XSSRC}/build >/dev/null 2>/dev/null; \
		echo ${BUILDNUMBER} > ${XSSRC}/build/$$X.build; \
	done

testxs:FORCE
	${MAKE} -f ${BUILDDIR}/build_xs.mk buildxs
	@for X in ${BUILDXS}; \
	do \
		cd ${XSSRC}; \
		cd $$X; \
		${MAKE} test; \
		cd .. ; \
		cd .. ; \
		mkdir -p ${XSSRC}/build >/dev/null 2>/dev/null; \
		echo ${BUILDNUMBER} > ${XSSRC}/build/$$X.test; \
	done

installxs:FORCE
	${MAKE} -f ${BUILDDIR}/build_xs.mk testxs
	mkdir -p ${XSINSTALL} >/dev/null 2>/dev/null
	@for X in ${BUILDXS}; \
	do \
		echo Install $$X ;\
		cp -pR ${XSSRC}/$$X/blib/* ${XSINSTALL}; \
		mkdir -p ${XSSRC}/build >/dev/null 2>/dev/null; \
		echo ${BUILDNUMBER} > ${XSSRC}/build/$$X.install; \
	done
	@echo Order deny,allow>${XSINSTALL}/.htaccess
	@echo Deny from all>>${XSINSTALL}/.htaccess

updatexs:FORCE

deinstallxs:FORCE
	@echo Deinstall all xs module
	rm -rf ${XSINSTALL}

cleanxs:FORCE
	echo Cleaning xs library
	cd ${XSSRC}/xslib; \
	${PERL} Makefile.PL >/dev/null 2>/dev/null; \
	${MAKE} clean >/dev/null 2>/dev/null
	@for X in ${BUILDXS}; \
	do \
		echo Cleaning xs module work $$X; \
		cd ${XSSRC}; \
		cd $$X; \
		${PERL} Makefile.PL >/dev/null 2>/dev/null; \
		${MAKE} clean >/dev/null 2>/dev/null; \
		rm -f Makefile.old; \
		cd .. ; \
		cd .. ; \
	done
	rm -rf ${XSSRC}/build

FORCE:
