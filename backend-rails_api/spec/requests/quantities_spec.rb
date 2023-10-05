# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'quantities', type: :request do
  path '/api/quantities' do
    get('list quantities') do
      tags 'Quantities'
      security [{ bearerAuth: [] }]

      response(200, 'successful') do
        run_test!
      end
      response(500, 'server error') do
        run_test!
      end
    end

    post('create quantity') do
      tags 'Quantities'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :quantity, in: :body, schema: {
        type: :object,
        properties: {
          quantity: {
            type: :object,
            properties: {
              value_name: { type: :string },
              symbol: { type: :string },
              m_indicate_auto: { type: :integer },
              l_indicate_auto: { type: :integer },
              t_indicate_auto: { type: :integer },
              i_indicate_auto: { type: :integer },
              unit: { type: :string },
              l_indicate: { type: :integer },
              t_indicate: { type: :integer },
              id_gk: { type: :integer }
            },
            required: %w[value_name symbol m_indicate_auto l_indicate_auto t_indicate_auto i_indicate_auto unit
                         l_indicate t_indicate id_gk]
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

  path '/api/quantities/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show quantity') do
      tags 'Quantities'

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

    put('update quantity') do
      tags 'Quantities'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :quantity, in: :body, schema: {
        type: :object,
        properties: {
          quantity: {
            type: :object,
            properties: {
              value_name: { type: :string },
              symbol: { type: :string },
              m_indicate_auto: { type: :integer },
              l_indicate_auto: { type: :integer },
              t_indicate_auto: { type: :integer },
              i_indicate_auto: { type: :integer },
              unit: { type: :string },
              l_indicate: { type: :integer },
              t_indicate: { type: :integer },
              id_gk: { type: :integer }
            },
            required: %w[value_name symbol m_indicate_auto l_indicate_auto t_indicate_auto i_indicate_auto unit
                         l_indicate t_indicate id_gk]
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

    delete('delete quantity') do
      tags 'Quantities'
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

  path '/api/layers/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get quantities by lt id') do
      tags 'Quantities'

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
