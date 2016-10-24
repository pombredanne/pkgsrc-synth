$NetBSD: patch-estic_estic.cc,v 1.1 2012/11/16 00:37:45 joerg Exp $

--- estic/estic.cc.orig	1997-03-05 21:20:42.000000000 +0000
+++ estic/estic.cc
@@ -1,5 +1,4 @@
-/*****************************************************************************/
-/*                                                                           */
+/*****************************************************************************/ /*                                                                           */
 /*                                   ESTIC.CC                                */
 /*                                                                           */
 /* (C) 1995-97  Ullrich von Bassewitz                                        */
@@ -71,6 +70,7 @@
 #endif
 #include "estic.h"
 
+#undef FS
 
 
 /*****************************************************************************/
@@ -80,9 +80,9 @@
 
 
 // Diag mode update
-static const duOff              = 0;
-static const duOn               = 1;
-static const duAuto             = 2;    // Update if version <= 1.93
+static const int duOff              = 0;
+static const int duOn               = 1;
+static const int duAuto             = 2;    // Update if version <= 1.93
 
 static const char VersionStr [] = "1.50";
 static const char VersionID []  = "ESTIC-Version";
@@ -138,7 +138,7 @@ const u16 msCLIWinWarning               
 IstecApp::IstecApp (int argc, char* argv []):
     Program (argc, argv, CreateMenueBar, CreateStatusLine, "estic"),
     StatusFlags (0),
-    ComPortName ("COM2"),
+    ComPortName ("tty00"),
     SettingsFile ("estic.rc"),
     IstecPresent (0),
     DayNight (0),
