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
            required: ['email', 'password']
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

  path '/api/users/{id}/confirm' do
    parameter name: 'id', in: :path, type: :string, description: 'id'
    parameter name: 'confirmation_token', in: :query, type: :string, description: 'confirmation token', required: true

    post('confirm email') do
      tags 'Users'
      produces 'application/json'

      response(200, 'email confirmed') do
        run_test!
      end

      response(422, 'invalid confirmation token') do
        run_test!
      end
    end
  end

  path '/api/reset' do
    post('Send reset password email') do
      tags 'Users'
      consumes 'application/json'
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

  path '/api/users/{id}/new_password' do
    parameter name: 'id', in: :path, type: :string, description: 'id'
    parameter name: 'confirmation_token', in: :query, type: :string, description: 'confirmation token', required: true

    get('generate and send new password') do
      tags 'Users'
      produces 'application/json'

      response(200, 'new password generated and sent') do
        run_test!
      end

      response(422, 'invalid reset token') do
        run_test!
      end
    end
  end
end
