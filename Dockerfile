FROM php:5.5.37-apache
RUN apt-get update && apt-get install -y libfreetype6-dev libpng12-dev libjpeg62-turbo-dev git unzip ssmtp
RUN curl https://dl.eff.org/certbot-auto -o /usr/bin/certbot-auto
RUN chmod a+x /usr/bin/certbot-auto
RUN certbot-auto -n || true
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) mysqli gd
RUN a2enmod rewrite
RUN echo 'sendmail_path=/usr/sbin/ssmtp -t -i ' > /usr/local/etc/php/conf.d/docker-php-sendmail-path.ini
