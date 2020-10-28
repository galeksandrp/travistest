FROM php:7.4.9-apache
RUN a2enmod rewrite
RUN a2dismod php7
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event
RUN a2enmod proxy_fcgi
RUN a2enmod http2
RUN a2enmod ssl
