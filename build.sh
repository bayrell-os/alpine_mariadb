#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=10.5
SUBVERSION=2
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	amd64)
		docker build ./ -t bayrell/alpine_mariadb:$VERSION-$SUBVERSION-amd64 --file Dockerfile --build-arg ARCH=-amd64
	;;
	
	arm32v7)
		docker build ./ -t bayrell/alpine_mariadb:$VERSION-$SUBVERSION-arm32v7 --file Dockerfile --build-arg ARCH=-arm32v7
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_alpine_mariadb-*
		
		docker push bayrell/alpine_mariadb:$VERSION-$SUBVERSION-amd64
		docker push bayrell/alpine_mariadb:$VERSION-$SUBVERSION-arm32v7
		
		docker manifest create --amend bayrell/alpine_mariadb:$VERSION-$SUBVERSION \
			bayrell/alpine_mariadb:$VERSION-$SUBVERSION-amd64 \
			bayrell/alpine_mariadb:$VERSION-$SUBVERSION-arm32v7
		docker manifest push --purge bayrell/alpine_mariadb:$VERSION-$SUBVERSION
		
		docker manifest create --amend bayrell/alpine_mariadb:$VERSION \
			bayrell/alpine_mariadb:$VERSION-$SUBVERSION-amd64 \
			bayrell/alpine_mariadb:$VERSION-$SUBVERSION-arm32v7
		docker manifest push --purge bayrell/alpine_mariadb:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm32v7
		$0 manifest
	;;
	
	*)
		echo "Usage: $0 {amd64|arm32v7|manifest|all}"
		RETVAL=1

esac

exit $RETVAL

