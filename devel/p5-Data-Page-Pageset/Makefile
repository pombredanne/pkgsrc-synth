# $NetBSD: Makefile,v 1.2 2017/06/05 14:22:48 ryoon Exp $

DISTNAME=	Data-Page-Pageset-1.02
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	1
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=../../authors/id/C/CH/CHUNZI/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://search.cpan.org/dist/Data-Page-Pageset
COMMENT=	Change long page list to be shorter and well navigate
LICENSE=	${PERL5_LICENSE}

DEPENDS+=	p5-Class-Accessor-[0-9]*:../../devel/p5-Class-Accessor
DEPENDS+=	p5-Data-Page>=2:../../devel/p5-Data-Page

PERL5_PACKLIST=	auto/Data/Page/Pageset/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
