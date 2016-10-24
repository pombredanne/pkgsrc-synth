$NetBSD: patch-main.c,v 1.1 2015/07/09 11:56:59 jperkin Exp $

Use nbcompat.

--- main.c.orig	2005-05-10 20:48:24.000000000 +0000
+++ main.c
@@ -29,7 +29,12 @@
  * SUCH DAMAGE.
  */
 
+#if defined(HAVE_NBCOMPAT_H)
+#include <nbcompat.h>
+#include <nbcompat/cdefs.h>
+#else
 #include <sys/cdefs.h>
+#endif
 #ifndef lint
 __COPYRIGHT("@(#) Copyright (c) 1980, 1993\n\
 	The Regents of the University of California.  All rights reserved.\n");
