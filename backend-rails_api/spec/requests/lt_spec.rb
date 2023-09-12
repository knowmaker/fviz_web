require 'swagger_helper'

RSpec.describe 'lt', type: :request do
  path '/api/lt' do
    get('list lt') do
      tags 'LT'
      response(200, 'successful') do
        run_test!
      end
    end
  end
end
