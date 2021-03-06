# $NetBSD: Makefile,v 1.21 2017/08/19 00:24:13 jlam Exp $

DISTNAME=	pkg-1.9.99.4
PKGREVISION=	1
CATEGORIES=	pkgtools
MASTER_SITES=	http://files.etoilebsd.net/pkg/
EXTRACT_SUFX=	.tar.xz

MAINTAINER=	khorben@defora.org
HOMEPAGE=	https://wiki.freebsd.org/pkgng
COMMENT=	Package management tool for FreeBSD
LICENSE=	2-clause-bsd

BOOTSTRAP_PKG=	yes
GNU_CONFIGURE=	yes
USE_CWRAPPERS=	no
USE_LANGUAGES=	c

SKIP_LICENSE_CHECK=	yes
FILESDIR.pkg_install=	${PKGDIR:H}/pkg_install/files
FILESDIR.pkgng_admin=	${.CURDIR}/pkgng_files
WRKSRC.pkgng=		${WRKDIR}/pkgng

CPPFLAGS+=	-D_LOCALBASE="\"${PREFIX}\""
CPPFLAGS+=	-DPORTSDIR="\"${PKG.portsdir}\""
CPPFLAGS+=	-DDEFAULT_VULNXML_URL="\"http://muscles.dragonflybsd.org/pkgsrc-vuxml/vuln.xml.bz2\""
CFLAGS+=	-DSYSCONFDIR=\"${PKG_SYSCONFDIR}\"

.if defined(DEBUG_PKGNG)
CFLAGS:=	${CFLAGS:N-O2} -ggdb -O0
_STRIPFLAG_INSTALL=	# don't strip
.endif

AUTO_MKDIRS=	yes

EGDIR=		${PREFIX}/share/examples/pkg

CONF_FILES+=	${EGDIR}/bash_completion.d/_pkg.bash \
		${PKG_SYSCONFDIR}/bash_completion.d/_pkg.bash
CONF_FILES+=	${EGDIR}/periodic/daily/411.pkg-backup \
		${PKG_SYSCONFDIR}/periodic/daily/411.pkg-backup
CONF_FILES+=	${EGDIR}/periodic/daily/490.status-pkg-changes \
		${PKG_SYSCONFDIR}/periodic/daily/490.status-pkg-changes
CONF_FILES+=	${EGDIR}/periodic/security/410.pkg-audit \
		${PKG_SYSCONFDIR}/periodic/security/410.pkg-audit
CONF_FILES+=	${EGDIR}/periodic/security/460.pkg-checksum \
		${PKG_SYSCONFDIR}/periodic/security/460.pkg-checksum
CONF_FILES+=	${EGDIR}/periodic/weekly/400.status-pkg \
		${PKG_SYSCONFDIR}/periodic/weekly/400.status-pkg
CONF_FILES+=	${EGDIR}/pkg.conf.sample \
		${PKG_SYSCONFDIR}/pkg.conf

OWN_DIRS=	${PKG_SYSCONFDIR}/bash_completion.d \
		${PKG_SYSCONFDIR}/periodic/daily \
		${PKG_SYSCONFDIR}/periodic/security \
		${PKG_SYSCONFDIR}/periodic/weekly

SUBST_CLASSES+=	manpages-prefix
SUBST_STAGE.manpages-prefix=	pre-install
SUBST_FILES.manpages-prefix=	docs/pkg-install.8 docs/pkg-repo.8
SUBST_FILES.manpages-prefix+=	docs/pkg-search.8 docs/pkg-update.8
SUBST_FILES.manpages-prefix+=	docs/pkg-upgrade.8 docs/pkg.8
SUBST_FILES.manpages-prefix+=	docs/pkg.conf.5
SUBST_SED.manpages-prefix+=	-e "s|/usr/local|${PREFIX}|g"
SUBST_MESSAGE.manpages-prefix=	Correct the installation prefix in manual pages.

SUBST_CLASSES+=	pkgconf-prefix
SUBST_STAGE.pkgconf-prefix=	pre-install
SUBST_FILES.pkgconf-prefix=	src/pkg.conf.sample
SUBST_SED.pkgconf-prefix+=	-e "s|/usr/local|${PREFIX}|g"
SUBST_MESSAGE.pkgconf-prefix=	Correct the installation prefix in pkg.conf(5).

SUBST_CLASSES+=		portsdir
SUBST_STAGE.portsdir=	pre-install
SUBST_FILES.portsdir=	src/pkg.conf.sample \
			docs/pkg-create.8 \
			docs/pkg-set.8 \
			docs/pkg-repo.8 \
			docs/pkg.conf.5 \
			docs/pkg-version.8 \
			docs/pkg.8
SUBST_SED.portsdir=	-e "s|/usr/ports|${PKG.portsdir}|g" \
			-e "s|/var/db/pkg|${PKGNG_DBDIR}|g" \
			-e "s|/var/cache/pkg|${VARBASE}/cache/pkgng|g"
SUBST_MESSAGE.portsdir=	Correct reference to FreeBSD portsdir.

SUBST_CLASSES+=		config
SUBST_STAGE.config=	post-patch
SUBST_FILES.config=	libpkg/pkg_config.c
SUBST_SED.config=	-e "s|/usr/ports|${PKG.portsdir}|g" \
			-e "s|/var/db/pkg|${PKGNG_DBDIR}|g" \
			-e "s|/var/cache/pkg|${VARBASE}/cache/pkgng|g"
SUBST_MESSAGE.config=	Update pkg(8) defaults.

