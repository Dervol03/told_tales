require 'rails_helper'

describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    def index

    end
  end

  context 'user is signed out' do
    context 'no user exists' do
      before(:all) do
        User.destroy_all
      end

      subject { get :index}

      it 'redirects to the user registration' do
        expect(subject).to redirect_to(new_user_path)
      end
    end # no user exists


    context 'a user exists' do
      before(:all) do
        Fabricate(:user)
      end

      subject { get :index }

      it 'redirects to user login' do
        expect(subject).to redirect_to(new_user_session_path)
      end


    end # a user exists
  end # user is signed out
end # ApplicationController
