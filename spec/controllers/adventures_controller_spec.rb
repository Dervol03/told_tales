require 'rails_helper'

describe AdventuresController, type: :controller do
  let(:adventure_class) { Adventure }

  before(:each) do
    sign_in_with_role :user
  end


  let(:valid_attributes) do
    {
      name:    'My Super adventure_class',
      setting: 'In a dark room',
      owner:    User.last
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

  describe 'GET #index' do
    it 'assigns all adventures as @adventures' do
      adventure = valid_adventure
      get :index
      expect(assigns(:adventures)).to eq([adventure])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested adventure as @adventure' do
      adventure = valid_adventure
      get :show, {:id => adventure.to_param}
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
      get :edit, {:id => adventure.to_param}
      expect(assigns(:adventure)).to eq(adventure)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new adventure_class' do
        expect {
          post :create, {:adventure => valid_attributes}
        }.to change(adventure_class, :count).by(1)
      end

      it 'assigns a newly created adventure as @adventure' do
        post :create, {:adventure => valid_attributes}
        expect(assigns(:adventure)).to be_a(adventure_class)
        expect(assigns(:adventure)).to be_persisted
      end

      it 'redirects to the created adventure' do
        post :create, {:adventure => valid_attributes}
        expect(response).to redirect_to(adventure_class.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved adventure as @adventure' do
        post :create, {:adventure => invalid_attributes}
        expect(assigns(:adventure)).to be_a_new(adventure_class)
      end

      it "re-renders the 'new' template" do
        post :create, {:adventure => invalid_attributes}
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
        {:id => valid_adventure.to_param, :adventure => new_attributes}
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
          :id => valid_adventure.to_param,
          :adventure => invalid_attributes
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
    it 'destroys the requested adventure' do
      adventure = valid_adventure
      expect {
        delete :destroy, {:id => adventure.to_param}
      }.to change(adventure_class, :count).by(-1)
    end

    it 'redirects to the adventures list' do
      adventure = valid_adventure
      delete :destroy, {:id => adventure.to_param}
      expect(response).to redirect_to(adventures_url)
    end
  end

end