SUBST_CLASSES+=		vuxml
SUBST_STAGE.vuxml=	post-patch
SUBST_FILES.vuxml=	libpkg/pkg_audit.c
SUBST_SED.vuxml=	-e "s|https://vuxml.FreeBSD.org/freebsd|http://muscles.dragonflybsd.org/pkgsrc-vuxml/reports|"
SUBST_MESSAGE.vuxml=	Direct audit reports to Pkgsrc vuxml

# Install manpages under ${PKGMANDIR}.
INSTALL_MAKE_FLAGS+=	mandir=${PREFIX:Q}/${PKGMANDIR:Q}

.if defined(PACKAGE_BUILDING) # set by Synth which has custom location, so use default path
PKG.portsdir?=	/usr/pkgsrc
.else
PKG.portsdir?=	${PKGSRCDIR}
.endif

# DragonFly SSL libraries are private.  pkg(8) is the one exception of a userland
# program that is allowed to link to them due to bootstrap reasons
.if exists(/usr/lib/priv/libprivate_ssl.so)
BUILDLINK_PASSTHRU_RPATHDIRS=	/lib/priv
.endif

post-extract:
	${CP} -R ${FILESDIR.pkgng_admin} ${WRKSRC.pkgng}
	${CP} ${FILESDIR.pkg_install}/lib/dewey.[ch] \
		${FILESDIR.pkg_install}/lib/license.c \
		${FILESDIR.pkg_install}/lib/opattern.c ${WRKSRC.pkgng}/
	${SED} -e "s|@SYSCONFDIR@|${PKG_SYSCONFDIR}|" \
		${WRKSRC.pkgng}/pkgng_admin.conf.5.in > \
		${WRKSRC.pkgng}/pkgng_admin.conf.5

post-patch:
# DragonFly SSL libraries are private.
.if exists(/usr/lib/priv/libprivate_ssl.so)
	${SED} -i.bak \
		-e 's|lssl|lprivate_ssl|' \
		-e 's|lcrypto|lprivate_crypto|' \
		-e 's|la_rpath = |la_rpath = -R/lib/priv |' \
		${WRKSRC}/libpkg/Makefile.in \
		${WRKSRC}/src/Makefile.in \
		${WRKSRC}/tests/Makefile.in
	${SED} -i.bak \
		-e '/OS_CFLAGS=/ s|SOURCE|SOURCE -I/usr/include/priv|' \
		-e '/OS_LDFLAGS=/ s|=|="-L/usr/lib/priv -R/lib/priv"|' \
		${WRKSRC}/configure
.endif

pre-build:
	@(cd ${WRKSRC.pkgng} && ${BUILD_MAKE_CMD} all)

post-install:
	${RM} ${DESTDIR}${PREFIX}/sbin/pkg2ng
	${RM} -rf ${DESTDIR}${EGDIR}/periodic
	${MV} ${DESTDIR}${PREFIX}/etc/bash_completion.d \
		${DESTDIR}${EGDIR}/
	${MV} ${DESTDIR}${PREFIX}/etc/periodic \
		${DESTDIR}${EGDIR}/
	${MV} ${DESTDIR}${PREFIX}/etc/pkg.conf.sample \
		${DESTDIR}${EGDIR}/
	(cd ${WRKSRC.pkgng} && ${PKGSRC_SETENV} ${INSTALL_ENV} ${MAKE_ENV} \
		${MAKE_PROGRAM} ${MAKE_FLAGS} ${INSTALL_MAKE_FLAGS} \
		-f Makefile install)

deinstall:
	@${ECHO} "*************************************************************"
	@${ECHO} " Do not deinstall pkgtools/pkg!"
	@${ECHO} " To upgrade, just 'install' which will update files in-place"
	@${ECHO} "*************************************************************"

su-real-package-install:
	@${ECHO} "Force-installing ${PKGNAME}"
	@${PKG_ADD_CMD} -f ${STAGE_PKGFILE}

install:
	# do nothing

.include "../../mk/bsd.prefs.mk"

.if defined (PKG_DBDIR)
PKGNG_DBDIR?=	${PKG_DBDIR}
.else
PKGNG_DBDIR?=	${PREFIX}/pkgng-db
.endif

.if ${OPSYS} == "NetBSD"
BUILDLINK_TRANSFORM+=	rm:-Wl,--enable-new-dtags
.endif

# Disable checksum when pkg(8) is not installed and PKG_FORMAT is "pkgng".
# This format requires pkg to be present for the "info" capability used
# extensively, including for checksums.  It's bootstrap chicken/egg scenario.
# This is here to allow someone to build and reinstall pkg(8) when a new
# version comes out.

# Note that pkgtools/pkgng_admin and pkgtools/bootstrap-mk-files must be
# present before pkg(8) can be rebuilt.  There's is seemingly no way to
# enforce this requirement because pkgng PKG_FORMAT requires pkgng_admin
# to function properly.

.if ${PKG_FORMAT:Mpkgng} && !exists(${PKG_CMD})
NO_CHECKSUM=			yes
ALLOW_VULNERABLE_PACKAGES=	yes
TOOLS_IGNORE.digest=		# block dependency on digest
STATIC_PKG=			${DESTDIR}${LOCALBASE}/sbin/pkg-static
PKG_ADD_CMD=			${SETENV} PKG_DBDIR=${PKG_DBDIR:Q} \
				INSTALL_AS_USER=yes ${STATIC_PKG} add
PKG_CREATE=			${SETENV} PKG_DBDIR=${PKG_DBDIR:Q} \
				${STATIC_PKG} create
.endif

.if ${OPSYS} != "FreeBSD" && ${OPSYS} != "DragonFly" && ${OPSYS} != "NetBSD"
.include "../../archivers/libarchive/buildlink3.mk"
.endif
.include "../../mk/bsd.pkg.mk"
