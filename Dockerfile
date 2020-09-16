FROM php:7.4.10-fpm
RUN apt-get update && apt-get install -y libfreetype6-dev libpng-dev libjpeg62-turbo-dev git unzip msmtp
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) mysqli gd
RUN echo 'sendmail_path=/usr/bin/msmtp -t -i ' > /usr/local/etc/php/conf.d/docker-php-sendmail-path.ini
