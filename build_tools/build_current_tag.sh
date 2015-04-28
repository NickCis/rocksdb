#!/bin/bash

set -e

make shared_lib

#lastver=`git tag | grep "v" | sed 's/v//' | sort -r --version-sort`
#rev=`git log --pretty=format:'%h' -n 1`
pkgver=`git symbolic-ref HEAD | sed -e "s/^refs\/heads\/v//"`
pkgdir="rocksdb_$pkgver-1"

mkdir "$pkgdir"
mkdir "$pkgdir/usr"
mkdir "$pkgdir/usr/lib"
install -d "$pkgdir/usr/include"
cp -r include/rocksdb "$pkgdir"/usr/include
install -m755 -D librocksdb.so "$pkgdir"/usr/lib/librocksdb.so

mkdir "$pkgdir/DEBIAN"
echo "Package: RocksDb" >> "$pkgdir/DEBIAN/control"
echo "Version: $pkgver-1" >> "$pkgdir/DEBIAN/control"
echo "Section: base" >> "$pkgdir/DEBIAN/control"
echo "Priority: optional" >> "$pkgdir/DEBIAN/control"
echo "Architecture: amd64" >> "$pkgdir/DEBIAN/control"
#echo "Depends: libsomethingorrather (>= 1.2.13), anotherDependency (>= 1.2.6)" >> "$pkgdir/DEBIAN/control"
echo "Maintainer: Your Name <you@email.com>" >> "$pkgdir/DEBIAN/control"
echo "Description: Hello World" >> "$pkgdir/DEBIAN/control"
echo " When you need some sunshine, just run this" >> "$pkgdir/DEBIAN/control"
echo " small program!" >> "$pkgdir/DEBIAN/control"
echo " " >> "$pkgdir/DEBIAN/control"
echo " (the space before each line in the description is important)" >> "$pkgdir/DEBIAN/control"

dpkg-deb --build "$pkgdir"
