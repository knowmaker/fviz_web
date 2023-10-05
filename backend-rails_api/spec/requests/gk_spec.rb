require 'swagger_helper'

RSpec.describe 'gk', type: :request do
  path '/api/gk' do
    get('list gk') do
      tags 'GK'

      response(200, 'successful') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end
  end

  path '/api/gk/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show GK') do
      tags 'GK'
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

    patch('update GK') do
      tags 'GK'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :gk, in: :body, schema: {
        type: :object,
        properties: {
          gk: {
            type: :object,
            properties: {
              gk_name: {type: :string},
              color: { type: :string }
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
  end
end
