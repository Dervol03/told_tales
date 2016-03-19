require 'rails_helper'

describe AdventureHelper, type: :helper do
  describe '#join_adventure_link' do
    it 'links join URL of given adventure for specified role' do
      adventure = Fabricate(:adventure)
      player_link = helper.join_adventure_link(adventure, :player)
      master_link = helper.join_adventure_link(adventure, :master)
      expect(player_link).to include('Join as Player')
      expect(player_link).to include(join_adventure_path(adventure))
      expect(master_link).to include('Join as Master')
      expect(master_link).to include(join_adventure_path(adventure))
    end
  end # #join_adventure_link
end
