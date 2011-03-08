if [ ! -d "$SOURCE_ROOT/netsurf/" ]; then

#if we don't have the netsurf code, check it out into /netsurf
svn co svn://svn.netsurf-browser.org/trunk/libcss $SOURCE_ROOT/netsurf/libcss
svn co svn://svn.netsurf-browser.org/trunk/libparserutils $SOURCE_ROOT/netsurf/libparserutils
svn co svn://svn.netsurf-browser.org/trunk/libwapcaplet $SOURCE_ROOT/netsurf/libwapcaplet

fi