# release file makefile for PyukiWiki 
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

PKGNAME=PyukiWiki

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
	@echo "PyukiWiki ${VERSION} Release Builder"
	@echo "Usage: ${MAKE} [build|builddoc|prof|release|buildrelease|buildreleaseutf8|builddevel|builddevelutf8|buildcompact|buildcompactutf8|pkg|clean|realclean|cvsclean|ftp]"

version:
	@echo "PyukiWiki ${VERSION}"

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

make:FORCE
	mkdir -p ./temp
	@${PERL} ${BUILDDIR}/build_img.pl make ./temp/tmpimg.mk
	@${MAKE} -f ./temp/tmpimg.mk

clean:FORCE
	rm -f image/exedit.png image/face.png image/icon.png image/lang.png image/login16.png image/login32.png image/navi.png
	rm -f skin/img*.css*

FORCE:
