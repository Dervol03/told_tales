class Choice < ActiveRecord::Base
  belongs_to  :event,   inverse_of: :choices
  has_one     :outcome,
              class_name: 'Event',
              inverse_of: :choice,
              foreign_key: :outcome_id

  validates :event, presence: true
  validates :outcome, presence: true
  validates :decision, presence: true
end
