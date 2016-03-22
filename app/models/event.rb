# These are the events through which the player will run during an adventure.
class Event < ActiveRecord::Base
  # Associations
  belongs_to  :adventure
  belongs_to  :choice, inverse_of: :outcome
  belongs_to  :previous_event,
              class_name: 'Event',
              inverse_of: :next_event

  has_one     :next_event,
              class_name: 'Event',
              inverse_of: :previous_event,
              foreign_key: :previous_event_id

  has_many    :choices, inverse_of: :event, dependent: :destroy


  # Validations
  validates :adventure, presence: true

  validates :title,
            presence:   true,
            uniqueness: true

  validates :description, presence: true
  validate  :either_next_event_or_choices

  before_create :assert_visited_false
  before_destroy :validate_visited_false


  # Scopes
  scope :unpreceded, -> { where(previous_event_id: nil, ready: false) }


  # Actual behavior

  # @return [true, false] has choices assigned?
  def choices?
    choices.present?
  end


  # @return [true, false] has a next event?
  def next_event?
    next_event.present?
  end


  private

  def assert_visited_false
    self.visited = false

    # Makes sure creation continues despite 'false' assignment
    true
  end


  def validate_visited_false
    if visited || current_event_id
      errors.add(:base, 'You cannot destroy visited or current events!')
      false
    else
      true
    end
  end


  def either_next_event_or_choices
    errors.add(:base, :next_event_or_choice_error) if choices? && next_event?
  end


end
