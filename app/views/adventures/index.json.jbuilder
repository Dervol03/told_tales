json.array!(@adventures) do |adventure|
  json.extract! adventure, :id, :name, :setting, :started
  json.url adventure_url(adventure, format: :json)
end
