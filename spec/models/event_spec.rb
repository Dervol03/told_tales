require 'rails_helper'

describe Event, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :adventure      }
    it { is_expected.to belong_to :previous_event }
    it { is_expected.to have_one :next_event      }
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
end
