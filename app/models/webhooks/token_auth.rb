# frozen_string_literal: true

# == Schema Information
#
# Table name: webhooks
#
#  id         :bigint           not null, primary key
#  name       :string
#  token      :string
#  username   :string
#  password   :string
#  url        :string
#  type       :string
#  program_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Webhooks
  class TokenAuth < ::Webhook
    def notify(params = {})
      RestClient::Request.execute method: :post, payload: params, url: url, headers: { Authorization: "Token token=#{token}" }
    end
  end
end
