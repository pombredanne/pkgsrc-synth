# $NetBSD: Makefile,v 1.17 2017/07/11 14:19:23 jaapb Exp $
#

GITHUB_PROJECT=	eliom
DISTNAME=	${GITHUB_PROJECT}-6.2.0
PKGREVISION=	1
CATEGORIES=	www
MASTER_SITES=	${MASTER_SITE_GITHUB:=ocsigen/}

MAINTAINER=	jaapb@NetBSD.org
HOMEPAGE=	http://ocsigen.org/download/
COMMENT=	Dynamic webpage generation library
LICENSE=	gnu-lgpl-v2.1

USE_TOOLS+=	gmake
USE_LANGUAGES=	c
OCAML_USE_FINDLIB=	yes

DEPENDS+=	ocsigen>=2.8:../../www/ocsigen
DEPENDS+=	ocaml-deriving-ocsigen>=0.7.1:../../devel/ocaml-deriving-ocsigen

.include "../../mk/ocaml.mk"

.if ${OCAML_USE_OPT_COMPILER} == "yes"
BUILD_TARGET=	all
.else
BUILD_TARGET=	byte
.endif

do-install:
	cd ${WRKSRC} && opam-installer --install --prefix ${DESTDIR}${PREFIX} --libdir ${DESTDIR}${PREFIX}/${OCAML_SITELIBDIR} --docdir ${DESTDIR}${PREFIX}/share/doc eliom.install

.include "../../devel/js_of_ocaml/buildlink3.mk"
.include "../../devel/ocaml-react/buildlink3.mk"
.include "../../devel/ocaml-reactiveData/buildlink3.mk"
.include "../../devel/ocaml-optcomp/buildlink3.mk"
.include "../../devel/ocaml-ppx_tools/buildlink3.mk"
.include "../../devel/ocamlbuild/buildlink3.mk"
.include "../../misc/ocaml-opam/buildlink3.mk"
BUILDLINK_DEPMETHOD.ocaml-opam?=    build
.include "../../net/ocaml-ipaddr/buildlink3.mk"
.include "../../net/ocamlnet/buildlink3.mk"
.include "../../security/ocaml-ssl/buildlink3.mk"
.include "../../textproc/ocaml-tyxml/buildlink3.mk"
.include "../../time/ocaml-calendar/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
