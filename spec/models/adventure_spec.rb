require 'rails_helper'

describe Adventure, type: :model do
  context 'validation' do
    it { is_expected.to validate_presence_of :name   }
    it 'validates uniqueness of name' do
      name = 'valid'
      Fabricate(:adventure, name: name)
      invalid_adventure = Fabricate.build(:adventure, name: name)

      expect(invalid_adventure).not_to be_valid
      expect(invalid_adventure.errors).to have_key(:name)
      expect(invalid_adventure.errors[:name]).to eq(['has already been taken'])
    end
  end # validation
end
