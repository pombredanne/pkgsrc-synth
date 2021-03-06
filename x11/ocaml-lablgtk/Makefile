# $NetBSD: Makefile,v 1.27 2017/09/05 04:35:21 dholland Exp $

DISTNAME=	lablgtk-2.18.5
PKGNAME=	ocaml-${DISTNAME}
PKGREVISION=	8
CATEGORIES=	x11
MASTER_SITES=	https://forge.ocamlcore.org/frs/download.php/1627/

MAINTAINER=	jaapb@NetBSD.org
HOMEPAGE=	http://lablgtk.forge.ocamlcore.org/
COMMENT=	GTK+ 2.x bindings for Objective Caml
# for installed files; more restrictions on applications/
LICENSE=	gnu-lgpl-v2

GNU_CONFIGURE=		yes
CONFIGURE_ARGS+=	--enable-debug
USE_TOOLS+=		gmake pkg-config
OCAML_USE_FINDLIB=	yes
OCAML_FINDLIB_DIRS=	lablgtk2

MAKE_JOBS_SAFE=		no
BUILD_TARGET=		world

BUILDLINK_DEPMETHOD.ocaml=	full

CONFLICTS=	lablgtk-[0-9]*
SUPERSEDES=	lablgtk-[0-9]*

CONFIGURE_ENV+=	OCAML_SITELIBDIR="${OCAML_SITELIBDIR}"

.include "../../mk/bsd.prefs.mk"

# Stub libraries for functions missing from base system.
PLIST_VARS+=	stubs

.if ${OPSYS} == "Darwin" || ${OPSYS} == "DragonFly" || \
    ${OPSYS} == "NetBSD" || ${OPSYS} == "FreeBSD" || \
    ${OPSYS} == "SunOS"  || ${OPSYS} == "Linux"
PLIST.stubs=	yes
.endif

.include "../../mk/ocaml.mk"

.include "options.mk"

.include "../../devel/atk/buildlink3.mk"
.include "../../devel/glib2/buildlink3.mk"
.include "../../devel/pango/buildlink3.mk"
.include "../../graphics/cairo/buildlink3.mk"
.include "../../graphics/gdk-pixbuf2/buildlink3.mk"
.include "../../graphics/libart/buildlink3.mk"
.include "../../textproc/libxml2/buildlink3.mk"
.include "../../x11/gtk2/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
