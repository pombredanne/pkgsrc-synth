$NetBSD: patch-mozilla_gfx_skia_generate__mozbuild.py,v 1.5 2017/08/18 23:55:07 ryoon Exp $

--- mozilla/gfx/skia/generate_mozbuild.py.orig	2017-07-07 05:36:33.000000000 +0000
+++ mozilla/gfx/skia/generate_mozbuild.py
@@ -140,6 +140,9 @@ if CONFIG['CLANG_CXX'] or CONFIG['CLANG_
         '-Wno-unused-private-field',
     ]
 
+if CONFIG['MOZ_SYSTEM_HARFBUZZ']:
+    CXXFLAGS += CONFIG['MOZ_HARFBUZZ_CFLAGS']
+
 if CONFIG['MOZ_WIDGET_TOOLKIT'] in ('gtk2', 'gtk3', 'android', 'gonk'):
     CXXFLAGS += CONFIG['MOZ_CAIRO_CFLAGS']
     CXXFLAGS += CONFIG['CAIRO_FT_CFLAGS']
