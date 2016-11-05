# $NetBSD: bsd.pkginstall.mk,v 1.69 2016/06/17 08:53:42 jaapb Exp $
#
# This Makefile fragment is included by bsd.pkg.mk and implements the
# common INSTALL/DEINSTALL scripts framework.  To use the pkginstall
# framework, simply set the relevant variables to customize the install
# scripts to the package.
#
# User-settable variables:
#
# FONTS_VERBOSE indicates whether the +FONTS scriptlet will output a message
#	noting the actions taken if PKG_UPDATE_FONTS_DB is YES.  It is either
#	YES or NO and defaults to YES for PKG_DEVELOPERs, otherwise NO.
#
_VARGROUPS+=		pkginstall
_USER_VARS.pkginstall= \
	FONTS_VERBOSE \
	PKG_CREATE_USERGROUP \
	PKG_CONFIG PKG_CONFIG_PERMS \
	PKG_RCD_SCRIPTS \
	PKG_REGISTER_SHELLS \
	PKG_UPDATE_FONTS_DB
_PKG_VARS.pkginstall= \
	DEINSTALL_TEMPLATES INSTALL_TEMPLATES \
	DEINSTALL_SRC INSTALL_SRC \
	FILES_SUBST \
	PKG_USERS PKG_GROUPS USERGROUP_PHASE
.for u in ${PKG_USERS}
_PKG_VARS.pkginstall+=	PKG_UID.${u} PKG_GECOS.${u} PKG_HOME.${u} PKG_SHELL.${u}
.endfor
.for g in ${PKG_GROUPS}
_PKG_VARS.pkginstall+=	PKG_GID.${g}
.endfor
_SYS_VARS.pkginstall= \
	SETUID_ROOT_PERMS \
	SETGID_GAMES_PERMS

# The Solaris /bin/sh does not know the ${foo#bar} shell substitution.
# This shell function serves a similar purpose, but is specialized on
# stripping ${PREFIX}/ from a pathname.
_FUNC_STRIP_PREFIX= \
	strip_prefix() {						\
	  ${AWK} 'END {							\
	    plen = length(prefix);					\
	      if (substr(s, 1, plen) == prefix) {			\
	        s = substr(s, 1 + plen, length(s) - plen);		\
	      }								\
	      print s;							\
	    }' s="$$1" prefix=${PREFIX:Q}/ /dev/null;			\
	}

_PKGINSTALL_DIR=	${WRKDIR}/.pkginstall

# XXX This should not be duplicated from the install module, but we
# XXX need this until pkginstall is refactored.
# XXX
PKG_DB_TMPDIR?=		${WRKDIR}/.pkgdb

# These are the template scripts for the INSTALL/DEINSTALL scripts.
# Packages may do additional work in the INSTALL/DEINSTALL scripts by
# overriding the variables DEINSTALL_TEMPLATES and INSTALL_TEMPLATES to
# point to additional script fragments.  These bits are included after
# the main install/deinstall script fragments.
#
_HEADER_TMPL?=		${.CURDIR}/../../mk/pkginstall/header
HEADER_TEMPLATES?=	# empty
.if exists(${PKGDIR}/HEADER) && \
    empty(HEADER_TEMPLATES:M${PKGDIR}/HEADER)
HEADER_TEMPLATES+=	${PKGDIR}/HEADER
.endif
DEINSTALL_TEMPLATES?=	# empty
.if exists(${PKGDIR}/DEINSTALL) && \
    empty(DEINSTALL_TEMPLATES:M${PKGDIR}/DEINSTALL)
DEINSTALL_TEMPLATES+=	${PKGDIR}/DEINSTALL
.endif
_DEINSTALL_TMPL?=	${.CURDIR}/../../mk/pkginstall/deinstall
_INSTALL_UNPACK_TMPL?=	# empty
_INSTALL_TMPL?=		${.CURDIR}/../../mk/pkginstall/install
INSTALL_TEMPLATES?=	# empty
.if exists(${PKGDIR}/INSTALL) && \
    empty(INSTALL_TEMPLATES:M${PKGDIR}/INSTALL)
INSTALL_TEMPLATES+=	${PKGDIR}/INSTALL
.endif
_INSTALL_DATA_TMPL?=	# empty
_FOOTER_TMPL?=		${.CURDIR}/../../mk/pkginstall/footer

# _DEINSTALL_TEMPLATES and _INSTALL_TEMPLATES are the list of source
#	files that are concatenated to form the DEINSTALL/INSTALL
#	scripts.
#
# _DEINSTALL_TEMPLATES_DFLT and _INSTALL_TEMPLATES_DFLT are the list of
#	template files minus any user-supplied templates.
#
_DEINSTALL_TEMPLATES=	${_HEADER_TMPL} ${HEADER_TEMPLATES}		\
			${DEINSTALL_TEMPLATES}				\
			${_DEINSTALL_TMPL}				\
			${_FOOTER_TMPL}
