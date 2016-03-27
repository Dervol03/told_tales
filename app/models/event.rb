# These are the events through which the player will run during an adventure.
class Event < ActiveRecord::Base
  # Associations
  belongs_to  :adventure
  belongs_to  :choice, inverse_of: :outcome, foreign_key: :outcome_id
  belongs_to  :previous_event,
              class_name: 'Event',
              inverse_of: :next_event

  has_one     :next_event,
              class_name: 'Event',
              inverse_of: :previous_event,
              foreign_key: :previous_event_id

  has_one     :customized_choice,
              class_name: 'Choice',
              inverse_of: :customized_event,
              dependent: :destroy,
              foreign_key: :customized_choice_id

  has_many    :choices, inverse_of: :event, dependent: :destroy



  # Validations
  validates :adventure, presence: true

  validates :title,
            presence:   true,
            uniqueness: true

  validates :description, presence: true
  validate  :only_one_kind_of_outcome

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


  # @return [true, false] has a customized choice?
  def customized_choice?
    customized_choice.present?
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


  def only_one_kind_of_outcome
    if [next_event, choices.first, customized_choice].compact.count > 1
      errors.add(:base, :next_event_or_choice_error)
    end
  end


end
