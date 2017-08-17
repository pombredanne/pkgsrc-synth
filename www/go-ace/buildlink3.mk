# $NetBSD: buildlink3.mk,v 1.1 2017/08/17 01:08:30 gavan Exp $

BUILDLINK_TREE+=	go-ace

.if !defined(GO_ACE_BUILDLINK3_MK)
GO_ACE_BUILDLINK3_MK:=

BUILDLINK_CONTENTS_FILTER.go-ace=	${EGREP} gopkg/
BUILDLINK_DEPMETHOD.go-ace?=		build

BUILDLINK_API_DEPENDS.go-ace+=		go-ace>=0.0.4
BUILDLINK_PKGSRCDIR.go-ace?=		../../www/go-ace

.include "../../www/go-gohtml/buildlink3.mk"
.endif  # GO_ACE_BUILDLINK3_MK

BUILDLINK_TREE+=	-go-ace

