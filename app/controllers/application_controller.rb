class ApplicationController < ActionController::Base
  include Authenticable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :register_first_user, unless: any_user_exists
  before_action :authenticate_user!, if: any_user_exists
  before_action :update_password_if_temporary

  private

  def register_first_user
    redirect_to new_user_path
  end


  def update_password_if_temporary
    return true unless current_user.present?

    if  current_user.temporary_password.present?
      redirect_to password_user_path(current_user.id)
    end
  end
end
