require 'rails_helper'

RSpec.describe "adventures/new", type: :view do
  before(:each) do
    assign(:adventure, Adventure.new(
      :name => "MyString",
      :setting => "MyText",
      :started => false
    ))
  end

  it "renders new adventure form" do
    render

    assert_select "form[action=?][method=?]", adventures_path, "post" do

      assert_select "input#adventure_name[name=?]", "adventure[name]"

      assert_select "textarea#adventure_setting[name=?]", "adventure[setting]"

      assert_select "input#adventure_started[name=?]", "adventure[started]"
    end
  end
end
