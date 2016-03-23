require 'rails_helper'

describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index
    end
  end


  context 'user is signed out' do
    context 'no user exists' do
      before(:each) do
        User.destroy_all
      end

      subject { get :index }

      it 'redirects to the user registration' do
        expect(subject).to redirect_to(new_user_path)
      end
    end # no user exists


    context 'a user exists' do
      before(:each) do
        Fabricate(:user)
      end

      subject { get :index }

      it 'redirects to user login' do
        expect(subject).to redirect_to(new_user_session_path)
      end
    end # a user exists


    context 'existing user signs in' do
      context 'user has single use password' do
        it 'redirects to password change' do
          user = Fabricate(
            :user,
            temporary_password: 'Tilda',
            password: nil,
            password_confirmation: nil
          )
          sign_in user

          get :index
          expect(response).to redirect_to password_user_path(id: user.id)
        end
      end # user has temporary_password


      context 'does not have a single use password' do
        it 'gets to index page' do
          user = Fabricate(:user)
          sign_in user
          expect(subject).to receive(:render).with(no_args)
          get :index
        end
      end # does not have a single use password
    end # existing user signs in
  end # user is signed out
end # ApplicationController
