#!/bin/sh
docker-compose build
docker-compose run --rm web bundle install
docker-compose run --rm web bundle exec rake db:setup
docker-compose run --rm web bundle exec rake db:test:prepare
