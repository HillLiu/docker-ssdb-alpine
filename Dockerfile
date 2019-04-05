FROM alpine:3.8

ARG VERSION=${VERSION:-master}

RUN apk update && \
    apk add --virtual .build-deps curl make autoconf g++ && \
    mkdir -p /tmp/ssdb && \
    mkdir -p /var/lib/ssdb && \
    curl -Lk "https://github.com/ideawu/ssdb/archive/${VERSION}.tar.gz" | \
    tar -xz -C /tmp/ssdb --strip-components=1 && \
    cd /tmp/ssdb && \
    make && \
    make install && \
    sed \
      -e 's@home.*@home /var/lib@' \
      -e 's/loglevel.*/loglevel info/' \
      -e 's@work_dir = .*@work_dir = /var/lib/ssdb@' \
      -e 's@pidfile = .*@pidfile = /run/ssdb.pid@' \
      -e 's@level:.*@level: info@' \
      -e 's@ip:.*@ip: 0.0.0.0@' \
      -i /usr/local/ssdb/ssdb.conf && \
    rm /tmp/ssdb -rf && \
    apk del .build-deps

RUN apk add libstdc++ libgcc

EXPOSE 8888
VOLUME /var/lib/ssdb
ENTRYPOINT /usr/local/ssdb/ssdb-server /usr/local/ssdb/ssdb.conf
