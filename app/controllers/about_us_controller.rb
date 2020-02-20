# frozen_string_literal: true

class AboutUsController < ApplicationController
  skip_before_action :authenticate_user!
  layout :set_layout

  def index
  end

  private
    def set_layout
      signed_in? ? 'layouts/application' : 'layouts/footer-less'
    end
end
