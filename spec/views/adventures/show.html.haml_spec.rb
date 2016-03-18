require 'rails_helper'

RSpec.describe "adventures/show", type: :view do
  before(:each) do
    @adventure = assign(:adventure, Adventure.create!(
      :name => "Name",
      :setting => "MyText",
      :started => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
