require 'rails_helper'

describe User, type: :model do
  context 'validations' do
    context 'password' do
      it { is_expected.to validate_length_of(:password).is_at_least(6)  }
      it { is_expected.to validate_presence_of(:password)               }

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

      context 'temporary_password given' do
        it 'does not validate password' do
          user = Fabricate.build(:user,
                                 password: 'super',
                                 temporary_password: 'ladida'
          )
          expect(user).to be_valid
        end
      end # temporary_password given

      it 'sets the normal password to temporary password' do
        user = Fabricate.build(:user,
                               password: 'super',
                               temporary_password: 'ladida'
        )
        user.valid?
        expect(user.password).to eq user.temporary_password
      end
    end # password

    context '#name' do
      it { is_expected.to validate_presence_of    :name }
      it { is_expected.to validate_uniqueness_of  :name }
    end # #name


    context '#destroy' do
      context 'target is last admin' do
        it 'does not destroy the user' do
          described_class.destroy_all
          admin1 = Fabricate(:admin)
          admin2 = Fabricate(:admin)

          expect(admin1.destroy).to eq admin1
          expect(admin2.destroy).to be false
          expect(admin2.errors).to have_key(:base)
          expect(admin2.errors[:base]).not_to be_empty
        end
      end # target is an admin

      context 'target is last non-admin user' do
        it 'destroys the user' do
          described_class.destroy_all
          Fabricate(:admin)
          admin2 = Fabricate(:user)

          expect(admin2.destroy).to eq admin2
        end
      end # target is last non-admin user
    end # #delete
  end # validations
end # User
