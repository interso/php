FROM php:8.3-fpm

# Установка переменных окружения
ENV TZ=Europe/Moscow

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    libzip-dev \
    libicu-dev \
    libsodium-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install \
    gd \
    intl \
    pdo_pgsql \
    sodium \
    zip

# Установка Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Установка Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Установка часового пояса
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /var/www/html

EXPOSE 9000
