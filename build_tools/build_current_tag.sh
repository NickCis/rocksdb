#!/bin/bash -e

set -e

echo "Building"

make shared_lib static_lib

#lastver=`git tag | grep "v" | sed 's/v//' | sort -r --version-sort`
#rev=`git log --pretty=format:'%h' -n 1`
ROCKSDB_MAJOR=`egrep "ROCKSDB_MAJOR.[0-9]" include/rocksdb/version.h | cut -d ' ' -f 3`
ROCKSDB_MINOR=`egrep "ROCKSDB_MINOR.[0-9]" include/rocksdb/version.h | cut -d ' ' -f 3`
ROCKSDB_PATCH=`egrep "ROCKSDB_PATCH.[0-9]" include/rocksdb/version.h | cut -d ' ' -f 3`
#pkgver=`git symbolic-ref HEAD | sed -e "s/^refs\/heads\/v//"`-1
pkgver="$ROCKSDB_MAJOR.$ROCKSDB_MINOR-$ROCKSDB_PATCH"
#pkgdir="rocksdb_$pkgver-1"
pkgdir="rocksdb_$pkgver"

mkdir "$pkgdir"
mkdir "$pkgdir/usr"
mkdir "$pkgdir/usr/lib"
install -d "$pkgdir/usr/include"
cp -r include/rocksdb "$pkgdir"/usr/include
install -m755 -D librocksdb.so* "$pkgdir"/usr/lib/
install -m755 -D librocksdb.a* "$pkgdir"/usr/lib/

mkdir "$pkgdir/DEBIAN"
echo "Package: RocksDb" >> "$pkgdir/DEBIAN/control"
echo "Version: $pkgver" >> "$pkgdir/DEBIAN/control"
echo "Section: base" >> "$pkgdir/DEBIAN/control"
echo "Priority: optional" >> "$pkgdir/DEBIAN/control"
echo "Architecture: amd64" >> "$pkgdir/DEBIAN/control"
#echo "Depends: libsomethingorrather (>= 1.2.13), anotherDependency (>= 1.2.6)" >> "$pkgdir/DEBIAN/control"
echo "Maintainer: Your Name <you@email.com>" >> "$pkgdir/DEBIAN/control"
echo "Description: Rocksdb db package for travis ci" >> "$pkgdir/DEBIAN/control"
echo " This package was done in order to avoid compiling rocksdb every time" >> "$pkgdir/DEBIAN/control"
echo " while developing a proyect using travis ci" >> "$pkgdir/DEBIAN/control"
echo "" >> "$pkgdir/DEBIAN/control"

dpkg-deb --build "$pkgdir"
