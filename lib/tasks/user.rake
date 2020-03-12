# frozen_string_literal: true

namespace :user do
  desc 'migrate user province_code'
  task migrate_province: :environment do
    User.where(role: ['staff', 'guest']).each do |user|
      user.update_attributes(province_code: 'all')
    end
  end
end
