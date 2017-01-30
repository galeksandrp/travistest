FROM ubuntu:14.04
RUN sed 's&http://archive.ubuntu.com/ubuntu/&mirror://mirrors.ubuntu.com/mirrors.txt&' -i /etc/apt/sources.list
RUN apt-get update
RUN echo mysql-server-5.5 mysql-server/root_password password test | debconf-set-selections
RUN echo mysql-server-5.5 mysql-server/root_password_again password test | debconf-set-selections
RUN apt-get install -y ca-certificates wget mysql-server-5.5 netmask
WORKDIR /root
RUN wget https://raw.githubusercontent.com/nightflyza/ubuntustaller/master/batchsetup.sh
RUN wget http://stargazer.net.ua/download/server/2.408/stg-2.408.tar.gz -O - | tar xz
RUN perl -p -e 's/.*capture\/ipq_linux"\n//' -i stg-2.408/projects/stargazer/build
RUN sed 's&             capture/ether_linux&             capture/ether_linux"&' -i stg-2.408/projects/stargazer/build
RUN mkdir -p /root/stargazer
RUN tar czf /root/stargazer/stg-2.408.tar.gz stg-2.408
ENV MYSQL_PASSWD=test
ENV STG_PASS=teststg
ENV RSD_PASS=testrsd
ENV LAN_IFACE=eth0
RUN service mysql start && bash ./batchsetup.sh ${MYSQL_PASSWD} ${STG_PASS} ${RSD_PASS} ${LAN_IFACE} $(netmask $(ip addr show $LAN_IFACE | grep 'inet ' | cut -d ' ' -f 6) | cut -d '/' -f 1 | tr -d ' ') $(ip addr show $LAN_IFACE | grep 'inet ' | cut -d '/' -f 2 | cut -d ' ' -f 1) $LAN_IFACE $(ip addr show $LAN_IFACE | grep 'inet ' | cut -d '/' -f 1 | cut -d ' ' -f 6)
RUN sed 's&</VirtualHost>&        <Directory />\n        AllowOverride All\n        </Directory>\n</VirtualHost>&' -i /etc/apache2/sites-enabled/000-default.conf
RUN sed 's&/var/www/html&/var/www/billing&' -i /etc/apache2/sites-enabled/000-default.conf
EXPOSE 80
CMD service mysql start && service apache2 start && stargazer
