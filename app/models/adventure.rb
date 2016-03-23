# Represents the adventures a user may play.
class Adventure < ActiveRecord::Base
  # Associations
  belongs_to  :owner,   class_name: 'User',   inverse_of: :adventures
  belongs_to  :player,  class_name: 'User',   inverse_of: :played_adventures
  belongs_to  :master,  class_name: 'User',   inverse_of: :mastered_adventures
  has_many    :events,  dependent: :destroy,  inverse_of: :adventure
  has_one     :current_event,
              class_name: 'Event',
              foreign_key: :current_event_id


  # Constants

  # The possible roles in an Adventure.
  ROLES = [:player, :master].freeze


  # Validations
  validates :name, presence: true, uniqueness: true
  validates :owner, presence: true
  validate  :user_has_only_one_role


  # Scopes

  # Actual Behavior
  #-----------------------------------------------------------------------------

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
    ROLES.select { |role| send(role).blank? }
  end


  # Checks if this Adventure still has a free seat for the desired role.
  #
  # @param [String, Symbol] role to check.
  # @return [true, false] whether the role is still free.
  def seat_available?(role)
    send(role).blank?
  end


  # @return [Symbol, nil] the role of given user or nil if user is not assigned
  #   as player to this Adventure.
  def role_of_user(user)
    ROLES.each do |role|
      return role if send(role) == user
    end

    nil
  end


  # Returns the last n events of the Adventure. If no amount is specified, it
  # will return any event the user has already visited.
  #
  # @param [Fixnum] n events to present.
  # @return [Array<Event>] n last events of the Adventure.
  def last_events(n = 0)
    visited_events = visited
    m = n > visited_events.count ? visited_events.count : n
    visited[-m..-1].to_a
  end


  # @return [true, false] whether a next event exists and is ready.
  def next_event?
    current_event.next_event.present? && current_event.next_event.ready?
  end


  # Replaces the current event by its successor, if any exists, and returns it.
  #
  # @return [Event, nil] next event of the Adventure.
  def next_event
    return current_event unless next_event?

    current_event.update!(visited: true)
    update!(current_event: current_event.next_event)
    current_event
  end


  # Events that have not been connected to a following one.
  #
  # @return [Array<Event>] Events not visited and not linked to a follower.
  def unfollowed_events
    events.where(visited: false).select do |event|
      !(event.next_event? || event.choices?)
    end
  end


  # Starts the Adventure by setting the new current event. Returns nil, if
  # no event is ready
  #
  # @return [Event, nil] first event of the Adventure.
  def start
    return current_event if started?

    first_event = ready_events.first
    update!(current_event: first_event, started: true) if first_event

    current_event
  end


  # Decides how to ready to the current event and replaces it by the outcome
  # of the taken choice. Expects the outcome therefore to be ready, otherwise,
  # it will do nothing.
  #
  # @param [Choice] choice to take.
  # @return [Event, nil] the outcome of the choice, if ready.
  def choose(choice)
    return nil unless started? && decision_ready?(choice)

    update!(current_event: choice.outcome)
    current_event
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
      ROLES.each { |role| errors.add(role, msg) }
      return false
    end
    true
  end


  def visited
    events.where(visited: true)
  end


  def ready_events
    events.where(ready: true)
  end


  def decision_ready?(choice)
    current_event.choices.include?(choice) &&
    choice.outcome.ready?
  end


end
