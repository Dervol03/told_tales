require 'rails_helper'

describe Event, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :adventure      }
    it { is_expected.to belong_to :previous_event }
    it { is_expected.to have_one :next_event      }
    it do
      is_expected.to have_one(:customized_choice)
                       .with_foreign_key(:customized_choice_id)
    end
  end # associations


  describe 'validation' do
    it { is_expected.to validate_presence_of    :title        }
    it { is_expected.to validate_uniqueness_of  :title        }
    it { is_expected.to validate_presence_of    :description  }
    it { is_expected.to validate_presence_of    :adventure    }

    it 'validates a visited event can not be destroyed' do
      event = Fabricate(:event)
      expect(event.destroy).to be event

      event = Fabricate(:event)
      event.update!(visited: true)
      expect(event.destroy).to be false
      expect(event.errors).to have_key(:base)
      expect(event.errors[:base]).not_to be_blank
    end

    it 'validates current event can not be destroyed' do
      event = Fabricate(:event)
      expect(event.destroy).to be event

      event = Fabricate(:event)
      event.adventure.update!(current_event: event)
      expect(event.destroy).to be false
      expect(event.errors).to have_key(:base)
      expect(event.errors[:base]).not_to be_blank
    end


    context 'possible outcomes' do
      it 'may have a next event' do
        event_with_next = Fabricate.build(:event,
                                          next_event: Fabricate.build(:event))
        expect(event_with_next).to be_valid
      end

      it 'may have multiple choices' do
        event_with_choices = Fabricate.build(
          :event,
          choices: [Fabricate.build(:choice), Fabricate.build(:choice)]
        )
        expect(event_with_choices).to be_valid
      end

      it 'may have a customized choice' do
        event_with_choices = Fabricate.build(
          :event,
          customized_choice: Fabricate.build(:choice)
        )
        expect(event_with_choices).to be_valid
      end

      it 'it must not have more than one outcome type' do
        event_with_both = Fabricate.build(
          :event,
          next_event: Fabricate.build(:event),
          choices:    [Fabricate.build(:choice)])
        expect(event_with_both).to be_invalid

        event_with_both = Fabricate.build(
          :event,
          customized_choice: Fabricate.build(:choice),
          choices:    [Fabricate.build(:choice)])
        expect(event_with_both).to be_invalid
      end
    end # possible outcomes
  end # validation


  context 'scopes' do
    describe '.unpreceded' do
      it 'returns all not ready events without predecessor' do
        unpreceded = [
          Fabricate(:event),
          Fabricate(:event)
        ]

        ready_event = Fabricate(:event, ready: true)
        preceded_event = Fabricate(:event, previous_event: ready_event)

        expect(described_class.unpreceded).to eq(unpreceded)
        expect(described_class.unpreceded).not_to include(preceded_event)
        expect(described_class.unpreceded).not_to include(ready_event)
      end
    end # .unpreceded
  end #


  describe '#visited' do
    it 'is always false on creation' do
      expect(described_class.new.visited).to be false
      Fabricate(:event, visited: true)
      expect(described_class.last.visited).to be false
    end
  end # #visited


  describe '#choices?' do
    context 'event has choices' do
      it 'returns true' do
        event = Fabricate.build(:event, choices: [Fabricate.build(:choice)])
        expect(event.choices?).to be true
      end
    end # event has choices


    context 'even does not have choices' do
      it 'returns false' do
        event = Fabricate.build(:event)
        expect(event.choices?).to be false
      end
    end # even does not have choices
  end # #choices?


  describe '#next_event?' do
    context 'event has a next event' do
      it 'returns true' do
        event = Fabricate.build(:event, next_event: Fabricate.build(:event))
        expect(event.next_event?).to be true
      end
    end # event has a next event


    context 'event does not have a next event' do
      it 'returns false' do
        event = Fabricate.build(:event)
        expect(event.next_event?).to be false
      end
    end # event does not have a next event
  end # #next_event?


  describe 'customized_choice?' do
    context 'event has a customized choice' do
      it 'returns true' do
        event = Fabricate.build(:event, customized_choice: Fabricate(:choice))
        expect(event.customized_choice?).to be true
      end
    end # event has a customized choice


    context 'event does not have a customized choice' do
      it 'returns false' do
        event = Fabricate.build(:event)
        expect(event.customized_choice?).to be false
      end
    end # event does not have a customized choice
  end # customized_event?
end
