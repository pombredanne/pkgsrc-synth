# $NetBSD: Makefile,v 1.14 2017/07/11 14:19:20 jaapb Exp $

DISTNAME=	pict-4.1
PKGREVISION=	10
CATEGORIES=	lang
MASTER_SITES=	http://www.cis.upenn.edu/~bcpierce/papers/pict/pict-4.1/

MAINTAINER=	dholland@NetBSD.org
HOMEPAGE=	http://www.cis.upenn.edu/~bcpierce/papers/pict/Html/Pict.html
COMMENT=	Concurrent language based on Milner's pi calculus

LICENSE=	gnu-gpl-v2

MAKE_JOBS_SAFE=		no

USE_TOOLS+=		gmake
INSTALLATION_DIRS+=	bin lib/pict share/doc/pict

MAKE_ENV+=		X11INCLUDE=${X11BASE}/include \
			X11LIB=${X11BASE}/lib

TEST_TARGET=	test

post-install:
	${INSTALL_DATA} ${WRKSRC}/Doc/*.ps ${DESTDIR}${PREFIX}/share/doc/pict/

.include "../../lang/ocaml/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
