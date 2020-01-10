FROM ruby:2.6.3

LABEL maintainer="Kakada Chheang <kakada@instedd.org>"

# Updating nodejs version
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash

# Install dependencies
RUN apt-get update && \
  apt-get install -y nodejs postgresql-client && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /app
WORKDIR /app

# Install gem bundle
COPY Gemfile* /app/

RUN gem install bundler:2.0.2 && \
  bundle install --jobs 20 --deployment --without development test

# Install the application
COPY . /app

# Generate version file if available
RUN if [ -d .git ]; then git describe --always > VERSION; fi

# Precompile assets
RUN bash assets_precompile.sh

ENV RAILS_LOG_TO_STDOUT=true
ENV RACK_ENV=production
ENV RAILS_ENV=production
EXPOSE 80

# Add scripts
COPY docker/database.yml /app/config/database.yml

CMD ["puma", "-e", "production", "-b", "tcp://0.0.0.0:80"]
