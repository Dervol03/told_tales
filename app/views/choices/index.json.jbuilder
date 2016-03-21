json.array!(@choices) do |choice|
  json.extract! choice, :id, :decision, :event_id, :result
  json.url choice_url(choice, format: :json)
end
