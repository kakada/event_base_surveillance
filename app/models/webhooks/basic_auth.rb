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
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Webhooks
  class BasicAuth < ::Webhook
    def notify(params = {})
      RestClient::Request.execute method: :post, payload: params, url: url, timeout: 30, user: username, password: password
    end
  end
end
