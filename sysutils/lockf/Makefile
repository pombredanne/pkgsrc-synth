# $NetBSD: Makefile,v 1.3 2017/07/15 17:03:53 wiz Exp $

DISTNAME=	lockf-1
CATEGORIES=	sysutils
MASTER_SITES=	# none
DISTFILES=	# none

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://www.FreeBSD.org/
COMMENT=	FreeBSD's lockf
LICENSE=	original-bsd

WRKSRC=		${WRKDIR}
USE_LANGUAGES=	c

do-extract:
	cd ${FILESDIR} && cp *.c *.1 ${WRKSRC}/

.include "../../mk/bsd.prefs.mk"

INSTALLATION_DIRS=	bin ${PKGMANDIR}/man1

do-build:
	cd ${WRKSRC}; \
	 ${ECHO} "${CC} -o lockf lockf.c"; \
	 ${CC} ${CFLAGS} ${LDFLAGS} -o lockf lockf.c

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/lockf ${DESTDIR}${PREFIX}/bin/lockf
	${INSTALL_MAN} ${WRKSRC}/lockf.1 ${DESTDIR}${PREFIX}/${PKGMANDIR}/man1

.include "../../mk/bsd.pkg.mk"
