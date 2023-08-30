require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/api/login' do
    post('login') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
            },
            required: ['email', 'password']
          }
        }
      }
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
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
            },
            required: ['email', 'password', 'last_name', 'first_name', 'patronymic']
          }
        }
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

  path '/api/reset' do
    post('Send reset password email') do
      tags 'Users'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string }
            },
            required: ['email']
          }
        }
      }

      response(200, 'email sent') do
        run_test!
      end

      response(401, 'email not confirmed') do
        run_test!
      end

      response(404, 'user not found') do
        run_test!
      end
    end
  end
end
