json.array!(@events) do |event|
  json.extract! event, :id, :title, :description, :adventure_id, :event_id
  json.url event_url(event, format: :json)
end
