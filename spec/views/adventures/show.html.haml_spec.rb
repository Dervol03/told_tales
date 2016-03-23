require 'rails_helper'

RSpec.describe 'adventures/show', type: :view do
  before(:each) do
    @adventure = Fabricate(:adventure)
    @adventure = assign(:adventure, @adventure)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/#{@adventure.name}/)
    expect(rendered).to match(/#{@adventure.setting}/)
    expect(rendered).to match(/#{@adventure.started?}/)
  end
end
