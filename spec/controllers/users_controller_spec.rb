require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:default_password)    { 'Sup3r!'            }
  let(:error_401_template)  { 'shared/errors/401' }


  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      name:                  'Admin Boss',
      email:                 'admin@example.com',
      temporary_password:    'ladida'
    }
  end

  let(:valid_update_attributes) do
    {
      name:                  'Admin Other Boss',
      email:                 'admin@example.com'
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
    before(:each) do
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

  context 'no user exists' do
    before(:each) do
      User.destroy_all
      sign_out :user
    end

    context '#new' do
      it 'opens new user template' do
        get :new
        expect(response.status).to eq 200
        expect(response).to render_template :new
        expect(assigns(:user).is_admin?).to be true
      end
    end # #new


    context '#create' do
      context 'with valid parameters' do
        before(:each) do
          post :create, user: valid_attributes
        end

        it 'creates a new user' do
          expect(User).to have(1).item
        end

        it 'sets a session for new user' do
          expect(subject.current_user).not_to be nil
        end

        it 'rendirects welcome page' do
          expect(response).to redirect_to(root_path)
        end
      end # with valid parameters


      context 'with invalid parameters' do
        before(:each) do
          post :create, user: invalid_attributes
        end

        it 'does not create a new user' do
          expect(response.status).to eq 422
          expect(User).to have(:no).item
        end

        it 'redirects to creation view again' do
          expect(response).to render_template :new
        end
      end # with invalid parameters
    end # #create
  end # no user exists


  context 'a user exists' do
    context 'user is signed out' do
      before(:each) do
        Fabricate(:user)
        sign_out :user
      end

      describe '#new' do
        it 'redirects to login' do
          get :new
          expect(response).to redirect_to(new_user_session_path)
        end
      end # #new


      describe '#create' do
        it 'redirects to login' do
          post :create, user: valid_attributes
          expect(response).to redirect_to(new_user_session_path)
        end
      end # #create
    end # user is signed out


    context 'as signed in user' do
      before(:each) do
        @user = Fabricate(:user)
        sign_in @user
      end

      let(:user) { @user }

      describe '#new' do
        it 'can not be accessed' do
          post :new
          expect(response.status).to eq 401
          expect(response).to render_template error_401_template
        end
      end # #new

      describe '#create' do
        it 'can not be accessed' do
          post :create, user: valid_attributes
          expect(response.status).to eq 401
          expect(response).to render_template error_401_template
        end
      end # #create

      describe '#edit' do
        it 'can not be accessed' do
          post :edit, id: user.id
          expect(response.status).to eq 401
          expect(response).to render_template error_401_template
        end
      end # #edit

      describe '#update' do
        it 'can not be accessed' do
          post :update, id: user.id, user: valid_attributes
          expect(response.status).to eq 401
          expect(response).to render_template error_401_template
        end
      end # #update


      describe 'GET #show' do
        it 'shows the user details' do
          get :show, id: user.id
          expect(response.status).to eq 200
          expect(response).to render_template :show
        end
      end # GET #show


      describe 'DELETE #destroy' do
        it 'can not be accessed' do
          post :destroy, id: user.id
          expect(response.status).to eq 401
          expect(response).to render_template error_401_template
        end
      end # #destroy


      describe 'GET #password' do
        context 'is own password' do
          it 'grants access to password change' do
            get :password, id: user.id
            expect(response.status).to eq 200
            expect(response).to render_template :password
          end
        end # is own password

        context 'is password of another user' do
          it 'denies access' do
            other_user = Fabricate(:user)
            get :password, id: other_user.id
            expect(response.status).to eq 401
            expect(response).to render_template error_401_template
          end
        end # is password of another user
      end # #password


      describe 'PUT #update_password' do
        context 'change own password' do
          context 'with valid password' do
            let(:valid_password) do
              {password: 'Sup4r!', password_confirmation: 'Sup4r!'}
            end

            it 'changes the password' do
              old_pw = user.encrypted_password

              put :update_password, id: user.id, user: valid_password
              expect(response).to redirect_to user_path(user)

              updated_user = User.find(user.id)
              expect(updated_user.encrypted_password).not_to eq old_pw
            end

            it 'deletes temporary password' do
              user.update_attribute(:temporary_password, 'test')

              put :update_password, id: user.id, user: valid_password
              expect(response).to redirect_to user_path(user)

              updated_user = User.find(user.id)
              expect(updated_user.temporary_password).to be_blank
            end
          end # with valid password

          context 'with invalid password' do
            let(:invalid_password) do
              {password: 'Supr', password_confirmation: 'Sup4r!'}
            end

            it 'changes the password' do
              old_pw = user.encrypted_password

              put :update_password, id: user.id, user: invalid_password
              expect(response).to render_template :password

              updated_user = User.find(user.id)
              expect(updated_user.encrypted_password).to eq old_pw
            end

            it 'keeps temporary password' do
              user.update_attribute(:temporary_password, 'test')
              old_temp = user.temporary_password

              put :update_password, id: user.id, user: invalid_password
              expect(response).to render_template :password

              updated_user = User.find(user.id)
              expect(updated_user.temporary_password).to eq old_temp
            end
          end # with invalid password
        end # change own password


        context 'change password of another user' do
          let(:valid_password) do
            {password: 'Sup4r!', password_confirmation: 'Sup4r!'}
          end

          it 'denies access' do
            other_user = Fabricate(:user)
            old_pw = other_user.encrypted_password

            put :update_password, id: other_user.id, user: valid_password
            expect(response.status).to eq 401
            expect(response).to render_template error_401_template

            updated_user = User.find(other_user.id)
            expect(updated_user.encrypted_password).to eq old_pw
          end
        end # change password of another user
      end # #update_password
    end # as signed in user


    context 'as signed in admin' do
      before(:each) do
        @user = Fabricate(:admin)
        sign_in @user
      end

      let(:user) { @user }

      describe '#new' do
        it 'opens new user form' do
          post :new
          expect(response.status).to eq 200
          expect(response).to render_template :new
        end
      end # #new

      describe '#create' do
        it 'creates a new user' do
          post :create, user: valid_attributes
          expect(response).to redirect_to user_path(User.last.id)
          expect(assigns(:user)).to eq User.last
        end
      end # #create

      describe '#edit' do
        it 'opens user form to be editted' do
          post :edit, id: user.id
          expect(response.status).to eq 200
          expect(response).to render_template :edit
          expect(assigns(:user)).to eq user
        end
      end # #edit

      describe '#update' do
        it 'updates specified user' do
          post :update, id: user.id, user: valid_update_attributes
          expect(response).to redirect_to user_path(user.id)
          expect(assigns(:user).name).to eq valid_update_attributes[:name]
        end
      end # #update


      describe '#destroy' do
        it 'can not be accessed' do
          user = Fabricate(:user)
          post :destroy, id: user.id
          expect(response).to redirect_to users_path
          expect { User.find(user.id) }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end # #destroy
    end # as signed in admin
  end # a user exists
end
