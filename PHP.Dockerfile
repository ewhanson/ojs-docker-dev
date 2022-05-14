FROM php:8.0-fpm

# MySQL-related extensions
RUN docker-php-ext-install pdo pdo_mysql

# Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

