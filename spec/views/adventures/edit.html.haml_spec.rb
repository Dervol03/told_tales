require 'rails_helper'

RSpec.describe 'adventures/edit', type: :view do
  before(:each) do
    @adventure = assign(:adventure, Fabricate(:adventure))
  end

  it 'renders the edit adventure form' do
    render

    assert_select 'form[action=?][method=?]', adventure_path(@adventure), 'post' do

      assert_select 'input#adventure_name[name=?]', 'adventure[name]'

      assert_select 'textarea#adventure_setting[name=?]', 'adventure[setting]'

      assert_select 'input#adventure_started[name=?]', 'adventure[started]'
    end
  end
end
