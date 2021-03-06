#!/bin/sh
#desc: Variables to use in SDK"

# SDK basic directories
TMPDIR="tmp"
SCRIPTSDIR="scripts"
FILESDIR="files"
MOUNTDIR="mnt"
DOCSDIR="docs"
SRCDIR="src"
TESTDIR="test"
ISOFILESDIR="$FILESDIR/isofiles"
RPIFILESDIR="$FILESDIR/rpifiles"

# Opendomo packages and versions
ARCHCFG="$TMPDIR/arch"
ARCH=`cat $ARCHCFG 2>/dev/null`
ODPKG="odcommon odcgi odhal"
OD_VERSION="2.0.0"
IMGNAME="opendomo-$OD_VERSION-$ARCH"

# Kernel version and downloads
if [ "$ARCH" != "i386" ]; then
        KERNEL_SOURCES="3.6"
        KERNEL_PACKAGE="linux-source-3.6_3.6.9-1~experimental.1+rpi7_all.deb"
        KERNEL_VERSION="3.6.11"
	KERNEL_URL="http://archive.raspbian.org/raspbian/pool/main/l/linux-3.6/$KERNEL_PACKAGE"
else
        KERNEL_SOURCES="3.2"
        KERNEL_PACKAGE="linux-source-3.2_3.2.54-2_all.deb"
        KERNEL_VERSION="3.2.54-rt75"
        KERNEL_URL="http://ftp.debian.org/debian/pool/main/l/linux/$KERNEL_PACKAGE"
fi

# Configuration and other files
ROOTSTRAPCFG="$FILESDIR/rootstrap.conf"
KERNELCFG="$FILESDIR/kernel.$ARCH.conf"
INITRDIMG="$TMPDIR/initrd.$ARCH.tar.xz"
FREESIZE="5000"
CHANGESIMG="dfchange.img"

# Downloads
if [ "$ARCH" != "i386" ]; then
	INITRDURL="https://www.dropbox.com/s/sk2qdrzlfj1ko9u/initrd.arm.tar.xz"
else
	INITRDURL="https://www.dropbox.com/s/8kmciuirij8ut2o/initrd.i386.tar.xz"
fi

# SDK temporal directories
INITRDDIR="$TMPDIR/initrd.$ARCH"
ROOTSTRAPDIR="$TMPDIR/rootstrap.$ARCH"
TARGETDIR="$TMPDIR/image.$ARCH"
KERNELDIR="$ROOTSTRAPDIR/usr/src/linux"
EXPORTDIR="exports"
IMAGESDIR="$TARGETDIR/images"

# SDK commands
CHROOT="linux32 chroot"
