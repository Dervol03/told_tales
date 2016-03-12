class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :register_first_user, unless: -> { User.any? }
  before_action :authenticate_user!, if: -> { User.any? }


  private

  def register_first_user
    redirect_to new_user_path
  end


end
