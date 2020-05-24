FROM ruby:2.6.3-alpine
LABEL maintainer="Kariuki Gathitu <kgathi2@gmail.com>"
LABEL version="1.0"

ENV BUILD_PACKAGES="curl-dev ruby-dev build-base bash" \
  DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev" \
  DB_PACKAGES="postgresql-dev postgresql-client" \
  RUBY_PACKAGES="ruby-json yaml nodejs"

RUN apk update && \
  apk upgrade && \
  apk add --update\
  $BUILD_PACKAGES \
  $DEV_PACKAGES \
  $DB_PACKAGES \
  $RUBY_PACKAGES && \
  rm -rf /var/cache/apk/* && \
  mkdir -p /usr/src/app

RUN addgroup -S admin -g 1000 && adduser -S -g '' -u 1000 -G admin deploy

ENV RAILS_ROOT /home/deploy/app
ENV RAILS_LOG_TO_STDOUT 1
ENV RAILS_ENV production

USER deploy

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["entrypoint.sh"]

COPY --chown=deploy:admin Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

COPY --chown=deploy:admin . ./

EXPOSE 3000

CMD ["bundle exec puma"]
