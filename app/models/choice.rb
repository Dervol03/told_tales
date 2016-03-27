# These are the choices the player can make to react to the a presented event.
class Choice < ActiveRecord::Base
  # Assiciations
  belongs_to  :event, inverse_of: :choices
  belongs_to  :customized_event,
              class_name: 'Event',
              foreign_key: :customized_choice_id,
              inverse_of: :customized_choice

  has_one     :outcome,
              class_name: 'Event',
              inverse_of: :choice,
              foreign_key: :outcome_id,
              dependent: :destroy


  # Validations
  validates :event, presence: true
  validates :outcome,
            presence: true, unless: :customized?,
            nested_valid: true
  validates :decision, presence: true

end
