
## Introduction ##

This page contains instructions for all the administrative tasks required to manage this site.  If you learn any new processes (like how to upload images to the wiki, for instance), document them here.

## SVN ##

Subversion (SVN) is the version control system used to track all the files on this site.  In order to modify files offline you must download them (checkout) and then upload them again (commit).  To add a new file you must add it to your local SVN copy and then commit it (add / commit).

SVN works by making a local copy of the files on the website on your local drive.  When you checkout some code, you will specify a local directory to put it in.  until you delete the contents of this directory, SVN will then require that you put the same source tree in that directory forevermore.

### Checkout, Status and Update ###

To check out the WHOLE source tree into a sub-directory called fabfi in your current working directory:
```
$ svn checkout https://fabfi.googlecode.com/svn/ fabfi --username yourgoogleusername
```

Now, let's say you want to check out just the wiki part of your source tree
```
$ svn checkout https://fabfi.googlecode.com/svn/wiki wiki --username yourgoogleusername
```

once you have checked out the source, you now keep your source current using short commands. All SVN commands function with respect to the current working directory and most are recursive by default.   To see the status of your local copy, go to the top level and run:
```
svn st
```
Here's a list of common status codes:

![http://knaddison.com/sites/knaddison.com/files/svn_codes.png](http://knaddison.com/sites/knaddison.com/files/svn_codes.png)

To update all or a part of your local tree from the archive, go to the top level of the thing you want to update and run:
```
svn up
```

ALWAYS UPDATE YOUR SOURCE BEFORE BEGINNING YOUR EDITS!!!

### Add, Delete, Move and Undo ###

to bring your local copy back to the original state of the revision you have checked out, go to the level above the thing you want to revert and do:
```
svn revert <thing>
```
If you create a new file or folder and want it to become part of the archive:
```
svn add <thing>
```
if you want to delete or move something in the archive (and have the changes tracked, which you ususally do):
```
svn mv #move
svn rm #remove
svn rmdir #remove directory
```

### Committing ###

In SVN, nothing is changed in the online archive until you explicitly commit it.  When you're ready to push changes use
```
svn commit [file or folder]
```
this will commit everything in the working directory in a recursive fashion. You can optionally specify a file or folder.  The terminal will show you a list of changes and status codes, and ask you to write a comment about the commit.  MAKE THIS COMMENT USEFULLY DESCRIPTIVE!

### Uploading Images to SVN (for the wiki) ###

1. Checkout the current wiki (if you already have the whole tree checked out, then go to the directory above the wii in your local tree), then:
```
$ svn checkout https://fabfi.googlecode.com/svn/wiki wiki--username yourgoogleusername
```

2. Move to the working directory:
```
   $ cd wiki/
```

3. Make a directory in which to save images (this is probably already done for you by now):
```
   $ svn mkdir images
```

4. Put the image under subversion control:
```
   $ svn add /location/filename
```

5. Tell subversion what mime-type to use:
```
   $ svn propset svn:mime-type 'image/jpeg' /location/filename
   $ svn commit
   (Be sure to use the correct file extension e.g jpeg, png, etc)
```

**NOTE: You can omit this step by following [these instructions](https://code.google.com/p/support/wiki/SubversionFAQ#How_can_I_make_SVN_serve_HTML_and_images_with_the_correct_Conten).**

6. Upload the image:
```
   $ svn commit
   $ svn update
```

'svn update' is not required, but is a good idea to get all the new stuff that might have changed while you were figuring this out.

7. Refresh code.google,com/p/fabfi/wiki to check whether you did it right (it will be under Source>wiki>images)

## Managing Branches ##

http://www.murrayc.com/blog/permalink/2007/01/25/subversion-diff-between-branches/