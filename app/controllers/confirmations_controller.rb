# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  # skip_before_action :require_no_authentication
  skip_before_action :authenticate_user!

  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      if @confirmable.no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid? && @confirmable.password_match?
          do_confirm
        else
          do_show
          @confirmable.errors.clear # so that we wont render :new
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    return if @confirmable.errors.empty?

    self.resource = @confirmable
    render "devise/confirmations/new"
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.no_password?
        do_show
      else
        do_confirm
      end
    end

    return if @confirmable.errors.empty?

    self.resource = @confirmable
    render "devise/confirmations/new"
  end

  protected
    def with_unconfirmed_confirmable
      @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
      @confirmable.only_if_unconfirmed { yield } unless @confirmable.new_record?
    end

    def do_show
      @confirmation_token = params[:confirmation_token]
      @requires_password = true
      self.resource = @confirmable
      render "devise/confirmations/show"
    end

    def do_confirm
      @confirmable.confirm
      set_flash_message :notice, :confirmed
      sign_in_and_redirect(resource_name, @confirmable)
    end
end
