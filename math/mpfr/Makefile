# $NetBSD: Makefile,v 1.32 2017/08/30 10:35:54 martin Exp $

DISTNAME=		mpfr-3.1.5
CATEGORIES=		math
MASTER_SITES=		http://www.mpfr.org/${DISTNAME}/
EXTRACT_SUFX=		.tar.bz2

MAINTAINER=		pkgsrc-users@NetBSD.org
HOMEPAGE=		http://www.mpfr.org/
COMMENT=		GMP-based library for multiple-precision floating-point computations
LICENSE=		gnu-lgpl-v3

GNU_CONFIGURE=		yes
USE_LIBTOOL=		yes
TEST_TARGET=		check
INFO_FILES=		yes

.include "../../devel/gmp/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"

.if (${MACHINE_ARCH} == alpha)
CONFIGURE_ENV+=CFLAGS="${CFLAGS:N-mieee}"
.endif

