# Makefile for Qi.
#
# Copyright (c) 2015-2018 Matias Fonzo, <selk@dragora.org>.
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
version		= 1.0-rc48

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
packagedir	= $(prefix)/pkg
targetdir	= /
##
DISTNAME	= ${project}-${version}

MAKEINFO	= makeinfo
INSTALL         = install
INSTALL_PROGRAM = ${INSTALL} -p -m 755
INSTALL_DATA    = ${INSTALL} -p -m 644
INSTALL_DIR     = ${INSTALL} -d -m 755
HELP2MAN_OPTS   = --version-option=-V

.PHONY: all \
	doc info man html \
	dist distclean clean \
	install install-info \
	uninstall uninstall-info

-include config.mak


all : $(project) $(project)rc

$(project) : src/$(project)

src/$(project) : src/$(project).in
	@echo "Making tool: src/$(project) ..."
	@sed -e "s|@VERSION@|$(version)|g" \
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
	 $< > $@ && \
	 chmod 755 $@

$(project)rc : etc/$(project)rc

etc/$(project)rc : etc/$(project)rc.in
	@echo "Making config: etc/$(project)rc ..."
	@sed -e "s|@PREFIX@|$(prefix)|g" \
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
	 $< > $@ && \
	chmod 644 $@

doc : info man html

info : doc/$(project).info

doc/$(project).info : doc/$(project).texi
	cd doc && LC_ALL=C $(MAKEINFO) $(project).texi

man : doc/qi.1

doc/qi.1 : src/qi
	LC_ALL=C help2man ${HELP2MAN_OPTS} \
	 -n 'package manager' -o $@ src/qi

html : doc/$(project).html

doc/$(project).html : doc/$(project).texi
	cd doc && LC_ALL=C $(MAKEINFO) --html --no-split \
	 --css-ref=document-1.0.1.css $(project).texi

dist : doc
	ln -sf . $(DISTNAME)
	tar -Hustar -cvf $(DISTNAME).tar \
	  $(DISTNAME)/AUTHORS \
	  $(DISTNAME)/COPYING \
	  $(DISTNAME)/CREDITS \
	  $(DISTNAME)/Makefile \
	  $(DISTNAME)/NEWS \
	  $(DISTNAME)/README \
	  $(DISTNAME)/configure \
	  $(DISTNAME)/doc/recipe \
	  $(DISTNAME)/doc/document*.css \
	  $(DISTNAME)/doc/example.order \
	  $(DISTNAME)/doc/fdl.texi \
	  $(DISTNAME)/doc/qi.1 \
	  $(DISTNAME)/doc/$(project).html \
	  $(DISTNAME)/doc/$(project).info \
	  $(DISTNAME)/doc/$(project).texi \
	  $(DISTNAME)/etc/$(project)rc.in \
	  $(DISTNAME)/src/qi.in
	rm -f $(DISTNAME)
	lzip -v -9 $(DISTNAME).tar
	sha256sum $(DISTNAME).tar.lz > $(DISTNAME).tar.lz.sha256

distclean : clean
	-rm -f *.tar *.tar.lz *.tar.lz.*

clean :
	-rm -f src/$(project) etc/$(project)rc config.mak

install : all install-info install-man

	@echo "*** Checking required directories ..."

	if [ ! -d "$(DESTDIR)${bindir}" ] ; then \
	  $(INSTALL_DIR) "$(DESTDIR)${bindir}" ; \
	fi
	if [ ! -d "$(DESTDIR)${sysconfdir}" ] ; then \
	  $(INSTALL_DIR) "$(DESTDIR)${sysconfdir}" ; \
	fi

	@echo "*** Installing on $(DESTDIR)${bindir} ..."

	$(INSTALL_PROGRAM) src/$(project) "$(DESTDIR)${bindir}/$(project)"

	@echo "*** Installing config file on $(DESTDIR)${sysconfdir} ..."
	$(INSTALL_DATA) etc/$(project)rc "$(DESTDIR)${sysconfdir}/$(project)rc"

install-info :

	@echo "*** Checking required directory ..."

	if [ ! -d "$(DESTDIR)${infodir}" ] ; then \
	    $(INSTALL_DIR) "$(DESTDIR)${infodir}" ; \
	fi

	@echo "*** Installing Info document on $(DESTDIR)${infodir} ..."

	$(INSTALL_DATA) doc/$(project).info \
	"$(DESTDIR)${infodir}/$(project).info"

	-install-info --info-dir="$(DESTDIR)${infodir}" \
	"$(DESTDIR)${infodir}/$(project).info"

install-man :

	if [ ! -d "$(DESTDIR)${mandir}/man1" ] ; then \
	    $(INSTALL_DIR) "$(DESTDIR)${mandir}/man1" ; \
	fi                  
		  	
	@echo "*** Installing manual pages on $(DESTDIR)${mandir}/man1 ..."

	$(INSTALL_DATA) doc/qi.1 "$(DESTDIR)${mandir}/man1"

uninstall : uninstall-info uninstall-man

	@echo "*** Uninstalling from $(DESTDIR)${bindir} ..."

	-rm -f "$(DESTDIR)${bindir}/$(project)"

	-rm -f "$(DESTDIR)${sysconfdir}/$(project)rc"

uninstall-info :

	-install-info \
	--info-dir="$(DESTDIR)${infodir}" \
	--remove "$(DESTDIR)${infodir}/$(project).info"

	-rm -f "$(DESTDIR)${infodir}/$(project).info"

uninstall-man :

	-rm -f "$(DESTDIR)${mandir}/man1/qi.1"

