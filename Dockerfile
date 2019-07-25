FROM ruby:2.4.0-alpine
ENV LANG ja_JP.UTF-8

RUN apk update && apk upgrade && apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    rm -rf /var/cache/apk/*
ENV TZ Asia/Tokyo
ENV APP_HOME /opt/app

RUN gem install bundler && mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/

ENV BUNDLE_DISABLE_SHARED_GEMS 1
RUN bundle install && bundle clean

ADD . $APP_HOME
EXPOSE 80
CMD bundle exec ruby main.rb -o $HOSTNAME -p $PORT
