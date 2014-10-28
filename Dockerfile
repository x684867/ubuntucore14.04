# Docker Container for Ubuntu 14.04 x64
# (c) 2014 EdgeCase, Inc.  sam@edgecase.io
# 
#FROM ubuntu:14.04
FROM scratch
ADD files/base-ubuntu14.04x64.tar.gz /

# Install SSH Public Keys
#RUN mkdir -p /home/{dev,ops}/.ssh/
#ADD files/home/ops/authorized_keys /home/ops/.ssh/
#ADD files/home/dev/authorized_keys /home/ops/.ssh/



#Update the system.
ENV DEBIAN_FRONTEND noninteractive;
ENV APTOPT "-y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold --force-yes --yes --fix-missing"
RUN apt-get update --fix-missing -y  &>> /docker-install.log
RUN apt-get dist-upgrade -y  &>> /docker-install.log

RUN ln -sf /bin/bash /bin/sh
RUN cp /usr/share/zoneinfo/America/Chicago /etc/localtime;
RUN echo "America/Chicago" > /etc/timezone;

RUN rm -rf /swap &> /dev/null
RUN dd if=/dev/zero of=/swap bs=2048 count=1048576  &>> /docker-install.log
RUN mkswap /swap  &>> /docker-install.log
RUN echo "/swap swap swap defaults,noauto 0 0" >> /etc/fstab

#Install the basic tools on the machine.
RUN apt-get update && \
	apt-get install -y openssh-server; \
	apt-get install -y zip; \
	apt-get install -y wget; \
	apt-get install -y vim; \
	apt-get install -y nano; \
	apt-get install -y python-dev; \
	apt-get install -y lsof; \ 
	apt-get install -y rsync; \ 
	apt-get install -y openssh-client; \ 
	apt-get install -y openssh-server; \ 
	apt-get install -y ufw; \
	/etc/init.d/ssh start; \
	update-rc.d ssh enable 

#make tcp/22 available
EXPOSE 22

#default command when docker image is run
CMD ["/bin/bash"]

