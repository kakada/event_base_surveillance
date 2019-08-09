# frozen_string_literal: true

namespace :db do
  desc 'prepare to run the test'
  task prepare_for_test: :environment do
    sh 'bin/rails db:environment:set RAILS_ENV=test'
    sh 'bin/rails db:drop RAILS_ENV=test'
    sh 'bin/rails db:create RAILS_ENV=test'
    sh 'bin/rails db:schema:load RAILS_ENV=test'
  end
end
