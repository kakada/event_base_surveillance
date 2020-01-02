# frozen_string_literal: true

class DownloadsController < ApplicationController
  def show
    send_file "#{Rails.root}/public/#{params[:file]}", disposition: 'attachment'
  end
end
