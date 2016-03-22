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

    it { is_expected.to have_one :current_event }
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
    let(:started_adventure) do
      Fabricate(
        :adventure,
        owner: user,
        current_event: Fabricate(:event),
        started: true
      )
    end


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
        it 'does not destroy the adventure' do
          adventure = started_adventure
          expect {
            adventure.destroy_as(user)
          }.to change(described_class, :count).by(0)

          expect(started_adventure.errors[:base]).not_to be_empty
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
        it 'destroys the adventure' do
          adventure = started_adventure
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
        adventure = Fabricate(:adventure,
                              current_event: Fabricate(:event),
                              started: true)
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


  describe '#role_of_user' do
    context 'user has role player' do
      it 'returns :player' do
        default_adventure.update!(player: user)
        expect(default_adventure.role_of_user(user)).to eq :player
      end
    end # given user has a role


    context 'user has role master' do
      it 'returns :player' do
        default_adventure.update!(master: user)
        expect(default_adventure.role_of_user(user)).to eq :master
      end
    end # given user has a role


    context 'user is not assigned to adventure' do
      it 'returns nil' do
        expect(default_adventure.role_of_user(user)).to be nil
      end
    end # user is not assigned to adventure
  end # #role_of_user


  describe '#last_events' do
    let(:adventure) { persisted_adventure }
    let(:visited_events) { @visited_events }

    before(:each) do
      5.times { Fabricate(:event, adventure: adventure) }
      @visited_events = adventure.events[0..3]
      @visited_events.each { |event| event.update!(visited: true) }
    end

    context 'without argument' do
      it 'returns all events visited by the player' do
        expect(adventure.last_events).to eq(visited_events)
      end
    end # without argument


    context 'with argument: 2' do
      it 'returns the last two visited events' do
        expect(adventure.last_events(2)).to eq(visited_events[-2..-1])
      end
    end # with argument
  end # #last_events


  describe '#next_element?' do
    let(:adventure)     { persisted_adventure }
    let(:next_event)    { @next_event         }
    let(:current_event) { @current_event      }

    before(:each) do
      @current_event = Fabricate(:event, adventure: persisted_adventure)
      persisted_adventure.update!(current_event: @current_event)
    end

    context 'current event does not have a successor' do
      it 'returns false' do
        expect(adventure.next_event?).to be false
      end
    end # current event does not have a successor


    context 'current event has a successor' do
      before(:each) do
        @next_event = Fabricate(:event,
                                adventure: persisted_adventure,
                                previous_event: current_event)
      end

      context 'successor is not ready' do
        it 'returns false' do
          expect(adventure.next_event?).to be false
        end
      end # successor is not ready


      context 'successor is ready' do
        before(:each) do
          next_event.update!(ready: true)
        end

        it 'returns true' do
          expect(adventure.next_event?).to be true
        end
      end # successor is ready
    end # current event has a successor
  end # #next_element?


  describe '#next_event' do
    let(:adventure)     { persisted_adventure }
    let(:next_event)    { @next_event         }
    let(:current_event) { @current_event      }

    before(:each) do
      @current_event = Fabricate(:event, adventure: persisted_adventure)
      persisted_adventure.update!(current_event: @current_event)
    end

    context 'current event does not have a successor' do
      it 'returns current event' do
        expect(adventure.next_event).to be current_event
      end
    end # current even does not have a successor


    context 'current event has a successor' do
      before(:each) do
        @next_event = Fabricate(:event,
                                adventure: persisted_adventure,
                                previous_event: current_event)
      end

      context 'successor is not ready' do
        it 'returns current_event' do
          expect(adventure.next_event).to be current_event
        end
      end # successor is not ready


      context 'successor is ready' do
        before(:each) do
          next_event.update!(ready: true)
        end

        it 'returns event following current event' do
          expect(adventure.next_event).to eq next_event
        end

        it 'replaces the current event by its successor' do
          adventure.next_event
          expect(adventure.current_event).to eq next_event
          current_event.reload
          expect(current_event.current_event_id).to be_blank
        end

        it 'marks current event as visited' do
          adventure.next_event
          current_event.reload
          expect(current_event).to be_visited
        end
      end # successor is ready
    end # current event has a successor
  end # #next_event


  describe '#unfollowed_events' do
    it 'returns events which are not followed' do
      unfollowed = [
        Fabricate(:event, adventure: persisted_adventure),
        Fabricate(:event, adventure: persisted_adventure)
      ]

      with_next_event = Fabricate(:event,
                                  adventure: persisted_adventure,
                                  next_event: unfollowed[0])
      with_choice =     Fabricate(:event,
                                  adventure: persisted_adventure,
                                  choices: [Fabricate(:choice)])
      visited = Fabricate(:event, adventure: persisted_adventure)
      visited.update!(visited: true)

      persisted_adventure.reload
      unfollowed_events = persisted_adventure.unfollowed_events
      expect(unfollowed_events).to eq unfollowed
      # Even though the following lines don't add test relevance, they add
      # explicit test understanding.
      expect(unfollowed_events).not_to include(with_next_event)
      expect(unfollowed_events).not_to include(with_choice)
    end
  end # #unfollowed_events


  describe '#start' do
    let(:adventure)     { persisted_adventure }
    let(:next_event)    { @next_event         }
    let(:current_event) { @current_event      }

    before(:each) do
      @current_event = Fabricate(:event, adventure: persisted_adventure)
    end

    context 'adventure has not been started yet' do
      before(:each) do
        @next_event = Fabricate(
          :event,
          adventure: persisted_adventure,
          previous_event: current_event
        )

        adventure.update!(started: false)
      end

      context 'adventure has no ready event' do
        it 'returns nil' do
          expect(adventure.start).to be nil
        end

        it 'does nothing' do
          adventure.start
          expect(adventure.current_event).to be nil
        end
      end # adventure has no ready event


      context 'adventure has a ready event' do
        before(:each) do
          next_event.update!(ready: true)
        end

        it 'returns first ready event' do
          expect(adventure.start).to eq next_event
        end

        it 'sets first ready event as current event' do
          adventure.start
          expect(adventure.current_event).to eq next_event
        end

        it 'sets the started flag' do
          adventure.start
          expect(adventure).to be_started
        end
      end # adventure has a ready event
    end # adventure has no current event


    context 'adventure has already been started' do
      before(:each) do
        adventure.update!(started: true, current_event: current_event)
      end

      it 'returns current event' do
        expect(adventure.start).to be current_event
      end

      it 'does nothing' do
        adventure.start
        expect(adventure.current_event).to eq current_event
      end
    end # adventure has a current event
  end # #start
end
