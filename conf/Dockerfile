# The base docker image is based on the official PHP/Apache image. The exact PHP version can be specified as needed.
FROM php:8.0-apache

# Sets the document root to be out custom /app/www directory where the OJS code will be
ENV APACHE_DOCUMENT_ROOT /app/www

# Sets the default working directory for the image. Any relative paths can be assumed to start from here.
WORKDIR /app/www

# Updates the new document root in the applicable config files
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copies over node/npm prerequisites into the image
# Like the PHP image above, the node version can be specified below.
COPY --from=node:18 /usr/local/bin /usr/local/bin
COPY --from=node:18 /usr/local/lib/node_modules /usr/local/lib/node_modules

# Installs required libs for PHP extensions
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install --fix-missing libcurl4 \
    curl \
    git \
    libcurl4-openssl-dev \
    libzip-dev \
    libicu-dev

# Copies composer into our image for PHP library depencey management
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extension needed by OJS
RUN docker-php-ext-install pdo pdo_mysql mysqli zip gettext calendar exif intl

# Install xdebug for application debugging.
# The xdebug config is referenced in the volume section of the docker-compose file.
RUN pecl install xdebug && docker-php-ext-enable xdebug
