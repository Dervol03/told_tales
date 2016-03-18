# Represents the adventures a user may play.
class Adventure < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'

  validates :name, presence: true, uniqueness: true
  validates_presence_of :owner

  # Destroys this Adventure based on the given user. If the user is an admin,
  # no further checks are done. However, of a normal user is passed, the
  # destruction will only be done if the given user is the owner and this
  # Adventure hasn't been started yet.
  #
  # @param [User] user destroying this Adventure.
  # @return [Adventure, false] depending on destruction success.
  def destroy_as(user)
    check_user_destruction_rights(user)
    errors[:base].blank? ? destroy : false
  end


  # Behaves like {#destroy_as}, but raises ActiveRecord::RecordNotDestroyed
  # destruction fails.
  #
  # @param [User] user destroying this Adventure.
  # @return [Adventure] destroyed Adventure
  # @raise [ActiveRecord::RecordNotDestroyed] if anything goes wrong
  # @see #destroy_as
  def destroy_as!(user)
    check_user_destruction_rights(user)
    errors[:base].blank? ? destroy! : raise_not_destroyed
  end


  private

  def check_user_destruction_rights(user)
    unless user.is_admin?
      errors.add(:base, 'already started') if started?
      errors.add(:base, 'you are not the owner') unless user == owner
    end
  end


  def raise_not_destroyed
    fail(
      ActiveRecord::RecordNotDestroyed.new(
        'Failed to destroy the record', self
      )
    )
  end

end
