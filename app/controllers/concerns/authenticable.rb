# Holds important, but common methods related to user authentication.
module Authenticable
  extend ActiveSupport::Concern

  # Allows rendering 401 error template even in development
  ERROR_401_TEMPLATE = 'shared/errors/401'.freeze

  module ClassMethods
    # @return [true, false] whether a User exists, when called.
    def any_user_exists
      -> { User.any? }
    end
  end


  included do
    extend ClassMethods
  end


  # Redirects to forbidden page if current user is no admin.
  def verify_admin
    render_401 unless current_user.is_admin?
  end


  # Redirects to forbidden page if the current user tries to perform operations
  # on other users.
  def verify_on_current_user
    render_401 unless params[:id].to_i == current_user.id
  end


  # For controller instances.
  # @return [true, false] whether a User exists.
  def any_user_exists?
    User.any?
  end


  # @return [true, false] whether current user is an admin.
  def admin?
    current_user.is_admin?
  end


  private

  def render_401
    render ERROR_401_TEMPLATE, status: :unauthorized
  end
end
