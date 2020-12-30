FROM alpine:3.8

ARG VERSION=${VERSION:-master}

RUN echo Install Version: ${VERSION} && \
    mkdir -p /tmp/ssdb && \
    apk update && \
    apk add --virtual .build-deps curl make autoconf g++ && \
    curl -Lk "https://github.com/ideawu/ssdb/archive/${VERSION}.tar.gz" | \
    tar -xz -C /tmp/ssdb --strip-components=1

RUN mkdir -p /var/lib/ssdb && \
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
      -i /usr/local/ssdb/ssdb.conf

RUN rm /tmp/ssdb -rf && \
    apk del .build-deps
 
RUN apk add libstdc++ libgcc

EXPOSE 8888
VOLUME /var/lib/ssdb
ENTRYPOINT /usr/local/ssdb/ssdb-server /usr/local/ssdb/ssdb.conf
