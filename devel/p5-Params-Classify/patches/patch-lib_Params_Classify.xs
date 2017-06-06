$NetBSD: patch-lib_Params_Classify.xs,v 1.1 2017/06/06 14:38:05 ryoon Exp $

* Fix build with Perl 5.26.0
  From https://rt.cpan.org/Public/Bug/Display.html?id=114490

--- lib/Params/Classify.xs.orig	2010-11-16 20:35:47.000000000 +0000
+++ lib/Params/Classify.xs
@@ -41,6 +41,26 @@
 # define FPTR2DPTR(t,x) ((t)(UV)(x))
 #endif /* !FPTR2DPTR */
 
+#ifndef OpHAS_SIBLING
+#  define OpHAS_SIBLING(o)               (cBOOL((o)->op_sibling))
+#endif
+
+#ifndef OpSIBLING
+#  define OpSIBLING(o)                   (0 + (o)->op_sibling)
+#endif
+
+#ifndef OpMORESIB_set
+#  define OpMORESIB_set(o, sib)          ((o)->op_sibling = (sib))
+#endif
+
+#ifndef OpLASTSIB_set
+#  define OpLASTSIB_set(o, parent)       ((o)->op_sibling = NULL)
+#endif
+
+#ifndef OpMAYBESIB_set
+#  define OpMAYBESIB_set(o, sib, parent) ((o)->op_sibling = (sib))
+#endif
+
 #ifndef ptr_table_new
 
 struct q_ptr_tbl_ent {
@@ -625,8 +645,8 @@ static OP *myck_entersub(pTHX_ OP *op)
 	OP *(*ppfunc)(pTHX);
 	I32 cvflags;
 	pushop = cUNOPx(op)->op_first;
-	if(!pushop->op_sibling) pushop = cUNOPx(pushop)->op_first;
-	for(cvop = pushop; cvop->op_sibling; cvop = cvop->op_sibling) ;
+	if(!OpHAS_SIBLING(pushop)) pushop = cUNOPx(pushop)->op_first;
+	for(cvop = pushop; OpHAS_SIBLING(cvop); cvop = OpSIBLING(cvop)) ;
 	if(!(cvop->op_type == OP_RV2CV &&
 			!(cvop->op_private & OPpENTERSUB_AMPER) &&
 			(cv = rvop_cv(cUNOPx(cvop)->op_first)) &&
@@ -635,20 +655,20 @@ static OP *myck_entersub(pTHX_ OP *op)
 		return nxck_entersub(aTHX_ op);
 	cvflags = CvXSUBANY(cv).any_i32;
 	op = nxck_entersub(aTHX_ op);   /* for prototype checking */
-	aop = pushop->op_sibling;
-	bop = aop->op_sibling;
+	aop = OpSIBLING(pushop);
+	bop = OpSIBLING(aop);
 	if(bop == cvop) {
 		if(!(cvflags & PC_ALLOW_UNARY)) return op;
 		unary:
-		pushop->op_sibling = bop;
-		aop->op_sibling = NULL;
+		OpLASTSIB_set(pushop, bop);
+		OpLASTSIB_set(aop, NULL);
 		op_free(op);
 		op = newUNOP(OP_NULL, 0, aop);
 		op->op_type = OP_RAND;
 		op->op_ppaddr = ppfunc;
 		op->op_private = (U8)cvflags;
 		return op;
-	} else if(bop && bop->op_sibling == cvop) {
+	} else if(bop && OpSIBLING(op) == cvop) {
 		if(!(cvflags & PC_ALLOW_BINARY)) return op;
 		if(ppfunc == THX_pp_check_sclass &&
 				(cvflags & PC_TYPE_MASK) == SCLASS_REF) {
@@ -667,9 +687,9 @@ static OP *myck_entersub(pTHX_ OP *op)
 			cvflags &= ~PC_TYPE_MASK;
 			ppfunc = THX_pp_check_dyn_battr;
 		}
-		pushop->op_sibling = cvop;
-		aop->op_sibling = NULL;
-		bop->op_sibling = NULL;
+		OpLASTSIB_set(pushop, cvop);
+		OpLASTSIB_set(aop, NULL);
+		OpLASTSIB_set(bop, NULL);
 		op_free(op);
 		op = newBINOP(OP_NULL, 0, aop, bop);
 		op->op_type = OP_RAND;
