#/bin/sh
IMG=$PWD/image
mkdir -p $PWD/image/var/lib/pacman
#arm-gnx5-linux-gnueabi-pacman -r $PWD/image -Sy 
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S filesystem 

arm-gnx5-linux-gnueabi-pacman -r $PWD/image -U $PWD/repo/busybox-rescue-1.21.1-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -U $PWD/repo/libarchive-rescue-3.1.2-8-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -U $PWD/repo/pacman-rescue-4.2.1-2-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -U $PWD/repo/init-rescue-1.0.0-1-any.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -U $PWD/repo/openssl-rescue-1.0.2.d-1-arm.pkg.tar.xz
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -U $PWD/repo/e2fsprogs-rescue-1.42.13-1-arm.pkg.tar.xz

arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S iproute2
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S gcc-libs
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S acl
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S expat
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S lzo
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S bzip2
arm-gnx5-linux-gnueabi-pacman -r $PWD/image -S dropbear

#exit 0

rm -fvR $IMG/usr/include
rm -fvR $IMG/usr/share/iana-etc
rm -fvR $IMG/usr/share/i18n
rm -fvR $IMG/usr/share/doc
rm -fvR $IMG/usr/share/info
rm -fvR $IMG/usr/share/locale
rm -fvR $IMG/usr/share/zoneinfo
rm -fvR $IMG/usr/share/perl5
rm -fvR $IMG/usr/share/man
rm -fvR $IMG/usr/lib/*.a
rm -fvR $IMG/usr/lib/*.la
rm -fvR $IMG/usr/lib/audit
rm -fvR $IMG/usr/lib/gconv
rm -fvR $IMG/usr/lib/getconf
rm -fvR $IMG/usr/lib/perl5
rm -fvR $IMG/var/lib/pacman

arm-gnx5-linux-gnueabi-strip $IMG/usr/lib/*.so
arm-gnx5-linux-gnueabi-strip $IMG/usr/bin/*

mkdir $IMG/var/lib/pacman

cp ./passwd $IMG/etc/passwd
cp ./resolv.conf $IMG/etc/resolv.conf

cd $IMG
mkfs.jffs2 --little-endian --eraseblock=0x10000 -n --pad -o ../rescue.pacman.jffs2
cd ..
