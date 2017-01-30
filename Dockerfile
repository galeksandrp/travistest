FROM openjdk
RUN sed 's&http://deb.debian.org/debian&http://httpredir.debian.org/debian&' -i /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget mysql-server
RUN mkdir -p /root/billing
WORKDIR /root/billing
RUN wget http://www.netams.com/files/netams4/netams4.0.1640-linux-x64.tar.gz -O - | tar xz
RUN service mysql start && mysqladmin create netams4
RUN ln -s $(dirname $(which java))/.. java
RUN sed 's/nohup //' -i webadmin/webadmin-startup.sh
RUN sed 's/ 2> $LOGFILE > $LOGFILE &//' -i webadmin/webadmin-startup.sh
EXPOSE 8080
CMD service mysql start && cd jserver && ./jserver-startup.sh && cd ../webadmin && ./webadmin-startup.sh
