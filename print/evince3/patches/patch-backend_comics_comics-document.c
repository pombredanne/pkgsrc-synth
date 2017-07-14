$NetBSD: patch-backend_comics_comics-document.c,v 1.1 2017/07/14 05:31:20 maya Exp $

comics: Remove support for tar and tar-like commands
From https://bugzilla.gnome.org/show_bug.cgi?id=784630

CVE-2017-1000083.


When handling tar files, or using a command with tar-compatible syntax,
to open comic-book archives, both the archive name (the name of the
comics file) and the filename (the name of a page within the archive)
are quoted to not be interpreted by the shell.

But the filename is completely with the attacker's control and can start
with "--" which leads to tar interpreting it as a command line flag.

This can be exploited by creating a CBT file (a tar archive with the
.cbt suffix) with an embedded file named something like this:
"--checkpoint-action=exec=bash -c 'touch ~/hacked;'.jpg"

CBT files are infinitely rare (CBZ is usually used for DRM-free
commercial releases, CBR for those from more dubious provenance), so
removing support is the easiest way to avoid the bug triggering. All
this code was rewritten in the development release for GNOME 3.26 to not
shell out to any command, closing off this particular attack vector.

This also removes the ability to use libarchive's bsdtar-compatible
binary for CBZ (ZIP), CB7 (7zip), and CBR (RAR) formats. The first two
are already supported by unzip and 7zip respectively. libarchive's RAR
support is limited, so unrar is a requirement anyway.

Discovered by Felix Wilhelm from the Google Security Team.

--- backend/comics/comics-document.c.orig	2016-10-12 05:42:04.000000000 +0000
+++ backend/comics/comics-document.c
@@ -56,8 +56,7 @@ typedef enum
 	RARLABS,
 	GNAUNRAR,
 	UNZIP,
-	P7ZIP,
-	TAR
+	P7ZIP
 } ComicBookDecompressType;
 
 typedef struct _ComicsDocumentClass ComicsDocumentClass;
@@ -117,9 +116,6 @@ static const ComicBookDecompressCommand 
 
         /* 7zip */
 	{NULL               , "%s l -- %s"     , "%s x -y %s -o%s", FALSE, OFFSET_7Z},
-
-        /* tar */
-	{"%s -xOf"          , "%s -tf %s"      , NULL             , FALSE, NO_OFFSET}
 };
 
 static GSList*    get_supported_image_extensions (void);
@@ -364,13 +360,6 @@ comics_check_decompress_command	(gchar  
 			comics_document->command_usage = GNAUNRAR;
 			return TRUE;
 		}
-		comics_document->selected_command =
-				g_find_program_in_path ("bsdtar");
-		if (comics_document->selected_command) {
-			comics_document->command_usage = TAR;
-			return TRUE;
-		}
-
 	} else if (g_content_type_is_a (mime_type, "application/x-cbz") ||
 		   g_content_type_is_a (mime_type, "application/zip")) {
 		/* InfoZIP's unzip program */
@@ -396,12 +385,6 @@ comics_check_decompress_command	(gchar  
 			comics_document->command_usage = P7ZIP;
 			return TRUE;
 		}
-		comics_document->selected_command =
-				g_find_program_in_path ("bsdtar");
-		if (comics_document->selected_command) {
-			comics_document->command_usage = TAR;
-			return TRUE;
-		}
 
 	} else if (g_content_type_is_a (mime_type, "application/x-cb7") ||
 		   g_content_type_is_a (mime_type, "application/x-7z-compressed")) {
@@ -425,27 +408,6 @@ comics_check_decompress_command	(gchar  
 			comics_document->command_usage = P7ZIP;
 			return TRUE;
 		}
-		comics_document->selected_command =
-				g_find_program_in_path ("bsdtar");
-		if (comics_document->selected_command) {
-			comics_document->command_usage = TAR;
-			return TRUE;
-		}
-	} else if (g_content_type_is_a (mime_type, "application/x-cbt") ||
-		   g_content_type_is_a (mime_type, "application/x-tar")) {
-		/* tar utility (Tape ARchive) */
-		comics_document->selected_command =
-				g_find_program_in_path ("tar");
-		if (comics_document->selected_command) {
-			comics_document->command_usage = TAR;
-			return TRUE;
-		}
-		comics_document->selected_command =
-				g_find_program_in_path ("bsdtar");
-		if (comics_document->selected_command) {
-			comics_document->command_usage = TAR;
-			return TRUE;
-		}
 	} else {
 		g_set_error (error,
 			     EV_DOCUMENT_ERROR,
