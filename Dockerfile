FROM lookitsatravis/docker-ruby:2.7.0
LABEL maintainer="Travis Vignon <travis@lookitsatravis.com>"

ENV APP_HOME /var/www
ENV GEM_HOME /ruby_gems/2.7.0
ENV BUNDLE_PATH /ruby_gems/2.7.0
ENV PATH /ruby_gems/2.7.0/bin:$PATH
ENV PORT 3000

# Load latest postgresql-client releases
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > \
       /etc/apt/sources.list.d/pgdg.list && \
       wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
           apt-key add -

RUN apt-get -qq update;\
    apt-get -qqy install \
        mysql-client \
        postgresql-client-9.4 \
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
