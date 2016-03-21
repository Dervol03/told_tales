Fabricator(:user) do
  name      { sequence(:name)   { |i| "user#{i}"             } }
  email     { sequence(:email)  { |i| "user#{i}@example.com" } }
  password  'Sup3r!'
  password_confirmation 'Sup3r!'
end


Fabricator(:admin, from: :user) do
  name      { sequence(:name)   { |i| "user#{i}"             } }
  email     { sequence(:email)  { |i| "user#{i}@example.com" } }
  password  'Sup3r!'
  password_confirmation 'Sup3r!'
  is_admin  true
end
