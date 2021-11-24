FROM ruby:2.2.7-alpine

ENV DEBIAN_FRONTEND=noninteractive
ENV BUNDLER_VERSION=1.17.3

RUN echo "America/Sao_Paulo" >  /etc/timezone
ENV TZ America/Sao_Paulo
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

RUN apk add --update --no-cache \
  binutils-gold \
  build-base \
  curl \
  file \
  g++ \
  gcc \
  git \
  less \
  libstdc++ \
  libffi-dev \
  libc-dev \
  linux-headers \
  libxml2-dev \
  libxslt-dev \
  libgcrypt-dev \
  make \
  netcat-openbsd \
  nodejs \
  openssl \
  pkgconfig \
  python \
  tzdata \
  bash

RUN gem install bundler -v $BUNDLER_VERSION

RUN mkdir /app
# COPY Gemfile Gemfile.lock ./
# RUN bundle config build.nokogiri --use-system-libraries
# RUN bundle check || bundle install;
# COPY . /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

WORKDIR /app

EXPOSE 3000

# Start the main process.
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD ["tail", "-f", "/dev/null"]