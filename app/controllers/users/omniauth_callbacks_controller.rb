# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.present? && @user.persisted?
      @user.update_column(:sign_in_type, User::GOOGLE)
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"

      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to new_user_session_path, alert: I18n.t("devise.no_account")
    end
  end
end
