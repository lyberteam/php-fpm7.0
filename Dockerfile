################################
#                              #
#   Debian - PHP 7.0 CLI+FPM   #
#                              #
################################

FROM debian:jessie

ADD lyberteam-message.sh /var/www/lyberteam/lyberteam-message.sh
RUN chmod +x /var/www/lyberteam/lyberteam-message.sh
RUN /var/www/lyberteam/lyberteam-message.sh

MAINTAINER Lyberteam <lyberteamltd@gmail.com>
LABEL Vendor="Lyberteam"
LABEL Description="PHP-FPM v7.0.18"
LABEL Version="1.0.3"

ENV LYBERTEAM_TIME_ZONE Europe/Kiev

# Add Debian and source's
ADD https://www.dotdeb.org/dotdeb.gpg /tmp/dotdeb.gpg
RUN apt-key add /tmp/dotdeb.gpg \
    && echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list

## Install php7.0 extension
RUN apt-get update -yqq \
    && apt-get install -yqq \
	ca-certificates \
    git \
    gcc \
    make \
    wget \
    mc \
    curl \
    cron \
    php7.0-pgsql \
	php7.0-mysql \
	php7.0-opcache \
	php7.0-common \
	php7.0-mbstring \
	php7.0-mcrypt \
	php7.0-soap \
	php7.0-cli \
	php7.0-intl \
	php7.0-json \
	php7.0-xsl \
	php7.0-imap \
	php7.0-ldap \
	php7.0-curl \
	php7.0-gd  \
	php7.0-zip  \
	php7.0-dev \
	php7.0-redis \
	php7.0-memcached \
	php7.0-mongodb \
	php7.0-xdebug \
    php7.0-imagick \
    php7.0-fpm \
    && apt-get install -y -q --no-install-recommends \
       ssmtp


# Add default timezone
RUN echo $LYBERTEAM_TIME_ZONE > /etc/timezone
RUN echo "date.timezone=$LYBERTEAM_TIME_ZONE" > /etc/php/7.0/cli/conf.d/timezone.ini


# Install phpredis extension
#RUN mkdir /tmp/phpredis \
#    && cd /tmp/phpredis \
#    && git clone -b php7 https://github.com/phpredis/phpredis . \
#    && phpize7.0 && ./configure && make && make install \
#    && echo "extension=redis.so" > /etc/php/7.0/mods-available/redis.ini

## Install Xdebug extension
#RUN mkdir /tmp/xdebug \
#    && cd /tmp/xdebug \
#    && wget -c "http://xdebug.org/files/xdebug-2.5.3.tgz" \
#    && tar -xf xdebug-2.5.3.tgz \
#    && cd xdebug-2.5.3/ \
#    && phpize \
#    && ./configure \
#    && make \
#    && make install
#
#COPY php-conf/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
##    echo "zend_extension=xdebug.so" > /etc/php/7.0/mods-available/xdebug.ini \
#RUN ln -sf /etc/php/7.0/mods-available/xdebug.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini \
#    && ln -sf /etc/php/7.0/mods-available/xdebug.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini

# Download browscap.ini
RUN mkdir /var/lib/browscap
RUN wget http://browscap.org/stream?q=BrowsCapINI -O /var/lib/browscap/browscap.ini

## Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Copy our config files for php7.0 fpm and php7.0 cli
COPY php-conf/php.ini /etc/php/7.0/cli/php.ini
COPY php-conf/php-fpm.ini /etc/php/7.0/fpm/php.ini
COPY php-conf/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
COPY php-conf/www.conf /etc/php/7.0/fpm/pool.d/www.conf

RUN rm /etc/php/7.0/mods-available/xdebug.ini \
    && rm /etc/php/7.0/fpm/conf.d/20-xdebug.ini

## Install wkhtmltopdf and xvfb
RUN apt-get install -y \
    wkhtmltopdf \
    xvfb
