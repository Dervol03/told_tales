Fabricator(:adventure) do
  name    { sequence(:name) { |i| "adventure_#{i}" } }
  setting 'Some fascinating setting'
  owner   { Fabricate(:user) }
end
