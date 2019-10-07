FROM ruby:2.6

LABEL maintainer="Kakada Chheang <kakada@instedd.org>"

# Updating nodejs version
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash

# Install dependencies
RUN apt-get update && \
  apt-get install -y nodejs postgresql-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

# Install gem bundle
COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN bundle install --jobs 3 --deployment --without development test

# Install the application
COPY . /app

# Generate version file if available
RUN if [ -d .git ]; then git describe --always > VERSION; fi

# Precompile assets
RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=secret

ENV RAILS_LOG_TO_STDOUT=true
ENV RACK_ENV=production
ENV RAILS_ENV=production
EXPOSE 80

# Add scripts
COPY docker/database.yml /app/config/database.yml

CMD ["puma", "-e", "production", "-b", "tcp://0.0.0.0:80"]
