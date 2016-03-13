# Holds important, but common methods related to user authentication.
module Authenticable
  extend ActiveSupport::Concern

  module ClassMethods
    def any_user_exists
      -> { User.any? }
    end
  end

  included do
    extend ClassMethods
  end

  def verify_admin
    unless current_user.is_admin?
      render 'shared/errors/401', status: :unauthorized
    end
  end


  def any_user_exists?
    User.any?
  end
end
