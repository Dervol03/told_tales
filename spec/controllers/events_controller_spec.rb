require 'rails_helper'

describe EventsController, type: :controller do
  let(:user)              { Fabricate(:user)                   }
  let(:default_adventure) { Fabricate(:adventure, owner: user) }
  let(:event_class)       { Event                              }

  let(:valid_attributes) do
    {
      title:        'Some title',
      description:  'Awesome text',
      adventure_id: default_adventure.to_param
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      description: nil
    }
  end

  let(:valid_event)       { Fabricate(:event, valid_attributes)         }
  let(:adventure_param)   { {adventure_id: default_adventure.to_param}  }
  let(:collection_route)  { adventure_events_url(default_adventure)     }


  before(:each) do
    sign_in user
  end

  context 'user is adventure master' do
    before(:each) do
      default_adventure.update!(master: user)
    end


    describe 'GET #index' do
      it 'assigns all events as @events' do
        event = valid_event
        get :index, adventure_param
        expect(assigns(:events)).to eq([event])
      end
    end


    describe 'GET #show' do
      it 'assigns the requested event as @event' do
        event = valid_event
        get :show, adventure_param.deep_merge(id: event.to_param)
        expect(assigns(:event)).to eq(event)
      end
    end


    context 'with a connection to other events' do
      let(:free_events) { @free_events }

      before(:each) do
        @free_events = [
          Fabricate(:event, adventure: default_adventure),
          Fabricate(:event, adventure: default_adventure)
        ]
      end


      describe 'GET #new' do
        it 'assigns a new event as @event' do
          get :new, adventure_param
          expect(assigns(:event)).to be_a_new(event_class)
          expect(assigns(:unfollowed_events)).to eq(free_events)
        end
      end


      describe 'GET #edit' do
        it 'assigns the requested event as @event' do
          event = valid_event
          get :edit, adventure_param.deep_merge(id: event.to_param)
          expect(assigns(:event)).to eq(event)
          expect(assigns(:unfollowed_events)).to eq(free_events)
        end
      end
    end # with a connection to other events


    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Event' do
          expect {
            post :create, adventure_param.merge(event: valid_attributes)
          }.to change(event_class, :count).by(1)
        end

        it 'assigns a newly created event as @event' do
          post :create, adventure_param.merge(event: valid_attributes)
          expect(assigns(:event)).to be_a(event_class)
          expect(assigns(:event)).to be_persisted
        end

        it 'redirects to the created event' do
          post :create, adventure_param.merge(event: valid_attributes)
          expect(response).to redirect_to(
            adventure_events_url(default_adventure)
          )
        end
      end


      context 'with invalid params' do
        it 'assigns a newly created but unsaved event as @event' do
          post :create, adventure_param.merge(event: invalid_attributes)
          expect(assigns(:event)).to be_a_new(event_class)
        end

        it "re-renders the 'new' template" do
          post :create, adventure_param.merge(event: invalid_attributes)
          expect(response).to render_template('new')
        end
      end
    end


    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          {
            title:       'Other title',
            description: 'Other description'
          }
        end

        it 'updates the requested event' do
          event = valid_event
          put(
            :update,
            adventure_param.merge(
              id: event.to_param,
              event: new_attributes
            )
          )
          event.reload
          expect(event.title).to eq new_attributes[:title]
          expect(event.description).to eq new_attributes[:description]
        end

        it 'assigns the requested event as @event' do
          event = valid_event
          put(
            :update,
            adventure_param.merge(
              id: event.to_param,
              event: valid_attributes
            )
          )
          expect(assigns(:event)).to eq(event)
        end

        it 'redirects to the event' do
          event = valid_event
          put(
            :update,
            adventure_param.merge(
              id: event.to_param,
              event: valid_attributes
            )
          )
          event.reload
          expect(response).to redirect_to(event)
        end
      end


      context 'with invalid params' do
        it 'assigns the event as @event' do
          event = valid_event
          put(
            :update,
            adventure_param.merge(
              id: event.to_param,
              event: invalid_attributes
            )
          )
          expect(assigns(:event)).to eq(event)
        end

        it "re-renders the 'edit' template" do
          event = valid_event
          put(
            :update,
            adventure_param.merge(
              id: event.to_param,
              event: invalid_attributes
            )
          )
          expect(response).to render_template('edit')
        end
      end
    end


    describe 'DELETE #destroy' do
      it 'destroys the requested event' do
        event = valid_event
        expect {
          delete :destroy, adventure_param.merge(id: event.to_param)
        }.to change(event_class, :count).by(-1)
      end

      it 'redirects to the events list' do
        event = valid_event
        delete :destroy, adventure_param.merge(id: event.to_param)
        expect(response).to redirect_to(
          adventure_events_url(default_adventure)
        )
      end
    end


    describe 'PUT #ready' do
      it 'makes the event ready' do
        event = valid_event
        expect(event).not_to be_ready

        put :ready, adventure_param.merge(id: event.to_param)
        event.reload
        expect(event).to be_ready
      end

      it 'renders index page' do
        event = valid_event
        put :ready, adventure_param.merge(id: event.to_param)
        expect(response).to render_template :index
      end
    end # PUT #ready
  end # user is adventure master


  context 'usr is adventure player' do
    before(:each) do
      default_adventure.update!(player: user)
    end


    describe 'GET #index' do
      it 'prohibits access' do
        get :index, adventure_param

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end


    describe 'GET #show' do
      it 'assigns the requested event as @event' do
        event = valid_event
        get :show, adventure_param.deep_merge(id: event.to_param)
        expect(assigns(:event)).to eq(event)
      end
    end


    describe 'GET #new' do
      it 'prohibits access' do
        get :new, adventure_param

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end


    describe 'GET #edit' do
      it 'prohibits access' do
        event = valid_event
        get :edit, adventure_param.deep_merge(id: event.to_param)

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end


    describe 'POST #create' do
      it 'prohibits access' do
        post :create, adventure_param.merge(event: valid_attributes)

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end


    describe 'PUT #update' do
      let(:new_attributes) do
        {
          title:       'Other title',
          description: 'Other description'
        }
      end

      it 'prohibits access' do
        event = valid_event
        put(
          :update,
          adventure_param.merge(
            id: event.to_param,
            event: new_attributes
          )
        )

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end


    describe 'DELETE #destroy' do
      it 'prohibits access' do
        event = valid_event
        delete :destroy, adventure_param.merge(id: event.to_param)

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end


    describe 'PUT #ready' do
      it 'prohibits access' do
        event = valid_event
        put :ready, adventure_param.merge(id: event.to_param)

        expect(response.status).to eq 401
        expect(response).to render_template(error_401_template)
      end
    end # PUT #ready
  end # usr is adventure player
end
