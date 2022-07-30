ARG VERSION=${VERSION:-[VERSION]}

FROM alpine:3.15

ARG VERSION

# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN apk update \
  && INSTALL_VERSION=$VERSION install-packages \
  && rm /usr/local/bin/install-packages;

EXPOSE 8888
VOLUME /var/lib/ssdb
ENTRYPOINT ["entrypoint.sh"]
CMD ["server"]
