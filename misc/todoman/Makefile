# $NetBSD: Makefile,v 1.13 2017/09/04 14:44:58 wiz Exp $

DISTNAME=	todoman-3.2.1
CATEGORIES=	misc
MASTER_SITES=	${MASTER_SITE_PYPI:=t/todoman/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	https://github.com/pimutils/todoman
COMMENT=	Simple CalDav-based todo manager
LICENSE=	mit

DEPENDS+=	${PYPKGPREFIX}-atomicwrites-[0-9]*:../../devel/py-atomicwrites
DEPENDS+=	${PYPKGPREFIX}-click>=6.0:../../devel/py-click
DEPENDS+=	${PYPKGPREFIX}-configobj-[0-9]*:../../devel/py-configobj
DEPENDS+=	${PYPKGPREFIX}-dateutil-[0-9]*:../../time/py-dateutil
DEPENDS+=	${PYPKGPREFIX}-humanize-[0-9]*:../../textproc/py-humanize
DEPENDS+=	${PYPKGPREFIX}-icalendar-[0-9]*:../../time/py-icalendar
DEPENDS+=	${PYPKGPREFIX}-parsedatetime-[0-9]*:../../time/py-parsedatetime
DEPENDS+=	${PYPKGPREFIX}-tabulate-[0-9]*:../../textproc/py-tabulate
DEPENDS+=	${PYPKGPREFIX}-urwid-[0-9]*:../../devel/py-urwid
DEPENDS+=	${PYPKGPREFIX}-xdg-[0-9]*:../../devel/py-xdg
BUILD_DEPENDS+=	${PYPKGPREFIX}-setuptools_scm-[0-9]*:../../devel/py-setuptools_scm
BUILD_DEPENDS+=	${PYPKGPREFIX}-test-runner-[0-9]*:../../devel/py-test-runner

# TEST_DEPENDS
BUILD_DEPENDS+=	${PYPKGPREFIX}-flake8-[0-9]*:../../devel/py-flake8
BUILD_DEPENDS+=	${PYPKGPREFIX}-flakes-[0-9]*:../../devel/py-flakes
BUILD_DEPENDS+=	${PYPKGPREFIX}-flake8-import-order-[0-9]*:../../devel/py-flake8-import-order
BUILD_DEPENDS+=	${PYPKGPREFIX}-freezegun-[0-9]*:../../devel/py-freezegun
BUILD_DEPENDS+=	${PYPKGPREFIX}-hypothesis-[0-9]*:../../devel/py-hypothesis
BUILD_DEPENDS+=	${PYPKGPREFIX}-test-[0-9]*:../../devel/py-test
BUILD_DEPENDS+=	${PYPKGPREFIX}-test-cov-[0-9]*:../../devel/py-test-cov

PYTHON_VERSIONS_INCOMPATIBLE=	27
REPLACE_PYTHON+=	bin/todo
USE_LANGUAGES=	# none

# overwrite automatically generated file with recommended one, per
# "Notes for Packagers" in documentation
post-install:
	${INSTALL_SCRIPT} ${WRKSRC}/bin/todo ${DESTDIR}${PREFIX}/bin

.include "../../lang/python/application.mk"
.include "../../lang/python/egg.mk"
.include "../../mk/bsd.pkg.mk"
# needed due to py-click
TEST_ENV+=	LC_ALL=en_US.UTF-8
