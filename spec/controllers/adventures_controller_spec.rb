require 'rails_helper'

describe AdventuresController, type: :controller do
  let(:adventure_class) { Adventure         }
  let(:user)            { Fabricate(:user)  }
  let(:admin)           { Fabricate(:admin) }
  let(:valid_attributes) do
    {
      name:     'My Super adventure_class',
      setting:  'In a dark room',
      owner:    user,
      owner_id: user.id
    }
  end
  let(:invalid_attributes) do
    {
      name:     nil,
      setting:  'schickedieschnick, die Zeit hat nen Knick'
    }
  end
  let(:valid_adventure)   { Fabricate(:adventure, valid_attributes)   }
  let(:invalid_adventure) { adventure_class.new(invalid_attributes)   }

  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    context 'for admins' do
      before(:each) do
        sign_out :user
        sign_in admin
      end

      it 'assigns all adventures as @adventures' do
        adventures = [
          Fabricate(:adventure),
          Fabricate(:adventure, started: true),
          Fabricate(:adventure, owner: user)
        ]

        get :index
        expect(assigns(:adventures)).to eq(adventures)
      end
    end # for admins


    context 'for normal users' do
      it 'assigns all owned adventures as @adventure' do
        user_adv = [
          Fabricate(:adventure),
          Fabricate(:adventure),
          Fabricate(:adventure, owner: user, started: true)
        ]
        Fabricate(:adventure, started: true)

        get :index
        expect(assigns(:adventures)).to eq(user_adv)
      end
    end # for normal users
  end


  describe 'GET #show' do
    it 'assigns the requested adventure as @adventure' do
      adventure = valid_adventure
      get :show, id: adventure.to_param
      expect(assigns(:adventure)).to eq(adventure)
    end
  end


  describe 'GET #new' do
    it 'assigns a new adventure as @adventure' do
      get :new
      expect(assigns(:adventure)).to be_a_new(adventure_class)
    end
  end


  describe 'GET #edit' do
    it 'assigns the requested adventure as @adventure' do
      adventure = valid_adventure
      get :edit, id: adventure.to_param
      expect(assigns(:adventure)).to eq(adventure)
    end
  end


  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new adventure_class' do
        expect {
          post :create, adventure: valid_attributes
        }.to change(adventure_class, :count).by(1)
      end

      it 'assigns a newly created adventure as @adventure' do
        post :create, adventure: valid_attributes
        expect(assigns(:adventure)).to be_a(adventure_class)
        expect(assigns(:adventure)).to be_persisted
      end

      it 'redirects to the created adventure' do
        post :create, adventure: valid_attributes
        expect(response).to redirect_to(adventure_class.last)
      end
    end


    context 'with invalid params' do
      it 'assigns a newly created but unsaved adventure as @adventure' do
        post :create, adventure: invalid_attributes
        expect(assigns(:adventure)).to be_a_new(adventure_class)
      end

      it "re-renders the 'new' template" do
        post :create, adventure: invalid_attributes
        expect(response).to render_template('new')
      end
    end
  end


  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name:    'Ladida',
          setting: 'some other setting'
        }
      end
      let(:valid_hash) do
        {id: valid_adventure.to_param, adventure: new_attributes}
      end

      it 'updates the requested adventure' do
        put :update, valid_hash
        valid_adventure.reload
        expect(valid_adventure.name).to eq(new_attributes[:name])
        expect(valid_adventure.setting).to eq(new_attributes[:setting])
      end

      it 'assigns the requested adventure as @adventure' do
        put :update, valid_hash
        expect(assigns(:adventure)).to eq(valid_adventure)
      end

      it 'redirects to the adventure' do
        put :update, valid_hash
        expect(response).to redirect_to(valid_adventure)
      end
    end


    context 'with invalid params' do
      let(:invalid_hash) do
        {
          id:         valid_adventure.to_param,
          adventure:  invalid_attributes
        }
      end

      it 'assigns the adventure as @adventure' do
        put :update, invalid_hash
        expect(assigns(:adventure)).to eq(valid_adventure)
      end

      it "re-renders the 'edit' template" do
        put :update, invalid_hash
        expect(response).to render_template('edit')
      end
    end
  end


  describe 'DELETE #destroy' do
    before(:each) do
      request.env['HTTP_REFERER'] = adventures_url
    end

    it 'destroys the requested adventure' do
      adventure = valid_adventure
      expect {
        delete :destroy, id: adventure.to_param
      }.to change(adventure_class, :count).by(-1)
    end

    it 'redirects to the adventures list' do
      adventure = valid_adventure
      delete :destroy, id: adventure.to_param
      expect(response).to redirect_to(adventures_url)
    end
  end


  describe 'PUT #join' do
    let(:adventure) { @adventure }

    before(:each) do
      @adventure = valid_adventure
    end

    context 'desired role is still vacant' do
      it 'assigns signed in user as adventure player' do
        put :join, id: adventure.to_param, role: :player
        adventure.reload

        expect(response).to redirect_to adventures_url
        expect(adventure.player).to eq user
      end

      it 'assigns signed in user as adventure master' do
        put :join, id: adventure.to_param, role: :master
        adventure.reload

        expect(response).to redirect_to adventures_url
        expect(adventure.master).to eq user
      end
    end # a role is still vacant


    context 'desired role is taken' do
      it 'prevents joining' do
        adventure.master = Fabricate(:user)
        adventure.save!

        put :join, id: adventure.to_param, role: :master
        adventure.reload

        expect(response).to redirect_to adventures_url
        expect(adventure.master).not_to eq user
      end
    end # all roles are taken
  end # PUT join


  describe 'GET #play' do
    let(:adventure) { valid_adventure }

    context 'user is adventure player' do
      before(:each) do
        adventure.update!(player: user)
      end

      context 'adventure is not ready to play yet' do
        it 'redirects to #index' do
          get :play, id: adventure.to_param
          expect(response).to redirect_to adventures_url
        end
      end # adventure is not ready to play yet


      context 'adventure is ready to play' do
        let(:ready_event) do
          Fabricate(:event, adventure: adventure, ready: true)
        end

        before(:each) do
          ready_event
        end

        it 'shows the adventure play page' do
          get :play, id: adventure.to_param
          expect(response.status).to be 200
          expect(response).to render_template :play
        end

        it 'provides last 2 events' do
          last_events = [
            Fabricate(:event, adventure: adventure),
            Fabricate(:event, adventure: adventure),
            Fabricate(:event, adventure: adventure)
          ]
          last_events.each { |event| event.update!(visited: true) }

          get :play, id: adventure.to_param
          expect(assigns(:last_events)).to eq(last_events[-2..-1])
        end

        it 'provides the current event' do
          current_event = ready_event
          adventure.update!(current_event: current_event)

          get :play, id: adventure.to_param
          expect(assigns(:current_event)).to eq current_event
        end


        context 'adventure has not started yet' do
          before(:each) do
            Fabricate(:event, adventure: adventure, ready: true)
          end

          it 'starts the adventure' do
            get :play, id: adventure.to_param
            adventure.reload
            expect(adventure).to be_started
          end
        end # adventure has not started yet
      end # adventure is ready to play
    end # user is adventure player


    context 'user is adventure master' do
      before(:each) do
        adventure.update!(master: user)
      end

      it 'prohibits access' do
        get :play, id: adventure.to_param
        expect(response.status).to eq 401
        expect(response).to render_template error_401_template
      end
    end # user is adventure master
  end # GET #play


  describe 'PUT #next_event' do
    let(:adventure) { valid_adventure }

    context 'user is adventure player' do
      let(:current_event) { @current_event }

      before(:each) do
        @current_event = Fabricate(:event, adventure: adventure)
        adventure.update!(player: user, current_event: current_event)
      end

      it 'moves to the next event' do
        past_event = Fabricate(:event, adventure: adventure)
        past_event.update!(visited: true)
        next_event = Fabricate(
          :event,
          adventure: adventure,
          previous_event: current_event,
          ready: true
        )

        put :next_event, id: adventure.to_param

        current_event.reload
        next_event.reload
        expect(current_event.visited).to be true
        expect(next_event.current_event_id).to be_present
      end

      it 'redirects to #play' do
        put :next_event, id: adventure.to_param
        expect(subject).to redirect_to play_adventure_url
      end
    end # user is adventure player


    context 'user is adventure master' do
      before(:each) do
        adventure.update!(master: user)
      end

      it 'prohibits access' do
        put :next_event, id: adventure.to_param
        expect(response.status).to eq 401
        expect(response).to render_template error_401_template
      end
    end # user is adventure master
  end # GET #next_event
end
