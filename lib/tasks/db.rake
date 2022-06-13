# frozen_string_literal: true

namespace :db do
  desc "prepare to run the test"
  task prepare_for_test: :environment do
    sh "bin/rails db:environment:set RAILS_ENV=test"
    sh "bin/rails db:drop RAILS_ENV=test"
    sh "bin/rails db:create RAILS_ENV=test"
    sh "bin/rails db:schema:load RAILS_ENV=test"
  end

  desc "prepare to run the development"
  task dev: :environment do
    sh "bin/rails db:environment:set RAILS_ENV=development"
    sh "bin/rails db:drop RAILS_ENV=development"
    sh "bin/rails db:create RAILS_ENV=development"
    sh "bin/rails db:migrate RAILS_ENV=development"
    sh "bin/rails sample:load RAILS_ENV=development"
  end
end
