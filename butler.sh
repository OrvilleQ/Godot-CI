#!/bin/sh
set -xe

export DOCKERFILE=Dockerfile.base
export BUTLER_VERSION=v$(grep "^ENV BUTLER_VERSION=" $DOCKERFILE | cut -d '=' -f2 | sed 's/"//g')

git clone https://github.com/itchio/butler.git
cd butler
git checkout ${BUTLER_VERSION}

export BUTLER_BUILTAT=$(date +%s)
export BUTLER_BUILDINFO=github.com/itchio/butler/buildinfo
export BUTLER_COMMIT=$(git rev-parse HEAD)

CGO_ENABLED=1 go build -ldflags "-X ${BUTLER_BUILDINFO}.Version=${BUTLER_VERSION} -X ${BUTLER_BUILDINFO}.BuiltAt=${BUTLER_BUILTAT} -X ${BUTLER_BUILDINFO}.Commit=${BUTLER_COMMIT} -w -s"
