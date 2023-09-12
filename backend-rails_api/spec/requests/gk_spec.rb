require 'swagger_helper'

RSpec.describe 'gk', type: :request do
  let(:gk_params) do
    { gk:
        {
          g_indicate: 1,
          k_indicate: 2,
          gk_name: "Sample",
          color: '#fff'
        }
    }
  end

  path '/api/gk' do
    get('list gk') do
      tags 'GK'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/gk/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show GK') do
      tags 'GK'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end

    patch('update GK') do
      tags 'GK'
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
        let(:id) { '123' }
        let(:gk) { gk_params }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end
  end
end
