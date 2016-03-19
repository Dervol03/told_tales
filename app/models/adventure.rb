# Represents the adventures a user may play.
class Adventure < ActiveRecord::Base
  belongs_to  :owner,   class_name: 'User', inverse_of: :adventures
  belongs_to  :player,  class_name: 'User', inverse_of: :played_adventures
  belongs_to  :master,  class_name: 'User', inverse_of: :mastered_adventures

  validates :name, presence: true, uniqueness: true
  validates :owner, presence: true
  validate  :user_has_only_one_role

  # Scope for pending adventures and those belonging to the specified user.
  # @param [User] user whose adventures to search.
  # @return [ActiveRecord::Relation] of adventures accessible by the user.
  def self.pending(user)
    adv = arel_table
    where(adv[:started].eq(false)
            .or(adv[:owner_id].eq(user.id)))
  end


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


  # Returns the roles/seats which have not been assigned to a user yet.
  #
  # @return [Array<Symbol>] free roles.
  def vacant_seats
    [:player, :master].select { |role| send(role).blank? }
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


  def user_has_only_one_role
    if player && player == master
      msg = 'only one role is allowed'
      errors.add(:player, msg)
      errors.add(:master, msg)
      return false
    end
    true
  end
end
