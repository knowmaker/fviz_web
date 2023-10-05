require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/api/users/login' do
    post('user login') do
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
      response(401, 'not authorized') do
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/users/register' do
    post('user register') do
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
      response(422, 'unprocessable entity') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/users/profile' do
    get('show user profile') do
      tags 'Users'
      security [{ bearerAuth: [] }]

      response(200, 'successful') do
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/users/update' do
    patch('update user') do
      tags 'Users'
      security [{ bearerAuth: [] }]
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
      response(404, 'not found') do
        run_test!
      end
      response(422, 'unprocessable entity') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/users/delete' do
    delete('delete user') do
      tags 'Users'
      security [{ bearerAuth: [] }]

      response(200, 'successful') do
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
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

      response(200, 'successful') do
        run_test!
      end
      response(422, 'unprocessable entity') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/users/reset' do
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

      response(200, 'successful') do
        run_test!
      end
      response(401, 'not authorized') do
        run_test!
      end
      response(404, 'not found') do
        run_test!
      end
      response(500, 'server error') do
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

      response(200, 'successful') do
        run_test!
      end
      response(422, 'unprocessable entity') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end
end
