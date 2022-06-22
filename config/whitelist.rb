# frozen_string_literal: true

class Whitelist
  def self.matches?(request)
    return true if Rails.env.development?

    ip_exist?(request.remote_ip)
  end

  class << self
    private
      def allowed_hosts
        ENV["ALLOWED_HOSTS"].to_s.split(",")
          .map { |ip| IPAddress.parse(ip.strip) }
      end

      def ip_exist?(remote_ip)
        allowed_hosts.each do |host|
          return true if host.include? IPAddress.parse(remote_ip)
        end

        false
      end
  end
end
