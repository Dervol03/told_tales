require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users, [Fabricate(:user), Fabricate(:user)])
  end

  it 'renders a list of users' do
    render
  end
end
