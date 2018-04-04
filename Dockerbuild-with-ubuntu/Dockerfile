FROM ubuntu:16.04

RUN apt-get update
RUN apt-get -y upgrade

# Install apache and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 curl lynx-cur

# prepare php install 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential libxml2-dev libxslt1-dev 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libfcgi-dev libfcgi0ldbl libjpeg62-dbg libxml2-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libmcrypt-dev libssl-dev libc-client2007e libc-client2007e-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libfreetype6-dev libkrb5-dev libpq-dev libicu-dev

RUN ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a

RUN mkdir /opt/php-5.5.38
RUN mkdir /usr/local/src/php5-build
RUN cd /usr/local/src/php5-build
RUN wget http://br1.php.net/get/php-5.5.38.tar.bz2/from/this/mirror -O php-5.5.38.tar.bz2
RUN tar jxf php-5.5.38.tar.bz2

RUN cd php-5.5.38/
RUN ./configure --prefix=/opt/php-5.5.38 --with-pdo-pgsql --with-zlib-dir --with-freetype-dir --enable-mbstring \ 
--with-libxml-dir=/usr --enable-soap --enable-intl --enable-calendar --with-curl --with-mcrypt --with-zlib \
--with-gd --with-pgsql --disable-rpath --enable-inline-optimization --with-bz2 --with-zlib --enable-sockets \
--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --enable-exif --enable-bcmath --with-mhash \
--enable-zip --with-pcre-regex --with-mysql --with-pdo-mysql --with-mysqli --with-jpeg-dir=/usr --with-png-dir=/usr \
--enable-gd-native-ttf --with-openssl --with-fpm-user=www-data --with-fpm-group=www-data \
--with-libdir=/lib/x86_64-linux-gnu --enable-ftp --with-imap --with-imap-ssl --with-gettext --with-xmlrpc --with-xsl \
--with-kerberos --enable-fpm

RUN make
RUN make install
RUN cp /usr/local/src/php5-build/php-5.5.38/php.ini-production /opt/php-5.5.38/lib/php.ini
RUN cp /opt/php-5.5.38/etc/php-fpm.conf.default /opt/php-5.5.38/etc/php-fpm.conf
RUN mkdir /opt/php-5.5.38/etc/php-fpm.d




#---- OLD STUFF
# Enable apache mods.
RUN php5enmod openssl
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Copy site into place.
ADD app /var/www

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND