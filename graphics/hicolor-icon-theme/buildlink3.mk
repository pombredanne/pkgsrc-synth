# $NetBSD: buildlink3.mk,v 1.19 2015/11/25 12:50:43 jperkin Exp $

BUILDLINK_TREE+=	hicolor-icon-theme

.if !defined(HICOLOR_ICON_THEME_BUILDLINK3_MK)
HICOLOR_ICON_THEME_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.hicolor-icon-theme+=	hicolor-icon-theme>=0.4
BUILDLINK_ABI_DEPENDS.hicolor-icon-theme+=	hicolor-icon-theme>=0.9nb1
BUILDLINK_PKGSRCDIR.hicolor-icon-theme?=../../graphics/hicolor-icon-theme

.include "../../mk/bsd.fast.prefs.mk"

.if !defined(HICOLOR_ICON_THEME_DEPEND_ONLY)
FILES_SUBST+=		GTK_UPDATE_ICON_CACHE="${LOCALBASE}/bin/gtk-update-icon-cache"
FILES_SUBST+=		ICON_THEME_DIR="${BUILDLINK_PREFIX.hicolor-icon-theme}/share/icons/hicolor"
INSTALL_TEMPLATES+=	../../graphics/hicolor-icon-theme/files/icon-cache.tmpl
DEINSTALL_TEMPLATES+=	../../graphics/hicolor-icon-theme/files/icon-cache.tmpl

# The icon-theme cache file generated by gtk-update-icon-cache should
# never be in any PLIST.
#
PRINT_PLIST_AWK+=	/^share\/icons\/hicolor\/icon-theme.cache$$/ { next; }
CHECK_FILES_SKIP+=	${PREFIX}/share/icons/hicolor/icon-theme.cache

.if !defined(NOOP_GTK_UPDATE_ICON_CACHE)
NOOP_GTK_UPDATE_ICON_CACHE=
TOOLS_NOOP+=		gtk-update-icon-cache
.endif

.endif	# HICOLOR_ICON_THEME_DEPEND_ONLY
.endif # HICOLOR_ICON_THEME_BUILDLINK3_MK

BUILDLINK_TREE+=	-hicolor-icon-theme
