FROM ruby:2.6.3-alpine

RUN apk update && \
  apk upgrade && \
  apk add --no-cache tzdata

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base bash" \
  DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev" \
  DB_PACKAGES="postgresql-dev postgresql-client" \
  RUBY_PACKAGES="ruby-json yaml nodejs" \
  TZ="America/Sao_Paulo"

RUN apk add --update \
  $BUILD_PACKAGES \
  $DEV_PACKAGES \
  $DB_PACKAGES \
  $RUBY_PACKAGES && \
  rm -rf /var/cache/apk/* && \
  mkdir -p /usr/src/app && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN addgroup -S admin -g 1000 && adduser -S -g '' -u 1000 -G admin deploy

ENV RAILS_ROOT /home/deploy/app
ENV RAILS_LOG_TO_STDOUT 1
ENV RAILS_ENV production

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock .

USER deploy

ENTRYPOINT ["./entrypoint.sh"]

RUN gem install bundler
RUN bundle install

COPY . ./

EXPOSE 3000