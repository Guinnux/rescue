#/bin/sh
IMG=$PWD/image
mkdir -p $IMG/var/lib/pacman
#arm-gnx5-linux-gnueabi-pacman -r $IMG -Sy 
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm filesystem 

#Remove this one as busybox brings its own that works with ash
rm -fR $IMG/etc/profile

arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/busybox-rescue-1.21.1-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/libarchive-rescue-3.1.2-8-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/pacman-rescue-4.2.1-2-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/init-rescue-1.0.0-1-any.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/openssl-rescue-1.0.2.d-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/dropbear-2015.67-2-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/e2fsprogs-rescue-1.42.13-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/log4cpp-1.1.1-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/libklog-1.1-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/gnxid-2.0.2-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $IMG -U --noconfirm $PWD/repo/gnx-installer-3.0-1-any.pkg.tar.xz

arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm iproute2
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm gcc-libs
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm acl
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm expat
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm lzo
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm bzip2
arm-gnx5-linux-gnueabi-pacman -r $IMG -S --noconfirm nano

rm -fR $IMG/usr/include
rm -fR $IMG/usr/share/iana-etc
rm -fR $IMG/usr/share/i18n
rm -fR $IMG/usr/share/doc
rm -fR $IMG/usr/share/info
rm -fR $IMG/usr/share/locale
rm -fR $IMG/usr/share/zoneinfo
rm -fR $IMG/usr/share/perl5
rm -fR $IMG/usr/share/man
rm -fR $IMG/usr/lib/*.a
rm -fR $IMG/usr/lib/*.la
rm -fR $IMG/usr/lib/audit
rm -fR $IMG/usr/lib/gconv
rm -fR $IMG/usr/lib/getconf
rm -fR $IMG/usr/lib/perl5
rm -fR $IMG/var/lib/pacman

arm-gnx5-linux-gnueabi-strip $IMG/usr/lib/*.so
arm-gnx5-linux-gnueabi-strip $IMG/usr/bin/*

install -d -m755 $IMG/var/lib/pacman
install -d -m755 -o 1000 -g 100 $IMG/home/default
install -D -m644 ./passwd  $IMG/etc/passwd
install -D -m644 ./resolv.conf  $IMG/etc/resolv.conf
install -d -m755 $IMG/mnt/gnx

cd $IMG
mkfs.jffs2 --little-endian --eraseblock=0x10000 -n --pad -o ../rescue.pacman.jffs2
cd ..
