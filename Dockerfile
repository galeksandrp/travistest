FROM galeksandrp/travistest:docker-netams-common
WORKDIR /root/billing/jserver
RUN sed 's/nohup //' -i jserver-startup.sh
RUN sed 's/ 2> $LOGFILE > $LOGFILE &//' -i jserver-startup.sh
EXPOSE 8080
CMD ./jserver-startup.sh
