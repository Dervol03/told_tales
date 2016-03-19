Fabricator(:event) do
  title       { sequence(:title) { |i| 'Event_' + i.to_s } }
  description 'Some description'
  adventure   { Fabricate(:adventure) }
end
