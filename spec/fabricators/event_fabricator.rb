Fabricator(:event) do
  title       { sequence(:title) { |i| 'Event_' + i.to_s } }
  description 'Some description'
  visited     false

  adventure do |attrs|
    Adventure.find_by_id(attrs[:adventure_id]) ||
      Fabricate(:adventure)
  end
end
