#!/bin/sh

set -e

_IFS="$IFS"; IFS=':'
for dir in $PKG_CONFIG_PATH `pkg-config --variable pc_path pkg-config`; do
    if [ -d "${dir}" -a -w "${dir}" -a -d "${dir}/../../include" ]; then
        DST="$dir"
        break
    fi
done
IFS="$_IFS"; unset _IFS

if [ -z "${DST}" ]; then
    echo "no suitable pkg-config directory found."
    exit 1
fi

if [ `basename $0` = "pkg-install.sh" ]; then
    SRC=`dirname $0`
    SRC=`(cd $SRC/..; [ -d .git ] && pwd)`
fi

export DST
cd ${TMPDIR:-/tmp}

trap 'rm -rf blst.$$' 0
git clone ${SRC:-"https://github.com/supranational/blst"} blst.$$
( trap '[ $? -ne 0 ] && rm "${DST}/blst.pc" 2>/dev/null' 0
  cd blst.$$
  tag=`git tag --sort=v:refname | tail -1`
  git checkout --detach ${tag}
  tag=`expr substr $tag 2 8`
  ./build.sh "$@"
  cp libblst.a "${DST}/.."
  cp bindings/blst.h* "${DST}/../../include"
  cat > "${DST}/blst.pc" << blst.pc
libdir=\${pcfiledir}/..
incdir=\${pcfiledir}/../../include
Name: blst
Version: $tag
Description: blst core library
Cflags: -I\${incdir}
Libs: -L\${libdir} -lblst
blst.pc
)
