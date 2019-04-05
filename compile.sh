#!/bin/bash

tag(){
  tag=$1
  if [ -z $tag ]; then
    tag=latest
  fi
  echo $tag
  docker tag ssdb-docker-alpine_ssdb-alpine hillliu/ssdb-alpine:$tag
}

push(){
  tag=$1
  if [ -z $tag ]; then
    tag=latest
  fi
  echo $tag
  docker push hillliu/ssdb-alpine
}

build(){
  docker-compose build --no-cache
}

case "$1" in
  p)
    push $2 
    ;;
  t)
    tag $2 
    ;;
  *)
    build
    exit
esac

exit $?
