require 'rails_helper'

RSpec.describe 'adventures/edit', type: :view do
  before(:each) do
    @adventure = assign(:adventure, Fabricate(:adventure))
  end

  it 'renders the edit adventure form' do
    render

    form_details = ['form[action=?][method=?]', adventure_path(@adventure)]
    assert_select(*form_details, 'post') do
      assert_select 'input#adventure_name[name=?]', 'adventure[name]'

      assert_select 'textarea#adventure_setting[name=?]', 'adventure[setting]'

      assert_select 'input#adventure_owner_id[name=?]', 'adventure[owner_id]'
    end
  end
end
