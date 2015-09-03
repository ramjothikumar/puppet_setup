FROM ubuntu:14.04
Maintainer Ram Jothikumar

RUN apt-get update && apt-get -y install puppet
RUN echo "10.1.2.75 puppet" >> /etc/hosts
RUN service puppet restart
RUN puppet agent --enable
