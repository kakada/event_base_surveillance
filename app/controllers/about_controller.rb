# frozen_string_literal: true

class AboutController < ApplicationController
  skip_before_action :authenticate_user!
  layout :set_layout

  def index
  end

  private
    def set_layout
      signed_in? ? 'layouts/application' : 'layouts/minimal'
    end
end
