require 'rails_helper'

describe ChoicesController, type: :controller do
  let(:valid_attributes) do
    {
      decision:   'First decision',
      event_id:   Fabricate(:event).to_param,
      outcome_id: Fabricate(:event).to_param
    }
  end
  let(:valid_choice){ Fabricate(:choice) }
  let(:invalid_attributes) do
    {
      decision:    nil,
      event_id:    nil,
      outcome_id:  nil
    }
  end
  let(:user) { Fabricate(:user) }

  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns all choices as @choices' do
      choice = valid_choice
      get :index
      expect(assigns(:choices)).to eq([choice])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested choice as @choice' do
      choice = valid_choice
      get :show, id: choice.to_param
      expect(assigns(:choice)).to eq(choice)
    end
  end

  describe 'GET #new' do
    it 'assigns a new choice as @choice' do
      get :new
      expect(assigns(:choice)).to be_a_new(Choice)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested choice as @choice' do
      choice = valid_choice
      get :edit, id: choice.to_param
      expect(assigns(:choice)).to eq(choice)
    end
  end

  describe 'POST #create', wip: true do
    context 'with valid params' do
      it 'creates a new Choice' do
        expect {
          post :create, choice: valid_attributes
        }.to change(Choice, :count).by(1)
      end

      it 'assigns a newly created choice as @choice' do
        post :create, choice: valid_attributes
        expect(assigns(:choice)).to be_a(Choice)
        expect(assigns(:choice)).to be_persisted
      end

      it 'redirects to the created choice' do
        post :create, choice: valid_attributes
        expect(response).to redirect_to(Choice.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved choice as @choice' do
        post :create, choice: invalid_attributes
        expect(assigns(:choice)).to be_a_new(Choice)
      end

      it "re-renders the 'new' template" do
        post :create, choice: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          decision:   'other decision',
          event_id:   Fabricate(:event).id,
          outcome_id: Fabricate(:event).id
        }
      end

      it 'updates the requested choice' do
        choice = valid_choice
        put :update, id: choice.to_param, choice: new_attributes
        choice.reload
        expect(choice.decision).to    eq(new_attributes[:decision])
        expect(choice.event.id).to    eq(new_attributes[:event_id])
        expect(choice.outcome.id).to  eq(new_attributes[:outcome_id])
      end

      it 'assigns the requested choice as @choice' do
        choice = valid_choice
        put :update, id: choice.to_param, choice: valid_attributes
        expect(assigns(:choice)).to eq(choice)
      end

      it 'redirects to the choice' do
        choice = valid_choice
        put :update, id: choice.to_param, choice: valid_attributes
        expect(response).to redirect_to(choice)
      end
    end

    context 'with invalid params' do
      it 'assigns the choice as @choice' do
        choice = valid_choice
        put :update, id: choice.to_param, choice: invalid_attributes
        expect(assigns(:choice)).to eq(choice)
      end

      it "re-renders the 'edit' template" do
        choice = valid_choice
        put :update, id: choice.to_param, choice: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested choice' do
      choice = valid_choice
      expect {
        delete :destroy, id: choice.to_param
      }.to change(Choice, :count).by(-1)
    end

    it 'redirects to the choices list' do
      choice = valid_choice
      delete :destroy, id: choice.to_param
      expect(response).to redirect_to(choices_url)
    end
  end

end
