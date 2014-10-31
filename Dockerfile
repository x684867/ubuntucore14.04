# Docker Container for Ubuntu 14.04 x64
# (c) 2014 EdgeCase, Inc.  sam@edgecase.io
# 
MAINTAINER Sam Caldwell <mail@samcaldwell.net>
FROM scratch
ADD files/base-ubuntu14.04x64.tar.gz /

ENV DEBIAN_FRONTEND noninteractive;
ENV APTOPT "-y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --force-yes --yes --fix-missing"
RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    ln -sf /bin/bash /bin/sh && \
    cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    rm -rf /swap &> /dev/null && \
    dd if=/dev/zero of=/swap bs=2048 count=1048576 && \
    mkswap /swap && \
    echo "/swap swap swap defaults,noauto 0 0" >> /etc/fstab && \
    apt-get install -y wget -y

CMD ["/bin/bash"]
