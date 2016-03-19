# Helpers for the User model
module UserHelper
  # @return [true, false] whether current user is an admin.
  def admin?
    current_user.is_admin?
  end


  # @return [true, false] whether at least one user exists.
  def any_user_exists?
    User.any?
  end

end
