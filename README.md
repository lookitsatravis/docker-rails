# Rails

Docker image to run Rails (using Ruby 2.3.0). Use this a base image for Rails applications.

Installs some common DB dependencies as well as Node for gems that need a JS runtime.
It also allows for a mounted data volume for gems.

## Usage

In order to use this effectively for development, you'll want to mount a data container
for your gems. This is done so that you don't have to reinstall your gems every time you
build this image.

The default gem path is `/ruby_gems/2.3`.

`docker create -v /ruby_gems/2.3 --name gems-2.3 busybox`

The build:

`docker build -t docker-rails .`

And then when you run this container:

`docker run -it --volumes-from gems-2.3 -p "3000:3000" docker-rails`

## Database

No database is included in this image. The idea is that you will run a separate DB container
and link it to this one. Ideally, you'd use `docker-compose` for this task.

## `/script/start`

There is an assumption that you will want to slightly modify how this container
behaves at runtime. So, the default command will execute a shell script which you
will either need to copy from this repo, or create.

This file is responsible for installing gems, setting up the DB, and staring the server.

Here are the default contents for this file:

```sh
#!/usr/bin/env bash

echo "Bundling gems"
bundle install --jobs 4 --retry 3

echo "Generating Spring binstubs"
bundle exec spring binstub --all

echo "Clearing logs"
bin/rake log:clear

echo "Setting up new db if one doesn't exist"
bin/rake db:version || { bundle exec rake db:setup; }

echo "Removing contents of tmp dirs"
bin/rake tmp:clear

echo "Stopping existing app server"
rm /var/www/tmp/pids/server.pid

echo "Starting app server"
bundle exec rails s -p 3000 -b 0.0.0.0
```

### Use this image from Docker Hub

In your Dockerfile reference the prebuilt image as the base

		FROM lookitsatravis/docker-rails:latest

### To build the image

		$ git clone https://github.com/lookitsatravis/docker-rails.git
		$ cd docker-rails
		$ docker build -t docker-rails:5.5.0 .

## License

MIT
