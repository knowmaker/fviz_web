require 'rails_helper'

RSpec.describe LtController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].count).to eq(410)
    end
  end
end
