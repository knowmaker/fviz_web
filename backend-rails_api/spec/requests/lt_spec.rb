# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'lt', type: :request do
  path '/lt' do
    get('Get a list of lt (cells)') do
      tags 'LT'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   minItems: 2,
                   items: {
                     type: :object,
                     properties: {
                       id_lt: { type: :integer, example: 1 },
                       l_indicate: { type: :integer, example: 5 },
                       t_indicate: { type: :integer, example: 6 }
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
