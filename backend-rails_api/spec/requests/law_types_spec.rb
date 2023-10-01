require 'swagger_helper'

RSpec.describe 'law_types', type: :request do
  let(:law_type_params) do
    { law_type:
        {
          type_name: 'Sample Type',
          color: '#000000'
        }
    }
  end

  path '/api/law_types' do
    get('list law types') do
      tags 'Law Types'
      security [{ bearerAuth: [] }]
      response(200, 'successful') do
        run_test!
      end
    end

    post('create law type') do
      tags 'Law Types'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :law_type, in: :body, schema: {
        type: :object,
        properties: {
          law_type: {
            type: :object,
            properties: {
              type_name: { type: :string },
              color: { type: :string }
            },
            required: ['type_name, color']
          }
        }
      }

      response(201, 'created') do
        let(:law_type) { law_type_params }

        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end
  end

  path '/api/law_types/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show law type') do
      tags 'Law Types'
      security [{ bearerAuth: [] }]
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end

    put('update law type') do
      tags 'Law Types'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      parameter name: :law_type, in: :body, schema: {
        type: :object,
        properties: {
          law_type: {
            type: :object,
            properties: {
              type_name: { type: :string },
              color: { type: :string }
            }
          }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }
        let(:law_type) { law_type_params }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end

    delete('delete law type') do
      tags 'Law Types'
      security [{ bearerAuth: [] }]
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end
  end
end
