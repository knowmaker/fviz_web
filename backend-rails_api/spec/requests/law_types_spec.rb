# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'law_types', type: :request do
  path '/law_types' do
    get('Get a list of law types') do
      tags 'Law Types'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   minItems: 5,
                   items: {
                     type: :object,
                     properties: {
                       id_type: { type: :integer, example: 1 },
                       type_name: { type: :string, maxLength: 100, example: "Законы механики" },
                       color: { type: :string, maxLength: 50, example: "#FFFFFF" }
                     }
                   }
                 }
               }
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    post('Create a new law type') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'Law Types'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :law_type, in: :body, schema: {
        type: :object,
        properties: {
          law_type: {
            type: :object,
            properties: {
              type_name: { type: :string, maxLength: 100, example: "Законы механики" },
              color: { type: :string, maxLength: 50, example: "#FFFFFF" }
            },
            required: %w[type_name color]
          }
        }
      }

      response(201, 'created') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_type: { type: :integer, example: 1 },
                     type_name: { type: :string, maxLength: 100, example: "Законы механики" },
                     color: { type: :string, maxLength: 50, example: "#FFFFFF" }
                   }
                 }
               }
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

  path '/law_types/{id_type}' do
    parameter name: 'id_type', in: :path, type: :string, description: 'id_type'

    get('Get the law type') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'Law Types'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_type: { type: :integer, example: 1 },
                     type_name: { type: :string, maxLength: 100, example: "Законы механики" },
                     color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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

    put('Update the law type') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'Law Types'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :law_type, in: :body, schema: {
        type: :object,
        properties: {
          law_type: {
            type: :object,
            properties: {
              type_name: { type: :string, maxLength: 100, example: "Законы механики" },
              color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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
                     id_type: { type: :integer, example: 1 },
                     type_name: { type: :string, maxLength: 100, example: "Законы механики" },
                     color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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

    delete('Delete the law type') do
      tags 'Law Types'
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
end
