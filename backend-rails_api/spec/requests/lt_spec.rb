# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'lt', type: :request do
  path '/api/lt' do
    get('list lt') do
      tags 'LT'
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
                       id_lt: { type: :integer },
                       l_indicate: { type: :integer },
                       t_indicate: { type: :integer }
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
  end
end
