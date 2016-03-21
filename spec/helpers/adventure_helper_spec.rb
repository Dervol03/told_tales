require 'rails_helper'

describe AdventureHelper, type: :helper do
  describe '#join_adventure_links' do
    let(:user) { Fabricate.build(:user) }

    before(:each) do
      allow(helper).to receive(:current_user).and_return(user)
    end

    context 'user already has a role in the adventure' do
      it 'does not generate a link' do
        adventure = Fabricate(:adventure, player: user)
        links = helper.join_adventure_links(adventure)
        expect(links).to be_blank
      end
    end # user already has a role in the adventure


    context 'user is not assigned to adventure' do
      context 'no other player has joined yet' do
        it 'generates URLs for each role the user may take' do
          adventure = Fabricate(:adventure)
          links = helper.join_adventure_links(adventure)

          expect(links).to include(join_adventure_path(adventure))
          expect(links).to include('As Player')
          expect(links).to include('As Master')
        end
      end # no other player has joined yet


      context 'player role is already taken' do
        it 'generates URL for master role only' do
          adventure = Fabricate(:adventure, player: Fabricate(:user))
          links = helper.join_adventure_links(adventure)

          expect(links).not_to  include('As Player')
          expect(links).to      include('As Master')
          expect(links).to      include(join_adventure_path(adventure))
        end
      end # player role is already taken


      context 'master role is already taken' do
        it 'generates URL for master role only' do
          adventure = Fabricate(:adventure, master: Fabricate(:user))
          links = helper.join_adventure_links(adventure)

          expect(links).to      include('As Player')
          expect(links).to      include(join_adventure_path(adventure))
          expect(links).not_to  include('As Master')
        end
      end # master role is already taken
    end # user is not assigned to adventure
  end # #join_adventure_link


  describe '#play_adventure_link' do
    let(:user) { Fabricate.build(:user) }

    before(:each) do
      allow(helper).to receive(:current_user).and_return(user)
    end

    context 'user is player' do
      it 'links to play URL of the adventure' do
        adventure = Fabricate(:adventure, player: user)

        link = helper.play_adventure_link(adventure)
        expect(link).to include('Play')
        expect(link).to include(play_adventure_path(adventure))
      end
    end # user is player


    context 'user is master' do
      it 'links to event management URL of the adventure' do
        adventure = Fabricate(:adventure, master: user)
        link      = helper.play_adventure_link(adventure)
        expect(link).to include('Play')
        expect(link).to include(adventure_events_path(adventure))
      end
    end # user is master


    context 'user is not involved in the adventure' do
      it 'does not link' do
        adventure = Fabricate(:adventure)
        link = helper.play_adventure_link(adventure)
        expect(link).to be_blank
      end
    end # user is not involved in the adventure
  end # #link_to_adventure_interaction
end
