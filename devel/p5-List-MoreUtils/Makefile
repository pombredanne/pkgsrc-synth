# $NetBSD: Makefile,v 1.32 2017/09/04 12:30:47 wiz Exp $

DISTNAME=	List-MoreUtils-0.423
PKGNAME=	p5-${DISTNAME}
CATEGORIES=	devel perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=List/}
MASTER_SITES+=	${MASTER_SITE_PERL_CPAN:=../../authors/id/V/VP/VPARSEVAL/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://search.cpan.org/dist/List-MoreUtils/
COMMENT=	Provide the stuff missing in List::Util
LICENSE=	apache-2.0

DEPENDS+=	p5-Exporter-Tiny-[0-9]*:../../devel/p5-Exporter-Tiny
DEPENDS+=	p5-List-MoreUtils-XS>=0.423:../../devel/p5-List-MoreUtils-XS

PERL5_PACKLIST=	auto/List/MoreUtils/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
