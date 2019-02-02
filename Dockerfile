FROM ubuntu:18.04

ENV TZ=Europe/Budapest LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGEVERSION=7.3.1-1+ubuntu18.04.1+deb.sury.org+1

RUN apt-get update -y \
  && apt-get dist-upgrade -y \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && echo "en_US UTF-8" >/etc/locale.gen \
  && echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen \
  && apt-get install -y --no-install-recommends ca-certificates curl git gnupg locales openssl openssh-client patch rsync ruby-compass wget \
  && locale-gen \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
  && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-ubuntu-php-bionic.list \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y --no-install-recommends \
    nodejs \
    php7.3-bcmath=$PACKAGEVERSION \
    php7.3-bz2=$PACKAGEVERSION \
    php7.3-common=$PACKAGEVERSION \
    php7.3-cli=$PACKAGEVERSION \
    php7.3-curl=$PACKAGEVERSION \
    php7.3-gd=$PACKAGEVERSION \
    php7.3-gmp=$PACKAGEVERSION \
    php7.3-imap=$PACKAGEVERSION \
    php7.3-intl=$PACKAGEVERSION \
    php7.3-mbstring=$PACKAGEVERSION \
    php7.3-mysql=$PACKAGEVERSION \
    php7.3-soap=$PACKAGEVERSION \
    php7.3-xmlrpc=$PACKAGEVERSION \
    php7.3-xsl=$PACKAGEVERSION \
    php7.3-zip=$PACKAGEVERSION \
    php-mongodb \
    php-redis \
    unzip \
  && npm -g i npm \
  && npm install -g grunt-cli gulp-cli eslint sass-lint \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
  && composer global require drupal/coder --update-no-dev --no-suggest --prefer-dist ^8.3 \
  && ln -s /root/.composer/vendor/bin/phpcs /usr/bin/phpcs \
  && ln -s /root/.composer/vendor/bin/phpcbf /usr/bin/phpcbf \
  && cd \
  && git clone --branch master https://git.drupal.org/sandbox/coltrane/1921926.git /root/drupalsecure_code_sniffs \
  && ln -s /root/drupalsecure_code_sniffs/DrupalSecure /root/.composer/vendor/drupal/coder/coder_sniffer/DrupalSecure \
  && rm -rf /root/drupalsecure_code_sniffs/.git \
  && cd /root/drupalsecure_code_sniffs \
  && curl https://www.drupal.org/files/issues/parenthesis_closer_notice-2320623-2.patch | git apply \
  && cd \
  && composer global require dealerdirect/phpcodesniffer-composer-installer \
  && curl -L -o /usr/bin/security-checker http://get.sensiolabs.org/security-checker.phar \
  && curl -L -o /usr/bin/drush https://github.com/drush-ops/drush/releases/download/8.1.18/drush.phar \
  && chmod +x /usr/bin/drush \
  && chmod +x /usr/bin/security-checker \
  && apt-get clean all \
  && rm -rf /var/lib/apt/lists/*
