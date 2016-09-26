#/bin/sh

if [ $# -lt 1 ]; then
	echo "Not Enough arguments"
	exit 1
fi

ARCH=$1
case $ARCH in
	arm)
	ARCH_PREFIX=arm-gnx5-linux-gnueabi
	IMG=$PWD/image/$ARCH
	;;
	aarch64)
	ARCH_PREFIX=aarch64-gnx5-linux-gnueabi
	IMG=$PWD/image/$ARCH
	;;
	*)
	echo "Unsupported architecture $ARCH"
	exit 1
esac

echo "Using arch '$ARCH' .."
echo "Using tuple '$ARCH_PREFIX' .."
echo "Using output directory '$IMG' .."

echo "Cleaning old images .."
if [ -e $IMG ]; then
	rm -fR $IMG
	rm -f  $IMG/../rescue-$ARCH.*
fi



mkdir -p $IMG/var/lib/pacman
$ARCH_PREFIX-pacman -r $IMG -Sy 
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm filesystem 

#Remove this one as busybox brings its own that works with ash
rm -fR $IMG/etc/profile

$ARCH_PREFIX-pacman -r $IMG -S --noconfirm busybox-rescue
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm libarchive-rescue
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm pacman-rescue
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm init-rescue
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm openssl-rescue
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm dropbear
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm e2fsprogs-rescue
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm log4cpp
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm libklog
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm gnxid
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm gnx-installer

$ARCH_PREFIX-pacman -r $IMG -S --noconfirm iproute2
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm gcc-libs
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm acl
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm expat
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm lzo
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm bzip2
$ARCH_PREFIX-pacman -r $IMG -S --noconfirm nano

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

$ARCH_PREFIX-strip $IMG/usr/lib/*.so
$ARCH_PREFIX-strip $IMG/usr/bin/*

install -d -m755 $IMG/var/lib/pacman
install -d -m755 -o 1000 -g 100 $IMG/home/default
install -D -m644 ./passwd  $IMG/etc/passwd
install -D -m644 ./resolv.conf  $IMG/etc/resolv.conf
install -d -m755 $IMG/mnt/gnx

pushd $PWD
cd $IMG
mkfs.jffs2 --little-endian --eraseblock=0x10000 -n --pad -o ../rescue-$ARCH.pacman.jffs2
tar -cvpf ../rescue-$ARCH.tar .
cd ..
wc -c rescue-$ARCH.tar
xz -9 -e rescue-$ARCH.tar

popd
