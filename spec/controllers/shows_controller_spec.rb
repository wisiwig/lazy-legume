require 'rails_helper'

RSpec.describe ShowsController, type: :controller do
  describe 'get index' do
    it 'gets all the shows and renders the index template' do
      create_list(:show, 5)
      get :index
      expect(assigns(:shows).first).to be_a(Show)
      expect(assigns(:shows).count).to eq(5)
      expect(response).to render_template(:index)
    end
  end

  describe 'get show' do
    it 'gets the right show' do
      show = create(:show)
      get :show, id: show.id

      expect(assigns(:show)).to eq(show)
    end

    it 'gets a sorted list of episodes for the show' do
      show = create(:show_with_episodes)
      get :show, id: show.id

      expect(assigns(:episodes)).to eq(show.episodes.order(:season, :ep_in_season))
    end
  end

  describe 'get new' do
    it 'instantiates a new show' do
      get :new
      expect(assigns(:show)).to be_a(Show)
      expect(response).to render_template(:new)
    end
  end

  describe 'post tvdb_search' do
    it 'uses the tvdb service to search for the show' do
      client_double = double
      expect(client_double).to receive(:search).and_return('hello')
      expect(Tvdb).to receive(:new).and_return(client_double)

      post :tvdb_search, format: :js
      expect(assigns(:shows)).to eq('hello')
      expect(response).to render_template(:tvdb_search)
    end
  end

  describe 'put create' do
    it 'creates a new show and rule with the given params' do
      create(:feed)

      params = {
        show: {
          name: 'test show',
          tvdb_id: 1234,
          rule: {
            quality: '1080'
          }
        }
      }

      expect { put :create, params }.to change { Show.count }.by(1)
      expect(assigns(:show)).to be_a(Show)
      expect(assigns(:show).name).to eq('test show')
      expect(assigns(:show).rules.first.quality).to eq('1080')
      expect(response).to redirect_to(assigns(:show))
    end
  end

  describe 'delete destroy' do
    it 'deletes the show' do
      show = create(:show)
      expect { delete :destroy, id: show.id }.to change { Show.count }.by(-1)
    end
  end
end
