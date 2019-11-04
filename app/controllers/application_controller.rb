# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend

  protect_from_forgery prepend: true
  before_action :authenticate_user!
  before_action :set_locale
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout :set_layout

  def current_program
    @current_program ||= current_user.try(:program)
  end
  helper_method :current_program

  protected

  def set_layout
    devise_controller? ? 'layouts/minimal' : 'layouts/application'
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  def set_locale
    I18n.locale = current_program.try(:language_code) || I18n.default_locale
  end
end
