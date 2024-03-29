ARG VERSION=${VERSION:-[VERSION]}

FROM alpine:3.15

ARG VERSION

# apk
COPY ./entrypoint.sh ./install-packages.sh /usr/local/bin/
RUN apk update \
  && INSTALL_VERSION=$VERSION install-packages.sh \
  && rm /usr/local/bin/install-packages.sh;

EXPOSE 8888
VOLUME /var/lib/ssdb
ENTRYPOINT ["entrypoint.sh"]
CMD ["server"]
