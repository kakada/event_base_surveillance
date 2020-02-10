# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap',       '>= 1.1.0', require: false
gem 'devise',         '~> 4.7.1'

gem 'sidekiq',        '~> 5.2.7'
gem 'sidekiq-scheduler'
gem 'sidekiq-unique-jobs'
gem 'sinatra', require: nil

gem 'haml-rails',     '~> 2.0'
gem 'jquery-rails',   '~> 4.3.5'
gem 'bootstrap',      '~> 4.3.1'

# Datetime Picker
gem 'font-awesome-rails', '~> 4.7.0.5'
gem 'bootstrap4-datetime-picker-rails', '~> 0.3.1'

gem 'simple_form',    '~> 5.0.0'
gem 'carrierwave',    '>= 2.0.0.rc', '< 3.0'
gem 'pundit',         '~> 2.0.1'
gem 'audited',        '~> 4.9'
gem 'pagy',           '~> 3.4.1'
gem 'jquery-minicolors-rails',    '~> 2.2.6.1'
gem 'strip_attributes',           '~> 1.9.0'
gem 'active_model_serializers',   '~> 0.10.10'
gem 'rack-cors',                  '~> 1.0.5'
gem 'pumi', github: 'dwilkie/pumi', require: 'pumi/rails'

gem 'elasticsearch-model',        '~> 7.0.0'
gem 'elasticsearch-rails',        '~> 7.0.0'
gem 'telegram-bot',   '~> 0.14.3'

gem 'rest-client',                '~> 2.1.0'

gem 'wicked_pdf',                 '~> 1.4.0'
gem 'wkhtmltopdf-binary',         '~> 0.12.5.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8.2'
  gem 'factory_bot_rails', '~> 5.0'
  gem 'ffaker', '~> 2.9.0'
  gem 'guard-rspec', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'rubocop-rails'
  gem 'rubocop-performance'
  gem 'solargraph'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'webdrivers', '~> 4.0'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'

  gem 'shoulda-matchers',       '~> 4.1.1'
  gem 'database_cleaner',       '~> 1.7.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
