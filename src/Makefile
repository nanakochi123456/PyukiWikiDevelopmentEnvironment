######################################################
# release file makefile for pyukiwiki
# $Id$
######################################################

MAKE=gmake --no-print-directory
BUILDDIR=./build

all:FORCE
	@${MAKE} all -f ${BUILDDIR}/build.mk

clean:FORCE
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} clean  -f ${BUILDDIR}/build.mk

tempclean:FORCE
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} tempclean  -f ${BUILDDIR}/build.mk

pkgclean:FORCE
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} pkgclean  -f ${BUILDDIR}/build.mk

cvsclean:FORCE
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cvsclean  -f ${BUILDDIR}/build.mk

touch:FORCE
	@${MAKE} touch  -f ${BUILDDIR}/build.mk

realclean:FORCE
	@${MAKE} realclean  -f ${BUILDDIR}/build.mk

ftp:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} ftp  -f ${BUILDDIR}/build.mk

build:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build -f ${BUILDDIR}/build.mk

buildall:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} buildall  -f ${BUILDDIR}/build.mk

buildallutf8:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} buildallutf8  -f ${BUILDDIR}/build.mk

builddevel:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} builddevel  -f ${BUILDDIR}/build.mk

builddevelutf8:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} builddevelutf8  -f ${BUILDDIR}/build.mk

buildrelease:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} buildrelease  -f ${BUILDDIR}/build.mk

buildreleaseutf8:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} buildreleaseutf8  -f ${BUILDDIR}/build.mk

buildcompact:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} buildcompact  -f ${BUILDDIR}/build.mk

buildcompactutf8:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} buildcompactutf8  -f ${BUILDDIR}/build.mk

prof:FORCE
	@${MAKE} prof  -f ${BUILDDIR}/build.mk

version:FORCE
	@${MAKE} version  -f ${BUILDDIR}/build.mk

versionall:FORCE
	@${MAKE} versionall  -f ${BUILDDIR}/build.mk

pkg:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} pkg  -f ${BUILDDIR}/build.mk

release:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} release  -f ${BUILDDIR}/build.mk

releasedevel:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk
	@${MAKE} build  -f ${BUILDDIR}/build.mk
	@${MAKE} releasedevel  -f ${BUILDDIR}/build.mk

mailaddr:FORCE
	@${MAKE} mailaddr -f ${BUILDDIR}/build.mk

buildxs:FORCE
	@${MAKE} buildxs -f ${BUILDDIR}/build_xs.mk

xsbuild:FORCE
	@${MAKE} buildxs -f ${BUILDDIR}/build_xs.mk

testxs:FORCE
	@${MAKE} testxs -f ${BUILDDIR}/build_xs.mk

xstest:FORCE
	@${MAKE} testxs -f ${BUILDDIR}/build_xs.mk

installxs:FORCE
	@${MAKE} installxs -f ${BUILDDIR}/build_xs.mk

xsinstall:FORCE
	@${MAKE} installxs -f ${BUILDDIR}/build_xs.mk

updatexs:FORCE
	@${MAKE} updatexs -f ${BUILDDIR}/build_xs.mk

xsupdate:FORCE
	@${MAKE} updatexs -f ${BUILDDIR}/build_xs.mk

deinstallxs:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk

xsdeinstall:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk

removexs:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk

xsremove:FORCE
	@${MAKE} deinstallxs -f ${BUILDDIR}/build_xs.mk

cleanxs:FORCE
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk

xsclean:FORCE
	@${MAKE} cleanxs -f ${BUILDDIR}/build_xs.mk

builddoc:FORCE
	@${MAKE} builddoc -f ${BUILDDIR}/build_doc.mk

doc:FORCE
	@${MAKE} builddoc -f ${BUILDDIR}/build_doc.mk

buildimage:FORCE
	@${MAKE} make -f ${BUILDDIR}/build_img.mk

cleanimage:FORCE
	@${MAKE} clean -f ${BUILDDIR}/build_img.mk

FORCE:
