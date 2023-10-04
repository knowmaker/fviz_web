require 'rails_helper'

RSpec.describe LawTypesController, type: :controller do
  before do
    @token = user_login(1)
    request.headers['Authorization'] = "Bearer #{@token}"
  end

  describe 'GET #index' do
    it 'returns a list of law types' do
      law_type = LawType.create(type_name: 'Sample Type', color: 'Red')
      get :index
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].last['id_type']).to eq(law_type.id_type)
    end
  end

  describe 'GET #show' do
    it 'returns a specific law type' do
      law_type = LawType.create(type_name: 'Sample Type', color: 'Red')
      get :show, params: { id: law_type.id_type }
      expect(response).to be_successful
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']['id_type']).to eq(law_type.id_type)
    end

    it 'returns a not found response if law type does not exist' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          type_name: 'Sample Type',
          color: 'Red'
        }
      end

      it 'creates a new law type' do
        expect {
          post :create, params: { law_type: valid_attributes }
        }.to change(LawType, :count).by(1)
      end

      it 'returns a 201 status code' do
        post :create, params: { law_type: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          type_name: nil,
          color: 'Red'
        }
      end

      it 'does not create a new law type' do
        expect {
          post :create, params: { law_type: invalid_attributes }
        }.to_not change(LawType, :count)
      end

      it 'returns an unprocessable entity status code' do
        post :create, params: { law_type: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:law_type) do
      LawType.create(type_name: 'Sample Type', color: 'Red')
    end

    context 'with valid parameters' do
      let(:new_attributes) do
        {
          type_name: 'New Type',
          color: 'Blue'
        }
      end

      it 'updates the requested law type' do
        put :update, params: { id: law_type.id_type, law_type: new_attributes }
        law_type.reload
        expect(law_type.type_name).to eq('New Type')
      end

      it 'returns a success response' do
        put :update, params: { id: law_type.id_type, law_type: new_attributes }
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          type_name: nil,
          color: 'Blue'
        }
      end

      it 'returns an unprocessable entity status code' do
        put :update, params: { id: law_type.id_type, law_type: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a not found response if law type does not exist' do
        put :update, params: { id: 999, law_type: { type_name: 'New Type' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested law type' do
      law_type = LawType.create(type_name: 'Sample Type', color: 'Red')
      expect {
        delete :destroy, params: { id: law_type.id_type }
      }.to change(LawType, :count).by(-1)
    end

    it 'returns a success response' do
      law_type = LawType.create(type_name: 'Sample Type', color: 'Red')
      delete :destroy, params: { id: law_type.id_type }
      expect(response).to be_successful
    end

    it 'returns a not found response if law type does not exist' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
