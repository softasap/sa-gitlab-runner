#!/bin/bash

set -e
set -o pipefail

REVISION={{ detected_gitlab_version }}
{% raw %}
if [ "$(id -u)" -ne 0 ]; then
    printf "E: This script requires root privileges.\n" >&2
    exit 1
fi
if [ ! -x "$(which cdebootstrap)" ]; then
    printf "W: 'cdebootstrap' is not available.\n" >&2
    exit 3
fi
if [ ! -x "$(which docker)" ]; then
    printf "W: Docker is not available.\n" >&2
    exit 3
fi

if ! service docker status >>/dev/null; then
    printf "W: Docker is not running.\n" >&2
    exit 3
fi

if [ -z "${http_proxy}" ]; then
    export http_proxy="$(apt-config --format '%f %v%n' dump | awk '/Acquire::http::Proxy\ / {print $2}')"
    if [ -n "${http_proxy}" ]; then
        printf "I: Detected proxy ${http_proxy}\n"
    fi
fi

clean() {
    docker rmi -f gitlab-runner-prebuilt:${REVISION} 2>>/dev/null || true
}
trap clean EXIT TERM INT

clean
rm -rf /var/cache/gitlab-runner/*

## Spinner:
## http://mebsd.com/coding-snipits/bash-spinner-example-freebsd-loading-spinner.html
i=1;
sp="/-\|";
tee_spinner() {
    local L
    while read -r L; do
        printf "%s\b" "${sp:i++%${#sp}:1}"       # spinner/bash
        printf "%s\n" "$L" >>"$1"
    done
    printf "\b\n"
}

set -u
cd /var/cache/gitlab-runner

BLOG="/var/cache/gitlab-runner/cdebootstrap.log"
rm -f "${BLOG}" || true

printf "I: Generating GitLab Runner Docker image. This may take a while...\n"
printf "I: cdebootstrap; saving build log to ${BLOG} "
cdebootstrap -v \
    --flavour=minimal \
    --exclude="dmsetup,systemd-sysv,systemd,udev" \
    --include="bash,ca-certificates,git,netcat-traditional" \
    stable ./debian-minbase http://deb.debian.org/debian/ \
2>&1 | tee_spinner "${BLOG}"

XZ_OPT="-2v" tar -C debian-minbase -caf stable.tar.xz .
rm -rf ./debian-minbase

cp -v /usr/bin/gitlab-runner-helper .
cp -v /usr/lib/gitlab-runner/gitlab* .
cp -v /usr/lib/gitlab-runner/Dockerfile .

## Build docker image:
printf "I: docker build "
docker build --no-cache --rm --force-rm \
    -t gitlab-runner-prebuilt:${REVISION} -f ./Dockerfile .

## Build image (instead of container, like upstream does):
## Depends on "nodim_loadimage.patch".
printf "I: Packing image into /var/lib/gitlab-runner/gitlab-runner-prebuilt.tar.xz\n"
#docker save gitlab-runner-prebuilt:${REVISION} | XZ_OPT="-v" xz -c > /var/lib/gitlab-runner/gitlab-runner-prebuilt.tar.xz
#docker save gitlab-runner-prebuilt:${REVISION} | gzip --no-name -c -9 > /var/lib/gitlab-runner/gitlab-runner-prebuilt.tar.gz

## Build container (follows upstream):
docker create --name=gitlab-runner-prebuilt-${REVISION} gitlab-runner-prebuilt:${REVISION} /bin/sh
docker export gitlab-runner-prebuilt-${REVISION} | XZ_OPT="-v" xz -c > /var/lib/gitlab-runner/gitlab-runner-prebuilt.tar.xz
#docker export gitlab-runner-prebuilt-${REVISION} | gzip --no-name -c -9 > /var/lib/gitlab-runner/gitlab-runner-prebuilt.tar.gz
docker rm -f gitlab-runner-prebuilt-${REVISION}

clean
{% endraw %}