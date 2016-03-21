require 'rails_helper'

describe Choice, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:outcome).with_foreign_key(:outcome_id) }
    it { is_expected.to belong_to :event  }
  end # associations


  context 'validations' do
    it { is_expected.to validate_presence_of :outcome   }
    it { is_expected.to validate_presence_of :event     }
    it { is_expected.to validate_presence_of :decision  }
  end # validations
end
