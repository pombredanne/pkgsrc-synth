# $NetBSD: alternatives.mk,v 1.12 2015/11/25 13:05:47 jperkin Exp $
#
# This Makefile fragment handles the alternatives system, registering a
# package in the database.
#
# User-settable variables:
#
# (none)
#
# Package-settable variables:
#
# ALTERNATIVES_SRC
#	A _single_ file that contains the alternatives provided by the
#	package.
#
#	Default value: The name of the ALTERNATIVES file in the package
#	directory, if it exists. Otherwise, nothing.
#
#	Each line of the alternatives file contains two filenames, first
#	the wrapper and then the alternative provided by the package.
#	Both paths are relative to PREFIX.
#
# Variables defined by this file:
#
# PKG_ALTERNATIVES
#	The path to the pkg_alternatives command.
#

.if !defined(ALTERNATIVES_MK)
ALTERNATIVES_MK=	# defined

_VARGROUPS+=		alternatives
_PKG_VARS.alternatives=	ALTERNATIVES_SRC
_SYS_VARS.alternatives=	PKG_ALTERNATIVES

.if exists(${.CURDIR}/ALTERNATIVES)
ALTERNATIVES_SRC?=	${.CURDIR}/ALTERNATIVES
.endif
ALTERNATIVES_SRC?=	# none

.if !empty(ALTERNATIVES_SRC)

# pkgsrc-synth hack, this needs USE_TOOLS+=pkg_alternatives:run
DEPENDS+=	pkg_alternatives-[0-9]*:../../pkgtools/pkg_alternatives

${WRKDIR}/.altinstall: ${ALTERNATIVES_SRC}
	@{ ${ECHO} 'if ${TEST} $${STAGE} = "POST-INSTALL"; then'; \
	${ECHO} 'if ${TEST} -x ${PKG_ALTERNATIVES}; then'; \
	${ECHO} '${CAT} >/tmp/${PKGBASE}_ALTERNATIVES <<EOF'; \
	${SED} ${FILES_SUBST_SED} <${ALTERNATIVES_SRC}; \
	${ECHO} 'EOF'; \
	${ECHO} '${PKG_ALTERNATIVES} -gs register /tmp/${PKGBASE}_ALTERNATIVES'; \
	${ECHO} '${RM} -f /tmp/${PKGBASE}_ALTERNATIVES'; \
	${ECHO} 'fi'; \
	${ECHO} 'fi'; \
	} >${WRKDIR}/.altinstall

${WRKDIR}/.altdeinstall: ${ALTERNATIVES_SRC}
	@{ ${ECHO} 'if ${TEST} $${STAGE} = "DEINSTALL"; then'; \
	${ECHO} 'if ${TEST} -x ${PKG_ALTERNATIVES}; then'; \
	${ECHO} '${CAT} >/tmp/${PKGBASE}_ALTERNATIVES <<EOF'; \
	${SED} ${FILES_SUBST_SED} <${ALTERNATIVES_SRC}; \
	${ECHO} 'EOF'; \
	${ECHO} '${PKG_ALTERNATIVES} -gs unregister /tmp/${PKGBASE}_ALTERNATIVES'; \
	${ECHO} '${RM} -f /tmp/${PKGBASE}_ALTERNATIVES'; \
	${ECHO} 'fi'; \
	${ECHO} 'fi'; \
	} >${WRKDIR}/.altdeinstall

PRINT_PLIST_AWK+=	/^libdata\/alternatives\// { next; }

PKG_ALTERNATIVES=	${LOCALBASE}/sbin/pkg_alternatives

INSTALL_TEMPLATES+=	${WRKDIR}/.altinstall
DEINSTALL_TEMPLATES+=	${WRKDIR}/.altdeinstall

.endif

.endif	# ALTERNATIVES_MK
