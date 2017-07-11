# $NetBSD: buildlink3.mk,v 1.4 2017/07/11 14:19:22 jaapb Exp $

BUILDLINK_TREE+=	camlp4

.if !defined(CAMLP4_BUILDLINK3_MK)
CAMLP4_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.camlp4+=	camlp4>=4.04
BUILDLINK_ABI_DEPENDS.camlp4+=	camlp4>=4.04nb1
BUILDLINK_PKGSRCDIR.camlp4?=	../../lang/camlp4
.endif	# CAMLP4_BUILDLINK3_MK

BUILDLINK_TREE+=	-camlp4
