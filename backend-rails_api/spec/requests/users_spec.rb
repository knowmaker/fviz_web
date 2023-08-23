require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/api/login' do
    post('login') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :email, in: :query, type: :string, required: true
      parameter name: :password, in: :query, type: :string, required: true

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/signup' do
    post('create user') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          last_name: { type: :string },
          first_name: { type: :string },
          patronymic: { type: :string }
        },
        required: ['email', 'password', 'last_name', 'first_name', 'patronymic']
      }

      response(201, 'created') do
        run_test!
      end
    end
  end

  path '/api/profile' do
    get('show user') do
      tags 'Users'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/update' do
    patch('update user') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          last_name: { type: :string },
          first_name: { type: :string },
          patronymic: { type: :string }
        }
      }

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