## Create xvfb wrapper for wkhtmltopdf and create special sh script
RUN touch /usr/local/bin/wkhtmltopdf \
    && chmod a+x /usr/local/bin/wkhtmltopdf \
    && echo 'xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"' > /usr/local/bin/wkhtmltopdf \
    && chmod a+x /usr/local/bin/wkhtmltopdf

RUN usermod -aG www-data www-data
# Reconfigure system time
RUN  dpkg-reconfigure -f noninteractive tzdata

# Clear all packages and temp files
RUN	apt-get clean -yqq \
	&& apt-get purge php7.0-dev -yqq \
	&& apt-get purge git -yqq \
	&& apt-get purge gcc -yqq \
	&& apt-get purge make -yqq \
	&& apt-get purge wget -yqq \
	&& apt-get purge curl -yqq

RUN rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* \
	&& apt-get clean -yqq

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

WORKDIR /var/www/lyberteam

EXPOSE 9000

#libapache2-mod-php7.0 - server-side, HTML-embedded scripting language (Apache 2 module)
#libphp7.0-embed - HTML-embedded scripting language (Embedded SAPI library)
#php-all-dev - package depending on all supported PHP development packages
#php7.0 - server-side, HTML-embedded scripting language (metapackage)
#php7.0-apcu - APC User Cache for PHP
#php7.0-apcu-bc - APCu Backwards Compatibility Module
#php7.0-bcmath - Bcmath module for PHP
#php7.0-bz2 - bzip2 module for PHP
#php7.0-cgi - server-side, HTML-embedded scripting language (CGI binary)
#php7.0-cli - command-line interpreter for the PHP scripting language
#php7.0-common - documentation, examples and common module for PHP
#php7.0-curl - CURL module for PHP
#php7.0-dba - DBA module for PHP
#php7.0-dbg - Debug symbols for PHP7.0
#php7.0-dev - Files for PHP7.0 module development
#php7.0-enchant - Enchant module for PHP
#php7.0-fpm - server-side, HTML-embedded scripting language (FPM-CGI binary)
#php7.0-gd - GD module for PHP
#php7.0-geoip - GeoIP module for PHP
#php7.0-gmp - GMP module for PHP
#php7.0-igbinary - igbinary serializer for PHP
#php7.0-imagick - Provides a wrapper to the ImageMagick library
#php7.0-imap - IMAP module for PHP
#php7.0-interbase - Interbase module for PHP
#php7.0-intl - Internationalisation module for PHP
#php7.0-json - JSON module for PHP
#php7.0-ldap - LDAP module for PHP
#php7.0-mbstring - MBSTRING module for PHP
#php7.0-mcrypt - libmcrypt module for PHP
#php7.0-memcached - memcached extension module for PHP, uses libmemcached
#php7.0-mongodb - MongoDB driver for PHP
#php7.0-msgpack - MessagePack serializer for PHP
#php7.0-mysql - MySQL module for PHP
#php7.0-odbc - ODBC module for PHP
#php7.0-opcache - Zend OpCache module for PHP
#php7.0-pgsql - PostgreSQL module for PHP
#php7.0-phpdbg - server-side, HTML-embedded scripting language (PHPDBG binary)
#php7.0-pspell - pspell module for PHP
#php7.0-readline - readline module for PHP
#php7.0-recode - recode module for PHP
#php7.0-redis - PHP extension for interfacing with Redis
#php7.0-snmp - SNMP module for PHP
#php7.0-soap - SOAP module for PHP
#php7.0-sqlite3 - SQLite3 module for PHP
#php7.0-ssh2 - Bindings for the libssh2 library
#php7.0-sybase - Sybase module for PHP
#php7.0-tidy - tidy module for PHP
#php7.0-xdebug - Xdebug Module for PHP
#php7.0-xml - DOM, SimpleXML, WDDX, XML, and XSL module for PHP
#php7.0-xmlrpc - XMLRPC-EPI module for PHP
#php7.0-xsl - XSL module for PHP (dummy)
#php7.0-zip - Zip module for PHP