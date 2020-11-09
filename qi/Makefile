# Makefile for Qi.
#
# Copyright (c) 2015-2020 Matias Fonzo, <selk@dragora.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project		= qi
version		= 2.2

## DO NOT MAKE CHANGES HERE.
#
# Use config.mak to override any of the following variables:
prefix		= /usr/local
exec_prefix	= $(prefix)
bindir		= $(exec_prefix)/bin
sbindir		= $(exec_prefix)/sbin
libexecdir	= $(exec_prefix)/libexec
sysconfdir	= $(prefix)/etc
localstatedir	= $(prefix)/var
datarootdir	= $(prefix)/share
infodir		= $(datarootdir)/info
mandir		= $(datarootdir)/man
docdir		= $(datarootdir)/doc
packagedir	= /usr/local/pkgs
targetdir	= /usr/local
arch		= $(shell uname -m)
##
DISTNAME	= ${project}-${version}

MAKEINFO	= makeinfo
INSTALL         = install
INSTALL_PROGRAM = ${INSTALL} -p -m 755
INSTALL_DATA    = ${INSTALL} -p -m 644
INSTALL_DIR     = mkdir -p -m 755
HELP2MAN_OPTS   = --locale=C --version-string=${version}

.PHONY: all \
	doc info man html \
	dist distclean clean \
	install install-info \
	uninstall uninstall-info

-include config.mak


all : $(project) $(project)rc

$(project) : src/$(project)

src/$(project) : src/$(project).in

	@echo "Making src/$(project) ..."
	@echo ""
	sed -e "s|@VERSION@|$(version)|g" \
	  -e "s|@PREFIX@|$(prefix)|g" \
	  -e "s|@BINDIR@|$(bindir)|g" \
	  -e "s|@SBINDIR@|$(sbindir)|g" \
	  -e "s|@LIBEXECDIR@|$(libexecdir)|g" \
	  -e "s|@SYSCONFDIR@|$(sysconfdir)|g" \
	  -e "s|@LOCALSTATEDIR@|$(localstatedir)|g" \
	  -e "s|@INFODIR@|$(infodir)|g" \
	  -e "s|@MANDIR@|$(mandir)|g" \
	  -e "s|@DOCDIR@|$(docdir)|g" \
	  -e "s|@PACKAGEDIR@|$(packagedir)|g" \
	  -e "s|@TARGETDIR@|$(targetdir)|g" \
	  -e "s|@ARCH@|$(arch)|g" \
	 $< > $@ && \
	 chmod 755 $@

$(project)rc : etc/$(project)rc

etc/$(project)rc : etc/$(project)rc.in

	@echo "Making config: etc/$(project)rc ..."
	@echo ""
	sed -e "s|@PREFIX@|$(prefix)|g" \
	  -e "s|@BINDIR@|$(bindir)|g" \
	  -e "s|@SBINDIR@|$(sbindir)|g" \
	  -e "s|@LIBEXECDIR@|$(libexecdir)|g" \
	  -e "s|@SYSCONFDIR@|$(sysconfdir)|g" \
	  -e "s|@LOCALSTATEDIR@|$(localstatedir)|g" \
	  -e "s|@INFODIR@|$(infodir)|g" \
	  -e "s|@MANDIR@|$(mandir)|g" \
	  -e "s|@DOCDIR@|$(docdir)|g" \
	  -e "s|@PACKAGEDIR@|$(packagedir)|g" \
	  -e "s|@TARGETDIR@|$(targetdir)|g" \
	  -e "s|@ARCH@|$(arch)|g" \
	 $< > $@ && \
	chmod 644 $@

doc : info man html

info : doc/$(project).info

doc/$(project).info : doc/$(project).texi
	cd doc && env LANG=C $(MAKEINFO) $(project).texi

man : doc/qi.1

doc/qi.1 : doc/qi.1.in
	help2man ${HELP2MAN_OPTS} \
	 --name="a simple but well-integrated package manager" \
	 --info-page=qi \
	 --output=$@ doc/qi.1.in
	 sed -e "s#QI.1.IN#QI#g" -e "s#qi.1.in#qi#g" -i $@

html : doc/$(project).html

doc/$(project).html : doc/$(project).texi
	cd doc && env LC_ALL=C $(MAKEINFO) --html --no-split \
	 $(project).texi

dist : doc
	rm -f $(DISTNAME)
	ln -sf . $(DISTNAME)
	tarlz --solid -9 -cvf $(DISTNAME).tar.lz \
	  $(DISTNAME)/AUTHORS \
	  $(DISTNAME)/COPYING \
	  $(DISTNAME)/CREDITS \
	  $(DISTNAME)/Makefile \
	  $(DISTNAME)/NEWS \
	  $(DISTNAME)/README.md \
	  $(DISTNAME)/configure \
	  $(DISTNAME)/doc/example.order \
	  $(DISTNAME)/doc/fdl.txt \
	  $(DISTNAME)/doc/qi.1 \
	  $(DISTNAME)/doc/qi.1.in \
	  $(DISTNAME)/doc/$(project).html \
	  $(DISTNAME)/doc/$(project).info \
	  $(DISTNAME)/doc/$(project).texi \
	  $(DISTNAME)/doc/recipe1 \
	  $(DISTNAME)/doc/recipe2 \
	  $(DISTNAME)/doc/recipe3 \
	  $(DISTNAME)/etc/$(project)rc.in \
	  $(DISTNAME)/src/qi.in
	rm -f $(DISTNAME)
	sha256sum $(DISTNAME).tar.lz > $(DISTNAME).tar.lz.sha256

distclean : clean
	-rm -f *.tar *.tar.lz *.tar.lz.*

clean :
	-rm -f src/$(project) etc/$(project)rc config.mak

install : all install-info install-man

	@echo ""
	@echo "* Checking required directories ..."
	if [ ! -d "$(DESTDIR)${bindir}" ] ; then \
	  $(INSTALL_DIR) "$(DESTDIR)${bindir}" ; \
	fi
	if [ ! -d "$(DESTDIR)${sysconfdir}" ] ; then \
	  $(INSTALL_DIR) "$(DESTDIR)${sysconfdir}" ; \
	fi

	@echo ""
	@echo "* Installing on $(DESTDIR)${bindir} ..."
	$(INSTALL_PROGRAM) src/$(project) "$(DESTDIR)${bindir}/$(project)"

	@echo ""
	@echo "* Installing config file on $(DESTDIR)${sysconfdir} ..."
	$(INSTALL_DATA) etc/$(project)rc "$(DESTDIR)${sysconfdir}/$(project)rc"

	@echo ""
	@echo "* Creating package and target directory (if needed) ..."
	if [ ! -d "$(DESTDIR)${packagedir}" ] ; then \
	  $(INSTALL_DIR) "$(DESTDIR)${packagedir}" ; \
	fi
	if [ ! -d "$(DESTDIR)${targetdir}" ] ; then \
	  $(INSTALL_DIR) "$(DESTDIR)${targetdir}" ; \
	fi
	@echo ""
	@echo "Done."

install-info :

	@echo ""
	@echo "* Installing Info document on $(DESTDIR)${infodir} ..."
	if [ ! -d "$(DESTDIR)${infodir}" ] ; then \
	    $(INSTALL_DIR) "$(DESTDIR)${infodir}" ; \
	fi

	$(INSTALL_DATA) doc/$(project).info \
	"$(DESTDIR)${infodir}/$(project).info"

	-install-info --info-dir="$(DESTDIR)${infodir}" \
	"$(DESTDIR)${infodir}/$(project).info"

install-man :

	@echo ""
	@echo "* Installing manual pages on $(DESTDIR)${mandir}/man1 ..."
	if [ ! -d "$(DESTDIR)${mandir}/man1" ] ; then \
	    $(INSTALL_DIR) "$(DESTDIR)${mandir}/man1" ; \
	fi                  

	$(INSTALL_DATA) doc/qi.1 "$(DESTDIR)${mandir}/man1"

uninstall : uninstall-info uninstall-man

	@echo ""
	@echo "* Uninstalling from $(DESTDIR)${bindir} ..."
	-rm -f "$(DESTDIR)${bindir}/$(project)"

	-rm -f "$(DESTDIR)${sysconfdir}/$(project)rc"

uninstall-info :

	-install-info \
	--info-dir="$(DESTDIR)${infodir}" \
	--remove "$(DESTDIR)${infodir}/$(project).info"

	-rm -f "$(DESTDIR)${infodir}/$(project).info"

uninstall-man :

	-rm -f "$(DESTDIR)${mandir}/man1/qi.1"

