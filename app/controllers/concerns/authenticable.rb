# Holds important, but common methods related to user authentication.
module Authenticable
  extend ActiveSupport::Concern

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
    unless current_user.is_admin?
      render 'shared/errors/401', status: :unauthorized
    end
  end


  # For controller instances.
  # @return [true, false] whether a User exists.
  def any_user_exists?
    User.any?
  end
end
