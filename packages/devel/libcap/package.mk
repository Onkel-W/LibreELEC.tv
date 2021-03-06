# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2010-2011 Roman Weber (roman@openelec.tv)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libcap"
PKG_VERSION="2.31"
PKG_SHA256="c6088de41e1c97fa8047e2e7de0e4ee0cd13e6cc16538022230ae76727a87c46"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL="http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A library for getting and setting POSIX.1e capabilities."

post_unpack() {
  mkdir -p $PKG_BUILD/.$HOST_NAME
  cp -r $PKG_BUILD/* $PKG_BUILD/.$HOST_NAME
  mkdir -p $PKG_BUILD/.$TARGET_NAME
  cp -r $PKG_BUILD/* $PKG_BUILD/.$TARGET_NAME
}

make_host() {
  cd $PKG_BUILD/.$HOST_NAME
  make CC=$CC \
       AR=$AR \
       RANLIB=$RANLIB \
       CFLAGS="$HOST_CFLAGS" \
       BUILD_CFLAGS="$HOST_CFLAGS -I$PKG_BUILD/libcap/include" \
       PAM_CAP=no \
       lib=/lib \
       BUILD_GPERF=no \
       -C libcap libcap.pc libcap.a
}

make_target() {
  cd $PKG_BUILD/.$TARGET_NAME
  make CC=$CC \
       AR=$AR \
       RANLIB=$RANLIB \
       CFLAGS="$TARGET_CFLAGS" \
       BUILD_CC=$HOST_CC \
       BUILD_CFLAGS="$HOST_CFLAGS -I$PKG_BUILD/libcap/include" \
       PAM_CAP=no \
       lib=/lib \
       BUILD_GPERF=no \
       -C libcap libcap.pc libcap.a
}

makeinstall_host() {
  mkdir -p $TOOLCHAIN/lib
    cp libcap/libcap.a $TOOLCHAIN/lib

  mkdir -p $TOOLCHAIN/lib/pkgconfig
    cp libcap/libcap.pc $TOOLCHAIN/lib/pkgconfig

  mkdir -p $TOOLCHAIN/include/sys
    cp libcap/include/sys/capability.h $TOOLCHAIN/include/sys
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libcap/libcap.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp libcap/libcap.pc $SYSROOT_PREFIX/usr/lib/pkgconfig

  mkdir -p $SYSROOT_PREFIX/usr/include/sys
    cp libcap/include/sys/capability.h $SYSROOT_PREFIX/usr/include/sys
}
