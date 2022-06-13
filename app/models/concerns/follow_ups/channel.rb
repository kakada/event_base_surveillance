# frozen_string_literal: true

module FollowUps
  module Channel
    extend ActiveSupport::Concern

    included do
      CHANNELS = %w(email telegram)

      validate :correct_channels

      private
        def correct_channels
          channels.reject!(&:blank?)

          errors.add(:channels, "Channels can't be blank") if channels.blank?
          errors.add(:channels, "Channels is invalid") if channels.detect { |s| !(CHANNELS.include? s) }
        end
    end
  end
end
