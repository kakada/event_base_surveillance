# frozen_string_literal: true

module Users::Confirmable
  extend ActiveSupport::Concern

  included do
    def password_match?
      errors[:password] << I18n.t('errors.messages.blank') if password.blank?
      errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
      errors[:password_confirmation] << I18n.translate('errors.messages.confirmation', attribute: 'password') if password != password_confirmation
      password == password_confirmation && !password.blank?
    end

    # new function to set the password without knowing the current
    # password used in our confirmation controller.
    def attempt_set_password(params)
      p = {}
      p[:password] = params[:password]
      p[:password_confirmation] = params[:password_confirmation]
      update_attributes(p)
    end

    # new function to return whether a password has been set
    def no_password?
      encrypted_password.blank?
    end

    # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
    # Instead you should use `pending_any_confirmation`.
    def only_if_unconfirmed
      pending_any_confirmation { yield }
    end

    protected
      def password_required?
        confirmed? ? super : false
      end
  end
end
