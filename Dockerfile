FROM lookitsatravis/docker-ruby:2.3.1
MAINTAINER Travis Vignon <travis@lookitsatravis.com>

ENV APP_HOME /var/www
ENV GEM_HOME /ruby_gems/2.3.1
ENV BUNDLE_PATH /ruby_gems/2.3.1
ENV PATH /ruby_gems/2.3.1/bin:$PATH
ENV PORT 3000

RUN apt-get -qq update;\
    apt-get -qqy install \
        mysql-client \
        postgresql-client \
        sqlite3 \
        libpq-dev; \
    apt-get clean -y; \
    apt-get autoremove -y

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ONBUILD ADD . $APP_HOME
ONBUILD ADD /script/start /script/start

EXPOSE $PORT

CMD ./script/start
