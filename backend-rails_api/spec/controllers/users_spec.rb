require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #register' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          email: 'test@example.com',
          password: 'password'
        }
      end

      it 'creates a new user' do
        expect {
          post :register, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'returns a 201 status code' do
        post :register, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          email: 'test@example.com',
          password: 'short'
        }
      end

      it 'does not create a new user' do
        expect {
          post :register, params: { user: invalid_attributes }
        }.to_not change(User, :count)
      end

      it 'returns an unprocessable entity status code' do
        post :register, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { User.create(email: 'test@example.com', password: Argon2::Password.create('password'), confirmed: true) }

    context 'with valid credentials' do
      it 'returns a token' do
        post :login, params: { user: { email: 'test@example.com', password: 'password' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('data')
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized status code' do
        post :login, params: { user: { email: 'test@example.com', password: 'wrongpassword' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #profile' do
    before do
      @user = User.create(email: 'test@example.com', password: Argon2::Password.create('password'), confirmed: true)
      @token = user_login(@user.id_user)
      request.headers['Authorization'] = "Bearer #{@token}"
    end
    it 'returns a success response if quantity exists' do
      get :profile
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    before do
      @user = User.create(email: 'test@example.com', password: Argon2::Password.create('password'), confirmed: true)
      @token = user_login(@user.id_user)
      request.headers['Authorization'] = "Bearer #{@token}"
    end
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          password: 'newpassword',
          last_name: 'UpdatedDoe',
          first_name: 'UpdatedJohn',
          patronymic: 'UpdatedSmith'
        }
      end

      it 'updates the user' do
        put :update, params: { user: valid_attributes }
        @user.reload
        expect(@user.last_name).to eq('UpdatedDoe')
      end

      it 'returns a success response' do
        put :update, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          password: 'short',
          last_name: 'UpdatedDoe',
          first_name: 'UpdatedJohn',
          patronymic: 'UpdatedSmith'
        }
      end

      it 'does not update the user' do
        put :update, params: { user: invalid_attributes }
        @user.reload
        expect(@user.email).to eq('test@example.com')
      end

      it 'returns an unprocessable entity status code' do
        put :update, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #confirm' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password', confirmation_token: 'valid_token') }

    context 'with valid confirmation token' do
      it 'confirms the user' do
        get :confirm, params: { id: user.id_user, confirmation_token: 'valid_token' }
        user.reload
        expect(user.confirmed).to be(true)
      end

      it 'returns a success response' do
        get :confirm, params: { id: user.id_user, confirmation_token: 'valid_token' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid confirmation token' do
      it 'returns an unprocessable entity status code' do
        get :confirm, params: { id: user.id_user, confirmation_token: 'invalid_token' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #reset' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password', confirmed: true) }

    context 'with valid email' do
      it 'sends reset password email' do
        expect {
          post :reset, params: { user: { email: 'test@example.com' } }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'returns a success response' do
        post :reset, params: { user: { email: 'test@example.com' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid email' do
      it 'returns a not found status code' do
        post :reset, params: { user: { email: 'invalid@example.com' } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with unconfirmed email' do
      let!(:unconfirmed_user) { User.create(email: 'unconfirmed@example.com', password: 'password', confirmed: false) }

      it 'returns an unauthorized status code' do
        post :reset, params: { user: { email: 'unconfirmed@example.com' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #new_password' do
    let!(:user) { User.create(email: 'test@example.com', password: 'password', confirmed: true, confirmation_token: 'valid_token') }

    context 'with valid confirmation token' do
      it 'resets the password' do
        get :new_password, params: { id: user.id_user, confirmation_token: 'valid_token' }
        user.reload
        expect(user.confirmed).to be(true)
        expect(user.password).not_to eq('password')
      end

      it 'returns a success response' do
        get :new_password, params: { id: user.id_user, confirmation_token: 'valid_token' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid confirmation token' do
      it 'returns an unprocessable entity status code' do
        get :new_password, params: { id: user.id_user, confirmation_token: 'invalid_token' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @user = User.create(email: 'test@example.com', password: Argon2::Password.create('password'), confirmed: true)
      @token = user_login(@user.id_user)
      request.headers['Authorization'] = "Bearer #{@token}"
    end

    it 'destroys the user' do
      expect {
        delete :destroy
      }.to change(User, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy
      expect(response).to have_http_status(:ok)
    end
  end
end
