#!/bin/sh

HERE=`dirname $0`
cd "${HERE}"

cargo publish "$@"
