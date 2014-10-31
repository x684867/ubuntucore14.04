# Docker Container for Ubuntu 14.04 x64
# (c) 2014 EdgeCase, Inc.  sam@edgecase.io
# 
FROM scratch
MAINTAINER Sam Caldwell <mail@samcaldwell.net>

ADD files/base-ubuntu14.04x64.tar.gz /
ADD files/udev.sh /usr/bin/fake-udev

ENV DEBIAN_FRONTEND noninteractive;
RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    ln -sf /bin/bash /bin/sh && \
    cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    rm -rf /swap &> /dev/null && \
    dd if=/dev/zero of=/swap bs=1024 count=1048576 &> /dev/null && \
    mkswap /swap &> /dev/null && \
    echo "/swap swap swap defaults,noauto 0 0" >> /etc/fstab && \
    apt-get install wget -y
RUN dpkg-divert --local --rename --add /sbin/initctl && \
    ln -s /usr/bin/true /sbin/initctl && \
    chmod +x /usr/bin/fake-udev && \
    ln -sf /usr/bin/fake-udev /etc/init.d/udev
RUN openssl req \
            -nodes \
            -newkey rsa:2048 \
            -keyout /etc/ssl/private/selfsigned.key \
            -out /etc/ssl/selfsigned.csr \
            -subj "/C=US/ST=TX/L=Austin/O=scaldwell/OU=Ops/CN=localhost"  &> /dev/null && \
    openssl x509 \
            -req \
            -days 365 \
            -in /etc/ssl/selfsigned.csr \
            -signkey /etc/ssl/private/selfsigned.key \
            -out /etc/ssl/certs/selfsigned.crt &> /dev/null


CMD ["/bin/bash"]
