# $NetBSD: Makefile,v 1.15 2017/08/24 20:03:32 adam Exp $

VERSION=	2.0.0_beta3
GITHUB_PROJECT=	opam
GITHUB_TAG=	${VERSION:S/_/-/}
DISTNAME=	${GITHUB_PROJECT}-${VERSION}
PKGNAME=	ocaml-${DISTNAME}
PKGREVISION=	1
CATEGORIES=	misc
MASTER_SITES=	${MASTER_SITE_GITHUB:=ocaml/}

MAINTAINER=	jaapb@NetBSD.org
HOMEPAGE=	http://opam.ocaml.org/
COMMENT=	OCaml package manager
LICENSE=	gnu-lgpl-v3
MAKE_JOBS_SAFE=	no

HAS_CONFIGURE=	yes
USE_TOOLS+=	bash gawk gmake

CONFIGURE_ARGS+=	--prefix=${PREFIX} --mandir=${PREFIX}/${PKGMANDIR}

BUILD_TARGET=	all
INSTALL_TARGET=	install libinstall
INSTALL_ENV+=	LIBINSTALL_DIR=${DESTDIR}${PREFIX}/${OCAML_SITELIBDIR}

.include "../../devel/ocaml-cmdliner/buildlink3.mk"
.include "../../devel/ocaml-extlib/buildlink3.mk"
.include "../../devel/ocaml-re/buildlink3.mk"
.include "../../devel/ocamlgraph/buildlink3.mk"
.include "../../lang/camlp4/buildlink3.mk"
.include "../../misc/dose3/buildlink3.mk" # with ocamlgraph option
.include "../../misc/ocaml-cudf/buildlink3.mk"
.include "../../misc/ocaml-opam-file-format/buildlink3.mk"
.include "../../textproc/ocaml-jsonm/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/ocaml.mk"
.include "../../mk/bsd.pkg.mk"
