FROM ubuntu:trusty
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y bzip2
RUN adduser --disabled-password --gecos "" ubuntu
WORKDIR /home/ubuntu
RUN apt-get install -y sudo
RUN sudo -u ubuntu bash -c 'wget https://github.com/galeksandrp/zyxel-keenetic-packages/releases/download/v-oss/zyxel_keenetics_gpl_v.1.00_4_d0.tar_.bz2 -O - | tar xj'
RUN sudo -u ubuntu bash -c 'yes "Yes" | zyxel_keenetics_gpl_v.1.00_4_D0/zyxel_keenetics_gpl_v.1.00_4_D0.lnx && rm zyxel_keenetics_gpl_v.1.00_4_D0 -rf'
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y g++
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y gawk
RUN apt-get install -y bison
RUN apt-get install -y flex
RUN apt-get install -y unzip
RUN apt-get install -y patch
RUN apt-get install -y subversion
RUN apt-get install -y autoconf
RUN apt-get install -y python
COPY prereq-build.mk.patch /home/ubuntu/
WORKDIR /home/ubuntu/zyxel_keenetics_gpl_v.1.00_4_D0_161111/include
RUN sudo -u ubuntu bash -c 'patch < /home/ubuntu/prereq-build.mk.patch'
WORKDIR /home/ubuntu/zyxel_keenetics_gpl_v.1.00_4_D0_161111
RUN sudo -u ubuntu ./configure.sh keenetic
RUN apt-get install -y nano
