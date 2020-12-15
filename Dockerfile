FROM php:7.4.10-fpm
RUN apt-get update && apt-get install -y libfreetype6-dev libpng-dev libjpeg62-turbo-dev git unzip msmtp
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) mysqli gd
RUN pecl install xdebug-2.9.8
RUN docker-php-ext-enable xdebug
