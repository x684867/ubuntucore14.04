UbuntuCore14.04
===============

This repo provides a base ubuntu 14.04 core image for use in other development projects I have.  This is a known starting point with
a self-signed certificate and other basic features I like to start with.

Parameters
----------
(1) Ubuntu 14.04 x64 is patched and updated with each build.
(2) A self-signed certificate (2048 bits) is created unique to each build.
(3) SWAP is added just for process safety.  We can alert on its use rather 
    than on process failure.
(4) Timezone is set to CDT.

ChangeList:
-----------
30 Oct 2014: udev was broken in a joomla build derived from this image.
             To fix the problem, I'm breaking udev perm. and using a
             forced exit 0 in the init script so apt-get will not break.
