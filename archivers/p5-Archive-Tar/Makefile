# $NetBSD: Makefile,v 1.71 2017/06/05 14:22:16 ryoon Exp $

DISTNAME=	Archive-Tar-2.24
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	1
CATEGORIES=	archivers perl5
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Archive/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://search.cpan.org/dist/Archive-Tar/
COMMENT=	Perl5 module interface to manipulate tar files
LICENSE=	${PERL5_LICENSE}

#DEPENDS+=	{perl>=5.9.3,p5-IO-Zlib>=1.01}:../../devel/p5-IO-Zlib
# IO::Compress::{Base,Gzip,Bzip2} are included since perl-5.10.1
#DEPENDS+=	{perl>=5.10.1,p5-IO-Compress>=2.017}:../../devel/p5-IO-Compress
DEPENDS+=	p5-IO-String-[0-9]*:../../devel/p5-IO-String
DEPENDS+=	p5-Text-Diff-[0-9]*:../../textproc/p5-Text-Diff

MAKE_PARAMS+=		"-d"	# Text::Diff is a prerequisite
PERL5_PACKLIST=		auto/Archive/Tar/.packlist

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
