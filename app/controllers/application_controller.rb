# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend

  protect_from_forgery prepend: true
  before_action :authenticate_user!
  before_action :set_locale
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  before_action :set_raven_context

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
      I18n.locale = current_user.try(:locale) || I18n.default_locale
    end

    def set_raven_context
      Raven.user_context(id: session[:current_user_id]) # or anything else in session
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
end
