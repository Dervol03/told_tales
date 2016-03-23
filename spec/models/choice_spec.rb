require 'rails_helper'

describe Choice, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:outcome).with_foreign_key(:outcome_id) }
    it { is_expected.to belong_to :event                                 }
  end # associations


  context 'validations' do
    it { is_expected.to validate_presence_of :outcome   }
    it { is_expected.to validate_presence_of :event     }
    it { is_expected.to validate_presence_of :decision  }

    it 'validates given outcome event is valid' do
      invalid_event = Event.new(title: nil, description: nil)
      choice = Fabricate.build(:choice, outcome: invalid_event)

      expect(choice).to be_invalid
      expect(choice.errors).to have_key(:outcome)
      expect(choice.errors[:outcome]).not_to be_blank
    end
  end # validations
end
