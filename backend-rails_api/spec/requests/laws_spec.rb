require 'swagger_helper'

RSpec.describe 'laws', type: :request do
  path '/api/laws' do
    get('list laws') do
      tags 'Laws'
      security [{ bearerAuth: [] }]

      response(200, 'successful') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    post('create law') do
      tags 'Laws'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :law, in: :body, schema: {
        type: :object,
        properties: {
          law: {
            type: :object,
            properties: {
              law_name: { type: :string },
              first_element: { type: :integer },
              second_element: { type: :integer },
              third_element: { type: :integer },
              fourth_element: { type: :integer },
              id_type: { type: :integer }
            },
            required: ['law_name', 'first_element', 'second_element', 'third_element', 'fourth_element', 'id_type']
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

  path '/api/laws/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show law') do
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

    patch('update law') do
      tags 'Laws'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :law, in: :body, schema: {
        type: :object,
        properties: {
          law: {
            type: :object,
            properties: {
              law_name: { type: :string },
              id_type: { type: :integer }
            }
          }
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

    delete('delete law') do
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
