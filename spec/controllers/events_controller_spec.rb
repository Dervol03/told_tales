require 'rails_helper'

describe EventsController, type: :controller, wip: true do
  let(:user)              { Fabricate(:user)                   }
  let(:default_adventure) { Fabricate(:adventure, owner: user) }
  let(:event_class)       { Event                              }

  let(:valid_attributes) do
    {
      title:        'Some title',
      description:  'Awesome text',
      adventure:    default_adventure
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      description: nil
    }
  end

  let(:valid_event) { Fabricate(:event, valid_attributes) }

  before(:each) do
    sign_in user
  end


  describe 'GET #index' do
    it 'assigns all events as @events' do
      event = valid_event
      get :index
      expect(assigns(:events)).to eq([event])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested event as @event' do
      event = valid_event
      get :show, id: event.to_param
      expect(assigns(:event)).to eq(event)
    end
  end

  describe 'GET #new' do
    it 'assigns a new event as @event' do
      get :new
      expect(assigns(:event)).to be_a_new(event_class)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested event as @event' do
      event = valid_event
      get :edit, id: event.to_param
      expect(assigns(:event)).to eq(event)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Event' do
        expect {
          post :create, event: valid_attributes
        }.to change(event_class, :count).by(1)
      end

      it 'assigns a newly created event as @event' do
        post :create, event: valid_attributes
        expect(assigns(:event)).to be_a(event_class)
        expect(assigns(:event)).to be_persisted
      end

      it 'redirects to the created event' do
        post :create, event: valid_attributes
        expect(response).to redirect_to(event_class.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved event as @event' do
        post :create, event: invalid_attributes
        expect(assigns(:event)).to be_a_new(event_class)
      end

      it "re-renders the 'new' template" do
        post :create, event: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          title:       'Other title',
          description: 'Other description',
        }
      end

      it 'updates the requested event' do
        event = valid_event
        put :update, id: event.to_param, event: new_attributes
        event.reload
        expect(event.title).to eq new_attributes[:title]
        expect(event.description).to eq new_attributes[:description]
      end

      it 'assigns the requested event as @event' do
        event = valid_event
        put :update, id: event.to_param, event: valid_attributes
        expect(assigns(:event)).to eq(event)
      end

      it 'redirects to the event' do
        event = valid_event
        put :update, id: event.to_param, event: valid_attributes
        expect(response).to redirect_to(event)
      end
    end

    context 'with invalid params' do
      it 'assigns the event as @event' do
        event = valid_event
        put :update, id: event.to_param, event: invalid_attributes
        expect(assigns(:event)).to eq(event)
      end

      it "re-renders the 'edit' template" do
        event = valid_event
        put :update, id: event.to_param, event: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested event' do
      event = valid_event
      expect {
        delete :destroy, id: event.to_param
      }.to change(event_class, :count).by(-1)
    end

    it 'redirects to the events list' do
      event = valid_event
      delete :destroy, id: event.to_param
      expect(response).to redirect_to(events_url)
    end
  end
end
