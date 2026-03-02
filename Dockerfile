FROM ruby:3.3-alpine

ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

RUN apk update && apk upgrade && \
    apk --no-cache add tzdata build-base && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV APP_HOME=/opt/app
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install && bundle clean --force && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

COPY . $APP_HOME

EXPOSE 10000

CMD ["bundle", "exec", "ruby", "main.rb"]
