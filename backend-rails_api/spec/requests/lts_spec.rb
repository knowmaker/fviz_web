require 'swagger_helper'

RSpec.describe 'lts', type: :request do

  path '/api/cell/{cellId}' do
    # You'll want to customize the parameter types...
    parameter name: 'cellId', in: :path, type: :string, description: 'cellId'

    get('get_quantity_by_cell_id lt') do
      response(200, 'successful') do
        let(:cellId) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