_INSTALL_TEMPLATES=	${_HEADER_TMPL} ${HEADER_TEMPLATES}		\
			${_INSTALL_UNPACK_TMPL}				\
			${_INSTALL_TMPL}				\
			${INSTALL_TEMPLATES}				\
			${_FOOTER_TMPL}					\
			${_INSTALL_DATA_TMPL}				\

_DEINSTALL_TEMPLATES_DFLT=	${_HEADER_TMPL}				\
				${_DEINSTALL_TMPL}			\
				${_FOOTER_TMPL}
_INSTALL_TEMPLATES_DFLT=	${_HEADER_TMPL}				\
				${_INSTALL_TMPL}			\
				${_FOOTER_TMPL}

# These are the list of source files that are concatenated to form the
# INSTALL/DEINSTALL scripts.
#
DEINSTALL_SRC?=		${_DEINSTALL_TEMPLATES}
INSTALL_SRC?=		${_INSTALL_TEMPLATES}

# FILES_SUBST lists what to substitute in DEINSTALL/INSTALL scripts and in
# rc.d scripts.
#
FILES_SUBST+=		PREFIX=${PREFIX:Q}
FILES_SUBST+=		LOCALBASE=${LOCALBASE:Q}
FILES_SUBST+=		X11BASE=${X11BASE:Q}
FILES_SUBST+=		VARBASE=${VARBASE:Q}
FILES_SUBST+=		PKG_SYSCONFBASE=${PKG_SYSCONFBASE:Q}
FILES_SUBST+=		PKG_SYSCONFBASEDIR=${PKG_SYSCONFBASEDIR:Q}
FILES_SUBST+=		PKG_SYSCONFDIR=${PKG_SYSCONFDIR:Q}
FILES_SUBST+=		CONF_DEPENDS=${CONF_DEPENDS:C/:.*//:Q}
FILES_SUBST+=		PKGBASE=${PKGBASE:Q}

# PKG_USERS represents the users to create for the package.  It is a
#	space-separated list of elements of the form
#
#		user:group
#
# The following variables are optional and specify further details of
# the user accounts listed in PKG_USERS:
#
# PKG_UID.<user> is the hardcoded numeric UID for <user>.
# PKG_GECOS.<user> is <user>'s description, as well as contact info.
# PKG_HOME.<user> is the home directory for <user>.
# PKG_SHELL.<user> is the login shell for <user>.
#
#
# PKG_GROUPS represents the groups to create for the package.  It is a
#	space-separated list of elements of the form
#
#		group
#
# The following variables are optional and specify further details of
# the user accounts listed in PKG_GROUPS:
#
# PKG_GID.<group> is the hardcoded numeric GID for <group>.
#
# For example:
#
#	PKG_GROUPS+=	mail
#	PKG_USERS+=	courier:mail
#
#	PKG_GECOS.courier=	Courier authlib and mail user
#
# USERGROUP_PHASE is set to the phase just before which users and
#	groups need to be created.  Valid values are "configure" and
#	"build" and "pre-install".
#	If not defined, then by default users and groups are created
#	as pare of the +INSTALL script.  If this is defined, then
#	the numeric UIDs and GIDs of users and groups required by this
#	package are hardcoded into the +INSTALL script.
#
PKG_GROUPS?=		# empty
PKG_USERS?=		# empty
_PKG_USER_HOME?=	/nonexistent
_PKG_USER_SHELL?=	${NOLOGIN}
FILES_SUBST+=		PKG_USER_HOME=${_PKG_USER_HOME:Q}
FILES_SUBST+=		PKG_USER_SHELL=${_PKG_USER_SHELL:Q}

USE_GAMESGROUP?=	no
SETGIDGAME?=            ${USE_GAMESGROUP}
# If USE_GAMESGROUP == yes, then we need the "games" group.
# SETGIDGAME is a deprecated alias for USE_GAMESGROUP.
#
# If USE_GAMESGROUP is set, GAMES_GROUP, GAMEMODE, SETGID_GAMES_PERMS,
# etc. variables can be used to install setgid games and their data
# files.
#
# SETGIDGAME is a deprecated alternative variable with the same
# purpose but a murky history and unclear semantics; it is being
# phased out because it conflicts with a like-named build variable in
# the NetBSD base system.
#
# For now we also create the "games" user; this should not be used and
# should be removed at some point.
.if (defined(USE_GAMESGROUP) && !empty(USE_GAMESGROUP:M[yY][eE][sS])) ||\
    (defined(SETGIDGAME) && !empty(SETGIDGAME:M[yY][eE][sS]))
PKG_GROUPS+=	${GAMES_GROUP}
PKG_USERS+=	${GAMES_USER}:${GAMES_GROUP}
_BUILD_DEFS+=	GAMES_GROUP GAMES_USER GAMEDATAMODE GAMEDIRMODE GAMEMODE
.endif

# Interix is very special in that users and groups cannot have the
# same name.  Interix.mk tries to work around this by overriding
# some specific package defaults.  If we get here and there's still a
# conflict, add a breakage indicator to make sure the package won't
# compile without changing something.
#
.if !empty(OPSYS:MInterix)
.  for user in ${PKG_USERS:C/\\\\//g:C/:.*//}
.    if !empty(PKG_GROUPS:M${user})
PKG_FAIL_REASON+=	"User and group '${user}' cannot have the same name on Interix"
.    endif
.  endfor
.endif

.if !empty(PKG_USERS) || !empty(PKG_GROUPS)
DEPENDS+=		${_USER_DEPENDS}
.endif

_INSTALL_USERGROUP_FILE=	${_PKGINSTALL_DIR}/usergroup
.if exists(../../mk/pkginstall/usergroupfuncs.${OPSYS})
_INSTALL_USERGROUPFUNCS_FILE?=	../../mk/pkginstall/usergroupfuncs.${OPSYS}
.else
_INSTALL_USERGROUPFUNCS_FILE?=	../../mk/pkginstall/usergroupfuncs
.endif
_INSTALL_USERGROUP_DATAFILE=	${_PKGINSTALL_DIR}/usergroup-data
_INSTALL_UNPACK_TMPL+=		${_INSTALL_USERGROUP_FILE}
_INSTALL_DATA_TMPL+=		${_INSTALL_USERGROUP_DATAFILE}

.for _group_ in ${PKG_GROUPS}
.  if defined(USERGROUP_PHASE)
# Determine the numeric GID of each group.
USE_TOOLS+=	perl
PKG_GID.${_group_}_cmd=							\
	if ${TEST} ! -x ${PERL5}; then ${ECHO} ""; exit 0; fi;		\
	${PERL5} -le 'print scalar getgrnam shift' ${_group_}
PKG_GID.${_group_}?=	${PKG_GID.${_group_}_cmd:sh:M*}
.  endif
_PKG_GROUPS+=	${_group_}:${PKG_GID.${_group_}}
.endfor

.for _entry_ in ${PKG_USERS}
.  for e in ${_entry_:C/\:.*//}
.    if defined(USERGROUP_PHASE)
# Determine the numeric UID of each user.
USE_TOOLS+=	perl
PKG_UID.${e}_cmd=							\
	if ${TEST} ! -x ${PERL5}; then ${ECHO} ""; exit 0; fi;		\
	${PERL5} -le 'print scalar getpwnam shift' ${e}
PKG_UID.${e}?=	${PKG_UID.${e}_cmd:sh:M*}
.    endif
_PKG_USERS+=	${_entry_}:${PKG_UID.${e}}:${PKG_GECOS.${e}:Q}:${PKG_HOME.${e}:Q}:${PKG_SHELL.${e}:Q}
.  endfor
.endfor

${_INSTALL_USERGROUP_DATAFILE}:
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}								\
	set -- dummy ${_PKG_GROUPS:C/\:*$//}; shift;			\
	exec 1>>${.TARGET};						\
	while ${TEST} $$# -gt 0; do					\
		i="$$1"; shift;						\
		${ECHO} "# GROUP: $$i";					\
	done
	${RUN}								\
	set -- dummy ${_PKG_USERS:C/\:*$//}; shift;			\
	exec 1>>${.TARGET};						\
	while ${TEST} $$# -gt 0; do					\
		i="$$1"; shift;						\
		${ECHO} "# USER: $$i";					\
	done

${_INSTALL_USERGROUP_FILE}: ${_INSTALL_USERGROUP_DATAFILE}
${_INSTALL_USERGROUP_FILE}:						\
		../../mk/pkginstall/usergroup				\
		${INSTALL_USERGROUPFUNCS_FILE}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}								\
	${SED}	-e "/^# platform-specific adduser\/addgroup functions/r${_INSTALL_USERGROUPFUNCS_FILE}" ../../mk/pkginstall/usergroup |			\
	${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${RUN}								\
	if ${_ZERO_FILESIZE_P} ${_INSTALL_USERGROUP_DATAFILE}; then	\
		${RM} -f ${.TARGET};					\
		${TOUCH} ${TOUCH_ARGS} ${.TARGET};			\
	fi

_INSTALL_USERGROUP_UNPACKER=	${_PKGINSTALL_DIR}/usergroup-unpack

${_INSTALL_USERGROUP_UNPACKER}:						\
		${_INSTALL_USERGROUP_FILE}				\
		${_INSTALL_USERGROUP_DATAFILE}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}								\
	exec 1>${.TARGET};						\
	${ECHO} "#!${SH}";						\
	${ECHO} "";							\
	${ECHO} "CAT="${CAT:Q};						\
	${ECHO} "CHMOD="${CHMOD:Q};					\
	${ECHO} "SED="${SED:Q};						\
	${ECHO} "";							\
	${ECHO} "SELF=\$$0";						\
	${ECHO} "STAGE=UNPACK";						\
	${ECHO} "";							\
	${CAT}	${_INSTALL_USERGROUP_FILE}				\
		${_INSTALL_USERGROUP_DATAFILE}
	${RUN}${CHMOD} +x ${.TARGET}

.if defined(USERGROUP_PHASE)
.  if !empty(USERGROUP_PHASE:M*configure)
pre-configure: create-usergroup
.  elif !empty(USERGROUP_PHASE:M*build)
pre-build: create-usergroup
.  elif !empty(USERGROUP_PHASE:Mpre-install)
pre-install: create-usergroup
.  endif
.endif

_INSTALL_USERGROUP_CHECK=						\
	${PKGSRC_SETENV} PERL5=${PERL5:Q}					\
	${SH} ${PKGSRCDIR}/mk/pkginstall/usergroup-check

.PHONY: create-usergroup
create-usergroup: su-target
	@${STEP_MSG} "Requiring users and groups for ${PKGNAME}"

PRE_CMD.su-create-usergroup=						\
	if ${_INSTALL_USERGROUP_CHECK} -g ${_PKG_GROUPS:C/\:*$//} &&	\
	   ${_INSTALL_USERGROUP_CHECK} -u ${_PKG_USERS:C/\:*$//}; then	\
		exit 0;							\
	fi

.PHONY: su-create-usergroup
su-create-usergroup: ${_INSTALL_USERGROUP_UNPACKER}
	${RUN}								\
	cd ${_PKGINSTALL_DIR} &&					\
	${SH} ${_INSTALL_USERGROUP_UNPACKER};				\
	exitcode=1;							\
	if ${TEST} -f ./+USERGROUP &&					\
	   ./+USERGROUP ADD ${_PKG_DBDIR}/${PKGNAME} &&			\
	   ./+USERGROUP CHECK-ADD ${_PKG_DBDIR}/${PKGNAME}; then	\
		exitcode=0;						\
	fi;								\
	${RM} -f ${_INSTALL_USERGROUP_FILE:Q}				\
		${_INSTALL_USERGROUP_DATAFILE:Q}			\
		${_INSTALL_USERGROUP_UNPACKER:Q}			\
		./+USERGROUP;						\
	exit $$exitcode

# SPECIAL_PERMS are lists that look like:
#		file user group mode
#	At post-install time, <file> (it may be a directory) is changed
#	to be owned by <user>:<group> with <mode> permissions.  If a file
#	pathname is relative, then it is taken to be relative to ${PREFIX}.
#
#	SPECIAL_PERMS should be used primarily to change permissions of
#	files or directories listed in the PLIST.  This may be used to
#	make certain files set-uid or to change the ownership or a
#	directory.
#
#	The special permissions may not directly recorded (as file
#	attributes) in the binary package file.
#
# SETUID_ROOT_PERMS is a convenience definition to note an executable is
# meant to be setuid-root, and should be used as follows:
#
#	SPECIAL_PERMS+=	/path/to/suidroot ${SETUID_ROOT_PERMS}
#
# SETGID_GAMES_PERMS is a convenience definition to note an executable is
# meant to be setgid games, and should be used as follows:
#
#	SPECIAL_PERMS+=	/path/to/sgidgame ${SETGID_GAMES_PERMS}
#
# GAMEDATA_PERMS and GAMEDIR_PERMS are convenience definitions for files
# that are meant to be accessed by things that are setgid games. Because
# such files should normally be under ${VARBASE}, generally these 
# definitions should be used roughly as follows:
#
#	REQD_DIRS_PERMS+=  /path/to/scoredir ${GAMEDIR_PERMS}
#	REQD_FILES_PERMS+= /dev/null /path/to/scorefile ${GAMEDATA_PERMS}
#
# Note that GAMEDIR_PERMS should only be used when the game requires
# write access to scribble in its directory; many games do not, in which
# case REQD_DIRS instead of REQD_DIRS_PERMS can be used and GAMEDIR_PERMS
# is not needed.
#
# Keywords: setuid setgid st_mode perms
#
SPECIAL_PERMS?=		# empty
SETUID_ROOT_PERMS?=	${REAL_ROOT_USER} ${REAL_ROOT_GROUP} 4511
SETGID_GAMES_PERMS?=	${GAMES_USER} ${GAMES_GROUP} ${GAMEMODE}
GAMEDATA_PERMS?=	${GAMES_USER} ${GAMES_GROUP} ${GAMEDATAMODE}
GAMEDIR_PERMS?=		${GAMES_USER} ${GAMES_GROUP} ${GAMEDIRMODE}

# CONF_FILES
# REQD_FILES
#	Pairs of example and true config files, used much like MLINKS in
#	the NetBSD base system.  At post-install time, if the true config
#	file doesn't exist, then the example one is copied into place.  At
#	deinstall time, the true one is removed if it doesn't differ from the
#	example one.  REQD_FILES is the same as CONF_FILES but the value
#	of PKG_CONFIG is ignored.
#
#	However, all files listed in REQD_FILES should be under ${PREFIX}.
#	(XXX: Why?)
#
# CONF_FILES_MODE and REQD_FILES_MODE are the file permissions for the
# files in CONF_FILES and REQD_FILES, respectively.
#
# CONF_FILES_PERMS
# REQD_FILES_PERMS
#	Lists that look like:
#
#		example_file config_file user group mode
#
#	This works like CONF_FILES and REQD_FILES, except that the config
#	files are owned by user:group and have mode permissions.
#	REQD_FILES_PERMS is the same as CONF_FILES_PERMS but the value of
#	PKG_CONFIG is ignored;
#
#	However, all files listed in REQD_FILES_PERMS should be under
#	${PREFIX}. (XXX: Why?)
#
# RCD_SCRIPTS lists the basenames of the rc.d scripts.  They are
#	expected to be found in ${PREFIX}/share/examples/rc.d, and
#	the scripts will be copied into ${RCD_SCRIPTS_DIR} with
#	${RCD_SCRIPTS_MODE} permissions.
#
# If any file pathnames are relative, then they are taken to be relative
# to ${PREFIX}.
#
# Keywords: etc conf configuration
#

CONF_FILES?=		# empty
CONF_FILES_MODE?=	0644
CONF_FILES_PERMS?=	# empty
RCD_SCRIPTS?=		# empty
RCD_SCRIPTS_MODE?=	0755
RCD_SCRIPTS_EXAMPLEDIR=	share/examples/rc.d
RCD_SCRIPTS_SHELL?=	${SH}
FILES_SUBST+=		RCD_SCRIPTS_SHELL=${RCD_SCRIPTS_SHELL:Q}
MESSAGE_SUBST+=		RCD_SCRIPTS_DIR=${RCD_SCRIPTS_DIR}
MESSAGE_SUBST+=		RCD_SCRIPTS_EXAMPLEDIR=${RCD_SCRIPTS_EXAMPLEDIR}

# Only generate init scripts if we are using rc.d
_INSTALL_RCD_SCRIPTS=	# empty

.if ${INIT_SYSTEM} == "rc.d"
_INSTALL_RCD_SCRIPTS=	${RCD_SCRIPTS}
.endif

# PKG_SHELL contains the pathname of the shell that should be added or
#	removed from the shell database, /etc/shells.  If a pathname
#	is relative, then it is taken to be relative to ${PREFIX}.
#
PKG_SHELL?=		# empty

# PKGNG only supports ELF format, so there's no need to test library type
# Set the @ldconfig configure if port provided RUN_LDCONFIG setting

SHLIB_TYPE=	ELF
RUN_LDCONFIG?=	no

.if !empty(RUN_LDCONFIG:tl:Myes)
SET_LDCONFIG_KEYWORD=	yes
.endif

# FONTS_DIRS.<type> are lists of directories in which the font databases
#	are updated.  If this is non-empty, then the appropriate tools are
#	used to update the fonts database for the font type.  The supported
#	types are:
#
#	    ttf		TrueType fonts
#	    type1	Type1 fonts
#	    x11		Generic X fonts, e.g. PCF, SNF, BDF, etc.
#
FONTS_DIRS.ttf?=	# empty
FONTS_DIRS.type1?=	# empty
FONTS_DIRS.x11?=	# empty

.if !empty(FONTS_DIRS.ttf:M*)
.if ${X11_TYPE} == "modular"
USE_TOOLS+=		mkfontscale:run
.else
USE_TOOLS+=		ttmkfdir:run
.endif
.endif

.if !empty(FONTS_DIRS.type1:M*)
.if ${X11_TYPE} == "modular"
USE_TOOLS+=		mkfontscale:run
.else
USE_TOOLS+=		type1inst:run
.endif
.endif

.if !empty(FONTS_DIRS.x11:M*) || !empty(FONTS_DIRS.ttf:M*) || !empty(FONTS_DIRS.type1:M*)
USE_TOOLS+=		mkfontdir:run
.if ${X11_TYPE} == "modular"
DEPENDS+=		encodings-[0-9]*:../../fonts/encodings
.endif
.endif

# PKG_CREATE_USERGROUP indicates whether the INSTALL script should
#	automatically add any needed users/groups to the system using
#	useradd/groupadd.  It is either YES or NO and defaults to YES.
#
# PKG_CONFIG indicates whether the INSTALL/DEINSTALL scripts should do
#	automatic config file and directory handling, or if it should
#	merely inform the admin of the list of required files and
#	directories needed to use the package.  It is either YES or NO
#	and defaults to YES.
#
# PKG_CONFIG_PERMS indicates whether to automatically correct permissions
#	and ownership on pre-existing files and directories, or if it
#	should merely inform the admin of the list of files and
#	directories whose permissions and ownership need to be fixed.  It
#	is either YES or NO and defaults to NO.
#
# PKG_RCD_SCRIPTS indicates whether to automatically install rc.d scripts
#	to ${RCD_SCRIPTS_DIR}.  It is either YES or NO and defaults to
#	NO.  This variable only takes effect if ${PKG_CONFIG} == "YES".
#
# PKG_REGISTER_SHELLS indicates whether to automatically register shells
#	in /etc/shells.  It is either YES or NO and defaults to YES.
#
# PKG_UPDATE_FONTS_DB indicates whether to automatically update the fonts
#	databases in directories where fonts have been installed or
#	removed.  It is either YES or NO and defaults to YES.
#
# These values merely set the defaults for INSTALL/DEINSTALL scripts, but
# they may be overridden by resetting them in the environment.
#
.if ${PKG_DEVELOPER:Uno} != "no"
FONTS_VERBOSE?=		YES
OCAML_FINDLIB_REGISTER_VERBOSE?=	YES
.else
FONTS_VERBOSE?=		NO
OCAML_FINDLIB_REGISTER_VERBOSE?=	NO
.endif
PKG_CREATE_USERGROUP?=	YES
PKG_CONFIG?=		YES
PKG_CONFIG_PERMS?=	NO
PKG_RCD_SCRIPTS?=	NO
PKG_REGISTER_SHELLS?=	YES
PKG_UPDATE_FONTS_DB?=	YES
FILES_SUBST+=		PKG_CREATE_USERGROUP=${PKG_CREATE_USERGROUP:Q}
FILES_SUBST+=		PKG_CONFIG=${PKG_CONFIG:Q}
FILES_SUBST+=		PKG_CONFIG_PERMS=${PKG_CONFIG_PERMS:Q}
FILES_SUBST+=		PKG_RCD_SCRIPTS=${PKG_RCD_SCRIPTS:Q}
FILES_SUBST+=		PKG_REGISTER_SHELLS=${PKG_REGISTER_SHELLS:Q}
FILES_SUBST+=		PKG_UPDATE_FONTS_DB=${PKG_UPDATE_FONTS_DB:Q}
FILES_SUBST+=		FONTS_VERBOSE=${FONTS_VERBOSE:Q}
FILES_SUBST+=		OCAML_FINDLIB_REGISTER_VERBOSE=${OCAML_FINDLIB_REGISTER_VERBOSE:Q}

# Substitute for various programs used in the DEINSTALL/INSTALL scripts and
# in the rc.d scripts.
#
FILES_SUBST+=		AWK=${AWK:Q}
FILES_SUBST+=		BASENAME=${BASENAME:Q}
FILES_SUBST+=		CAT=${CAT:Q}
FILES_SUBST+=		CHGRP=${CHGRP:Q}
FILES_SUBST+=		CHMOD=${CHMOD:Q}
FILES_SUBST+=		CHOWN=${CHOWN:Q}
FILES_SUBST+=		CMP=${CMP:Q}
FILES_SUBST+=		CP=${CP:Q}
FILES_SUBST+=		DIRNAME=${DIRNAME:Q}
FILES_SUBST+=		ECHO=${ECHO:Q}
FILES_SUBST+=		ECHO_N=${ECHO_N:Q}
FILES_SUBST+=		EGREP=${EGREP:Q}
FILES_SUBST+=		EXPR=${EXPR:Q}
FILES_SUBST+=		FALSE=${FALSE:Q}
FILES_SUBST+=		FIND=${FIND:Q}
FILES_SUBST+=		GREP=${GREP:Q}
FILES_SUBST+=		GROUPADD=${GROUPADD:Q}
FILES_SUBST+=		GTAR=${GTAR:Q}
FILES_SUBST+=		HEAD=${HEAD:Q}
FILES_SUBST+=		ID=${ID:Q}
FILES_SUBST+=		INSTALL_INFO=${INSTALL_INFO:Q}
FILES_SUBST+=		LINKFARM=${LINKFARM:Q}
FILES_SUBST+=		LN=${LN:Q}
FILES_SUBST+=		LS=${LS:Q}
FILES_SUBST+=		MKDIR=${MKDIR:Q}
FILES_SUBST+=		MV=${MV:Q}
FILES_SUBST+=		OCAML_FINDLIB_DIRS=${OCAML_FINDLIB_DIRS:Q}
FILES_SUBST+=		OCAML_SITELIBDIR=${OCAML_SITELIBDIR:Q}
FILES_SUBST+=		PERL5=${PERL5:Q}
FILES_SUBST+=		PKG_ADMIN=${PKG_ADMIN_CMD:Q}
FILES_SUBST+=		PKG_INFO=${PKG_INFO_CMD:Q}
FILES_SUBST+=		PW=${PW:Q}
FILES_SUBST+=		PWD_CMD=${PWD_CMD:Q}
FILES_SUBST+=		RM=${RM:Q}
FILES_SUBST+=		RMDIR=${RMDIR:Q}
FILES_SUBST+=		SED=${SED:Q}
FILES_SUBST+=		SETENV=${SETENV:Q}
FILES_SUBST+=		SH=${SH:Q}
FILES_SUBST+=		SORT=${SORT:Q}
FILES_SUBST+=		SU=${SU:Q}
FILES_SUBST+=		TEST=${TEST:Q}
FILES_SUBST+=		TOUCH=${TOUCH:Q}
FILES_SUBST+=		TR=${TR:Q}
FILES_SUBST+=		TRUE=${TRUE:Q}
FILES_SUBST+=		USERADD=${USERADD:Q}
FILES_SUBST+=		XARGS=${XARGS:Q}

FILES_SUBST_SED=	${FILES_SUBST:S/=/@!/:S/$/!g/:S/^/ -e s!@/}

PKG_REFCOUNT_DBDIR?=	${PKG_DBDIR}.refcount

INSTALL_SCRIPTS_ENV=	PKG_PREFIX=${PREFIX}
INSTALL_SCRIPTS_ENV+=	PKG_METADATA_DIR=${_PKG_DBDIR}/${PKGNAME}
INSTALL_SCRIPTS_ENV+=	PKG_REFCOUNT_DBDIR=${PKG_REFCOUNT_DBDIR}

DEINSTALL_FILE=		${PKG_DB_TMPDIR}/+DEINSTALL
INSTALL_FILE=		${PKG_DB_TMPDIR}/+INSTALL
_DEINSTALL_FILE=	${_PKGINSTALL_DIR}/DEINSTALL
_INSTALL_FILE=		${_PKGINSTALL_DIR}/INSTALL
_DEINSTALL_FILE_DFLT=	${_PKGINSTALL_DIR}/DEINSTALL.default
_INSTALL_FILE_DFLT=	${_PKGINSTALL_DIR}/INSTALL.default

.PHONY: generate-install-scripts
generate-install-scripts:						\
		${_DEINSTALL_FILE} ${_INSTALL_FILE}			\
		${_DEINSTALL_FILE_DFLT} ${_INSTALL_FILE_DFLT}
.if !exists(${DEINSTALL_FILE}) || !exists(${INSTALL_FILE})
	${RUN}${MKDIR} ${INSTALL_FILE:H}
	${RUN}${MKDIR} ${DEINSTALL_FILE:H}
	${RUN}								\
	if ${CMP} -s ${_INSTALL_FILE_DFLT:Q} ${_INSTALL_FILE:Q}; then	\
		${TRUE};						\
	else								\
		${CP} -f ${_INSTALL_FILE} ${INSTALL_FILE};		\
		${CP} -f ${_DEINSTALL_FILE} ${DEINSTALL_FILE};		\
	fi
	${RUN}								\
	if ${CMP} -s ${_DEINSTALL_FILE_DFLT:Q} ${_DEINSTALL_FILE:Q}; then \
		${TRUE};						\
	else								\
		${CP} -f ${_DEINSTALL_FILE} ${DEINSTALL_FILE};		\
	fi
.endif

${_DEINSTALL_FILE_DFLT}: ${_DEINSTALL_TEMPLATES_DFLT}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${.ALLSRC} | ${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${RUN}${CHMOD} +x ${.TARGET}

${_INSTALL_FILE_DFLT}: ${_INSTALL_TEMPLATES_DFLT}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${.ALLSRC} | ${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${RUN}${CHMOD} +x ${.TARGET}

${_DEINSTALL_FILE}: ${DEINSTALL_SRC}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}								\
	exec 1>>${.TARGET};						\
	case ${.ALLSRC:Q}"" in						\
	"")	${ECHO} "#!${SH}" ;					\
		${ECHO} "exit 0" ;;					\
	*)	${CAT} ${.ALLSRC} | ${SED} ${FILES_SUBST_SED} ;;	\
	esac
	${RUN}${CHMOD} +x ${.TARGET}

${_INSTALL_FILE}: ${INSTALL_SRC}
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}								\
	exec 1>>${.TARGET};						\
	case ${.ALLSRC:Q}"" in						\
	"")	${ECHO} "#!${SH}" ;					\
		${ECHO} "exit 0" ;;					\
	*)	${CAT} ${.ALLSRC} | ${SED} ${FILES_SUBST_SED} ;;	\
	esac
	${RUN}${CHMOD} +x ${.TARGET}

# rc.d scripts are automatically generated and installed into the rc.d
# scripts example directory at the post-install step.  The following
# variables are relevant to this process:
#
# RCD_SCRIPTS			lists the basenames of the rc.d scripts
#
# RCD_SCRIPT_SRC.<script>	the source file for <script>; this will
#				be run through FILES_SUBST to generate
#				the rc.d script (defaults to
#				${FILESDIR}/<script>.sh)
#
# If the source rc.d script is not present, then the automatic handling
# doesn't occur.

.PHONY: generate-rcd-scripts
generate-rcd-scripts:	# do nothing

.PHONY: install-rcd-scripts
post-install: install-rcd-scripts
install-rcd-scripts:	# do nothing

.for _script_ in ${_INSTALL_RCD_SCRIPTS}
RCD_SCRIPT_SRC.${_script_}?=	${FILESDIR}/${_script_}.sh
RCD_SCRIPT_WRK.${_script_}?=	${WRKDIR}/.rc.d/${_script_}

.  if !empty(RCD_SCRIPT_SRC.${_script_})
generate-rcd-scripts: ${RCD_SCRIPT_WRK.${_script_}}
${RCD_SCRIPT_WRK.${_script_}}: ${RCD_SCRIPT_SRC.${_script_}}
	@${STEP_MSG} "Creating ${.TARGET}"
	${RUN}${MKDIR} ${.TARGET:H}
	${RUN}${CAT} ${.ALLSRC} | ${SED} ${FILES_SUBST_SED} > ${.TARGET}
	${RUN}${CHMOD} +x ${.TARGET}

install-rcd-scripts: install-rcd-${_script_}
install-rcd-${_script_}: ${RCD_SCRIPT_WRK.${_script_}}
	${RUN}								\
	if [ -f ${RCD_SCRIPT_WRK.${_script_}} ]; then			\
		${MKDIR} ${DESTDIR}${PREFIX}/${RCD_SCRIPTS_EXAMPLEDIR};		\
		${INSTALL_SCRIPT} ${RCD_SCRIPT_WRK.${_script_}}		\
			${DESTDIR}${PREFIX}/${RCD_SCRIPTS_EXAMPLEDIR}/${_script_}; \
	fi
.  endif
GENERATE_PLIST+=	${ECHO} ${RCD_SCRIPTS_EXAMPLEDIR}/${_script_};
PRINT_PLIST_AWK+=	/^${RCD_SCRIPTS_EXAMPLEDIR:S|/|\\/|g}\/${_script_}/ { next; }
.endfor

_PKGINSTALL_TARGETS+=	acquire-pkginstall-lock
_PKGINSTALL_TARGETS+=	real-pkginstall
_PKGINSTALL_TARGETS+=	release-pkginstall-lock

.PHONY: pkginstall install-script-data
pkginstall: ${_PKGINSTALL_TARGETS}

install-script-data:	# do nothing

.PHONY: acquire-pkginstall-lock release-pkginstall-lock
acquire-pkginstall-lock: acquire-lock
release-pkginstall-lock: release-lock

.PHONY: real-pkginstall
real-pkginstall: generate-rcd-scripts generate-install-scripts