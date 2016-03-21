Fabricator(:choice) do
  decision { sequence { |i| 'descision_' + i.to_s } }
  event do |attrs|
    Event.find_by_id(attrs[:event_id]) ||
      Fabricate(:event)
  end

  outcome do |attrs|
    Event.find_by_id(attrs[:outcome_id]) ||
      Fabricate(:event)
  end
end
