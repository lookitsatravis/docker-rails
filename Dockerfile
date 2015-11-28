FROM lookitsatravis/ruby:2.2.3
MAINTAINER Travis Vignon <travis@lookitsatravis.com>

ENV PORT 5000

RUN curl -sL https://deb.nodesource.com/setup | sudo bash - && \
apt-get -qqy install nodejs -y; \
apt-get clean -y; \
apt-get autoremove -y

RUN apt-get -qq update;\
apt-get -qqy install libpq-dev; \
apt-get clean -y; \
apt-get autoremove -y

RUN adduser web --shell /bin/bash --disabled-password --gecos ""

RUN mkdir -p /var/bundle && chown -R web:web /var/bundle
RUN mkdir -p /var/www && chown -R web:web /var/www

ADD Gemfile /var/www/
ADD Gemfile.lock /var/www/

WORKDIR /var/www

EXPOSE $PORT

RUN su web -c "bundle config --global path /var/bundle"
RUN su web -c "bundle install"

ADD . /var/www

RUN chown -R web:web /var/www

USER web

CMD bundle exec foreman start
