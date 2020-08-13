FROM php:7.4.9-apache
RUN apt-get update && apt-get install -y libfreetype6-dev libpng-dev libjpeg62-turbo-dev git unzip msmtp
RUN curl https://dl.eff.org/certbot-auto -o /usr/bin/certbot-auto
RUN chmod a+x /usr/bin/certbot-auto
RUN certbot-auto -n || true
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) mysqli gd
RUN a2enmod rewrite
RUN echo 'sendmail_path=/usr/bin/msmtp -t -i ' > /usr/local/etc/php/conf.d/docker-php-sendmail-path.ini
