require 'rails_helper'

RSpec.describe GkController, type: :controller do
  before do
    @token = user_login(1)
    request.headers['Authorization'] = "Bearer #{@token}"
  end

  describe 'GET #index' do
    it 'returns a list of gks' do
      get :index

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].count).to eq(14)
    end
  end

  describe 'GET #show' do
    it 'returns the requested gk' do
      gk = Gk.create(g_indicate: 1, k_indicate: 2, gk_name: 'GK1', gk_sign: 'Sign 1', color: 'Red')

      get :show, params: { id: gk.id_gk }
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']['id_gk']).to eq(gk.id_gk)
    end

    it 'returns a not found response if gk does not exist' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT #update' do
    let(:gk) do
      Gk.create(g_indicate: 1, k_indicate: 2, gk_name: 'GK1', gk_sign: 'Sign 1', color: 'Red')
    end

    let(:valid_attributes) do
      {
        gk_name: 'Updated GK',
        color: 'Green'
      }
    end

    it 'updates the requested gk' do
      put :update, params: { id: gk.id_gk, gk: valid_attributes }
      gk.reload
      expect(gk.gk_name).to eq('Updated GK')
      expect(gk.color).to eq('Green')
    end

    it 'returns a success response' do
      put :update, params: { id: gk.id_gk, gk: valid_attributes }
      expect(response).to have_http_status(:ok)
    end

    it 'returns an unprocessable entity status code with invalid params' do
      put :update, params: { id: gk.id_gk, gk: { color: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns a not found response if gk does not exist' do
      put :update, params: { id: 999, gk: valid_attributes }
      expect(response).to have_http_status(:not_found)
    end
  end
end
