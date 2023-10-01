require 'rails_helper'

RSpec.describe QuantitiesController, type: :controller do

  let(:user_credentials) do
    {
      user: {
        email: 'alvoronin2015@yandex.ru',
        password: 'qwer1234'
      }
    }
  end
  describe 'GET #index' do
    it 'returns a PDF file' do

      post 'users/login', params: user_credentials
      expect(response).to have_http_status(:success)
      token = response['data']

      # Include the token in the request headers
      request.headers['Authorization'] = "Bearer #{token}"
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/pdf')
    end
  end

  describe 'GET #show' do
    let(:quantity) { FactoryBot.create(:quantity) }

    it 'returns a success response' do
      get :show, params: { id: quantity.id }
      expect(response).to be_successful
    end
  end


  describe 'POST #create' do
    before do
      # user_login is defined in controller_helpers.rb
      @token= user_login(1)
      request.headers['Authorization'] = "Bearer #{@token}"
    end

    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          value_name: 'Sample Value',
          symbol: 'symbol',
          m_indicate_auto: 0,
          l_indicate_auto: 1,
          t_indicate_auto: 2,
          i_indicate_auto: 3,
          unit: 'Unit',
          l_indicate: 1,
          t_indicate: 2,
          id_gk: 1
        }
      end

      it 'creates a new quantity' do
        expect {
          post :create, params: { quantity: valid_attributes }
        }.to change(Quantity, :count).by(1)
      end

      it 'returns a 201 status code' do
        post :create, params: { quantity: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          value_name: nil,
          amount: 10
        }
      end

      it 'does not create a new quantity' do
        expect {
          post :create, params: { quantity: invalid_attributes }
        }.to_not change(Quantity, :count)
      end

      it 'returns an unprocessable entity status code' do
        post :create, params: { quantity: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe 'PUT #update' do
    let(:quantity) { FactoryBot.create(:quantity) }

    context 'with valid parameters' do
      let(:new_attributes) { FactoryBot.attributes_for(:quantity, value_name: 'New Value Name') }

      it 'updates the requested quantity' do
        put :update, params: { id: quantity.id, quantity: new_attributes }
        quantity.reload
        expect(quantity.value_name).to eq('New Value Name')
      end

      it 'returns a success response' do
        put :update, params: { id: quantity.id, quantity: new_attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:quantity, value_name: nil) }

      it 'returns an unprocessable entity status code' do
        put :update, params: { id: quantity.id, quantity: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:quantity) { FactoryBot.create(:quantity) }

    it 'destroys the requested quantity' do
      expect {
        delete :destroy, params: { id: quantity.id }
      }.to change(Quantity, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { id: quantity.id }
      expect(response).to be_successful
    end
  end
end
