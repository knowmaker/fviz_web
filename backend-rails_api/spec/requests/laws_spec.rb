# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'laws', type: :request do
  path '/laws' do
    get('Get a list of laws') do
      tags 'Laws'
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
                       id_law: { type: :integer, example: 1 },
                       law_name: { type: :string, maxLength: 100, example: "2-й Закон Ньютона" },
                       first_element: { type: :integer, example: 1 },
                       second_element: { type: :integer, example: 2 },
                       third_element: { type: :integer, example: 3 },
                       fourth_element: { type: :integer, example: 4 },
                       id_user: { type: :integer, example: 20 },
                       id_type: { type: :integer, example: 10 }
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

    post('Create a new law') do
      tags 'Laws'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :law, in: :body, schema: {
        type: :object,
        properties: {
          law: {
            type: :object,
            properties: {
              law_name: { type: :string, maxLength: 100, example: "2-й Закон Ньютона" },
              first_element: { type: :integer, example: 1 },
              second_element: { type: :integer, example: 2 },
              third_element: { type: :integer, example: 3 },
              fourth_element: { type: :integer, example: 4 },
              id_type: { type: :integer, example: 10 }
            },
            required: %w[law_name first_element second_element third_element fourth_element id_type]
          }
        }
      }

      response(201, 'created') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_law: { type: :integer, example: 1 },
                     law_name: { type: :string, maxLength: 100, example: "2-й Закон Ньютона" },
                     first_element: { type: :integer, example: 1 },
                     second_element: { type: :integer, example: 2 },
                     third_element: { type: :integer, example: 3 },
                     fourth_element: { type: :integer, example: 4 },
                     id_user: { type: :integer, example: 20 },
                     id_type: { type: :integer, example: 10 }
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

  path '/laws/{id_law}' do
    parameter name: 'id_law', in: :path, type: :string, description: 'id_law'

    get('Get the law') do
      tags 'Laws'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_law: { type: :integer, example: 1 },
                     law_name: { type: :string, maxLength: 100, example: "2-й Закон Ньютона" },
                     first_element: { type: :integer, example: 1 },
                     second_element: { type: :integer, example: 2 },
                     third_element: { type: :integer, example: 3 },
                     fourth_element: { type: :integer, example: 4 },
                     id_user: { type: :integer, example: 20 },
                     id_type: { type: :integer, example: 10 }
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

    patch('Update the law') do
      tags 'Laws'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :law, in: :body, schema: {
        type: :object,
        properties: {
          law: {
            type: :object,
            properties: {
              law_name: { type: :string, maxLength: 100, example: "2-й Закон Ньютона" },
              id_type: { type: :integer, example: 10 }
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
                     id_law: { type: :integer, example: 1 },
                     law_name: { type: :string, maxLength: 100, example: "2-й Закон Ньютона" },
                     first_element: { type: :integer, example: 1 },
                     second_element: { type: :integer, example: 2 },
                     third_element: { type: :integer, example: 3 },
                     fourth_element: { type: :integer, example: 4 },
                     id_user: { type: :integer, example: 20 },
                     id_type: { type: :integer, example: 10 }
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

    delete('Delete the law') do
      tags 'Laws'
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
