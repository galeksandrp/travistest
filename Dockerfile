FROM ubuntu:trusty
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget bzip2 make gcc g++ libncurses5-dev zlib1g-dev gawk bison flex unzip patch subversion autoconf python
RUN adduser --disabled-password --gecos "" ubuntu
USER ubuntu
WORKDIR /home/ubuntu
RUN wget https://github.com/galeksandrp/zyxel-keenetic-packages/releases/download/v-oss/zyxel_keenetics_gpl_v.1.00_4_d0.tar_.bz2 -O - | tar xj && yes "Yes" | zyxel_keenetics_gpl_v.1.00_4_D0/zyxel_keenetics_gpl_v.1.00_4_D0.lnx && rm zyxel_keenetics_gpl_v.1.00_4_D0 -rf
COPY prereq-build.mk.patch /home/ubuntu/
WORKDIR /home/ubuntu/zyxel_keenetics_gpl_v.1.00_4_D0_161111/include
RUN patch < /home/ubuntu/prereq-build.mk.patch
WORKDIR /home/ubuntu/zyxel_keenetics_gpl_v.1.00_4_D0_161111
RUN ./configure.sh keenetic
RUN make
RUN make clean
