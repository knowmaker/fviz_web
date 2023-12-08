# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'gk', type: :request do
  path '/gk' do
    get('Get a list of gk (system levels)') do
      tags 'GK'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   minItems: 14,
                   items: {
                     type: :object,
                     properties: {
                       id_gk: { type: :integer, example: 1 },
                       gk_name: { type: :string, maxLength: 100, example: "Базовые ФВ" },
                       g_indicate: { type: :integer, example: 2 },
                       k_indicate: { type: :integer, example: 3 },
                       color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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

  path '/gk/{id_gk}' do
    parameter name: 'id_gk', in: :path, type: :string, description: 'id_gk'

    get('Get the gk (system level)') do
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
                     id_gk: { type: :integer, example: 1 },
                     gk_name: { type: :string, maxLength: 100, example: "Базовые ФВ" },
                     g_indicate: { type: :integer, example: 2 },
                     k_indicate: { type: :integer, example: 3 },
                     color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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

    patch('Update the gk (system level)') do
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
              gk_name: { type: :string, maxLength: 100, example: "Базовые ФВ" },
              color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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
                     id_gk: { type: :integer, example: 1 },
                     gk_name: { type: :string, maxLength: 100, example: "Базовые ФВ" },
                     g_indicate: { type: :integer, example: 2 },
                     k_indicate: { type: :integer, example: 3 },
                     color: { type: :string, maxLength: 50, example: "#FFFFFF" }
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
