# Используем официальный Ruby образ с BuildKit
# syntax=docker/dockerfile:1.4
FROM ruby:3.3.0-slim

# Включаем BuildKit secrets для приватных гемов (опционально)
# Это позволяет использовать `--secret` при сборке
RUN --mount=type=cache,target=/usr/local/bundle \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libyaml-dev \
    libpq-dev \
    nodejs \
    tzdata \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Рабочая директория
WORKDIR /app

# Копируем Gemfile и Gemfile.lock для установки гемов
COPY Gemfile Gemfile.lock ./

# Установка гемов с кэшированием
RUN --mount=type=cache,target=/usr/local/bundle \
    gem install bundler && \
    bundle config set path 'vendor/bundle' && \
    bundle install --jobs $(nproc) --retry 3

# Копируем остальные файлы проекта
COPY . .

# Исправляем shebang в бинстабсах (если нужно)
RUN sed -i '1s/.*/#!\/usr\/bin\/env ruby/' bin/rails bin/rake || true

# Обновляем PATH
ENV GEM_HOME="/app/vendor/bundle"
ENV PATH="$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH"

# Проверяем, что boot.rb существует
RUN if [ ! -f config/boot.rb ]; then \
      echo "config/boot.rb отсутствует, создаю..." && \
      echo "ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __dir__)" > config/boot.rb && \
      echo "require 'bundler/setup'" >> config/boot.rb && \
      echo "require 'bootsnap/setup' if defined?(Bootsnap)" >> config/boot.rb; \
    fi

# Экспортируем порт
EXPOSE 3000

# Команда по умолчанию — запуск Rails через Bundler
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]