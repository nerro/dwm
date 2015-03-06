# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = dwm.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo [info] dwm build options:
	@echo "  CFLAGS   = ${CFLAGS}"
	@echo "  LDFLAGS  = ${LDFLAGS}"
	@echo "  CC       = ${CC}"

.c.o:
	@echo "  CC $<"
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo :: Creating $@ from config.def.h
	@cp config.def.h $@

dwm: ${OBJ}
	@echo "  CC -o $@"
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo :: Cleaning...
	@rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz config.h

dist: clean
	@echo :: Creating dist tarball...
	@mkdir -p dwm-${VERSION}
	@cp -R LICENSE Makefile README.md config.def.h config.mk \
		dwm.1 ${SRC} dwm-${VERSION}
	@tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	@gzip dwm-${VERSION}.tar
	@rm -rf dwm-${VERSION}

install: all
	@echo :: Installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dwm ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	@echo :: Installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

uninstall:
	@echo :: Removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dwm
	@echo :: Removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dwm.1

.PHONY: all options clean dist install uninstall
