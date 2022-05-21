#!/bin/sh

INSTALL="libstdc++"

BUILD_DEPS="curl make autoconf g++"

echo "###"
echo "# Will install"
echo "###"
echo ""
echo $INSTALL
echo ""
echo "###"
echo "# Will build package"
echo "###"
echo ""
echo $BUILD_DEPS
echo ""

apk add --virtual .build-deps $BUILD_DEPS && apk add $INSTALL

mkdir -p /tmp/src
curl -Lk "https://github.com/ideawu/ssdb/archive/${INSTALL_VERSION}.tar.gz" \
  | tar -xz -C /tmp/src --strip-components=1
mkdir -p /var/lib/ssdb \
  && cd /tmp/src \
  && make \
  && make install \
  && sed \
    -e 's@home.*@home /var/lib@' \
    -e 's/loglevel.*/loglevel info/' \
    -e 's@work_dir = .*@work_dir = /var/lib/ssdb@' \
    -e 's@pidfile = .*@pidfile = /dev/shm/ssdb.pid@' \
    -e 's@level:.*@level: info@' \
    -e 's@ip:.*@ip: 0.0.0.0@' \
    -i /usr/local/ssdb/ssdb.conf

rm -rf /tmp/src
apk del -f .build-deps && rm -rf /var/cache/apk/* || exit 1

exit 0
