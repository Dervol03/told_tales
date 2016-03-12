require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:default_password) { 'Sup3r!' }

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name:                  'Admin Boss',
      email:                 'admin@example.com',
      password:              default_password,
      password_confirmation: default_password
    }
  end

  let(:invalid_attributes) do
    {
      name:                  '',
      email:                 'asddsadad',
      password:              '1',
      password_confirmation: '2'
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_credentials) do
    {
      email: 'admin@example.com',
      password: default_password
    }
  end

  context 'user is signed in' do
    before(:all) do
      Fabricate(:user)
    end

    let(:default_user) { User.first }

    before(:each) do
      sign_in(default_user)
    end

    # describe 'GET #index' do
    #   it 'assigns all users as @users' do
    #     user = Fabricate(:user)
    #     get :index, {}, valid_credentials
    #     expect(assigns(:users)).to eq([user])
    #   end
    # end
    #
    # describe 'GET #show' do
    #   it 'assigns the requested user as @user' do
    #     user = User.create! valid_attributes
    #     get :show, {:id => user.to_param}, valid_credentials
    #     expect(assigns(:user)).to eq(user)
    #   end
    # end
    #
    # describe 'GET #new' do
    #   it 'assigns a new user as @user' do
    #     get :new, {}, valid_credentials
    #     expect(assigns(:user)).to be_a_new(User)
    #   end
    # end
    #
    # describe 'GET #edit' do
    #   it 'assigns the requested user as @user' do
    #     user = User.create! valid_attributes
    #     get :edit, {:id => user.to_param}, valid_credentials
    #     expect(assigns(:user)).to eq(user)
    #   end
    # end
    #
    # describe 'POST #create' do
    #   context 'with valid params' do
    #     it 'creates a new User' do
    #       expect {
    #         post :create, {:user => valid_attributes}, valid_credentials
    #       }.to change(User, :count).by(1)
    #     end
    #
    #     it 'assigns a newly created user as @user' do
    #       post :create, {:user => valid_attributes}, valid_credentials
    #       expect(assigns(:user)).to be_a(User)
    #       expect(assigns(:user)).to be_persisted
    #     end
    #
    #     it 'redirects to the created user' do
    #       post :create, {:user => valid_attributes}, valid_credentials
    #       expect(response).to redirect_to(User.last)
    #     end
    #   end
    #
    #   context 'with invalid params' do
    #     it 'assigns a newly created but unsaved user as @user' do
    #       post :create, {:user => invalid_attributes}, valid_credentials
    #       expect(assigns(:user)).to be_a_new(User)
    #     end
    #
    #     it "re-renders the 'new' template" do
    #       post :create, {:user => invalid_attributes}, valid_credentials
    #       expect(response).to render_template('new')
    #     end
    #   end
    # end
    #
    # describe 'PUT #update' do
    #   context 'with valid params' do
    #     let(:new_attributes) {
    #       skip('Add a hash of attributes valid for your model')
    #     }
    #
    #     it 'updates the requested user' do
    #       user = User.create! valid_attributes
    #       put :update, {:id => user.to_param, :user => new_attributes},
    #           valid_credentials
    #       user.reload
    #       skip('Add assertions for updated state')
    #     end
    #
    #     it 'assigns the requested user as @user' do
    #       user = User.create! valid_attributes
    #       put :update, {:id => user.to_param, :user => valid_attributes},
    #           valid_credentials
    #       expect(assigns(:user)).to eq(user)
    #     end
    #
    #     it 'redirects to the user' do
    #       user = User.create! valid_attributes
    #       put :update, {:id => user.to_param, :user => valid_attributes},
    #           valid_credentials
    #       expect(response).to redirect_to(user)
    #     end
    #   end
    #
    #   context 'with invalid params' do
    #     it 'assigns the user as @user' do
    #       user = User.create! valid_attributes
    #       put :update, {:id => user.to_param, :user => invalid_attributes},
    #           valid_credentials
    #       expect(assigns(:user)).to eq(user)
    #     end
    #
    #     it "re-renders the 'edit' template" do
    #       user = User.create! valid_attributes
    #       put :update, {:id => user.to_param, :user => invalid_attributes},
    #           valid_credentials
    #       expect(response).to render_template('edit')
    #     end
    #   end
    # end
    #
    # describe 'DELETE #destroy' do
    #   it 'destroys the requested user' do
    #     user = User.create! valid_attributes
    #     expect {
    #       delete :destroy, {:id => user.to_param}, valid_credentials
    #     }.to change(User, :count).by(-1)
    #   end
    #
    #   it 'redirects to the users list' do
    #     user = User.create! valid_attributes
    #     delete :destroy, {:id => user.to_param}, valid_credentials
    #     expect(response).to redirect_to(users_url)
    #   end
    # end
  end # user is signed in
end