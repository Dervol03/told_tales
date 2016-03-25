require 'rails_helper'

RSpec.describe EventsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/adventures/1/events')
        .to route_to('events#index', adventure_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/adventures/1/events/new')
        .to route_to('events#new', adventure_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/events/1')
        .to route_to('events#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/events/1/edit')
        .to route_to('events#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/adventures/1/events')
        .to route_to('events#create', adventure_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/events/1')
        .to route_to('events#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/events/1')
        .to route_to('events#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/events/1')
        .to route_to('events#destroy', id: '1')
    end

    it 'routes to #ready' do
      expect(put: '/events/1/ready')
        .to route_to('events#ready', id: '1')
    end

    it 'routes to #custom_choice' do
      expect(post: 'events/1/custom_choice')
        .to route_to('events#add_custom_choice', id: '1')
    end
  end
end
