# Docker Container for Ubuntu 14.04 x64
# (c) 2014 EdgeCase, Inc.  sam@edgecase.io
# 
# This container just takes a default ubuntu14.04
# and does some basic configuration common to all
# of the machines we deploy.  The idea here is to
# establish a baseline for all operations.
#
FROM ubuntu:14.04
MAINTAINER Sam Caldwell <mail@samcaldwell.net>

COPY files/usr/bin/ /usr/bin/

ENV DEBIAN_FRONTEND noninteractive
ENV BANNED_USERS "games news irc backup"
#
# Configure the machine (timezone, shell, udev, etc.)
# These are just some basic configuration parameters we need
# to get started.
#

RUN \
    dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /usr/bin/true /sbin/initctl && \
    ln -sf /usr/bin/udev.sh /etc/init.d/udev && \
    ln -sf /bin/bash /bin/sh && \
    cp /usr/share/zoneinfo/America/Chicago /etc/localtime && \
    echo "America/Chicago" > /etc/timezone && \
    echo "DEBIAN_FRONTEND=${DEBIAN_FRONTEND}" > /etc/profile.d/debian_frontend.sh 
#
# Update the system and install software
# packages.
#
RUN apt-get update --fix-missing -y && \
    apt-get upgrade -y && \
    apt-get install curl wget openssl apparmor-profiles -y && \
    apt-get autoremove -y && \
    apt-get clean -y && apt-get autoclean -y
#
# Clean up some of the junk that comes in Linux that we just do not need
# Who needs a user 'games' for a server after all?
#
RUN for i in games news irc backup; do userdel -r $i &> /dev/null; done; \
    for i in disk dialout fax voice cdrom floppy tape audio backup operator; do groupdel $i &> /dev/null; done; \
    rm -rf /usr/games/ &> /dev/null; \
    rm -rf /usr/local/games &> /dev/null; \
    rm /etc/issue /etc/issue.net &> /dev/null; \
    rm /etc/motd /etc/update-motd.d/* &> /dev/null; \
    exit 0

#
# Generate a self-signed certificate for the host.
#
RUN /usr/bin/generateSelfSignedCert


#
# Need some tests here to make sure
# the build is successful and that
# our requirements are satisfied.
#
RUN which openssl
RUN which curl
RUN which wget


# This is so everyone knows we're happy.
RUN echo " "; echo "------";echo "*** Build passes ***";echo " "; echo "------";echo " "

CMD ["/bin/bash"]
