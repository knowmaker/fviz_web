require 'rails_helper'

RSpec.describe QuantitiesController, type: :controller do
  before do
    @token= user_login(1)
    request.headers['Authorization'] = "Bearer #{@token}"
  end

  describe 'GET #index' do
    it 'returns a PDF file' do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/pdf')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: 1, id_gk: 1)

      get :show, params: { id: quantity.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
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

      it 'does not create a new quantity if lt does not exist' do
        invalid_attributes = {
          value_name: 'Sample Value',
          symbol: 'symbol',
          l_indicate_auto: 1,
          t_indicate_auto: 2,
          i_indicate_auto: 3,
          unit: 'Unit',
          l_indicate: 99,
          t_indicate: 99,
          id_gk: 1
        }

        expect {
          post :create, params: { quantity: invalid_attributes }
        }.to_not change(Quantity, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) do
      {
        value_name: 'New Value',
        symbol: 'symbol',
        l_indicate_auto: 1,
        t_indicate_auto: 2,
        i_indicate_auto: 3,
        unit: 'Unit',
        l_indicate: 1,
        t_indicate: 2,
        id_gk: 1
      }
    end
    it 'updates the requested quantity' do
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: 1, id_gk: 1)

      put :update, params: { id: quantity.id, quantity: new_attributes }
      quantity.reload
      expect(quantity.value_name).to eq('New Value')
    end

    it 'returns a success response' do
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: 1, id_gk: 1)

      put :update, params: { id: quantity.id, quantity: new_attributes }
      expect(response).to be_successful
    end

    it 'returns an unprocessable entity status code with invalid params' do
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: 1, id_gk: 1)

      invalid_attributes = {
        value_name: 'New Value',
        symbol: 'symbol',
        l_indicate_auto: 1,
        t_indicate_auto: 2,
        i_indicate_auto: 3,
        unit: 'Unit',
        l_indicate: 1,
        t_indicate: 2,
        id_gk: nil
      }

      put :update, params: { id: quantity.id, quantity: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns a not found response  if quantity does not exist' do
      put :update, params: { id: 0, quantity: { value_name: 'New Value' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested quantity' do
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: 1, id_gk: 1)

      expect {
        delete :destroy, params: { id: quantity.id }
      }.to change(Quantity, :count).by(-1)
    end

    it 'returns a success response' do
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: 1, id_gk: 1)

      delete :destroy, params: { id: quantity.id }
      expect(response).to be_successful
    end

    it 'returns a not found response if quantity does not exist' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #lt_values' do
    it 'returns quantities associated with a specific lt' do
      lt = Lt.create(l_indicate: 1, t_indicate: 2)
      quantity = Quantity.create(value_name: 'Sample Value', symbol: 'symbol', m_indicate_auto: 0,
                                 l_indicate_auto: 1, t_indicate_auto: 2, i_indicate_auto: 3,
                                 unit: 'Unit', id_lt: lt.id, id_gk: 1)

      get :lt_values, params: { id: lt.id }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].first['id_value']).to eq(quantity.id_value)
    end

    it 'returns an empty array if no quantities are associated with the lt' do
      lt = Lt.create(l_indicate: 1, t_indicate: 2)
      get :lt_values, params: { id: lt.id }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']).to be_empty
    end

    it 'returns a not found response if lt does not exist' do
      get :lt_values, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
