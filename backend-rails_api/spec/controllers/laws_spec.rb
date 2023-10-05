require 'rails_helper'

RSpec.describe LawsController, type: :controller do
  before do
    @token = user_login(1)
    request.headers['Authorization'] = "Bearer #{@token}"
    @user = User.find_by(id_user: 1)

    Law.destroy_all
    LawType.destroy_all
    LawType.create(id_type: 1, type_name: 'Name', color: 'Red')
  end

  describe 'GET #index' do
    it 'returns a list of laws for the current user' do
      law1 = @user.laws.create(law_name: 'Sample name', first_element: 1, second_element: 2, third_element: 3, fourth_element: 4,
                        id_type: 1)
      law2 = @user.laws.create(law_name: 'Another name', first_element: 5, second_element: 6, third_element: 7, fourth_element: 8,
                        id_type: 1)

      get :index
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data'].count).to eq(2)

      expect(parsed_response['data'][0]['id_law']).to eq(law1.id_law)
      expect(parsed_response['data'][1]['id_law']).to eq(law2.id_law)
    end

    it 'returns an empty list if the user has no laws' do
      get :index
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']).to be_empty
    end
  end

  describe 'GET #show' do
    it 'returns the details of a law for the current user' do
      law = @user.laws.create(law_name: 'Sample name', first_element: 1, second_element: 2, third_element: 3, fourth_element: 4,
                               id_type: 1)

      get :show, params: { id: law.id_law }
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']['id_law']).to eq(law.id_law)
    end

    it 'returns a not found response if the law does not exist' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    it 'creates a new law' do
      law_params = {
        law_name: 'Test Law',
        first_element: 1,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_type: 1
      }

      expect {
        post :create, params: { law: law_params }
      }.to change(Law, :count).by(1)

      expect(response).to have_http_status(:created)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['data']['law_name']).to eq('Test Law')
    end

    it 'returns an unprocessable entity status code with invalid params' do
      invalid_law_params = {
        law_name: 'Test Law',
        first_element: nil,
        second_element: 2,
        third_element: 3,
        fourth_element: 4,
        id_type: 1
      }

      post :create, params: { law: invalid_law_params }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    it 'updates the requested law' do
      law = @user.laws.create(law_name: 'Sample name', first_element: 1, second_element: 2, third_element: 3, fourth_element: 4,
                               id_type: 1)
      new_law_name = 'Updated Law'

      put :update, params: { id: law.id_law, law: { law_name: new_law_name } }
      expect(response).to have_http_status(:ok)

      law.reload
      expect(law.law_name).to eq(new_law_name)
    end

    it 'returns an unprocessable entity status code with invalid params' do
      law = @user.laws.create(law_name: 'Sample name', first_element: 1, second_element: 2, third_element: 3, fourth_element: 4,
                               id_type: 1)

      put :update, params: { id: law.id_law, law: { first_element: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns a not found response if the law does not exist' do
      put :update, params: { id: 999, law: { law_name: 'Updated Law' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested law' do
      law = @user.laws.create(law_name: 'Sample name', first_element: 1, second_element: 2, third_element: 3, fourth_element: 4,
                               id_type: 1)

      expect {
        delete :destroy, params: { id: law.id_law }
      }.to change(Law, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end

    it 'returns a not found response if the law does not exist' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
