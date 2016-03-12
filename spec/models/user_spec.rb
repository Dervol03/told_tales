require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    context 'password' do
      it { is_expected.to validate_length_of(:password).is_at_least(6) }
      it { is_expected.to validate_presence_of(:password) }

      it 'validates password has at least one number' do
        user = Fabricate.build(:user, password: 'Super!')
        expect(user).not_to be_valid
        expect(user.errors).to have_key :password

        user = Fabricate.build(:user,
                               password: 'Sup3r!',
                               password_confirmation: 'Sup3r!'
                               )
        expect(user).to be_valid
      end

      it 'validates password has at least one special character' do
        user = Fabricate.build(:user, password: 'Super3')
        expect(user).not_to be_valid
        expect(user.errors).to have_key :password

        [
          '!', '§', '$', '%', '&', '/', '(', ')', '{', '[', ']', '}', '=', '?',
          '\\', '*', '+', '~', '#', '.', ',', '\\-', '_', '@', ';', ':', '"',
          "'"
        ].each do |special_char|
          pw = 'Sup3r' + special_char
          user.password, user.password_confirmation = pw, pw
          expect(user).to be_valid
        end

      end
    end # password
  end # validations
end # User
