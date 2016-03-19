require 'rails_helper'

RSpec.describe 'adventures/index', type: :view do
  before(:each) do
    @advents = [Fabricate(:adventure), Fabricate(:adventure)]
    assign(:adventures, Adventure.all)
  end

  it 'renders a list of adventures' do
    render
    assert_select 'tr>td', text: @advents.first.name,    count: 1
    assert_select 'tr>td', text: @advents.last.name,     count: 1
    assert_select 'tr>td', text: @advents.first.setting, count: 2
    assert_select 'tr>td', text: false.to_s,             count: 2
  end
end
