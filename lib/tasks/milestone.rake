# frozen_string_literal: true

namespace :milestone do
  desc 'migrate verified milestone'
  task migrate_verified: :environment do
    Milestone.where(name: 'Verification').each do |milestone|
      milestone.update_attributes(verified: true)
    end
  end

  desc 'migrate milestone flag'
  task migrate_flag: :environment do
    statuses = [
      { col: 'is_default', status: 'root' },
      { col: 'verified', status: 'verified' },
      { col: 'final', status: 'final' }
    ]

    statuses.each do |item|
      Milestone.where("#{item[:col]} = ?", true).each do |milestone|
        milestone.update_attributes(status: item[:status].to_sym)
      end
    end
  end
end
