ARG PHP_VERSION=8.3

# PHP image
FROM php:${PHP_VERSION}-cli-alpine

USER root

# Install dependencies
RUN apk add --no-cache \
    sudo \
    curl \
    gnupg \
    bash \
    libzip-dev \
    icu-dev \
    icu-data-full \
    libxml2-dev \
    libxslt-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    freetype-dev \
    oniguruma-dev \
    linux-headers

# Composer installation
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && chmod 0755 /usr/bin/composer

# Install PHP extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-configure calendar && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure soap && \
    docker-php-ext-configure xsl && \
    docker-php-ext-configure exif && \
    docker-php-ext-configure dom && \
    docker-php-ext-configure mbstring && \
    docker-php-ext-configure xml && \
    docker-php-ext-configure xmlwriter && \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-install -j "$(nproc)" \
    calendar \
    gd \
    bcmath \
    intl \
    mysqli \
    opcache \
    soap \
    zip \
    xsl \
    exif \
    dom \
    mbstring \
    xml \
    xmlwriter \
    pcntl

# Install MSSQL driver
COPY install_mssql_driver.sh /install_mssql_driver.sh
RUN chmod +x /install_mssql_driver.sh
RUN /install_mssql_driver.sh

COPY php.ini /usr/local/etc/php/
