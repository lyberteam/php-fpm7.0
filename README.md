# PHP-FPM

 **image from official debian:jessie**

   [![Build Status](https://travis-ci.org/lyberteam/php-fpm7.0.png?branch=master)](https://travis-ci.org/lyberteam/php-fpm7.0)
   [![Size and Layers](https://images.microbadger.com/badges/image/lyberteam/php-fpm7.0.svg?branch=master)](https://microbadger.com/images/lyberteam/php-fpm7.0)
   [![Version](https://images.microbadger.com/badges/version/lyberteam/php-fpm7.0.svg)](https://microbadger.com/images/lyberteam/php-fpm7.0)
   [![Docker Pulls](https://img.shields.io/docker/pulls/lyberteam/php-fpm7.0.svg)](https://hub.docker.com/r/lyberteam/php-fpm7.0)

  PHP-FPM version - 7.0.20

  DateTime - Europe/Kiev

  Composer installed globally

## Getting Started
This instruction will help you to launch the PHP-FPM + NGINX + DB (Postgres, or Mysql) and run your application
In addition we can suggest to use different useful tools, such as Mailcatcher and so on.

### Prerequisites
 1. First you have to install docker.
    * [Docker for MAC](https://docs.docker.com/docker-for-mac/install/)
    * [Docker for Windows](https://docs.docker.com/docker-for-windows/install/)
    * [Docker for Ubuntu-16.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)

 2. Next step is installing the docker-compose.
    * [Extended instruction](https://docs.docker.com/compose/install/)
 3. Create domain name of your application (of course local name)
    In this manual we will use domain name: \
    `awesome.io`
 4. Choose the root folder for your application on your local machine.
    Let's say path to our root folder wiil be: \
    `/var/www/awesome/`

### Installing
Hope you've already installed docker and docker-compose on your machine.
[docker-compose.yml](https://github.com/lyberteam/php-fpm7.0/tree/master/awesome/docker-compose.yml) file lies into the awesome folder.

You need to put this file into the root directory of your project - `/var/www/awesome/`

Also we need to put our nginx config file with our domain.
Here you can find the simpliest example: [lyberteam.conf](https://github.com/lyberteam/php-fpm7.0/tree/master/awesome/lyberteam.conf)

Copy this file and put it to path /var/www/awesome/nginx/vhost/lyberteam.conf
If you want change the domain name, then replace `server_name lyberteam.com;` -  with your domain (i.e. awesome.io). \
Now we should mount our config to the nginx container. To do this add this line into docker-compose.yml file.

```
## docker-compose.yml
...

nginx:
  container_name: awesome_nginx
  image: lyberteam/nginx-base
  ports:
     - "80:80"
  links:
     - php
  volumes_from:
     - application
  volumes:
     - ./logs/nginx:/var/log/nginx
     - ./nginx/vhost/lyberteam.conf:/etc/nginx/vhost/lyberteam.conf # <- add this line
  working_dir: /etc/nginx

...
```


Then you need just to run the docker-compose command in the terminal:
```
docker-compose up -d
```

After that you will see, how will the images be installed (pulled)

![alt text](https://github.com/lyberteam/php-fpm7.0/raw/master/docs/images/pulling.png "Pulling the containers")

To check out if is everything ok - just run this command:
```
docker-compose ps
```


The last one is to make changes to your `/etc/hosts` file
we need to make our domain (awesome.io) be reachable locally.
Open it with your text editor (vim, nano etc) and add the next line:
```
127.0.0.1    awesome.io
```
Save and close.

No you type awesome.io in your favorite browser and enjoy.

## Docker ags
 * lyberteam/php-fpm7.0:xdebug - with xdebug
 * lyberteam/php-fpm7.0:xtools - with xdebug and code check tools
 * lyberteam/php-fpm7.0:stable

## Extensions:

 * php7.0-pgsql
 * php7.0-mysql
 * php7.0-opcache
 * php7.0-common
 * php7.0-mbstring
 * php7.0-mcrypt
 * php7.0-soap
 * php7.0-cli
 * php7.0-intl
 * php7.0-json
 * php7.0-xsl
 * php7.0-imap
 * php7.0-ldap
 * php7.0-curl
 * php7.0-gd
 * php7.0-zip
 * php7.0-dev
 * php7.0-fpm
 * php7.0-redis
 * php7.0-memcached
 * php7.0-mongodb
 * php7.0-xdebug (`only for lyberteam/php-fpm7.0:xdebug`)
 * php7.0-imagick
 * php7.0-apcu (`new`)

### In addition

 * Composer (installed globally)
 * Cron (added for Magento support)
 * Browscap ([Browscap official page](http://browscap.org/))
 * wkhtmltopdf ([Official website](https://wkhtmltopdf.org/))

### PHP Tools:
(`only for lyberteam/php-fpm7.0:xdebug`)
 * [PHP Unit](https://phpunit.de/)
 * [PHP CodeSniffer](https://www.squizlabs.com/php-codesniffer)
 * [PHPLOC](https://inviqa.com/blog/phploc-php-lines-code)
 * [PHP Depend](https://pdepend.org/)
 * [PHPMD (Mess Detector)](https://phpmd.org/)
 * [PHPCPD (Detecting duplicate code in PHP files)](http://www.codediesel.com/tools/detecting-duplicate-code-in-php-files/)
 * [PHPDox - Be free with docs!](http://phpdox.de/)



