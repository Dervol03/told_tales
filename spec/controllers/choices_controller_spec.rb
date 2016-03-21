require 'rails_helper'

describe ChoicesController, type: :controller, wip: true do
  let(:choice_class)  { Choice                              }
  let(:event_class)   { Event                               }
  let(:default_event) { Fabricate(:event)                   }
  let(:event_params)  { {event_id: default_event.to_param}  }

  let(:valid_event_attributes) do
    {
      title:        'Outcome Event',
      description:  'Once upon a time',
      adventure_id: default_event.adventure.to_param
    }
  end

  let(:valid_attributes) do
    {
      decision: 'First decision',
      event_id: default_event.to_param,
      outcome:  valid_event_attributes
    }
  end

  let(:valid_choice) do
    Fabricate(:choice, decision: 'First decision', event: default_event)
  end

  let(:invalid_attributes) do
    {
      decision: nil,
      event_id: nil,
      outcome:  valid_event_attributes
    }
  end

  let(:invalid_event_attributes) do
    {
      title: nil,
      description: nil
    }
  end

  let(:user) { Fabricate(:user) }


  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns all choices as @choices' do
      choice = valid_choice
      get :index, event_params
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
      get :new, event_params
      expect(assigns(:choice)).to be_a_new(choice_class)
    end

    it "assigns the parent event's adventure to @adventure" do
      get :new, event_params
      expect(assigns(:adventure)).to eq(default_event.adventure)
    end
  end


  describe 'GET #edit' do
    it 'assigns the requested choice as @choice' do
      choice = valid_choice
      get :edit, id: choice.to_param
      expect(assigns(:choice)).to eq(choice)
    end
  end


  describe 'POST #create' do
    before(:each) do
      default_event
    end

    context 'with valid params' do
      it 'creates a new choice_class' do
        expect {
          post :create, event_params.merge(choice: valid_attributes)
        }.to change(choice_class, :count).by(1)
      end

      it 'creates a new outcome event' do
        expect {
          post :create, event_params.merge(choice: valid_attributes)
        }.to change(event_class, :count).by(1)
      end

      it 'assigns a newly created choice as @choice' do
        post :create, event_params.merge(choice: valid_attributes)
        expect(assigns(:choice)).to be_a(choice_class)
        expect(assigns(:choice)).to be_persisted
      end

      it 'redirects to the created choice' do
        post :create, event_params.merge(choice: valid_attributes)
        expect(response).to redirect_to(choice_class.last)
      end
    end


    context 'with invalid choice params' do
      it 'assigns a newly created but unsaved choice as @choice' do
        post :create, event_params.merge(choice: invalid_attributes)
        expect(assigns(:choice)).to be_a_new(choice_class)
      end

      it "re-renders the 'new' template" do
        post :create, event_params.merge(choice: invalid_attributes)
        expect(response).to render_template('new')
      end
    end


    context 'with invalid outcome event params' do
      let(:valid_choice_invalid_event) do
        valid_attributes.merge(outcome: invalid_event_attributes)
      end

      it 'assigns a newly created but unsaved choice as @choice' do
        post :create, event_params.merge(choice: valid_choice_invalid_event)
        expect(assigns(:choice)).to be_a_new(choice_class)
      end

      it "re-renders the 'new' template" do
        post :create, event_params.merge(choice: valid_choice_invalid_event)
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
          outcome:    {
            title:        'Other title',
            description:  'Schwuppdiwupp',
            adventure_id: default_event.adventure.to_param
          }
        }
      end

      it 'updates the requested choice' do
        choice = valid_choice
        old_outcome_id = choice.outcome.id
        put :update, id: choice.to_param, choice: new_attributes
        choice.reload
        expect(choice.decision).to    eq(new_attributes[:decision])
        expect(choice.event.id).to    eq(new_attributes[:event_id])
        expect(choice.outcome.id).to  eq(old_outcome_id)
        expect(choice.outcome.title).to eq(new_attributes[:outcome][:title])
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
      }.to change(choice_class, :count).by(-1)
    end

    it 'redirects to the choices list' do
      choice = valid_choice
      delete :destroy, id: choice.to_param
      expect(response).to redirect_to(event_choices_url(default_event))
    end
  end
end
