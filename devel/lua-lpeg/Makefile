# $NetBSD: Makefile,v 1.14 2017/07/12 11:07:36 wiz Exp $

DISTNAME=	lpeg-1.0.1
PKGNAME=	${DISTNAME:S/lpeg/${LUA_PKGPREFIX}-lpeg/}
CATEGORIES=	devel
MASTER_SITES=	http://www.inf.puc-rio.br/~roberto/lpeg/

MAINTAINER=	alnsn@NetBSD.org
HOMEPAGE=	http://www.inf.puc-rio.br/~roberto/lpeg/
COMMENT=	Parsing Expression Grammars (PEGs) library for Lua
LICENSE=	mit

NO_CONFIGURE=	yes
USE_TOOLS+=	gmake
MAKE_FILE=	makefile
TEST_TARGET=	test

BUILD_TARGET.Darwin=	macosx
BUILD_TARGET.*=		linux

SUBST_CLASSES+=		test
SUBST_MESSAGE.test=	Fixing shebang in test.lua
SUBST_STAGE.test=	post-build
SUBST_FILES.test=	test.lua
SUBST_SED.test=		-e 's,/usr/bin/env *lua,${LUA_INTERPRETER},'

INSTALLATION_DIRS+=	${LUA_CDIR} ${LUA_LDIR} ${LUA_DOCDIR}

do-install:
	${INSTALL_LIB} ${WRKSRC}/lpeg.so \
	                ${DESTDIR}${PREFIX}/${LUA_CDIR}
	${INSTALL_DATA} ${WRKSRC}/re.lua \
	                ${DESTDIR}${PREFIX}/${LUA_LDIR}
	${INSTALL_DATA} ${WRKSRC}/*.html \
	                ${DESTDIR}${PREFIX}/${LUA_DOCDIR}
	${INSTALL_DATA} ${WRKSRC}/lpeg-128.gif \
	                ${DESTDIR}${PREFIX}/${LUA_DOCDIR}
	${INSTALL_DATA} ${WRKSRC}/HISTORY \
	                ${DESTDIR}${PREFIX}/${LUA_DOCDIR}

.include "../../lang/lua/module.mk"
.include "../../lang/lua/application.mk"
.include "../../mk/bsd.pkg.mk"
