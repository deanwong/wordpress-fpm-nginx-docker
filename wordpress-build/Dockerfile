FROM php:fpm-alpine

# install the PHP extensions we need
# ENV http_proxy <HTTP_PROXY>
# ENV https_proxy <HTTPS_PROXY>
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories && \
    echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/community" >> /etc/apk/repositories && \
    echo "https://mirror.tuna.tsinghua.edu.cn/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
		apk add --no-cache bash curl libpng-dev libjpeg-turbo-dev && \
 	  docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install gd mysqli opcache && \
    rm -rf /var/cache/apk/*


# install composer
#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
#    php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
#    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
#    php -r "unlink('composer-setup.php');"

# install wordpress cli
# https://github.com/KaiHofstetter/docker-wordpress-cli/blob/master/Dockerfile
# COPY wp.sh /usr/local/bin/wp
# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#   chmod +x wp-cli.phar && chmod +x /usr/local/bin/wp && \
#   mv wp-cli.phar /usr/local/bin/wp-cli.phar

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# taken from mkz71's comment on Wordpress official Docker Hub page
# https://hub.docker.com/_/wordpress/
RUN { \
    echo 'file_uploads = On'; \
    echo 'memory_limit = 256M'; \
    echo 'upload_max_filesize = 256M'; \
    echo 'post_max_size = 300M'; \
    echo 'max_execution_time = 600'; \
  } > /usr/local/etc/php/conf.d/uploads.ini

VOLUME /var/www/html

ENV WORDPRESS_VERSION 4.7

COPY wordpress-${WORDPRESS_VERSION}.tar.gz wordpress.tar.gz

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& chown -R www-data:www-data /usr/src/wordpress

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
