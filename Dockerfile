FROM galeksandrp/travistest:docker-netams-common
WORKDIR /root/billing/webadmin
RUN sed 's/nohup //' -i webadmin-startup.sh
RUN sed 's/ 2> $LOGFILE > $LOGFILE &//' -i webadmin-startup.sh
EXPOSE 8080
CMD ./webadmin-startup.sh
