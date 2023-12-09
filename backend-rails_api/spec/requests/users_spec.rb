# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users/login' do
    post('User login') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: "example@example.com" },
              password: { type: :string, example: "PaSS567099" }
            },
            required: %w[email password]
          }
        }
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: { type: :string }
               }
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

  path '/users/register' do
    post('User registration') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, maxLength: 100, pattern: '\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z', example: "example@example.com" },
              password: { type: :string, minLength: 8, pattern: '\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}\z', example: "PaSS567099" }
            },
            required: %w[email password]
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

  path '/users/profile' do
    get('Get the user profile') do
      tags 'Users'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_user: { type: :integer },
                     email: { type: :string, maxLength: 100, example: "example@example.com" },
                     last_name: { type: :string, maxLength: 100, example: "Иванов" },
                     first_name: { type: :string, maxLength: 100, example: "Иван" },
                     patronymic: { type: :string, maxLength: 100, example: "Иванович" },
                     role: { type: :boolean, example: false },
                     confirmed: { type: :boolean, example: true },
                     active_repr: { type: :integer, example: 5 },
                     locale: { type: :string, example: "ru" }
                   }
                 }
               }
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

  path '/users/update' do
    patch('Update the user') do
      tags 'Users'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              last_name: { type: :string, maxLength: 100, example: "Иванов" },
              first_name: { type: :string, maxLength: 100, example: "Иван" },
              patronymic: { type: :string, maxLength: 100, example: "Иванович" }
            }
          }
        }
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_user: { type: :integer },
                     email: { type: :string, maxLength: 100, example: "example@example.com" },
                     last_name: { type: :string, maxLength: 100, example: "Иванов" },
                     first_name: { type: :string, maxLength: 100, example: "Иван" },
                     patronymic: { type: :string, maxLength: 100, example: "Иванович" },
                     role: { type: :boolean, example: false },
                     confirmed: { type: :boolean, example: true },
                     active_repr: { type: :integer, example: 5 },
                     locale: { type: :string, example: "ru" }
                   }
                 }
               }
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

  path '/users/delete' do
    delete('Delete the user') do
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

  path '/users/{id_user}/confirm' do
    parameter name: 'id_user', in: :path, type: :string, description: 'id_user'
    parameter name: 'confirmation_token', in: :query, type: :string, description: 'confirmation token', required: true

    post('Confirm email') do
      tags 'Users'
      produces 'application/json'
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

  path '/users/reset' do
    post('Send reset password email') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: "example@example.com" }
            },
            required: ['email']
          }
        }
      }

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

  path '/users/{id_user}/new_password' do
    parameter name: 'id_user', in: :path, type: :string, description: 'id_user'
    parameter name: 'confirmation_token', in: :query, type: :string, description: 'confirmation token', required: true

    get('Generate and send new password') do
      tags 'Users'
      produces 'application/json'
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
