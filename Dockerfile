FROM ubuntu:12.04
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN echo mysql-server-5.5 mysql-server/root_password password test | debconf-set-selections
RUN echo mysql-server-5.5 mysql-server/root_password_again password test | debconf-set-selections
RUN apt-get install -y ca-certificates wget mysql-server-5.5 netmask
WORKDIR /root
RUN wget https://raw.githubusercontent.com/nightflyza/ubuntustaller/master/batchsetup.sh
ENV MYSQL_PASSWD=test
ENV STG_PASS=teststg
ENV RSD_PASS=testrsd
ENV LAN_IFACE=eth0
RUN (mysqld &) && bash ./batchsetup.sh ${MYSQL_PASSWD} ${STG_PASS} ${RSD_PASS} ${LAN_IFACE} $(netmask $(ip addr show $LAN_IFACE | grep 'inet ' | cut -d ' ' -f 6) | cut -d '/' -f 1 | tr -d ' ') $(ip addr show $LAN_IFACE | grep 'inet ' | cut -d '/' -f 2 | cut -d ' ' -f 1) $LAN_IFACE $(ip addr show $LAN_IFACE | grep 'inet ' | cut -d '/' -f 1 | cut -d ' ' -f 6)
EXPOSE 80
CMD (mysqld &) && service apache2 start && stargazer
