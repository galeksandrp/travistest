FROM php:7.4.9-apache
RUN curl https://dl.eff.org/certbot-auto -o /usr/bin/certbot-auto
RUN chmod a+x /usr/bin/certbot-auto
RUN certbot-auto -n || true
RUN a2enmod rewrite
RUN a2dismod php7
RUN a2dismod mpm_prefork
RUN a2enmod mpm_event
RUN a2enmod proxy_fcgi
RUN a2enmod http2
