# These are the events through which the player will run during an adventure.
class Event < ActiveRecord::Base
  belongs_to  :adventure

  has_one     :next_event,
              class_name: 'Event',
              inverse_of: :previous_event,
              foreign_key: :previous_event_id

  belongs_to  :previous_event,
              class_name: 'Event',
              inverse_of: :next_event
end
