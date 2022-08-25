# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  prepend_after_action :set_sign_in_type, only: [:create]

  private
    def set_sign_in_type
      resource.update_column(:sign_in_type, User::SYSTEM)
    end
end
