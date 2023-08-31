require 'swagger_helper'

RSpec.describe 'laws', type: :request do
  let(:law_params) do
    { law:
      {
        law_name: 'Sample Law',
        first_element: 123,
        second_element: 456,
        third_element: 789,
        fourth_element: 1011,
        id_type: 1
      }
    }
  end

  path '/api/laws' do
    get('list laws') do
      tags 'Laws'
      response(200, 'successful') do
        run_test!
      end
    end

    post('create law') do
      tags 'Laws'
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
        let(:law) { law_params }

        run_test!
      end

      response(422, 'unprocessable entity') do
        run_test!
      end
    end
  end

  path '/api/laws/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show law') do
      tags 'Laws'
      response(200, 'successful') do
        let(:id) { '123' }

        run_test!
      end

      response(404, 'not found') do
        run_test!
      end
    end

    delete('delete law') do
      tags 'Laws'
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
