# $NetBSD: Makefile,v 1.42 2017/08/24 20:03:08 adam Exp $
#

DISTNAME=		apache-couchdb-2.0.0
PKGNAME=		${DISTNAME:S/apache-//}
PKGREVISION=		5
CATEGORIES=		databases
MASTER_SITES=		${MASTER_SITE_APACHE:=couchdb/source/${PKGVERSION_NOREV}/}

MAINTAINER=		filip@joyent.com
HOMEPAGE=		http://couchdb.apache.org/
COMMENT=		Document database server, accessible via a RESTful JSON API
LICENSE=		apache-2.0

HAS_CONFIGURE=		yes
USE_LANGUAGES=		c c++
USE_TOOLS+=		gmake install-info pax pkg-config
USE_LIBTOOL=		yes
INFO_FILES=		yes
BUILD_DEFS+=		VARBASE

BUILD_DEPENDS+=		help2man-[0-9]*:../../converters/help2man
BUILD_DEPENDS+=		rebar>=2.6.0<3:../../devel/rebar

.include "../../mk/bsd.prefs.mk"

COUCH_DBDIR?=		${VARBASE}/db/couchdb
COUCH_EGDIR=		${PREFIX}/share/examples/couchdb
COUCH_LOGDIR?=		${VARBASE}/log/couchdb
COUCH_RUNDIR?=		${VARBASE}/run/couchdb
COUCH_USER?=		couchdb
COUCH_GROUP?=		${COUCH_USER}

PKG_GROUPS+=		${COUCH_GROUP}
PKG_USERS+=		${COUCH_USER}:${COUCH_GROUP}
PKG_GECOS.${COUCH_USER}=CouchDB Server User
PKG_HOME.${COUCH_USER}=	${COUCH_DBDIR}
PKG_SHELL.${COUCH_USER}=${COMMAND_SHELL}

FILES_SUBST+=		COUCH_USER=${COUCH_USER}
FILES_SUBST+=		COUCH_GROUP=${COUCH_GROUP}
FILES_SUBST+=		COUCH_DBDIR=${COUCH_DBDIR}
FILES_SUBST+=		COUCH_RUNDIR=${COUCH_RUNDIR}
FILES_SUBST+=		ERTS_VERSION=${VERSION.erts}

OWN_DIRS=		${COUCH_LOGDIR} ${COUCH_DBDIR} ${COUCH_RUNDIR} ${PKG_SYSCONFDIR}
OWN_DIRS_PERMS+=	${COUCH_DBDIR} ${COUCH_USER} ${COUCH_GROUP} 0770
OWN_DIRS_PERMS+=	${COUCH_LOGDIR} ${COUCH_USER} ${COUCH_GROUP} 0770
OWN_DIRS_PERMS+=	${COUCH_RUNDIR} ${COUCH_USER} ${COUCH_GROUP} 0770

PKG_SYSCONFSUBDIR=	couchdb
PKG_SYSCONFDIR_PERMS=	${COUCH_USER} ${COUCH_GROUP} 0775
CONF_FILES_PERMS+=	${COUCH_EGDIR}/default.ini ${PKG_SYSCONFDIR}/default.ini\
			${COUCH_USER} ${COUCH_GROUP} 0660
CONF_FILES_PERMS+=	${COUCH_EGDIR}/local.ini ${PKG_SYSCONFDIR}/local.ini	\
			${COUCH_USER} ${COUCH_GROUP} 0660
CONF_FILES_PERMS+=	${COUCH_EGDIR}/vm.args ${PKG_SYSCONFDIR}/vm.args	\
			${COUCH_USER} ${COUCH_GROUP} 0660

SUBST_CLASSES+=		paths
SUBST_MESSAGE.paths=	Setting standard paths
SUBST_STAGE.paths=	pre-configure
SUBST_FILES.paths=	configure
SUBST_FILES.paths+=	rel/overlay/bin/couchdb
SUBST_FILES.paths+=	rel/overlay/etc/default.ini
SUBST_FILES.paths+=	src/config/src/config_app.erl
SUBST_VARS.paths=	COUCH_DBDIR COUCH_LOGDIR COUCH_RUNDIR PREFIX PKG_SYSCONFDIR

CONFIGURE_ARGS+=	--rebar\ ${PREFIX}/bin/rebar
CONFIGURE_ARGS+=	--user\ ${COUCH_USER}
CONFIGURE_ARGS+=	--skip-deps
CONFIGURE_ARGS+=	--with-curl

BUILD_TARGET=		release

INSTALLATION_DIRS+=	bin couchdb/lib
INSTALLATION_DIRS+=	couchdb/share/server couchdb/share/www/docs
INSTALLATION_DIRS+=	${PKGINFODIR} ${PKGMANDIR}/man1
INSTALLATION_DIRS+=	share/doc/couchdb share/examples/couchdb

RCD_SCRIPTS+=		couchdb

# This is silly, but the rebar release target embeds the Erlang VM
# into the tree, including existing Erlang module versions that might
# differ from those included in the tarball. We use a dynamic PLIST
# for the parts that may change.
GENERATE_PLIST=		cd ${DESTDIR}${PREFIX}; ${FIND}				\
				couchdb/erts-* couchdb/lib			\
				\( -type f -o -type l \) -print |		\
				${SORT} -u;

# We need to know the version of erts and subst it inside the SMF manifest
.include "../../lang/erlang/Makefile.versions"

do-install:
	cd ${WRKSRC}/rel/couchdb &&						\
		${PAX} -rw -pp erts-${VERSION.erts} lib releases		\
		${DESTDIR}${PREFIX}/couchdb
	${INSTALL_SCRIPT} ${WRKSRC}/rel/couchdb/bin/couchdb 			\
		${DESTDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKSRC}/rel/couchdb/bin/couchjs			\
		${DESTDIR}${PREFIX}/bin
	${INSTALL_INFO} ${WRKSRC}/rel/couchdb/share/docs/CouchDB.info		\
		${DESTDIR}${PREFIX}/${PKGINFODIR}/CouchDB.info
	${INSTALL_MAN} ${WRKSRC}/rel/couchdb/share/docs/couchdb.1		\
		${DESTDIR}${PREFIX}/${PKGMANDIR}/man1
	${INSTALL_DATA} ${WRKSRC}/share/docs/pdf/CouchDB.pdf			\
		${DESTDIR}${PREFIX}/share/doc/couchdb
	cd ${WRKSRC}/rel/couchdb/share && ${PAX} -rw -pp server www		\
		${DESTDIR}${PREFIX}/couchdb/share
	cd ${WRKSRC}/rel/couchdb/etc && ${PAX} -rw -pp *.ini vm.args		\
		${DESTDIR}${COUCH_EGDIR}

# The erlang VM gets embedded, but it may still need the curses lib
BUILDLINK_DEPMETHOD.erlang=	build
.include "../../mk/termcap.buildlink3.mk"
.include "../../lang/erlang/buildlink3.mk"

.include "../../lang/spidermonkey185/buildlink3.mk"
.include "../../security/openssl/buildlink3.mk"
.include "../../textproc/icu/buildlink3.mk"
.include "../../www/curl/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"
