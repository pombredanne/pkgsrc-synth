$NetBSD: patch-lib_ext2fs_bitops.c,v 1.1 2016/08/09 21:46:07 jdolecek Exp $

--- lib/ext2fs/bitops.c.orig	2013-09-09 14:29:01.000000000 +0000
+++ lib/ext2fs/bitops.c
@@ -116,14 +116,14 @@ int ext2fs_test_bit64(__u64 nr, const vo
 	return (mask & *ADDR);
 }
 
-static unsigned int popcount8(unsigned int w)
+static unsigned int ext2fs_popcount8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
 
-static unsigned int popcount32(unsigned int w)
+static unsigned int ext2fs_popcount32(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
@@ -139,19 +139,19 @@ unsigned int ext2fs_bitcount(const void 
 	unsigned int res = 0;
 
 	while (((((unsigned long) cp) & 3) != 0) && (nbytes > 0)) {
-		res += popcount8(*cp++);
+		res += ext2fs_popcount8(*cp++);
 		nbytes--;
 	}
 	p = (const __u32 *) cp;
 
 	while (nbytes > 4) {
-		res += popcount32(*p++);
+		res += ext2fs_popcount32(*p++);
 		nbytes -= 4;
 	}
 	cp = (const unsigned char *) p;
 
 	while (nbytes > 0) {
-		res += popcount8(*cp++);
+		res += ext2fs_popcount8(*cp++);
 		nbytes--;
 	}
 	return res;
