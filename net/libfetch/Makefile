# $NetBSD: Makefile,v 1.59 2016/10/27 10:05:38 joerg Exp $
#

DISTNAME=	libfetch-2.38
CATEGORIES=	net
MASTER_SITES=	# empty
DISTFILES=	# empty

MAINTAINER=	joerg@NetBSD.org
HOMEPAGE=	http://www.FreeBSD.org/
COMMENT=	Library to access HTTP/FTP server
LICENSE=	modified-bsd

USE_FEATURES=		nbcompat

USE_BSD_MAKEFILE=	yes

.include "../../mk/bsd.prefs.mk"
.if !empty(FETCH_USING:Mfetch)
CHECK_PERMS=		no
.endif

INSTALLATION_DIRS=	include lib ${PKGMANDIR}/cat3 ${PKGMANDIR}/man3

BUILD_TARGET=	depend all
INSTALL_TARGET=	install includes

do-extract:
	${CP} -r ${FILESDIR} ${WRKSRC}
	${TOUCH} ${WRKSRC}/fetch.cat3

.include "options.mk"

.include "../../mk/bsd.pkg.mk"
