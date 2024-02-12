# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepresentsController, type: :controller do
  before do
    @token = user_login(1)
    request.headers['Authorization'] = "Bearer #{@token}"
    @user = User.find_by(id_user: 1)

    Represent.destroy_all
  end

  describe 'GET #index' do
    it 'returns a list of represents for the current user' do
      represent1 = @user.represents.create(title: 'Sample title', active_quantities: [1, 2, 3, 4, 5, 6, 7])
      represent2 = @user.represents.create(title: 'Sample title2', active_quantities: [1, 2, 3, 4, 5, 6, 7])

      get :index
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)

      expect(parsed_response['data'][1]['id_repr']).to eq(represent1.id_repr)
      expect(parsed_response['data'][2]['id_repr']).to eq(represent2.id_repr)
    end

    it 'returns an empty list if the user has no represents' do
      get :index
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].count).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a specific represent for the current user' do
      represent = @user.represents.create(title: 'Sample title', active_quantities: [1, 2, 3, 4, 5, 6, 7])
      get :show, params: { id: represent.id_repr }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['id_repr']).to eq(represent.id_repr)
    end

    it 'returns a not found response if represent does not exist' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    it 'creates a new represent for the current user' do
      expect do
        post :create, params: { represent: { title: 'New Represent', active_quantities: [1, 2] } }
      end.to change(Represent, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns unprocessable entity status with invalid params' do
      post :create, params: { represent: { title: nil, active_quantities: [1, 2] } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    it 'updates the requested represent' do
      represent = @user.represents.create(title: 'Sample title', active_quantities: [1, 2, 3, 4, 5, 6, 7])

      put :update, params: { id: represent.id_repr, represent: { title: 'Updated Represent' } }
      expect(response).to have_http_status(:ok)

      represent.reload
      expect(represent.title).to eq('Updated Represent')
    end

    it 'returns unprocessable entity status with invalid params' do
      represent = @user.represents.create(title: 'Sample title', active_quantities: [1, 2, 3, 4, 5, 6, 7])

      put :update, params: { id: represent.id_repr, represent: { title: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns a not found response if represent does not exist' do
      put :update, params: { id: 999, represent: { title: 'Updated Represent' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested represent' do
      represent = @user.represents.create(title: 'Sample title', active_quantities: [1, 2, 3, 4, 5, 6, 7])
      expect do
        delete :destroy, params: { id: represent.id_repr }
      end.to change(Represent, :count).by(-1)
    end

    it 'returns a success response' do
      represent = Represent.create(title: 'Sample Represent', id_user: 1, active_quantities: [1, 2])
      delete :destroy, params: { id: represent.id_repr }
      expect(response).to be_successful
    end

    it 'returns a not found response if represent does not exist' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #represent_view_index' do
    it 'returns the active quantities for user' do
      get :represent_view_index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']).not_to be_empty
    end
  end

  describe 'GET #represent_view_show' do
    it 'returns the active quantities for a specific represent' do
      represent = @user.represents.create(title: 'Sample title', active_quantities: [1, 2, 3, 4, 5, 6, 7])

      get :represent_view_show, params: { id: represent.id_repr }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['id_repr']).to eq(represent.id_repr)
    end

    it 'returns a not found response if represent does not exist' do
      get :represent_view_show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
