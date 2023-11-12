# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'gk', type: :request do
  path '/api/gk' do
    get('list gk') do
      tags 'GK'
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
                       id_gk: { type: :integer },
                       gk_name: { type: :string },
                       g_indicate: { type: :integer },
                       k_indicate: { type: :integer },
                       color: { type: :string }
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

  path '/api/gk/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show GK') do
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'GK'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_gk: { type: :integer },
                     gk_name: { type: :string },
                     g_indicate: { type: :integer },
                     k_indicate: { type: :integer },
                     color: { type: :string }
                   }
                 }
               }
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
      parameter name: 'locale_content', in: :query, type: :string, description: 'Locale Content'

      tags 'GK'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :gk, in: :body, schema: {
        type: :object,
        properties: {
          gk: {
            type: :object,
            properties: {
              gk_name: { type: :string },
              color: { type: :string }
            }
          }
        }
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data:{
                   type: :object,
                   properties: {
                     id_gk: { type: :integer },
                     gk_name: { type: :string },
                     g_indicate: { type: :integer },
                     k_indicate: { type: :integer },
                     color: { type: :string }
                   }
                 }
               }
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
