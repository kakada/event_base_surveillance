# frozen_string_literal: true

class DownloadsController < ApplicationController
  def show
    send_file params[:file], disposition: 'attachment'
  end
end
