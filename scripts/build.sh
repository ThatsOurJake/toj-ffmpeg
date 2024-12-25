#!/bin/bash
set -e

function build() {
  dockerfile=$1
  docker build -t $dockerfile -f ./dockerfiles/$dockerfile .
  docker create --name $dockerfile $dockerfile
  docker cp $dockerfile:/compile/bin ./out/$dockerfile
  docker rm $dockerfile
  docker rmi $dockerfile
}

build "ffmpeg-ubuntu-25"
