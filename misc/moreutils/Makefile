# $NetBSD: Makefile,v 1.2 2017/09/06 12:38:32 leot Exp $

DISTNAME=	moreutils_0.60.orig
PKGNAME=	${DISTNAME:S/_/-/:S/.orig//}
CATEGORIES=	misc
MASTER_SITES=	${MASTER_SITE_DEBIAN:=pool/main/m/moreutils/}
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	leot@NetBSD.org
HOMEPAGE=	https://joeyh.name/code/moreutils/
COMMENT=	Additional Unix utilities
LICENSE=	gnu-gpl-v2

BUILD_DEPENDS+=	docbook-xsl-[0-9]*:../../textproc/docbook-xsl
BUILD_DEPENDS+=	libxml2-[0-9]*:../../textproc/libxml2
BUILD_DEPENDS+=	libxslt-[0-9]*:../../textproc/libxslt

DEPENDS+=	p5-IPC-Run-[0-9]*:../../devel/p5-IPC-Run

USE_TOOLS+=	gmake pod2man perl:run
WRKSRC=		${WRKDIR}/${PKGNAME_NOREV}

USE_LANGUAGES=	c99

REPLACE_PERL+=	chronic
REPLACE_PERL+=	combine
REPLACE_PERL+=	ts
REPLACE_PERL+=	vidir
REPLACE_PERL+=	vipe
REPLACE_PERL+=	zrun

SUBST_CLASSES+=			pkgmandir
SUBST_STAGE.pkgmandir=		pre-configure
SUBST_FILES.pkgmandir=		Makefile
SUBST_MESSAGE.pkgmandir=	Fixing man page installation.
SUBST_SED.pkgmandir=		-e 's,share/man,${PKGMANDIR},'

MAKE_ENV+=	\
	PREFIX=${PREFIX} \
	CFLAGS=${CFLAGS:Q} \
	LDFLAGS=${LDFLAGS:Q} \
	DOCBOOKXSL=${PREFIX}/share/xsl/docbook \
	INSTALL_BIN=${INSTALL_PROGRAM:Q} \
	INSTALL_MAN=${INSTALL_MAN:Q} \
	INSTALL_SCRIPT=${INSTALL_SCRIPT:Q}

.include "../../mk/bsd.pkg.mk"
