require 'rails_helper'

RSpec.describe 'adventures/new', type: :view do
  before(:each) do
    assign(:adventure, Fabricate.build(:adventure))
  end

  it 'renders new adventure form' do
    render

    assert_select 'form[action=?][method=?]', adventures_path, 'post' do
      assert_select 'input#adventure_name[name=?]', 'adventure[name]'

      assert_select 'textarea#adventure_setting[name=?]', 'adventure[setting]'

      assert_select 'input#adventure_owner_id[name=?]', 'adventure[owner_id]'
    end
  end
end
