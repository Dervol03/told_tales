# These are the choices the player can make to react to the a presented event.
class Choice < ActiveRecord::Base
  # Assiciations
  belongs_to  :event, inverse_of: :choices
  has_one     :outcome,
              class_name: 'Event',
              inverse_of: :choice,
              foreign_key: :outcome_id,
              dependent: :destroy


  # Validations
  validates :event, presence: true
  validates :outcome, presence: true
  validates :decision, presence: true
  validates :outcome, nested_valid: true

end
