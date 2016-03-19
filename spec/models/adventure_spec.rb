require 'rails_helper'

describe Adventure, type: :model do
  let(:default_adventure)   { Fabricate.build(:adventure) }
  let(:persisted_adventure) { Fabricate(:adventure)       }
  let(:user)                { Fabricate(:user)            }

  context 'associations' do
    it 'has a player' do
      adventure = Fabricate(:adventure)

      adventure.player = user
      expect(adventure.save).to be true
      expect(adventure.player).to eq(user)
      expect(user.played_adventures).to eq([adventure])
    end

    it 'has a master' do
      adventure = Fabricate(:adventure)

      adventure.master = user
      expect(adventure.save).to be true
      expect(adventure.master).to eq(user)
      expect(user.mastered_adventures).to eq([adventure])
    end
  end # associations


  context 'validation' do
    it { is_expected.to validate_presence_of :name   }
    it { is_expected.to belong_to :owner             }
    it { is_expected.to validate_presence_of :owner  }

    it 'validates uniqueness of name' do
      name = 'valid'
      Fabricate(:adventure, name: name)
      invalid_adventure = Fabricate.build(:adventure, name: name)

      expect(invalid_adventure).not_to be_valid
      expect(invalid_adventure.errors).to have_key(:name)
      expect(invalid_adventure.errors[:name]).to eq(['has already been taken'])
    end


    context 'roles' do
      it 'validates each user may only have one role' do
        adventure = Fabricate.build(:adventure)

        adventure.player = user
        expect(adventure).to be_valid

        adventure.master = user
        expect(adventure).not_to be_valid
        expect(adventure.errors).to have_key(:player)
        expect(adventure.errors[:player]).not_to be_empty
        expect(adventure.errors).to have_key(:master)
        expect(adventure.errors[:master]).not_to be_empty
      end
    end # roles
  end # validation


  describe '#destroy_as' do
    context 'as user' do
      let(:adventure) { @adventure }

      context 'adventure has not been started yet' do
        before(:each) do
          @adventure = Fabricate(:adventure, owner: user)
        end

        it 'destroys the adventure' do
          expect {
            adventure.destroy_as(user)
          }.to change(described_class, :count).by(-1)
        end

        it 'returns destroyed adventure' do
          expect(adventure.destroy_as(user)).to eq adventure
        end
      end # adventure has not been started yet


      context 'adventure has already started' do
        before(:each) do
          @adventure = Fabricate(:adventure, owner: user, started: true)
        end

        it 'does not destroy the adventure' do
          expect {
            adventure.destroy_as(user)
          }.to change(described_class, :count).by(0)

          expect(adventure.errors[:base]).not_to be_empty
        end
      end # adventure has already started


      context 'user is not the owner of the adventure' do
        let(:owner) { Fabricate(:user) }
        before(:each) do
          @adventure = Fabricate(:adventure, owner: owner)
        end

        it 'does not destroy the adventure' do
          expect {
            adventure.destroy_as(user)
          }.to change(described_class, :count).by(0)

          expect(adventure.errors[:base]).not_to be_empty
        end
      end # user is not the owner of the adventure
    end # as user


    context 'as admin' do
      let(:admin)     { Fabricate(:admin) }
      let(:adventure) { @adventure        }

      context 'adventure has not been started yet' do
        before(:each) do
          @adventure = Fabricate(:adventure, owner: admin)
        end

        it 'destroys the adventure' do
          expect {
            adventure.destroy_as(admin)
          }.to change(described_class, :count).by(-1)
        end
      end # adventure has not been started yet


      context 'adventure has already started' do
        before(:each) do
          @adventure = Fabricate(:adventure, owner: admin, started: true)
        end

        it 'destroys the adventure' do
          expect {
            adventure.destroy_as(admin)
          }.to change(described_class, :count).by(-1)
        end
      end # adventure has already started


      context 'admin is not the owner of the adventure' do
        let(:owner) { Fabricate(:user) }

        before(:each) do
          @adventure = Fabricate(:adventure, owner: owner)
        end

        it 'destroys the adventure' do
          expect {
            adventure.destroy_as(admin)
          }.to change(described_class, :count).by(-1)

          expect(subject.errors).not_to have_key(:base)
        end
      end # user is not the owner of the adventure
    end # as admin
  end # #destroy_as


  describe '#destroy_as!' do
    context 'destruction fails' do
      it 'raises ActiveRecord::RecordNotDestroyed' do
        adventure = Fabricate(:adventure, started: true)
        expect {
          adventure.destroy_as!(User.last)
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end # destruction fails
  end # #destroy_as!


  describe '#vacant_seats' do
    context 'at least one role is vacant' do
      it 'returns list of vacant roles' do
        adventure = Fabricate(:adventure)

        expect(adventure.vacant_seats).to eq([:player, :master])

        adventure.player = user
        expect(adventure.vacant_seats).to eq([:master])

        adventure.player = nil
        adventure.master = user
        expect(adventure.vacant_seats).to eq([:player])
      end
    end # at least one role is vacant

    context 'all roles are taken' do
      it 'returns empty array' do
        adventure = Fabricate(
          :adventure,
          player: Fabricate(:user),
          master: Fabricate(:user)
        )
        expect(adventure.vacant_seats).to eq([])
      end
    end # all roles are taken
  end # #vacant_seats


  describe '#seat_available?' do
    context 'desired role is available' do
      it 'returns true' do
        default_adventure.player = user
        expect(default_adventure.seat_available?(:master)).to be true
      end
    end # desired role is available

    context 'desired role is already taken' do
      it 'returns false' do
        default_adventure.player = user
        expect(default_adventure.seat_available?(:player)).to be false
      end
    end # desired role is already taken
  end # #seat_available?


  describe 'role_of_user' do
    context 'user has role player' do
      it 'returns :player' do
        default_adventure.update_attributes(player: user)
        expect(default_adventure.role_of_user(user)).to eq :player
      end
    end # given user has a role

    context 'user has role master' do
      it 'returns :player' do
        default_adventure.update_attributes(master: user)
        expect(default_adventure.role_of_user(user)).to eq :master
      end
    end # given user has a role

    context 'user is not assigned to adventure' do
      it 'returns nil' do
        expect(default_adventure.role_of_user(user)).to be nil
      end
    end # user is not assigned to adventure
  end # role_of_user
end
