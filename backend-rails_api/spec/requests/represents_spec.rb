require 'swagger_helper'

RSpec.describe 'represents', type: :request do
  let(:represent_params) do
    { represent:
      {
        title: 'Sample Represent',
        active_values: [1, 2, 3]
      }
    }
  end

  path '/api/represents' do
    get('list represents') do
      tags 'Represents'
      response(200, 'successful') do
        run_test!
      end
    end

    post('create represent') do
      tags 'Represents'
      consumes 'application/json'
      parameter name: :represent, in: :body, schema: {
        type: :object,
        properties: {
          represent: {
            type: :object,
            properties: {
              title: { type: :string },
              active_values: {
                type: :array,
                items: { type: :integer }
              }
            },
            required: ['title', 'active_values']
          }
        }
      }

      response(201, 'created') do
        let(:represent) { represent_params }

        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end
  end

  path '/api/represents/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    put('update represent') do
      tags 'Represents'
      consumes 'application/json'
      parameter name: :represent, in: :body, schema: {
        type: :object,
        properties: {
          represent: {
            type: :object,
            properties: {
              title: { type: :string },
              active_values: {
                type: :array,
                items: { type: :integer }
              }
            }
          }
        }
      }

      response(200, 'successful') do
        let(:id) { '123' }
        let(:represent) { represent_params }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end

    delete('delete represent') do
      tags 'Represents'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end
  end

  path '/api/active_view' do
    get('get active quantities for represent view') do
      tags 'Represents'
      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/active_view/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get active quantities for specific represent view') do
      tags 'Represents'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end
  end

  path '/api/layers/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('get quantities by lt id') do
      tags 'Represents'
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
