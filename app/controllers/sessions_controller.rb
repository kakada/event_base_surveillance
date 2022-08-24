# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  include UsersHelper
  prepend_before_action :verify_captcha, only: [:create] # Change this to be any actions you want to protect.
  prepend_after_action :set_sign_in_type, only: [:create]

  private
    def set_sign_in_type
      resource.update_column(:sign_in_type, User::SYSTEM)
    end

    def verify_captcha
      return if disable_recaptcha? || verify_recaptcha # verify_recaptcha(action: 'login') for v3

      self.resource = resource_class.new sign_in_params

      respond_with_navigational(resource) do
        flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
        render :new
      end
    end
end
