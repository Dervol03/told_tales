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
  end # validation


  context '#visited' do
    it 'is always false on creation' do
      expect(Event.new.visited).to be false
      Fabricate(:event, visited: true)
      expect(Event.last.visited).to be false
    end
  end # #visited
end
