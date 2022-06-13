# frozen_string_literal: true

namespace :user do
  desc "migrate user province_code"
  task migrate_province: :environment do
    User.where(role: ["staff", "guest"]).each do |user|
      user.update_attributes(province_code: "all")
    end
  end

  desc "migrate user full name"
  task migrate_full_name: :environment do
    User.all.each do |user|
      user.set_full_name
      user.save
    end
  end

  desc "migrate program_admin province_code"
  task migrate_province_code: :environment do
    User.where(role: :program_admin).update_all(province_code: "all")
  end
end
