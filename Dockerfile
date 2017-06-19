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
    sendmail \
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
